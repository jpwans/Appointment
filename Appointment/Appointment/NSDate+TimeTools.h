//
//  NSDate+TimeTools.h
//  Appointment
//
//  Created by Pellet Mo on 15/12/23.
//  Copyright © 2015年 mopellet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TimeTools)
/**
 * 获取明天日期
 */
+(NSString *)GetTomorrowDay;
/**
 * 获取当前时间
 */
+(NSString *)getCurrentTime;
/**
 * 将时间字符串转为时间
 */
+(NSDate *)dateWithString:(NSString *)string;
@end
