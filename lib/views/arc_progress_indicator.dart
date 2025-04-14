import 'dart:math';

import 'package:flutter/material.dart';

class ArcProgressIndicator extends StatelessWidget {
  const ArcProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, double.infinity),
      painter: ArcPainter(),
    );
  }
}

class ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Path path =
    //     Path()
    //       ..addArc(
    //         Rect.fromCircle(
    //           center: Offset(size.width * 0.5, size.height * 0.5),
    //           radius: size.width * 0.4,
    //         ),
    //         130 * pi / 180,
    //         280 * pi / 180,
    //       )
    //       ..close();

    Paint paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
    paint.color = Color(0xffa04Ff0).withAlpha(140);

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width * 0.5, size.height * 0.5),
        radius: size.width * 0.4,
      ),
      130 * pi / 180,
      280 * pi / 180,
      false,
      paint,
    );

    paint =
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint.color = Color(0xffa04Ff0).withAlpha(60);

    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.5), size.width * 0.32, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
