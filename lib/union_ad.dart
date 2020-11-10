import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class UnionAd {
  static const MethodChannel _channel = const MethodChannel('union_ad');

  UnionAd._();

  ///sdk注册初始化
  static Future<bool> register({
    @required String iosAppId,
    @required String androidAppId,
    String appName,
    bool debug,
  }) async {
    return await _channel.invokeMethod("register", {
      "iosAppId": iosAppId,
      "androidAppId": androidAppId,
      "appName": appName ?? "",
      "debug": debug ?? false,
    });
  }

  static Future<bool> loadRewardVideo() async {
    return await _channel.invokeMethod('loadRewardVideo');
  }

  static Future<bool> showRewardVideo() async {
    return await _channel.invokeMethod('showRewardVideo');
  }
}
