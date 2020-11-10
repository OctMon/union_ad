//
//  RewardedVideoAd.h
//  union_ad
//
//  Created by OctMon on 2020/11/10.
//

#import <Foundation/Foundation.h>
#import <BUAdSDK/BUAdSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface RewardedVideoAd : NSObject

- (instancetype)initWithSlotID:(NSString *)slotID rewardedVideoModel:(BURewardedVideoModel *)model;

- (void)loadAdData;

- (void)showRewardVideo;

@end

NS_ASSUME_NONNULL_END
