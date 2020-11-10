#import "UnionAdPlugin.h"
#import <BUAdSDK/BUAdSDK.h>

@implementation UnionAdPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"union_ad"
            binaryMessenger:[registrar messenger]];
  UnionAdPlugin* instance = [[UnionAdPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *arguments = call.arguments;
      
    if ([@"register" isEqualToString:call.method]) {
        BUAdSDKLogLevel logLevel = [arguments[@"debug"] boolValue] ? BUAdSDKLogLevelDebug : BUAdSDKLogLevelNone;
        // Whether to open log. default is none.
        [BUAdSDKManager setLoglevel:logLevel];
        // BUAdSDK requires iOS 9 and up
        [BUAdSDKManager setAppID:arguments[@"iosAppId"]];
          
        result(@YES);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
