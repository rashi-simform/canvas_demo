import 'dart:async';

import 'package:flutter/services.dart';

class Gaimon {
  static const MethodChannel _channel = MethodChannel('gaimon');

  /// check if the device can vibrate or not
  static Future<bool> get canSupportsHaptic async {
    return await _channel.invokeMethod('canSupportsHaptic');
  }

  /// generate a selection impact vibration
  static void selection() => HapticFeedback.selectionClick();

  /// generate an error impact vibration
  static void error() => _channel.invokeMethod('error');

  /// generate a success impact vibration
  static void success() => _channel.invokeMethod('success');

  /// generate a warning impact vibration
  static void warning() => _channel.invokeMethod('warning');

  /// generate a heavy impact vibration
  static void heavy() => HapticFeedback.heavyImpact();

  /// generate a medium impact vibration
  static void medium() => HapticFeedback.mediumImpact();

  /// generate a light impact vibration
  static void light() => HapticFeedback.lightImpact();

  /// generate a rigid impact vibration
  static void rigid() => _channel.invokeMethod('rigid');

  /// generate a soft impact vibration
  static void soft() => _channel.invokeMethod('soft');

  static void cancel() => _channel.invokeMethod('cancel');

  /// generate a custom pattern impact vibration. This should be used for android.
  static void hapticsFromData(
    List<int> timings,
    List<int> scales, {
    bool repeat = false,
  }) =>
      _channel.invokeMethod(
        'hapticsFromData',
        {
          'timings': timings,
          'scales': scales,
          'repeat': repeat,
        },
      );

  /// generate a custom pattern impact vibration. This should be used for IOS.
  static void patternFromData(String data) => _channel.invokeMethod(
        'pattern',
        {
          'data': data,
        },
      );

  /// generate a custom pattern impact vibration from waveform (android only)
  static void patternFromWaveForm(
    List<int> timings,
    List<int> amplitudes, {
    required bool repeat,
  }) =>
      _channel.invokeMethod(
        'pattern',
        {
          'timings': timings,
          'amplitudes': amplitudes,
          'repeat': repeat,
        },
      );
}
