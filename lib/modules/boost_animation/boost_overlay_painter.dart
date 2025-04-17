import 'package:flutter/material.dart';

class BoostOverlayPainter extends CustomPainter {
  final Color overlayColor;

  const BoostOverlayPainter({
    required this.overlayColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const radius = 10;

    // Define the path for the custom shape
    final path = Path()
      ..moveTo(
          size.width * 0.02 - (0.0 * radius), size.height * 0.85 + (1 * radius))
      ..quadraticBezierTo(
        size.width * 0.02 - (2.5 * radius),
        size.height * 0.85 - (0.1 * radius),
        size.width * 0.025 + (0 * radius),
        size.height * 0.85 - (4.0 * radius),
      )
      ..arcToPoint(
        Offset(size.width * 0.95 + (1 * radius),
            size.height * 0.85 - (4 * radius)),
        radius: Radius.circular(size.width * 0.55),
        clockwise: true,
      )
      ..quadraticBezierTo(
        size.width * 0.95 + (4 * radius),
        size.height * 0.85 + (0.5 * radius),
        size.width * 0.95 - (0 * radius),
        size.height * 0.85 + (1.5 * radius),
      )
      ..lineTo(
          size.width * 0.85 + (0 * radius), size.height * 0.95 - (0.8 * radius))
      ..quadraticBezierTo(
        size.width * 0.75 - (0 * radius),
        size.height * 0.95 + (0 * radius),
        size.width * 0.75 - (0.5 * radius),
        size.height * 0.9 - (0 * radius),
      )
      ..arcToPoint(
        Offset(
            size.width * 0.2 + (2 * radius), size.height * 0.95 - (2 * radius)),
        radius: Radius.circular(size.width * 0.27),
        clockwise: false,
      )
      ..quadraticBezierTo(
        size.width * 0.2 + radius,
        size.height * 0.95,
        size.width * 0.2 - (2 * radius),
        size.height * 0.95 - radius,
      )
      ..close();

    // Draw box shadow
    final shadowPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill
      ..maskFilter =
      const MaskFilter.blur(BlurStyle.outer, 30);
    canvas.drawPath(path, shadowPaint);

    final bgPaint = Paint()
      ..color = overlayColor.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, bgPaint);

    // Draw the main gradient-filled shape
    final gradientPaint = Paint()
      ..shader = RadialGradient(
        colors: [overlayColor.withOpacity(0.8), overlayColor],
        radius: 1.5,
      ).createShader(Rect.fromCircle(center: center, radius: size.width / 2))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    canvas.drawPath(path, gradientPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

