//
//  NetworkHelper.h
//  Appointment
//
//  Created by Pellet Mo on 15/12/22.
//  Copyright © 2015年 mopellet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkHelper : NSObject
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
/**
 *  操作序列
 */
@property(nonatomic,strong) NSMutableArray *operationArray;
/**
 *  预约参数字典
 */
@property(nonatomic,strong) NSMutableDictionary * ticketParameter;

/**
 *  账号列表
 */
@property(nonatomic,strong) NSMutableArray * accountArray;
+(NetworkHelper *)instance;

/**
 *  单任务
 */
-(void)singleTaskWith:(NSDictionary *)userDict ticketParameter:(NSDictionary *)ticketParameter CompletionHandler:(void (^)(id responseObject))block;
/**
 *用户登陆
 */
-(void)loginWith:(NSDictionary *)parameters CompletionHandler:(void (^)(id responseObject, NSError *error))block;

/**
 * 取消预约
 */
-(void)cancelWith:(NSDictionary *)parameters CompletionHandler:(void (^)(id responseObject, NSError *error))block;

/**
 *  多任务
 */
-(void)multitasking;

/**
 *  清除cookies
 */
-(void)deleteCookies;

@end
