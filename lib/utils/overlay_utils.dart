import 'dart:io';

import 'package:flutter/services.dart';
import 'package:gaimon/gaimon.dart';
import 'package:vibration/vibration.dart';

class Utils {
  Utils._();

  static List<int> createHapticsPatternForAndroid() {
    final pattern = List.generate(30, (index) {
      int intensity =
          (index * 500 / 60).round();
      int duration = 1;
      return [duration, intensity];
    }).expand((e) => e).toList();
    return pattern;
  }

  static void startVibration() async {
    if (Platform.isAndroid) {
      final pattern = createHapticsPatternForAndroid();
      Vibration.vibrate(pattern: pattern);
    } else {
      final String jsonString = await rootBundle
          .loadString('assets/haptic/iOSBlastAnimationPattern.ahap');
      Gaimon.patternFromData(jsonString);
    }
  }

  static void stopVibration() {
    if (Platform.isAndroid) {
      Vibration.cancel();
    } else {
      Gaimon.cancel();
    }
  }
}
