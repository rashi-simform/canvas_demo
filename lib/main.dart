import 'package:canvas_demo/modules/home/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: HomeScreen()
    );
  }
}


/// Simple CustomPainter example to draw a rectangle
class RectanglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    // canvas.clipPath(Path()
    //   ..addRect(const Rect.fromLTRB(10, 10, 20, 200))
    //   ..addRect(const Rect.fromLTRB(80, 80, 10, 10)));
    canvas.clipPath(Path()
      ..addRect(const Rect.fromLTRB(80, 10, 100, 20))
      ..addRect(const Rect.fromLTRB(10, 80, 20, 1)));
    // Get the area the canvas is allowed to draw on
    final Rect clipBounds = canvas.getLocalClipBounds();

    // Draw a rectangle that fills the clip bounds
    canvas.drawRect(clipBounds, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
