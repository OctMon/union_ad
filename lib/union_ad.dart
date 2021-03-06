import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
// import 'package:permission_handler/permission_handler.dart';

class UnionAd {
  static const MethodChannel _channel = const MethodChannel('union_ad');

  static const method_loadError = 'loadError';
  static const method_loaded = 'loaded';
  static const method_cached = 'cached';
  static const method_showed = 'showed';
  static const method_skip = 'skip';
  static const method_rewarded = 'rewarded';
  static const method_playComplete = 'playComplete';
  static const method_closed = 'closed';
  static const method_adIdForAdvertisers = 'adIdForAdvertisers';

  UnionAd._();

  ///sdk注册初始化
  static Future<bool> registerAd({
    @required String iosAppId,
    @required String androidAppId,
    String appName,
    bool debug,
  }) async {
    bool register = await _channel.invokeMethod("registerAd", {
      "iosAppId": iosAppId,
      "androidAppId": androidAppId,
      "appName": appName ?? "",
      "debug": debug ?? false,
    });

    ///android 为了增加转化
    // if(Platform.isAndroid){
    //   Map<Permission, PermissionStatus> statuses = await [
    //     Permission.phone,
    //     Permission.location,
    //     Permission.storage,
    //   ].request();
    // }

    return register;
  }

  ///激励视频监听
  static Future<void> registerRewardAdCallback({
    @required Function loadError,
    @required Function loaded,
    @required Function cached,
    @required Function showed,
    @required Function skip,
    @required Function rewarded,
    @required Function playComplete,
    @required Function closed,
  }) async {
    _channel.setMethodCallHandler((call) {
      print('reward video status：${call.method}');
      switch (call.method) {
        case method_loadError:
          loadError();
          break;
        case method_loaded:
          loaded();
          break;
        case method_cached:
          cached();
          break;
        case method_showed:
          showed();
          break;
        case method_skip:
          skip();
          break;
        case method_rewarded:
          rewarded();
          break;
        case method_playComplete:
          playComplete();
          break;
        case method_closed:
          closed();
          break;
        default:
          print('flutter notImplemented the method');
      }

      return;
    });
  }

  ///加载激励视频广告
  static Future<bool> loadRewardVideo(
      {@required String codeIdAndroid, @required String codeIdIos}) async {
    return await _channel.invokeMethod('loadRewardVideo',
        {"codeIdAndroid": codeIdAndroid ?? '', 'codeIdIos': codeIdIos ?? ''});
  }

  ///展示激励视频广告
  static Future<bool> showRewardVideo() async {
    return await _channel.invokeMethod('showRewardVideo');
  }

  /// 获取IDFA
  static Future<String> getAdIdForAdvertisers() async {
    return await _channel.invokeMethod('adIdForAdvertisers');
  }
}
