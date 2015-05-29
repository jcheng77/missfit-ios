//
//  UmengHelper.h
//  missfit
//
//  Created by Hank Liang on 5/29/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UmengHelper : NSObject
+ (void)initializeUmeng;
+ (void)event:(NSString *)eventId;
+ (void)event:(NSString *)eventId label:(NSString *)label;
@end
