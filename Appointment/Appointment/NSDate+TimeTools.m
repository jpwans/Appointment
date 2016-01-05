//
//  NSDate+TimeTools.m
//  Appointment
//
//  Created by Pellet Mo on 15/12/23.
//  Copyright © 2015年 mopellet. All rights reserved.
//

#import "NSDate+TimeTools.h"

@implementation NSDate (TimeTools)
/**
 * 获取明天日期
 */
+(NSString *)GetTomorrowDay
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    [components setDay:([components day]+1)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"yyyy-MM-dd"];
    return [dateday stringFromDate:beginningOfWeek];
}


/**
 * 获取当前时间
 */
+(NSString *)getCurrentTime{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *dataTime = [formatter stringFromDate:[NSDate date]];
    return dataTime;
}

/**
 * 将时间字符串转为时间
 */
+(NSDate *)dateWithString:(NSString *)string{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate *date = [[NSDate alloc] init];
    date = [formatter dateFromString:string];
    return date;
}
@end
