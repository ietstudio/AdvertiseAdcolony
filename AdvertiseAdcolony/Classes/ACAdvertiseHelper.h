//
//  ACAdvertiseHelper.h
//  Pods
//
//  Created by geekgy on 16/6/11.
//
//

#import <Foundation/Foundation.h>
#import "AdvertiseDelegate.h"
#import "Macros.h"

#define Adcolony_Name               @"Adcolony"
#define Adcolony_AppId              @"Adcolony_AppId"
#define Adcolony_ZoneId             @"Adcolony_ZoneId"

@interface ACAdvertiseHelper : NSObject <AdvertiseDelegate>

SINGLETON_DECLARE(ACAdvertiseHelper)

@end
