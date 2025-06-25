import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdditionalInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const AdditionalInfo({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark
            ? Colors.white70
            : const Color.fromARGB(
              255,
              79,
              131,
              155,
            ); // Consistent with main_screen2.dart

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color:
              isDark
                  ? Colors.white12
                  : Colors.blue[100]!.withOpacity(0.6), // Enhanced blue hint
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      color:
          isDark
              ? const Color(0xFF37474F) // Dark mode unchanged
              : const Color(0xFFEFF4F8), // Light blue-grey for light mode
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 36, color: textColor),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: textColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
