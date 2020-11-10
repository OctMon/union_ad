//
//  RewardedVideoAd.h
//  union_ad
//
//  Created by OctMon on 2020/11/10.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <BUAdSDK/BUAdSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface RewardedVideoAd : NSObject

- (instancetype)initWithSlotID:(NSString *)slotID rewardedVideoModel:(BURewardedVideoModel *)model unionAdChannel:(FlutterMethodChannel *)unionAdChannel;

- (void)loadAdData;

- (void)showRewardVideo;

@end

NS_ASSUME_NONNULL_END
