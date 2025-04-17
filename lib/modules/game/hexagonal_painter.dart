import 'package:flutter/material.dart';

class HexagonalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path =
    Path()
      ..moveTo(0, size.height * 0.5)
      ..lineTo(size.width * 0.25, 0)
      ..lineTo(size.width * 0.75, 0)
      ..lineTo(size.width, size.height * 0.5)
      ..lineTo(size.width * 0.75, size.height)
      ..lineTo(size.width * 0.25, size.height)
      ..lineTo(0, size.height * 0.5);

    Paint paint =
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint.color = Color(0xffa04Ff0).withAlpha(100);
    canvas.drawPath(path, paint);

    Paint fillPaint = Paint()..style = PaintingStyle.fill;
    fillPaint.color = Color(0xffa04Ff0).withAlpha(40);
    canvas.drawPath(path, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HexagonPainter extends CustomPainter {
  const HexagonPainter({super.repaint, this.rotationAngle});

  /// rotationAngle is in radians and is used to rotate the hexagon
  final double? rotationAngle;

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.3197917, size.height * 0.8750000);
    path.cubicTo(
      size.width * 0.3086812,
      size.height * 0.8750000,
      size.width * 0.2983375,
      size.height * 0.8722646,
      size.width * 0.2887604,
      size.height * 0.8667917,
    );
    path.cubicTo(
      size.width * 0.2791917,
      size.height * 0.8613271,
      size.width * 0.2714792,
      size.height * 0.8536458,
      size.width * 0.2656250,
      size.height * 0.8437500,
    );
    path.lineTo(size.width * 0.08437542, size.height * 0.5312500);
    path.cubicTo(
      size.width * 0.07882000,
      size.height * 0.5212979,
      size.width * 0.07604208,
      size.height * 0.5108271,
      size.width * 0.07604208,
      size.height * 0.4998333,
    );
    path.cubicTo(
      size.width * 0.07604208,
      size.height * 0.4888333,
      size.width * 0.07882000,
      size.height * 0.4784729,
      size.width * 0.08437542,
      size.height * 0.4687500,
    );
    path.lineTo(size.width * 0.2656250, size.height * 0.1562500);
    path.cubicTo(
      size.width * 0.2714792,
      size.height * 0.1463542,
      size.width * 0.2791917,
      size.height * 0.1386702,
      size.width * 0.2887604,
      size.height * 0.1331979,
    );
    path.cubicTo(
      size.width * 0.2983375,
      size.height * 0.1277327,
      size.width * 0.3086813,
      size.height * 0.1250000,
      size.width * 0.3197917,
      size.height * 0.1250000,
    );
    path.lineTo(size.width * 0.6802083, size.height * 0.1250000);
    path.cubicTo(
      size.width * 0.6913208,
      size.height * 0.1250000,
      size.width * 0.7016646,
      size.height * 0.1277327,
      size.width * 0.7112396,
      size.height * 0.1331979,
    );
    path.cubicTo(
      size.width * 0.7208104,
      size.height * 0.1386702,
      size.width * 0.7285208,
      size.height * 0.1463542,
      size.width * 0.7343750,
      size.height * 0.1562500,
    );
    path.lineTo(size.width * 0.9156250, size.height * 0.4687500);
    path.cubicTo(
      size.width * 0.9211813,
      size.height * 0.4787021,
      size.width * 0.9239583,
      size.height * 0.4891729,
      size.width * 0.9239583,
      size.height * 0.5001667,
    );
    path.cubicTo(
      size.width * 0.9239583,
      size.height * 0.5111667,
      size.width * 0.9211813,
      size.height * 0.5215271,
      size.width * 0.9156250,
      size.height * 0.5312500,
    );
    path.lineTo(size.width * 0.7343750, size.height * 0.8437500);
    path.cubicTo(
      size.width * 0.7285208,
      size.height * 0.8536458,
      size.width * 0.7208104,
      size.height * 0.8613271,
      size.width * 0.7112396,
      size.height * 0.8667917,
    );
    path.cubicTo(
      size.width * 0.7016646,
      size.height * 0.8722646,
      size.width * 0.6913208,
      size.height * 0.8750000,
      size.width * 0.6802083,
      size.height * 0.8750000,
    );
    path.lineTo(size.width * 0.3197917, size.height * 0.8750000);
    path.close();

    Paint strokePaint =
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    strokePaint.color = Color(0xffa04Ff0).withAlpha(100);

    Paint fillPaint = Paint()..style = PaintingStyle.fill;
    fillPaint.color = Color(0xffa04Ff0).withAlpha(40);


    if (rotationAngle != null && rotationAngle != 0) {
      // Save the current canvas state
      // canvas.save();

      // Translate to the center of the rectangle
      canvas.translate(size.width * 0.5, size.height * 0.5);

      // Rotate
      canvas.rotate(rotationAngle!);

      // Translate back to the original position (optional, depends on desired output)
      canvas.translate(- size.width * 0.5,- size.height * 0.5);

      // Draw the rotated rectangle
      canvas.drawPath(path, strokePaint);
      canvas.drawPath(path, fillPaint);

      // Restore the canvas state
      // canvas.restore();
    }else{
      canvas.drawPath(path, strokePaint);
      canvas.drawPath(path, fillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
