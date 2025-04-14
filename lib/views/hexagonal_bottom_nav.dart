import 'package:canvas_demo/views/hexagonal_box.dart';
import 'package:flutter/material.dart';

class HexagonalBottomNav extends StatelessWidget {
  const HexagonalBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 20,
          left: 130,
          child: SizedBox(
            // width: 100,
            // height: 100,
            child: CustomPaint(
              size: const Size(100, 100),
              painter: HexagonPainter(),
            ),
          ),
        ),
        Positioned(
          bottom: 60,
          left: 60,
          child: SizedBox(
            // width: 100,
            // height: 100,
            child: CustomPaint(
              size: const Size(100, 100),
              painter: HexagonPainter(),
            ),
          ),
        ),
        Positioned(
          bottom: 60,
          left: 200,
          child: SizedBox(
            // width: 100,
            // height: 100,
            child: CustomPaint(
              size: const Size(100, 100),
              painter: HexagonPainter(),
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          left: 125,
          child: SizedBox(
            // width: 100,
            // height: 100,
            child: CustomPaint(
              size: const Size(110, 110),
              painter: HexagonPainter(),
            ),
          ),
        ),
      ],
    );
  }
}
