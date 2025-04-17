import 'package:canvas_demo/modules/game/hexagonal_painter.dart';
import 'package:flutter/material.dart';

class HexagonalBox extends StatelessWidget {
  const HexagonalBox({this.rotationAngle, this.size, super.key});

  /// rotation angle is in radians
  final double? rotationAngle;
  final Size? size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size ?? Size(80, 80),
      painter: HexagonPainter(rotationAngle: rotationAngle),
    );
  }
}
