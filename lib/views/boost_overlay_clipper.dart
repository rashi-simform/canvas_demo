import 'package:flutter/material.dart';

class BoostOverlayClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const radius = 10;

    final path = Path()
      ..moveTo(
          size.width * 0.02 - (0.0 * radius), size.height * 0.85 + (1 * radius))
      ..quadraticBezierTo(
        size.width * 0.02 - (2.5 * radius),
        size.height * 0.85 - (0.1 * radius),
        size.width * 0.025 + (0 * radius),
        size.height * 0.85 - (4.0 * radius),
      )
      ..arcToPoint(
        Offset(size.width * 0.95 + (1 * radius),
            size.height * 0.85 - (4 * radius)),
        radius: Radius.circular(size.width * 0.55),
        clockwise: true,
      )
      ..quadraticBezierTo(
        size.width * 0.95 + (4 * radius),
        size.height * 0.85 + (0.5 * radius),
        size.width * 0.95 - (0 * radius),
        size.height * 0.85 + (1.5 * radius),
      )
      ..lineTo(
          size.width * 0.85 + (0 * radius), size.height * 0.95 - (0.8 * radius))
      ..quadraticBezierTo(
        size.width * 0.75 - (0 * radius),
        size.height * 0.95 + (0 * radius),
        size.width * 0.75 - (0.5 * radius),
        size.height * 0.9 - (0 * radius),
      )
      ..arcToPoint(
        Offset(
            size.width * 0.2 + (2 * radius), size.height * 0.95 - (2 * radius)),
        radius: Radius.circular(size.width * 0.27),
        clockwise: false,
      )
      ..quadraticBezierTo(
        size.width * 0.2 + radius,
        size.height * 0.95,
        size.width * 0.2 - (2 * radius),
        size.height * 0.95 - radius,
      )
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
