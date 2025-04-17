import 'dart:math';

import 'package:flutter/material.dart';

class EmojiPainter extends CustomPainter {
  const EmojiPainter({
    required this.value,
    required this.selectedEmoji,
    required this.vibrationValue,
    required this.handValue,
  });

  final double value;
  final String selectedEmoji;
  final double vibrationValue;
  final double handValue;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Apply the vibration effect to the emoji position
    final vibrationOffset = Offset(
      vibrationValue * (2.0 * (0.5 - Random().nextDouble())),

      vibrationValue *
          (2.0 * (0.5 - Random().nextDouble())),
    );

    // Draw emoji at the center with vibration effect
    final emoji = selectedEmoji;
    final emojiPainter = TextPainter(
      text: TextSpan(
        text: emoji,
        style: TextStyle(
          fontSize: 48+ (15* handValue),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    emojiPainter.layout();
    emojiPainter.paint(
      canvas,
      Offset(center.dx - emojiPainter.width / 2 + vibrationOffset.dx,
          center.dy - emojiPainter.height / 16 + vibrationOffset.dy),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
