import 'package:flutter/material.dart';
import 'package:weather_app/main_screen2.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  const SplashScreen({super.key, required this.onThemeToggle});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _navigateToMainScreen();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToMainScreen() {
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder:
              (context) => MainScreen2(onThemeToggle: widget.onThemeToggle),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFB3E5FC), // Light blue
              Color(0xFFFFF9A3), // Light yellow
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_animation.value * 0.2),
                    child: Icon(
                      Icons.wb_sunny,
                      size: 120,
                      color: Colors.yellow[700],
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: const Offset(6, 6),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20.0), // Spacing between icon and title
              Text(
                'Weather Now',
                style: GoogleFonts.poppins(
                  fontSize: 28, // Matches main_screen2.dart headers
                  fontWeight: FontWeight.w600,
                  color: const Color(
                    0xFF455A64,
                  ).withOpacity(0.9), // Consistent with main_screen2.dart
                  shadows: [
                    Shadow(
                      color: Colors.black12,
                      offset: const Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
