//
//  ACAdvertiseHelper.m
//  Pods
//
//  Created by geekgy on 16/6/11.
//
//

#import "ACAdvertiseHelper.h"
#import "IOSSystemUtil.h"
#import <AdColony/AdColony.h>

@interface ACAdvertiseHelper()

@end

@implementation ACAdvertiseHelper
{
    NSString* _appId;
    NSString* _zoneId;
    AdColonyInterstitial* _interstitialAd;
    BOOL _isClicked;
    void(^_viewFunc)(BOOL);
    void(^_clickFunc)(BOOL);
}

SINGLETON_DEFINITION(ACAdvertiseHelper)

// 预加载视频广告
- (void)requestInterstitial {
    [AdColony requestInterstitialInZone:_zoneId
                                options:nil
                                success:^(AdColonyInterstitial* ad) {
                                    _interstitialAd = ad;
                                }
                                failure:^(AdColonyAdRequestError* error) {
                                    NSLog(@"Interstitial request failed with error: %@", [error localizedDescription]);
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                        [self requestInterstitial];
                                    });
                                }
     ];
}

- (int)showBannerAd:(BOOL)portrait :(BOOL)bottom {
    NSLog(@"did not support");
    return 0;
}

- (void)hideBannerAd {
    NSLog(@"did not support");
}

- (BOOL)showSpotAd:(void (^)(BOOL))func {
    NSLog(@"did not support");
    return NO;
}

- (BOOL)isVedioAdReady {
    return _interstitialAd != nil;
}

- (BOOL)showVedioAd:(void (^)(BOOL))viewFunc :(void (^)(BOOL))clickFunc {
    if (![self isVedioAdReady]) {
        return NO;
    }
    _viewFunc = viewFunc;
    _clickFunc = clickFunc;
    _isClicked = NO;
    __weak ACAdvertiseHelper* wself = self;
    _interstitialAd.close = ^{
        [wself requestInterstitial];
    };
    _interstitialAd.click = ^{
        _isClicked = YES;
    };
    [_interstitialAd showWithPresentingViewController:[IOSSystemUtil getInstance].controller];
    _interstitialAd = nil;
    return YES;
}

- (NSString *)getName {
    return Adcolony_Name;
}

#pragma mark - AdvertiseDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%@ : %@", Adcolony_Name, nil);
    _appId = [[IOSSystemUtil getInstance] getConfigValueWithKey:Adcolony_AppId];
    _zoneId = [[IOSSystemUtil getInstance] getConfigValueWithKey:Adcolony_ZoneId];
    [AdColony configureWithAppID:_appId
                         zoneIDs:@[_zoneId]
                         options:nil
                      completion:^(NSArray<AdColonyZone*>* zones) {
                          AdColonyZone* zone = [zones firstObject];
                          /* Set the zone's reward handler block */
                          zone.reward = ^(BOOL success, NSString* name, int amount) {
                              NSLog(@"Reward with success: %@ name: %@ and amount: %d", success ? @"YES" : @"NO", name, amount);
                              _clickFunc(_isClicked);
                              _viewFunc(YES);
                          };
                          [self requestInterstitial];
                      }
     ];
    return YES;
}

@end
