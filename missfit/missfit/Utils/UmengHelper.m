//
//  UmengHelper.m
//  missfit
//
//  Created by Hank Liang on 5/29/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

#import "UmengHelper.h"
#import "MobClick.h"

@implementation UmengHelper
+ (void)initializeUmeng {
    [MobClick startWithAppkey:@"5563581367e58e01e4003e98" reportPolicy:BATCH channelId:nil];
}

+ (void)event:(NSString *)eventId {
    [MobClick event:eventId];
}

+ (void)event:(NSString *)eventId label:(NSString *)label {
    [MobClick event:eventId label:label];
}
@end
