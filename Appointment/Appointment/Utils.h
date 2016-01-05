//
//  Utils.h
//  Appointment
//
//  Created by Pellet Mo on 15/12/22.
//  Copyright © 2015年 mopellet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject
@property(nonatomic,strong)NSUserDefaults *userDefaults;
+(id)instance;

/**
 * 加入用户
 */
-(BOOL)insertAccount:(NSDictionary *)dictionary;
@end
