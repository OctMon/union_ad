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

  ///加载激励视频广告
  static Future<bool> loadRewardVideo({@required String codeIdAndroid, @required String codeIdIos}) async {
    return await _channel.invokeMethod('loadRewardVideo',{"codeIdAndroid":codeIdAndroid??'','codeIdIos':codeIdIos??''});
  }

  ///展示激励视频广告
  static Future<bool> showRewardVideo() async {
    return await _channel.invokeMethod('showRewardVideo');
  }
}
