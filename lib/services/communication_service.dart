import 'dart:async';
import 'package:flutter/services.dart';

class ShakeDetectorStream {
  static const _eventChannel = EventChannel('com.example/shake');

  static Stream<Map<String, dynamic>> shakeEvents({
    double? shakeThresholdG,
    int? minIntervalMs,
  }) {
    return _eventChannel.receiveBroadcastStream().map((event) {
      return Map<String, dynamic>.from(event as Map);
    });
  }
}
