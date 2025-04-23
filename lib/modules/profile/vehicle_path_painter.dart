import 'dart:ui';

import 'package:flutter/material.dart';

class PathPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    final circlePaint =
    Paint()
      ..color = const Color(0xff1fff9d)
      ..style = PaintingStyle.fill;
    List<Offset> points = [];
    final completedPath =
        Path()
          ..moveTo(size.width * 0.1, size.height * 0.9)
          ..quadraticBezierTo(
            size.width * 0.4,
            size.height * 0.8,
            size.width * 0.4,
            size.height * 0.6,
          );

    final incompletePath =
        Path()
          ..moveTo(size.width * 0.4, size.height * 0.6)
          ..cubicTo(
            size.width * 0.3,
            size.height * 0.34,
            size.width * 0.8,
            size.height * 0.38,
            size.width * 0.75,
            size.height * 0.12,
          )
          ..quadraticBezierTo(
            size.width * 0.68,
            size.height * 0.06,
            size.width * 0.6,
            size.height * 0.05,
          );

    final pathPaint =
        Paint()
          ..color = const Color(0xfb1fff9d)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round;

    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.9),
      6,
      circlePaint,
    );
    canvas.drawPath(completedPath, pathPaint);
    //TODO: dashed line
    for (final PathMetric metric in incompletePath.computeMetrics()) {
          final length = metric.length;
          const step = 5.0; // Smaller step = smoother curve, more points

          for (double distance = 0; distance < length; distance += step) {
            final tangent = metric.getTangentForOffset(distance);
            if (tangent != null) {
              points.add(tangent.position);
            }
          }
        }
        canvas.drawPoints(PointMode.lines, points, pathPaint);
    // canvas.drawPath(incompletePath, pathPaint);

    canvas.drawCircle(
      Offset(size.width * 0.6, size.height * 0.05),
      6,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
