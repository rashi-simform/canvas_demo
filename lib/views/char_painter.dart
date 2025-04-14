import 'dart:ui';

import 'package:flutter/material.dart';

class AnimatedCharPainter extends StatefulWidget {
  const AnimatedCharPainter({
    required this.char,
    this.xOffset = 0,
    required this.index,
    required this.animationNotifier,
    required this.metric,
    super.key,
  });

  final double xOffset;
  final String char;
  final int index;
  final PathMetric metric;
  final ValueNotifier<bool> animationNotifier;

  @override
  _AnimatedCharPainterState createState() => _AnimatedCharPainterState();
}

class _AnimatedCharPainterState extends State<AnimatedCharPainter>
    with SingleTickerProviderStateMixin {
  late AnimationController _opacityController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.animationNotifier.addListener(_onAnimationTriggered);
    });

    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _opacityAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _opacityController,
        curve: Curves.easeInOut,
      ),
    );
  }


  void _onAnimationTriggered() {
    if (widget.animationNotifier.value) {
      _opacityController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: CharPainter(
            char: widget.char,
            opacity: _opacityAnimation.value,
            xOffset: widget.xOffset,
            index: widget.index,
            metric: widget.metric,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    widget.animationNotifier.removeListener(_onAnimationTriggered);
    _opacityController.dispose();
    super.dispose();
  }

}

class CharPainter extends CustomPainter {
  const CharPainter({
    required this.char,
    required this.opacity,
    required this.xOffset,
    required this.index,
    required this.metric,
  });

  final String char;
  final double opacity;
  final double xOffset;
  final int index;
  final PathMetric metric;

  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      fontSize: 84,
      fontWeight: FontWeight.bold,
      color: Colors.white.withOpacity(0.4),
      fontFamily: 'Flawless',
      letterSpacing: 9,
    );
    final charPainter = TextPainter(
      text: TextSpan(
        text: char,
        style: textStyle.copyWith(
          color: Colors.white.withOpacity(opacity),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    charPainter.layout();
    final position =
    metric.getTangentForOffset(xOffset  + charPainter.width / 2);

    if(position == null) return;

    // Rotate canvas to align text with the path
    canvas.save();
    canvas.translate(position.position.dx, position.position.dy);
    canvas.rotate(-position.angle);
    charPainter.paint(
        canvas, Offset(-charPainter.width / 2, - charPainter.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
