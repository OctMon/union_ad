
import 'dart:async';

import 'package:flutter/services.dart';

class UnionAd {
  static const MethodChannel _channel =
      const MethodChannel('union_ad');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> loadRewardVideo() async {
    await _channel.invokeMethod('loadRewardVideo');

  }

  static Future<bool> showRewardVideo() async {
    await _channel.invokeMethod('showRewardVideo');
  }

}
