import 'package:flutter/material.dart';

class DrawShape extends StatefulWidget {
  const DrawShape({super.key});

  @override
  State<DrawShape> createState() => _DrawShapeState();
}

class _DrawShapeState extends State<DrawShape>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    animationController.addStatusListener(statusListener);
    animationController.forward();
  }

  statusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      animationController.value = 0.0;
      animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          //TODO: heart clipper and painter

          children: [
            SizedBox(
              width: 400,
              height: 400,
              child: AnimatedBuilder(
                animation: animationController.view,
                builder: (context, _) {
                  return SizedBox(
                    width: 400,
                    height: 400,
                    child: CustomPaint(
                      painter: ShapePainter(
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    animationController.removeStatusListener(statusListener);
    animationController.dispose();
    super.dispose();
  }
}

class ShapePainter extends CustomPainter {
  const ShapePainter({super.repaint, this.animationValue = 1});

  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint =
        Paint()
          ..color = Colors.pink
          ..style = PaintingStyle.stroke
    ..strokeWidth=5;

    //heart path
    final path = Path()
              ..moveTo(0.5 * size.width, size.height * 0.4)
              ..cubicTo(
                0.2 * size.width, size.height * 0.1, //control point 1
                -0.25 * size.width, size.height * 0.6, //control point 2
                0.5 * size.width, size.height, //end point
              )
              ..cubicTo(
                1.25 * size.width, size.height * 0.6, //control point 1
                0.8 * size.width, size.height * 0.1, //control point 2
                0.5 * size.width, size.height * 0.4, //end point
              )
              ..close();

    Rect rect = Rect.fromLTWH(10, 10, size.width, size.height * animationValue);

    canvas.drawRect(rect, paint);
    canvas.drawRect(rect, paint..color = Colors.white ..style = PaintingStyle.fill);
    canvas.drawPath(path, paint..color = Colors.pink ..style= PaintingStyle.stroke);

    // canvas.drawPath(path, paint..color=Colors.pink);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class ShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path =
        Path()
          ..moveTo(0.5 * size.width, size.height * 0.4)
          ..cubicTo(
            0.2 * size.width,
            size.height * 0.1, //control point 1
            -0.25 * size.width,
            size.height * 0.6, //control point 2
            0.5 * size.width,
            size.height, //end point
          )
          ..cubicTo(
            1.25 * size.width,
            size.height * 0.6, //control point 1
            0.8 * size.width,
            size.height * 0.1, //control point 2
            0.5 * size.width,
            size.height * 0.4, //end point
          )
          ..close();
    return path;
  }

  //clip inside

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
