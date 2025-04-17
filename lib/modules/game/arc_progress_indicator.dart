import 'dart:math';

import 'package:flutter/material.dart';

class ArcProgressIndicator extends StatefulWidget {
  final double initialProgress;

  const ArcProgressIndicator({
    super.key,
    this.initialProgress = 0,
  });

  @override
  State<ArcProgressIndicator> createState() => _ArcProgressIndicatorState();
}

class _ArcProgressIndicatorState extends State<ArcProgressIndicator> {
  late double _progress;
  final double _startAngle = 130 * pi / 180;
  final double _sweepAngle = 280 * pi / 180;

  @override
  void initState() {
    super.initState();
    _progress = widget.initialProgress.clamp(0.0, 1.0);
  }

  void _updateProgressFromPosition(Offset position) {
    final center = Offset(
      MediaQuery
          .of(context)
          .size
          .width * 0.5,
      MediaQuery
          .of(context)
          .size
          .height * 0.5,
    );

    // Calculate the angle from center to touch point
    final angle = atan2(
      position.dy - center.dy,
      position.dx - center.dx,
    );

    // Normalize the angle to range [0, 2π]
    double normalizedAngle = angle > 1 ? angle : angle + 2 * pi;

    // Check if the angle is within our arc range
    if (normalizedAngle < _startAngle ||
        normalizedAngle > _startAngle + _sweepAngle) {
      if (normalizedAngle > _startAngle + _sweepAngle &&
          normalizedAngle < 2 * pi) {
        normalizedAngle = _startAngle + _sweepAngle;
      }
    }

    double newProgress = (normalizedAngle - _startAngle) / _sweepAngle;
    newProgress = newProgress.clamp(0.0, 1.0);

    setState(() {
      _progress = newProgress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (details) =>
          _updateProgressFromPosition(details.localPosition),
      onPanUpdate: (details) =>
          _updateProgressFromPosition(details.localPosition),
      child: RepaintBoundary(
        child: CustomPaint(
          size: const Size(double.infinity, double.infinity),
          painter: ArcPainter(
            progress: _progress,
            startAngle: _startAngle,
            sweepAngle: _sweepAngle,
          ),
          child: IgnorePointer(
            ignoring: true,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Progress', style: TextStyle(color: Colors.white)),
                  Text(
                    '${(_progress * 100).toStringAsPrecision(3)}%',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ArcPainter extends CustomPainter {
  ArcPainter({
    required this.progress,
    required this.startAngle,
    required this.sweepAngle,
  });

  final double progress;
  final double startAngle;
  final double sweepAngle;
  Path hitPath = Path();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.5);
    final radius = size.width * 0.4;
    final arcRect = Rect.fromCircle(center: center, radius: radius);

    // Draw background arc
    Paint backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8 // Increased strokeWidth for better visibility
      ..color = const Color(0xffa04Ff0).withAlpha(60);

    hitPath = Path()
      ..addArc(arcRect,
          startAngle,
          sweepAngle
      );

    canvas.drawPath(
      hitPath,
      backgroundPaint,
    );

    // Draw progress arc
    Paint progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xffa04Ff0);
    // ..color = const Color(0xffffffff);

    canvas.drawArc(
      arcRect,
      startAngle,
      sweepAngle * progress,
      false,
      progressPaint,
    );

    // Draw inner circle
    Paint innerCirclePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = const Color(0xffa04Ff0).withAlpha(60);

    canvas.drawCircle(center, size.width * 0.32, innerCirclePaint);

    // Calculate position of the draggable circle
    final angle = startAngle + (sweepAngle * progress);
    final circleX = center.dx + radius * cos(angle);
    final circleY = center.dy + radius * sin(angle);


    // Draw draggable circle
    Paint circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..color = const Color(0xffa04Ff0);
    // ..color = const Color(0xff2f3Ff5);

    //TODO(Rashi): Check this for dotted line
    // canvas.drawPoints(PointMode.points, [
    //   Offset(100, 100),
    //   Offset(106, 106),
    //   Offset(113, 106),
    //   Offset(130, 130),
    //   Offset(140, 140),
    //   Offset(150, 150),
    // ], circlePaint);
    // drawDashedLine(
    //   canvas: canvas,
    //   p1: Offset(100, 200),
    //   p2: Offset(180, 300),
    //   pattern: [20, 5, 5, 5],
    //   paint: circlePaint,);

    canvas.drawCircle(Offset(circleX, circleY), 14, circlePaint);


    // Draw white border around the circle
    Paint circleBorderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white;

    canvas.drawCircle(Offset(circleX, circleY), 14, circleBorderPaint);
  }

  @override
  bool shouldRepaint(covariant ArcPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }

//TODO(Rashi): Check for the hitTest
@override
bool? hitTest(Offset position) {
  final center = Offset(190, 330);
  final arcRect = Rect.fromCircle(center: center, radius: 160);
  final smallerArcRect = Rect.fromCircle(center: center, radius: 130);
  final path =  Path()
  ..arcTo(arcRect, startAngle, sweepAngle, false)
  ..arcTo(smallerArcRect, startAngle+sweepAngle, -sweepAngle, false);
  return path.contains(position);
}

  // void drawDashedLine({
  //   required Canvas canvas,
  //   required Offset p1,
  //   required Offset p2,
  //   required Iterable<double> pattern,
  //   required Paint paint,
  // }) {
  //   assert(pattern.length.isEven);
  //   final distance = (p2 - p1).distance;
  //   final normalizedPattern = pattern.map((width) => width / distance).toList();
  //   final points = <Offset>[];
  //   double t = 0;
  //   int i = 0;
  //   while (t < 1) {
  //     points.add(Offset.lerp(p1, p2, t)!);
  //     t += normalizedPattern[i++]; // dashWidth
  //     points.add(Offset.lerp(p1, p2, t.clamp(0, 1))!);
  //     t += normalizedPattern[i++]; // dashSpace
  //     i %= normalizedPattern.length;
  //   }
  //   canvas.drawPoints(ui.PointMode.lines, points, paint);
  // }

}
