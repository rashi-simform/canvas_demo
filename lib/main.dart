import 'dart:math';

import 'package:canvas_demo/modules/post_screen.dart';
import 'package:flutter/material.dart';

import 'package:canvas_demo/modules/game_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PostScreen()
    );
  }
}
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

class RectanglePainter1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint =
        Paint()
          ..color = Colors.blue // Rectangle color
          ..style = PaintingStyle.stroke; // Can be fill or stroke

    //Draw Rectangle
    // Rect rect = Rect.fromLTWH(50, 50, 100, 100); // (x, y, width, height)
    // Rect rect = Rect.fromCenter(center: Offset(200, 0) , width: 20, height: 30); //(center, width, height)
    // Rect rect = Rect.fromCircle(center: Offset(0, 0) , radius: 20); //(center, radius)
    // Rect rect = Rect.fromLTRB(10, 50, 100, 20); //(left, top, right, bottom)
    Rect rect = Rect.fromPoints(Offset(10, 40), Offset(200, 300)); //(offset1, offset2)
    // canvas.drawRect(rect, paint);

    // Draw a arc
    canvas.drawArc(rect, pi/2, 3*pi/2 , false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class RectanglePainter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint =
        Paint()
          ..color =
              Colors
                  .blue // Rectangle color
          ..style = PaintingStyle.fill; // Can be fill or stroke

    // Rect rect = Rect.fromLTWH(50, 50, 100, 100); // (x, y, width, height)
    // Rect rect = Rect.fromCenter(center: Offset(200, 0) , width: 20, height: 30); //(center, width, height)
    // Rect rect = Rect.fromCircle(center: Offset(0, 0) , radius: 20); //(center, radius)
    Rect rect = Rect.fromLTRB(10, 40, 200, 30); //(left, top, right, bottom)
    // Rect rect = Rect.fromPoints(Offset(10, 40), Offset(200, 30)); //(offset1, offset2)
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
