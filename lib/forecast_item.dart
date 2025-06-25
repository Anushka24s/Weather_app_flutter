import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForecastItem extends StatelessWidget {
  final String time;
  final String temp;
  final IconData icon;

  const ForecastItem({
    super.key,
    required this.time,
    required this.temp,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDark ? const Color(0xFF455A64) : const Color(0xFFE3F2FD),
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              time,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : const Color(0xFF0288D1),
              ),
            ),
            const SizedBox(height: 8),
            Icon(
              icon,
              size: 32,
              color: isDark ? Colors.white70 : const Color(0xFF0288D1),
              shadows: [
                Shadow(
                  color: Colors.black26,
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              temp,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : const Color(0xFF0288D1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
