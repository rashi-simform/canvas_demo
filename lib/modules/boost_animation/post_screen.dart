import 'dart:async';
import 'dart:ui' as ui;

import 'package:canvas_demo/modules/boost_animation/boost_overlay_clipper.dart';
import 'package:canvas_demo/modules/boost_animation/boost_overlay_painter.dart';
import 'package:canvas_demo/modules/boost_animation/char_painter.dart';
import 'package:canvas_demo/utils/overlay_utils.dart';
import 'package:canvas_demo/modules/boost_animation/emoji_painter.dart';
import 'package:canvas_demo/modules/boost_animation/hand_painter.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';


class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen>
    with TickerProviderStateMixin {
  PaletteGenerator? paletteGenerator;
  double _value = 0.0;
  Color _overlayColor = Colors.blue;
  String _selectedEmoji = '💎';
  bool _isPressed = false;
  bool _showOverlay = false;
  late DateTime _pressStartTime;

  late AnimationController _vibrationAnimationController;
  late AnimationController _overlayController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _vibrationAnimation;
  late AnimationController _scaleController;

  late Animation<Offset> _overlayPositionAnimation;
  late Animation<double> _rotationAnimation;
  late Offset _initialPosition;
  late Offset _finalPosition;

  Timer? _timer;

  List<ValueNotifier<bool>> animationNotifiers = List.generate(
    6,
        (index) =>
        ValueNotifier<bool>(
          false,
        ),
  );

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _vibrationAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _overlayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeInOut,
      ),
    );

    _vibrationAnimation = Tween<double>(begin: 0.0, end: 2).animate(
      CurvedAnimation(
        parent: _vibrationAnimationController,
        curve: Curves.easeIn,
      ),
    );

    // Initialize the rotation animation
    _rotationAnimation = Tween<double>(begin: -30, end: 0.0).animate(
      CurvedAnimation(
        parent: _overlayController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  void _onValueChanged(double value) {
    if (value == 100) {
      _scaleController.forward().then((_) async{
        await _scaleController.reverse();
        setState(() {
          _showOverlay = false;
        });
      });
    } else {
      _scaleController.reverse();
    }
  }

  void _onPressStart() {
    setState(() {
      _isPressed = true;
    });
    _timer = Timer(const Duration(milliseconds: 100), () {
      if (_isPressed) {
        _startBlastAnimation();
      }
    });
  }

  void _startBlastAnimation() {
    setState(() {
      _isPressed = true;
      _showOverlay = true;
    });
    Utils.startVibration();
    // Define initial and final positions for the arc animation
    _initialPosition = const Offset(-60, 20); // Bottom-left corner
    _finalPosition = const Offset(0, 0); // Current position of the BoostOverlay

    _overlayPositionAnimation = Tween<Offset>(
      begin: _initialPosition,
      end: _finalPosition,
    ).animate(
      CurvedAnimation(
        parent: _overlayController,
        // curve: Curves.easeOutCubic,
        curve: Curves.fastEaseInToSlowEaseOut,
      ),
    );
    _vibrationAnimationController.forward();
    _overlayController.forward().then((_){
      _pressStartTime = DateTime.now();
      _updateValueOnPress();
    });
  }

  void _updateValueOnPress() async {
    const timeInMs = 3000;
    while (_isPressed) {
      final pressDuration = DateTime.now().difference(_pressStartTime).inMilliseconds;
      double percentage = (pressDuration / timeInMs).clamp(0.0, 1.0);
      setState(() {
        _value = (percentage * 100).clamp(0.0, 100.0);
      });
      _onValueChanged(_value);

      if (pressDuration >= timeInMs) break;
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  void _onPressEnd() {
    setState(() {
      _isPressed = false;
    });
    _vibrationAnimationController.reverse();
    if (_value < 100) {
      _overlayController.reverse().then((_) {
        setState(() {
          _showOverlay = false;
          _value=0;
        });
      });
    }else{
      _overlayController.reverse();
      setState(() {
        _showOverlay = false;
        _value = 0;
      });
    }
    Utils.stopVibration();
  }

  Future<void> _calculateBgColor(String emoji) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final textPainter = TextPainter(
      text: TextSpan(
        text: emoji,
        style: const TextStyle(fontSize: 50),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset.zero);

    final image = await recorder.endRecording().toImage(
      textPainter.width.toInt(),
      textPainter.height.toInt(),
    );

    final palette = await PaletteGenerator.fromImage(image);

    setState(() {
      _overlayColor = palette.colors.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dimensions = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/images/background3.jpg',
            height: dimensions.height,
            width: dimensions.width,
            opacity: const AlwaysStoppedAnimation(0.9),
            fit: BoxFit.cover,
          ),
          if (_showOverlay)
            AnimatedBuilder(
              animation: _overlayController,
              builder: (context, child) {
                return Transform.translate(
                  offset: _overlayPositionAnimation.value,
                  child: Transform.rotate(
                    angle: _rotationAnimation.value * 3.14159 / 180, // Convert degrees to radians
                    child: child,
                  ),
                );
              },
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Stack(
                  children: [
                    CustomPaint(
                      size: const Size(300, 300),
                      painter: BoostOverlayPainter(
                        overlayColor: _overlayColor,
                      ),
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
                                final textPath = Path()
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
                                    final handValue = _value / 100;
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
                                        animationNotifier:
                                        animationNotifiers[i],
                                        xOffset: xOffset,
                                      ),
                                    );
                                    animationNotifiers[i].value = false;
                                    xOffset += 55;
                                  }
                                  return Stack(
                                    fit: StackFit.loose,
                                    children: widgets,
                                  );
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
                                value: _value,
                                overlayColor: _overlayColor,
                              ),
                            ),
                          ),
                          CustomPaint(
                            size: const Size(300, 300),
                            painter: EmojiPainter(
                              value: _value,
                              selectedEmoji: _selectedEmoji,
                              vibrationValue: _vibrationAnimation.value,
                              handValue: _value / 100,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),


          ///Here
          // BoostOverlay(
          //   overlayController: _overlayController,
          //   overlayAnimationValue: _overlayPositionAnimation.value,
          //   rotationAnimationValue: _rotationAnimation.value,
          //   vibrationAnimationValue: _vibrationAnimation.value,
          //   scaleAnimation: _scaleAnimation,
          //   overlayColor: _overlayColor,
          //   value: _value,
          //   selectedEmoji: _selectedEmoji,
          // ),
          Positioned(
            bottom: 50,
            child: Column(
              children: [
                GestureDetector(
                  onTapDown: (_) => _onPressStart(),
                  onTapUp: (_) => _onPressEnd(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Boost",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 50,
            child: DropdownButton<String>(
              value: _selectedEmoji,
              items: ['🔥', '⭐', '😈', '❤️', '💥', '🌟', '💎']
                  .map((emoji) => DropdownMenuItem<String>(
                value: emoji,
                child: Text(emoji, style: const TextStyle(fontSize: 40)),
              ))
                  .toList(),
              onChanged: (emoji) {
                if (emoji == null) return;
                setState(() {
                  _selectedEmoji = emoji;
                  _calculateBgColor(emoji);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _vibrationAnimationController.dispose();
    _overlayController.dispose();
    _scaleController.dispose();
    super.dispose();
  }
}
