//
//  RewardedVideoAd.m
//  union_ad
//
//  Created by OctMon on 2020/11/10.
//

#import "RewardedVideoAd.h"
#import "UnionAdMacros.h"

@interface RewardedVideoAd () <BURewardedVideoAdDelegate>
{
    FlutterMethodChannel* _unionAdChannel;
}

@property (nonatomic, strong) BURewardedVideoAd *rewardedVideoAd;

@end

@implementation RewardedVideoAd

- (instancetype)initWithSlotID:(NSString *)slotID rewardedVideoModel:(BURewardedVideoModel *)model unionAdChannel:(FlutterMethodChannel *)unionAdChannel {
    self.rewardedVideoAd = [[BURewardedVideoAd alloc] initWithSlotID:slotID rewardedVideoModel:model];
    self.rewardedVideoAd.delegate = self;
    _unionAdChannel = unionAdChannel;
    return self;
}

- (void)loadAdData {
    [self.rewardedVideoAd loadAdData];
}

- (void)showRewardVideo {
    if (self.rewardedVideoAd) {
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        [self.rewardedVideoAd showAdFromRootViewController:keyWindow.rootViewController];
    }
}

#pragma mark - BURewardedVideoAdDelegate
- (void)rewardedVideoAdDidLoad:(BURewardedVideoAd *)rewardedVideoAd {
    [_unionAdChannel invokeMethod:@"loaded" arguments:nil result:nil];
    BUD_Log(@"%st",__func__);
    BUD_Log(@"mediaExt-%@",rewardedVideoAd.mediaExt);
}

- (void)rewardedVideoAdVideoDidLoad:(BURewardedVideoAd *)rewardedVideoAd {
    [_unionAdChannel invokeMethod:@"cached" arguments:nil result:nil];
    BUD_Log(@"%s",__func__);
}

- (void)rewardedVideoAd:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    [_unionAdChannel invokeMethod:@"loadError" arguments:nil result:nil];
    BUD_Log(@"%s",__func__);
    NSLog(@"error code : %ld , error message : %@",(long)error.code,error.description);
}

- (void)rewardedVideoAdWillVisible:(BURewardedVideoAd *)rewardedVideoAd {
    BUD_Log(@"%s",__func__);
}

- (void)rewardedVideoAdDidVisible:(BURewardedVideoAd *)rewardedVideoAd{
    [UIApplication.sharedApplication setStatusBarHidden:YES];
    [_unionAdChannel invokeMethod:@"showed" arguments:nil result:nil];
    BUD_Log(@"%s",__func__);
}

- (void)rewardedVideoAdWillClose:(BURewardedVideoAd *)rewardedVideoAd{
    BUD_Log(@"%s",__func__);
}

- (void)rewardedVideoAdDidClose:(BURewardedVideoAd *)rewardedVideoAd {
    [UIApplication.sharedApplication setStatusBarHidden:NO];
    [_unionAdChannel invokeMethod:@"closed" arguments:nil result:nil];
    BUD_Log(@"%s",__func__);
}

- (void)rewardedVideoAdDidClick:(BURewardedVideoAd *)rewardedVideoAd {
    BUD_Log(@"%s",__func__);
}

- (void)rewardedVideoAdDidPlayFinish:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    [_unionAdChannel invokeMethod:@"playComplete" arguments:nil result:nil];
    BUD_Log(@"%s",__func__);
}

- (void)rewardedVideoAdServerRewardDidFail:(BURewardedVideoAd *)rewardedVideoAd error:(nonnull NSError *)error {
    BUD_Log(@"%s error = %@",__func__,error);
}

- (void)rewardedVideoAdDidClickSkip:(BURewardedVideoAd *)rewardedVideoAd{
    [_unionAdChannel invokeMethod:@"skip" arguments:nil result:nil];
    BUD_Log(@"%s",__func__);
}

- (void)rewardedVideoAdServerRewardDidSucceed:(BURewardedVideoAd *)rewardedVideoAd verify:(BOOL)verify{
    [_unionAdChannel invokeMethod:@"rewarded" arguments:nil result:nil];
    BUD_Log(@"%s",__func__);
    BUD_Log(@"%@",[NSString stringWithFormat:@"verify:%@ rewardName:%@ rewardMount:%ld",verify?@"true":@"false",rewardedVideoAd.rewardedVideoModel.rewardName,(long)rewardedVideoAd.rewardedVideoModel.rewardAmount]);
}
- (void)rewardedVideoAdCallback:(BURewardedVideoAd *)rewardedVideoAd withType:(BURewardedVideoAdType)rewardedVideoAdType{
    BUD_Log(@"%s",__func__);
}

@end
