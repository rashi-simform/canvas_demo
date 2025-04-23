import 'dart:ui' as ui;

import 'package:canvas_demo/modules/game/hexagonal_painter.dart';
import 'package:flutter/material.dart';

class HexagonalBox extends StatefulWidget {
  const HexagonalBox({this.rotationAngle, this.size, super.key, this.child});

  /// rotation angle is in radians
  final double? rotationAngle;
  final Size? size;
  final Widget? child;

  @override
  State<HexagonalBox> createState() => _HexagonalBoxState();
}

class _HexagonalBoxState extends State<HexagonalBox> {
  ui.Image? _image;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    AssetImageLoader.loadImage('assets/images/background4.jpg').then((image) {
      setState(() {
        _image = image;
        _isLoading = false;
      });
    }).catchError((error) {
      // Handle error if needed
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CircularProgressIndicator()
        : CustomPaint(
          size: widget.size ?? Size(80, 80),
          painter: HexagonPainter(
            rotationAngle: widget.rotationAngle,
            image: _image,
          ),
          child: widget.child,
        );
  }
}
