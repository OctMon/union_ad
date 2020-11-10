//
//  RewardedVideoAd.m
//  union_ad
//
//  Created by OctMon on 2020/11/10.
//

#import "RewardedVideoAd.h"
#import <BUAdSDK/BUAdSDK.h>

@interface RewardedVideoAd ()

@property (nonatomic, strong) BURewardedVideoAd *rewardedVideoAd;

@end

@implementation RewardedVideoAd

- (instancetype)initWithSlotID:(NSString *)slotID rewardedVideoModel:(BURewardedVideoModel *)model {
    self.rewardedVideoAd = [[BURewardedVideoAd alloc] initWithSlotID:slotID rewardedVideoModel:model];
    return  self;
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

@end
