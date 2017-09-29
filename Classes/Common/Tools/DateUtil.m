//
//  DateUtil.m
//  POS2iPhone
//
//  Created by  STH on 11/28/12.
//  Copyright (c) 2012 RYX. All rights reserved.
//

#import "DateUtil.h"
#import "RegexKitLite.h"

@implementation DateUtil

+ (int) dayIntervalSinceDate:(NSDate *) startDate endDate:(NSDate *) endDate
{
    return [endDate timeIntervalSinceDate:startDate]/(3600*24);
}

+ (double) currentTimeMillis
{
    // [[NSDate date] timeIntervalSince1970] 返回的数值是以 “秒” 为单位的
    return [[NSDate date] timeIntervalSince1970];
}

@end
