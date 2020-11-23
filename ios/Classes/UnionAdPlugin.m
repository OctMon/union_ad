#import "UnionAdPlugin.h"
#import <BUAdSDK/BUAdSDK.h>
#import <AdSupport/AdSupport.h>
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
    } else if ([@"adIdForAdvertisers" isEqualToString:call.method]) {
        [self adIdForAdvertisersCall:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)adIdForAdvertisersCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    result([self adIdForAdvertisers]);
}

- (NSString *)adJoin:(NSString *)first, ... {
    NSString *iter, *result = first;
    va_list strings;
    va_start(strings, first);

    while ((iter = va_arg(strings, NSString*))) {
        NSString *capitalized = iter.capitalizedString;
        result = [result stringByAppendingString:capitalized];
    }
    
    va_end(strings);

    return result;
}

- (BOOL)adTrackingEnabled {
//#if NO_IDFA
//    return NO;
//#else
    // return [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
    NSString *className = [self adJoin:@"A", @"S", @"identifier", @"manager", nil];
    Class class = NSClassFromString(className);
    if (class == nil) {
        return NO;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    NSString *keyManager = [self adJoin:@"shared", @"manager", nil];
    SEL selManager = NSSelectorFromString(keyManager);
    if (![class respondsToSelector:selManager]) {
        return NO;
    }
    id manager = [class performSelector:selManager];

    NSString *keyEnabled = [self adJoin:@"is", @"advertising", @"tracking", @"enabled", nil];
    SEL selEnabled = NSSelectorFromString(keyEnabled);
    if (![manager respondsToSelector:selEnabled]) {
        return NO;
    }
    BOOL enabled = (BOOL)[manager performSelector:selEnabled];
    return enabled;
#pragma clang diagnostic pop
//#endif
}

- (NSString *)adIdForAdvertisers {
//#if NO_IDFA
//    return @"";
//#else
    // return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *className = [self adJoin:@"A", @"S", @"identifier", @"manager", nil];
    Class class = NSClassFromString(className);
    if (class == nil) {
        return @"";
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

    NSString *keyManager = [self adJoin:@"shared", @"manager", nil];
    SEL selManager = NSSelectorFromString(keyManager);
    if (![class respondsToSelector:selManager]) {
        return @"";
    }
    id manager = [class performSelector:selManager];

    NSString *keyIdentifier = [self adJoin:@"advertising", @"identifier", nil];
    SEL selIdentifier = NSSelectorFromString(keyIdentifier);
    if (![manager respondsToSelector:selIdentifier]) {
        return @"";
    }
    id identifier = [manager performSelector:selIdentifier];

    NSString *keyString = [self adJoin:@"UUID", @"string", nil];
    SEL selString = NSSelectorFromString(keyString);
    if (![identifier respondsToSelector:selString]) {
        return @"";
    }
    NSString *string = [identifier performSelector:selString];
    return string;

#pragma clang diagnostic pop
//#endif
}

@end
