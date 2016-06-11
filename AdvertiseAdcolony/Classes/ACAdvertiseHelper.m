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

@interface ACAdvertiseHelper() <AdColonyDelegate, AdColonyAdDelegate>

@end

@implementation ACAdvertiseHelper
{
    NSString* _appId;
    NSString* _zoneId;
    void(^_viewFunc)(BOOL);
    void(^_clickFunc)(BOOL);
}

SINGLETON_DEFINITION(ACAdvertiseHelper)

#pragma mark - AdvertiseDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%@ : %@", Adcolony_Name, nil);
    _appId = [[IOSSystemUtil getInstance] getConfigValueWithKey:Adcolony_AppId];
    _zoneId = [[IOSSystemUtil getInstance] getConfigValueWithKey:Adcolony_ZoneId];
    [AdColony configureWithAppID:_appId
                         zoneIDs:@[_zoneId]
                        delegate:self
                         logging:NO];
    return YES;
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
    return [AdColony zoneStatusForZone:_zoneId] == ADCOLONY_ZONE_STATUS_ACTIVE;
}

- (BOOL)showVedioAd:(void (^)(BOOL))viewFunc :(void (^)(BOOL))clickFunc {
    if ([self isVedioAdReady]) {
        _viewFunc = viewFunc;
        _clickFunc = clickFunc;
        [AdColony playVideoAdForZone:_zoneId withDelegate:self withV4VCPrePopup:NO andV4VCPostPopup:NO];
        return YES;
    }
    return NO;
}

- (NSString *)getName {
    return Adcolony_Name;
}

#pragma mark - AdColonyDelegate

- (void)onAdColonyV4VCReward:(BOOL)success currencyName:(NSString *)currencyName currencyAmount:(int)amount inZone:(NSString *)zoneID {
//    NSLog(@"AdColony zone %@ reward %i %i %@", zoneID, success, amount, currencyName);
    _viewFunc(YES);
}

@end
