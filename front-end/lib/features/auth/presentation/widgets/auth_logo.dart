import 'package:flutter/material.dart';
import '../../../../core/constants/colors/app_colors.dart';

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              AppColors.toColor(
                  isDark ? AppColors.darkPrimary : AppColors.lightPrimary),
              AppColors.toColor(
                  isDark ? AppColors.darkSecondary : AppColors.lightSecondary),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark
                ? AppColors.toColor(AppColors.darkCard)
                : AppColors.toColor(AppColors.lightCard),
          ),
          child: Center(
            child: CustomPaint(
              size: const Size(40, 40),
              painter: PillIconPainter(
                color: isDark
                    ? AppColors.toColor(AppColors.darkPrimary)
                    : AppColors.toColor(AppColors.lightPrimary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PillIconPainter extends CustomPainter {
  final Color color;

  PillIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    // Draw pill/capsule shape
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final pillWidth = size.width * 0.7;
    final pillHeight = size.height * 0.4;

    // Left semicircle
    canvas.drawArc(
      Rect.fromLTWH(
        centerX - pillWidth / 2,
        centerY - pillHeight / 2,
        pillHeight,
        pillHeight,
      ),
      -1.57, // -90 degrees
      3.14, // 180 degrees
      false,
      paint,
    );

    // Right semicircle
    canvas.drawArc(
      Rect.fromLTWH(
        centerX + pillWidth / 2 - pillHeight,
        centerY - pillHeight / 2,
        pillHeight,
        pillHeight,
      ),
      1.57, // 90 degrees
      3.14, // 180 degrees
      false,
      paint,
    );

    // Top horizontal line
    canvas.drawLine(
      Offset(
          centerX - pillWidth / 2 + pillHeight / 2, centerY - pillHeight / 2),
      Offset(
          centerX + pillWidth / 2 - pillHeight / 2, centerY - pillHeight / 2),
      paint,
    );

    // Bottom horizontal line
    canvas.drawLine(
      Offset(
          centerX - pillWidth / 2 + pillHeight / 2, centerY + pillHeight / 2),
      Offset(
          centerX + pillWidth / 2 - pillHeight / 2, centerY + pillHeight / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
