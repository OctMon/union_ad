#import "UnionAdPlugin.h"
#import <BUAdSDK/BUAdSDK.h>
#import "RewardedVideoAd.h"

@interface UnionAdPlugin ()

@property (nonatomic, strong) RewardedVideoAd *rewardedVideoAd;

@end

@implementation UnionAdPlugin

static FlutterMethodChannel* channel;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  channel = [FlutterMethodChannel
      methodChannelWithName:@"union_ad"
            binaryMessenger:[registrar messenger]];
  UnionAdPlugin* instance = [[UnionAdPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *arguments = call.arguments;
      
    if ([@"registerAd" isEqualToString:call.method]) {
        BUAdSDKLogLevel logLevel = [arguments[@"debug"] boolValue] ? BUAdSDKLogLevelDebug : BUAdSDKLogLevelNone;
        // Whether to open log. default is none.
        [BUAdSDKManager setLoglevel:logLevel];
        // BUAdSDK requires iOS 9 and up
        [BUAdSDKManager setAppID:arguments[@"iosAppId"]];
          
        result(@YES);
    } else if ([@"loadRewardVideo" isEqualToString:call.method]) {
        BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
    //    model.userId = @"123";
        self.rewardedVideoAd = [[RewardedVideoAd alloc] initWithSlotID:arguments[@"codeIdIos"] rewardedVideoModel:model unionAdChannel:channel];
        [self.rewardedVideoAd loadAdData];
        
    } else if ([@"showRewardVideo" isEqualToString:call.method]) {
        [self.rewardedVideoAd showRewardVideo];
    }  else {
        result(FlutterMethodNotImplemented);
    }
}

@end
