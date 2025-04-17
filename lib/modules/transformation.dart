import 'dart:math';

import 'package:flutter/material.dart';

class TransformedShapesDemo extends StatefulWidget {
  const TransformedShapesDemo({super.key});

  @override
  State<TransformedShapesDemo> createState() => _TransformedShapesDemoState();
}

class _TransformedShapesDemoState extends State<TransformedShapesDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _skewX = 0.0;
  double _skewY = 0.0;
  double _rotation = 0.0;
  double _scaleX = 1.0;
  double _scaleY = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    _controller.addListener(() {
      setState(() {
        // Create cyclical animations for transformations
        _skewX = sin(_controller.value * 2 * pi) * 0.3;
        _skewY = cos(_controller.value * 2 * pi) * 0.2;
        _rotation = _controller.value * 2 * pi;
        _scaleX = 1 + sin(_controller.value * 2 * pi) * 0.3;
        _scaleY = 1 + cos(_controller.value * 2 * pi) * 0.3;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transformed Custom Shapes'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Transformations Applied:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Skew X: ${_skewX.toStringAsFixed(2)}'),
            Text('Skew Y: ${_skewY.toStringAsFixed(2)}'),
            Text('Rotation: ${(_rotation * 180 / pi).toStringAsFixed(0)}°'),
            Text('Scale X: ${_scaleX.toStringAsFixed(2)}'),
            Text('Scale Y: ${_scaleY.toStringAsFixed(2)}'),
            const SizedBox(height: 30),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 1,
                  ),
                ],
              ),
              child: CustomPaint(
                painter: TransformedShapePainter(
                  skewX: _skewX,
                  skewY: _skewY,
                  rotation: _rotation,
                  scaleX: _scaleX,
                  scaleY: _scaleY,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransformedShapePainter extends CustomPainter {
  final double skewX;
  final double skewY;
  final double rotation;
  final double scaleX;
  final double scaleY;

  TransformedShapePainter({
    required this.skewX,
    required this.skewY,
    required this.rotation,
    required this.scaleX,
    required this.scaleY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Save the canvas state before transformations
    canvas.save();

    // Move to center to apply transformations around center point
    canvas.translate(center.dx, center.dy);

    // Apply transformations in sequence
    canvas.scale(scaleX, scaleY);

    canvas.rotate(rotation);

    // 3. Skew (requires matrix transformation)
    final Matrix4 skewMatrix =
        Matrix4.identity()
          ..setEntry(0, 1, skewX) // skew X (along Y axis)
          ..setEntry(1, 0, skewY); // skew Y (along X axis)

    canvas.transform(skewMatrix.storage);

    // Translate back to draw from top-left corner
    canvas.translate(-70, -70);

    // Define paths for custom shape - a star inside a pentagon
    final path = Path();

    // Draw pentagon
    final pentagonRadius = 70.0;
    final pentagonPoints = 5;
    final pentagonStartAngle = 45 * pi / 180; // Start from top

    for (int i = 0; i <= 4; i++) {
      final angle = pentagonStartAngle + i * (2 * pi / pentagonPoints);
      final x = pentagonRadius * cos(angle);
      final y = pentagonRadius * sin(angle);

      if (i == 0) {
        path.moveTo(70 + x, 70 + y);
      } else {
        path.lineTo(70 + x, 70 + y);
      }
    }

    // Draw star inside
    final starRadius = 40.0;
    final starInnerRadius = 20.0;
    final starPoints = 5;
    final starStartAngle = -pi / 2; // Start from top

    final starPath = Path();

    for (int i = 0; i < starPoints * 2; i++) {
      final radius = i % 2 == 0 ? starRadius : starInnerRadius;
      final angle = starStartAngle + i * (pi / starPoints);
      final x = radius * cos(angle);
      final y = radius * sin(angle);

      if (i == 0) {
        starPath.moveTo(70 + x, 70 + y);
      } else {
        starPath.lineTo(70 + x, 70 + y);
      }
    }
    starPath.close();

    // Draw with different styles
    final pentagonPaint =
        Paint()
          ..color = Colors.blue.shade700
          ..style = PaintingStyle.fill;

    final starPaint =
        Paint()
          ..color = Colors.amber
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.stroke
          // ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 5)
          ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 4)
          ..shader = const LinearGradient(
            colors: [Colors.red, Colors.yellow],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(Rect.fromCircle(center: Offset(70, 70), radius: 50))
          ..colorFilter = const ColorFilter.mode(
            Colors.red,
            BlendMode.colorBurn,
          )
          // ..imageFilter = ImageFilter.blur(
          //   sigmaX: 5,
          //   sigmaY: 5,
          // )
          // ..blendMode = BlendMode.colorDodge
          // ..strokeMiterLimit = 10 // Only used when strokeJoin = StrokeJoin.miter
          ..strokeWidth = 5;

    //     final borderPaint = Paint()
    //       ..color = Colors.deepPurple
    //       ..style = PaintingStyle.stroke
    //       ..strokeWidth = 3;
    //
    // canvas.drawPaint(borderPaint);
    // Draw shapes
    canvas.drawPath(path, pentagonPaint);
    canvas.drawPath(starPath, starPaint);
    // canvas.drawPath(path, borderPaint);

    // Restore the canvas to its original state
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant TransformedShapePainter oldDelegate) {
    return oldDelegate.skewX != skewX ||
        oldDelegate.skewY != skewY ||
        oldDelegate.rotation != rotation ||
        oldDelegate.scaleX != scaleX ||
        oldDelegate.scaleY != scaleY;
  }
}
