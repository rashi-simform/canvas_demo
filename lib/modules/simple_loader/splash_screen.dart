import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenStateBase createState() => SplashScreenStateBase();
}

class SplashScreenStateBase extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    controller.addStatusListener(statusListener);
    controller.forward();
  }

  statusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      controller.value = 0.0;
      controller.forward();
    }
  }

  @override
  void dispose() {
    controller.removeStatusListener(statusListener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      body: Center(
          child: ColoredBox(
            color: Colors.black,
            child: SizedBox(
              width: 105,
              height: 105,
              child: Center(
                child: AnimatedBuilder(
                    animation: controller.view,
                    builder: (context, snapshot) {
                      return ClipPath(
                        clipper: MyClipper(),
                        child: Container(
                          width: 100,
                          height: 100,
                          color: Colors.white,
                          child: CustomPaint(
                            painter: MyCustomPainter(controller.value),
                          ),
                        ),
                      );
                    }),
              ),
                ),
          ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final width = size.width;
    final height = size.height;
    final halfWidth = width * 0.5;

    Path path =
        Path()
          ..moveTo(halfWidth, 0)
          ..lineTo(halfWidth - 20, 55)
          ..lineTo(halfWidth, 55)
          ..lineTo(halfWidth - 20, height)
          ..lineTo(halfWidth + 20, 45)
          ..lineTo(halfWidth, 45)
          ..lineTo(halfWidth + 20, 0)
          ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return false;
  }
}

class MyCustomPainter extends CustomPainter {
  final double percentage;

  MyCustomPainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint =
        Paint()
          ..color = Colors.amber
          ..style = PaintingStyle.fill;

    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height * percentage);

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
