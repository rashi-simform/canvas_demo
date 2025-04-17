import 'package:canvas_demo/modules/boost_animation/boost_overlay_clipper.dart';
import 'package:canvas_demo/modules/boost_animation/boost_overlay_painter.dart';
import 'package:canvas_demo/modules/boost_animation/char_painter.dart';
import 'package:canvas_demo/modules/boost_animation/emoji_painter.dart';
import 'package:canvas_demo/modules/boost_animation/hand_painter.dart';
import 'package:flutter/material.dart';

class BoostOverlay extends StatefulWidget {
  const BoostOverlay({
    super.key,
    required this.overlayController,
    required this.overlayAnimationValue,
    required this.rotationAnimationValue,
    required this.vibrationAnimationValue,
    required this.scaleAnimation,
    required this.overlayColor,
    required this.value,
    required this.selectedEmoji,
  });

  final AnimationController overlayController;
  final Offset overlayAnimationValue;
  final double rotationAnimationValue;
  final double vibrationAnimationValue;
  final Animation<double> scaleAnimation;
  final Color overlayColor;
  final double value;
  final String selectedEmoji;

  @override
  State<BoostOverlay> createState() => _BoostOverlayState();
}

class _BoostOverlayState extends State<BoostOverlay> {
  List<ValueNotifier<bool>> animationNotifiers = List.generate(
    6,
    (index) => ValueNotifier<bool>(false),
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.overlayController,
      builder: (context, child) {
        return Transform.translate(
          offset: widget.overlayAnimationValue,
          child: Transform.rotate(
            angle: widget.rotationAnimationValue * 3.14159 / 180,
            // Convert degrees to radians
            child: child,
          ),
        );
      },
      child: ScaleTransition(
        scale: widget.scaleAnimation,
        child: Stack(
          children: [
            CustomPaint(
              size: const Size(300, 300),
              painter: BoostOverlayPainter(overlayColor: widget.overlayColor),
              child: Stack(
                children: [
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: Builder(
                      builder: (context) {
                        Size size = const Size(300, 300);
                        double radius = 10;
                        const text = "BOOST!";
                        // Create a path for the text to follow
                        final textPath =
                            Path()
                              ..moveTo(
                                size.width * 0.1 - (0 * radius),
                                size.height * 0.9,
                              )
                              ..arcToPoint(
                                Offset(
                                  size.width * 0.9 - radius,
                                  size.height * 0.85,
                                ),
                                radius: Radius.circular(size.width * 0.4),
                                clockwise: true,
                              );

                        // Measure the path
                        final pathMetrics = textPath.computeMetrics();
                        final widgets = <Widget>[];
                        var xOffset = 8.0;
                        for (final metric in pathMetrics) {
                          for (int i = 0; i < text.length; i++) {
                            final char = text[i];
                            final handValue = widget.value / 100;
                            final shouldStartAnimation =
                                (i) / 6 <= handValue
                                    ? handValue > (0.1 * (i + 0.5))
                                        ? true
                                        : false
                                    : false;

                            if (shouldStartAnimation) {
                              animationNotifiers[i].value = true;
                            }

                            widgets.add(
                              AnimatedCharPainter(
                                metric: metric,
                                char: char,
                                index: i,
                                animationNotifier: animationNotifiers[i],
                                xOffset: xOffset,
                              ),
                            );
                            animationNotifiers[i].value = false;
                            xOffset += 55;
                          }
                          return Stack(fit: StackFit.loose, children: widgets);
                        }
                        return Container();
                      },
                    ),
                  ),
                  ClipPath(
                    clipper: BoostOverlayClipper(),
                    child: CustomPaint(
                      size: const Size(300, 300),
                      painter: HandPainter(
                        value: widget.value,
                        overlayColor: widget.overlayColor,
                      ),
                    ),
                  ),
                  CustomPaint(
                    size: const Size(300, 300),
                    painter: EmojiPainter(
                      value: widget.value,
                      selectedEmoji: widget.selectedEmoji,
                      vibrationValue: widget.vibrationAnimationValue,
                      handValue: widget.value / 100,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
