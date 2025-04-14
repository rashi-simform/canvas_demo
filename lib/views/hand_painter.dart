import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class HandPainter extends CustomPainter {
  final double value;
  final Color overlayColor;

  const HandPainter({
    required this.value,
    required this.overlayColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.95 + 10);
    final radius = size.width * 0.3;

    const startAngle = 4.28 * pi / 4;
    const endAngle = 7.75 * pi / 4;

    final handAngle = startAngle + (value / 100) * (endAngle - startAngle);

    final handLength = radius * 1.8;
    final handBaseWidth = radius * 0.4;

    final handTip = Offset(
      center.dx + handLength * cos(handAngle),
      center.dy + handLength * sin(handAngle),
    );
    final baseLeft = Offset(
      center.dx + (handBaseWidth / 2) * sin(handAngle),
      center.dy - (handBaseWidth / 2) * cos(handAngle),
    );
    final baseRight = Offset(
      center.dx - (handBaseWidth / 2) * sin(handAngle),
      center.dy + (handBaseWidth / 2) * cos(handAngle),
    );


    final handPath = Path()
      ..moveTo(baseLeft.dx, baseLeft.dy)
      ..quadraticBezierTo(
        (baseLeft.dx + handTip.dx) / 2,
        (baseLeft.dy + handTip.dy) / 2,
        handTip.dx,
        handTip.dy,
      )
      ..quadraticBezierTo(
        (handTip.dx + baseRight.dx) / 2,
        (handTip.dy + baseRight.dy) / 2,
        baseRight.dx,
        baseRight.dy,
      )
      ..close();

    // Draw the shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 1); // Blur effect
    canvas.save();
    canvas.drawPath(handPath, shadowPaint);
    canvas.restore();

    // Draw the hand
    final handPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(handTip.dx, handTip.dy),
        Offset(baseRight.dx, size.height),
        [
          Colors.red,
          overlayColor,
        ],
        [
          0.0,
          0.5,
        ],
      )
      ..style = PaintingStyle.fill;
    canvas.drawPath(handPath, handPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
