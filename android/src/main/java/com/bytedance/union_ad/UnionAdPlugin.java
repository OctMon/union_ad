package com.bytedance.union_ad;

import android.app.Activity;

import androidx.annotation.NonNull;

import com.bytedance.union_ad.config.TTAdManagerHolder;
import com.bytedance.union_ad.reward_video.RewardVideo;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** UnionAdPlugin */
public class UnionAdPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity

  private static String channelName = "union_ad";

  private MethodChannel channel;
  private Activity context;
  private RewardVideo rewardVideo;

  public void registerWith(Registrar registrar) {
    UnionAdPlugin plugin = new UnionAdPlugin();
    plugin.context = registrar.activity();
    plugin.channel = new MethodChannel(registrar.messenger(), channelName);
    plugin.channel.setMethodCallHandler(this);
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), channelName);
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    }else if(call.method.equals("register")){
      String appId = call.argument("androidAppId");
      String appName = call.argument("appName");
      boolean debug = call.argument("debug");

      TTAdManagerHolder.init(context.getApplicationContext(), appId, appName, debug);

    }else if(call.method.equals("loadRewardVideo")){
      if (rewardVideo == null){
        rewardVideo = new RewardVideo(context);
      }
      String codeId = call.argument("codeIdAndroid");
      rewardVideo.loadAd(codeId);
    }else if(call.method.equals("showRewardVideo")){
      if (rewardVideo == null){
        rewardVideo = new RewardVideo(context);
      }
      rewardVideo.showAd();
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    context = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivity() {

  }

}
