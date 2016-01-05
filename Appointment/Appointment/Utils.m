//
//  Utils.m
//  Appointment
//
//  Created by Pellet Mo on 15/12/22.
//  Copyright © 2015年 mopellet. All rights reserved.
//

#import "Utils.h"

@implementation Utils
@synthesize userDefaults;
+ (id)instance
{
    static Utils *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

/**
 * 加入用户
 */
-(BOOL)insertAccount:(NSDictionary *)dictionary
{
   NSArray *array =  [userDefaults objectForKey:@"account"];
    if (array) {
        for (NSDictionary *dict in array) {
            if ([[dict objectForKey:@"email"] isEqualToString:[dictionary objectForKey:@"email"]]) {
                return NO;
            }
        }
    }
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:array];
    [tempArray addObject:dictionary];
    [userDefaults setObject:tempArray forKey:@"account"];
    [userDefaults synchronize];
    return YES;
}


@end
