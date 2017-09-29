//
//  DateUtil.h
//  POS2iPhone
//
//  Created by  STH on 11/28/12.
//  Copyright (c) 2012 RYX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject

// 计算两个日期之间相差的天数
+ (int) dayIntervalSinceDate:(NSDate *) startDate endDate:(NSDate *) endDate;
// 获取自1970年以来的秒数
+ (double) currentTimeMillis;

@end