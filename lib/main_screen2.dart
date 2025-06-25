import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:weather_app/forecast_item.dart';
import 'package:weather_app/additional_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as charts;
import 'package:google_fonts/google_fonts.dart';

class MainScreen2 extends StatefulWidget {
  final VoidCallback onThemeToggle;
  const MainScreen2({super.key, required this.onThemeToggle});

  @override
  State<MainScreen2> createState() => _MainScreen2State();
}

class _MainScreen2State extends State<MainScreen2>
    with TickerProviderStateMixin {
  late Future<Map<String, dynamic>> weather;
  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _iconController;
  late Animation<double> _scaleAnimation;
  late AnimationController _gradientController;
  late Animation<Color?> _gradientStartAnimation;
  late Animation<Color?> _gradientEndAnimation;

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'London';
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=$openWeatherAPIKey',
        ),
      );

      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw data['message'];
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
    );
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _gradientStartAnimation = ColorTween(
      begin: const Color(0xFFE3F2FD),
      end: const Color(0xFFDCE775),
    ).animate(
      CurvedAnimation(parent: _gradientController, curve: Curves.linear),
    );
    _gradientEndAnimation = ColorTween(
      begin: const Color(0xFFFFE082),
      end: const Color(0xFFF0F4C3),
    ).animate(
      CurvedAnimation(parent: _gradientController, curve: Curves.linear),
    );
    weather = getCurrentWeather();
  }

  @override
  void dispose() {
    _controller.dispose();
    _iconController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  Color _getCardColor(String sky) {
    switch (sky.toLowerCase()) {
      case 'clear':
        return const Color(0xFFFFF9C4); // Light yellow for sunny
      case 'clouds':
        return const Color(0xBBE0F7FA); // Light blue for cloudy
      case 'rain':
        return const Color(0xBBCE93D8); // Light purple-blue
      case 'thunderstorm':
        return const Color(0xBB9FA8DA); // Soft indigo
      default:
        return const Color(0xB3E0E0); // Light teal
    }
  }

  Color _getIconColor(String sky) {
    switch (sky.toLowerCase()) {
      case 'clear':
        return Colors.yellow[300]!; // Yellow for sunny
      case 'clouds':
      case 'rain':
      case 'thunderstorm':
      default:
        return Colors.blue[300]!; // Blue for cloudy, rain, or other conditions
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor =
        isDark
            ? const Color(0xFF263238) // Darker, elegant blue-grey
            : const Color(0xFFF5F5F5); // Off-white as base
    final textColor =
        isDark
            ? Colors.white70
            : const Color(0xFF455A64); // Soft grey-blue for light mode

    return Scaffold(
      body: AnimatedBuilder(
        animation: _gradientController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors:
                    isDark
                        ? [const Color(0xFF1A2529), const Color(0xFF37474F)]
                        : [
                          _gradientStartAnimation.value!,
                          _gradientEndAnimation.value!,
                        ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'London',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  weather =
                                      getCurrentWeather(); // Ensure rebuild on click
                                });
                              },
                              icon: Icon(Icons.refresh, color: textColor),
                            ),
                            IconButton(
                              onPressed: widget.onThemeToggle,
                              icon: Icon(
                                isDark ? Icons.light_mode : Icons.dark_mode,
                                color:
                                    isDark
                                        ? const Color(0xFFFFCA28)
                                        : textColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: weather,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              snapshot.error.toString(),
                              style: TextStyle(color: textColor),
                            ),
                          );
                        }

                        final data = snapshot.data!;
                        final currentWeatherData = data['list'][0];
                        final currentTemp =
                            currentWeatherData['main']['temp'] - 273.15;
                        final currentSky =
                            currentWeatherData['weather'][0]['main'];
                        final currentPressure =
                            currentWeatherData['main']['pressure'];
                        final currentWindSpeed =
                            currentWeatherData['wind']['speed'];
                        final currentHumidity =
                            currentWeatherData['main']['humidity'];

                        List<ChartData> chartData = [];
                        for (int i = 0; i < 8 && i < data['list'].length; i++) {
                          final hourly = data['list'][i];
                          final temp = (hourly['main']['temp'] ?? 0) - 273.15;
                          final dtTxt = hourly['dt_txt'];
                          if (dtTxt != null) {
                            final time = DateTime.parse(dtTxt).hour.toDouble();
                            chartData.add(ChartData(time, temp));
                          }
                        }

                        return SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20),
                              // Main Weather Card with Animated Elevation
                              AnimatedPhysicalModel(
                                duration: const Duration(milliseconds: 1000),
                                elevation: 10,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(20),
                                color: _getCardColor(currentSky),
                                shadowColor:
                                    isDark ? Colors.white24 : Colors.blue[100]!,
                                child: AnimatedBuilder(
                                  animation: _animation,
                                  builder: (context, child) {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(24.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '${currentTemp.round()}°C',
                                              style: GoogleFonts.poppins(
                                                fontSize: 48,
                                                fontWeight: FontWeight.w700,
                                                color: textColor,
                                              ),
                                            ),
                                            const SizedBox(height: 24),
                                            ScaleTransition(
                                              scale: _scaleAnimation,
                                              child: Transform.scale(
                                                scale: 1.3,
                                                child: Icon(
                                                  currentSky == 'Clear'
                                                      ? Icons.wb_sunny
                                                      : Icons.cloud,
                                                  size: 80,
                                                  color: _getIconColor(
                                                    currentSky,
                                                  ), // Static blue or yellow
                                                  // Removed black shadow
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 24),
                                            Text(
                                              currentSky,
                                              style: GoogleFonts.poppins(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w400,
                                                color: textColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 32),
                              Text(
                                'Hourly Forecast',
                                style: GoogleFonts.poppins(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 140,
                                child: ListView.builder(
                                  itemCount: 5,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    final hourlyForecast =
                                        data['list'][index + 1];
                                    final hourlySky =
                                        hourlyForecast['weather'][0]['main'];
                                    final time = DateTime.parse(
                                      hourlyForecast['dt_txt'],
                                    );
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                      ),
                                      child: ForecastItem(
                                            time: DateFormat.j().format(time),
                                            temp:
                                                '${(hourlyForecast['main']['temp'] - 273.15).round()}°C',
                                            icon:
                                                hourlySky == 'Clear'
                                                    ? Icons.wb_sunny
                                                    : Icons.cloud,
                                          )
                                          .animate()
                                          .fadeIn(duration: 600.ms)
                                          .slideX(begin: 0.3, end: 0),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 32),
                              Text(
                                'Additional Information',
                                style: GoogleFonts.poppins(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  AdditionalInfo(
                                    icon: Icons.water_drop,
                                    label: 'Humidity',
                                    value: '$currentHumidity%',
                                  ).animate().scale(duration: 400.ms),
                                  AdditionalInfo(
                                    icon: Icons.air,
                                    label: 'Wind Speed',
                                    value: '$currentWindSpeed m/s',
                                  ).animate().scale(duration: 500.ms),
                                  AdditionalInfo(
                                    icon: Icons.beach_access,
                                    label: 'Pressure',
                                    value: '$currentPressure hPa',
                                  ).animate().scale(duration: 600.ms),
                                ],
                              ),
                              const SizedBox(height: 32),
                              Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                color: baseColor.withOpacity(0.95),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Temperature Variation',
                                        style: GoogleFonts.poppins(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      SizedBox(
                                        height: 200,
                                        child: charts.SfCartesianChart(
                                          primaryXAxis: charts.NumericAxis(
                                            title: charts.AxisTitle(
                                              text: 'Hour',
                                              textStyle: TextStyle(
                                                color:
                                                    isDark
                                                        ? Colors.white70
                                                        : const Color(
                                                          0xFF455A64,
                                                        ),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            interval: 2,
                                            labelStyle: TextStyle(
                                              color:
                                                  isDark
                                                      ? Colors.white70
                                                      : const Color(0xFF455A64),
                                            ),
                                          ),
                                          primaryYAxis: charts.NumericAxis(
                                            title: charts.AxisTitle(
                                              text: 'Temp (°C)',
                                              textStyle: TextStyle(
                                                color:
                                                    isDark
                                                        ? Colors.white70
                                                        : const Color(
                                                          0xFF455A64,
                                                        ),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            labelStyle: TextStyle(
                                              color:
                                                  isDark
                                                      ? Colors.white70
                                                      : const Color(0xFF455A64),
                                            ),
                                          ),
                                          series: <
                                            charts.LineSeries<ChartData, double>
                                          >[
                                            charts.LineSeries<
                                              ChartData,
                                              double
                                            >(
                                              dataSource: chartData,
                                              xValueMapper:
                                                  (ChartData data, _) => data.x,
                                              yValueMapper:
                                                  (ChartData data, _) => data.y,
                                              color: const Color(0xFF42A5F5),
                                              width: 2,
                                              enableTooltip: true,
                                              animationDuration: 1000,
                                              markerSettings:
                                                  const charts.MarkerSettings(
                                                    isVisible: true,
                                                    color: Colors.white,
                                                    borderColor: Colors.black26,
                                                    borderWidth: 2,
                                                  ),
                                            ),
                                          ],
                                          tooltipBehavior:
                                              charts.TooltipBehavior(
                                                enable: true,
                                                color:
                                                    isDark
                                                        ? const Color(
                                                          0xFF455A64,
                                                        )
                                                        : Colors.white70,
                                                textStyle: TextStyle(
                                                  color:
                                                      isDark
                                                          ? Colors.white70
                                                          : const Color(
                                                            0xFF455A64,
                                                          ),
                                                ),
                                              ),
                                          backgroundColor: baseColor,
                                          plotAreaBorderWidth: 0,
                                          plotAreaBackgroundColor:
                                              isDark
                                                  ? const Color(0xFF263238)
                                                  : Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ChartData {
  final double x;
  final double y;
  ChartData(this.x, this.y);
}

// Extension to lighten colors
extension ColorLighten on Color {
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightenedHsl = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );
    return lightenedHsl.toColor();
  }
}
