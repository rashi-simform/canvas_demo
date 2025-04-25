import 'package:flutter/material.dart';

import '../../values/enumerations.dart';

class CustomAppbarButton extends StatelessWidget {
  const CustomAppbarButton({
    this.position = Position.topRight,
    this.size,
    this.child,
    super.key,
  });

  final Position position;
  final Size? size;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size ?? Size(140, 60),
      painter: CornerButtonPainter(position: position),
      child: child,
    );
  }
}

class CornerButtonPainter extends CustomPainter {
  const CornerButtonPainter({this.position = Position.topRight});

  final Position position;

  @override
  void paint(Canvas canvas, Size size) {
    final path =
        Path()
          ..lineTo(0, size.height * 0.45)
          ..lineTo(size.width * 0.3, size.height)
          ..lineTo(size.width, size.height);

    Paint paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5
          ..color = const Color(0xfb1fff9d);

    if (position == Position.topLeft) {
      // topleft position
      canvas.scale(-1, 1);
      canvas.translate(-size.width, 0);
    } else if (position == Position.bottomRight) {
      // bottomRight position
      canvas.scale(1, -1);
      canvas.translate(0, -size.height);
    } else if (position == Position.bottomLeft) {
      // bottomLeft position
      canvas.scale(-1, -1);
      canvas.translate(-size.width, -size.height);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
