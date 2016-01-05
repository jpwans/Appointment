//
//  NetworkHelper.m
//  Appointment
//
//  Created by Pellet Mo on 15/12/22.
//  Copyright © 2015年 mopellet. All rights reserved.
//

#import "NetworkHelper.h"


@implementation NetworkHelper

@synthesize manager;
@synthesize operationArray;
@synthesize accountArray;

+ (NetworkHelper *)instance
{
    static NetworkHelper *instance = nil;
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
        manager = [AFHTTPRequestOperationManager manager];
        UIWebView* web = [UIWebView new];
        NSString* safari_agent = [web stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        [manager.requestSerializer setValue:safari_agent forHTTPHeaderField:@"User-Agent"];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}

/**
 *  单任务
 */
-(void)singleTaskWith:(NSDictionary *)userDict ticketParameter:(NSDictionary *)ticketParameter CompletionHandler:(void (^)(id responseObject))block {
    
    //     __weak typeof(self) weakSelf = self;
    [self loginWith:userDict CompletionHandler:^(id responseObject, NSError *error) {
        if (!error) {
            NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"login:%@",string);
            if (string.length) {
                [self taskWith:ticketParameter CompletionHandler:^(id responseObject, NSError *error) {
                    //                    NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                    //                    NSLog(@"预约:%@",string);
                    if (block) {
                        block(responseObject);
                    }
                }];
                
                
            }
        }
    }];
}

/**
 *  抢预约
 */
-(void)taskWith:(NSDictionary *)parameters CompletionHandler:(void (^)(id responseObject, NSError *error))block
{
    [manager POST:URL_TicketTask parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) {
            block(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
    
}



/**
 *  多任务
 */
-(void)multitasking{
    
    //1.先从NSUserDefaults取出账号列表
    accountArray  = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    if (!accountArray.count) {
        [MBProgressHUD showError:@"请先添加账号!"];
        return;
    }
    //2.实例化NSOperationQueue 数组
    operationArray =[[NSMutableArray alloc] init];
      
    //3.循环添加
    for (int i = 0; i<accountArray.count; i++) {
        
        //4.创建request 并设置请求类型 每个操作对象一个 request 不能共享
        NSURL * url =[NSURL URLWithString:URL_Login];
        NSMutableURLRequest * request=[NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        
        //5.1从账号列表里面取出账号设置请求体
        NSDictionary *account = [accountArray objectAtIndex:i];
        NSMutableData * postBody  = [NSMutableData data];
        
        NSString *bodyString =[NSString stringWithFormat:@"email=%@&password=%@",[account objectForKey:@"email"],[account objectForKey:@"password"]];
        
        [postBody appendData:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request setHTTPBody:postBody];
        
        //5.2.将请求对象封装成请求操作对象
        AFHTTPRequestOperation * operation=[[AFHTTPRequestOperation alloc]initWithRequest:request];
        [operationArray addObject:operation];
    }
    [MBProgressHUD showMessage:@"执行任务中..."];
    [self executeAllTasks];
    
}


/**
 * operationArray 序数
 */
static int i = 0;

/**
 *  操作成功的个数
 */
static int n = 0;

/**
 *  批量执行任务
 */
-(void)executeAllTasks{
    /**
     *  执行完成跳出
     */
    if (i>=operationArray.count) {
        i=0;
        [MBProgressHUD hideHUD];
        int count  = (int)operationArray.count - n;
        [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"执行完成,成功%d个,失败%d个！,另可通过单个账号进行预约",n,count] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"关闭", nil] show];
        /**
         *  刷新列表状态
         */
        [[NSNotificationCenter defaultCenter] postNotificationName:Noti_ReloadTable object:nil];
        return ;
    }
    AFHTTPRequestOperation *operation = [operationArray objectAtIndex:i];
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc]init];
    [operationQueue setMaxConcurrentOperationCount:1];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"第%d个登陆",i);
        //NSLog(@"request  %@",[self stringWithData:responseObject]);
        NSString * JSESSIONID = [self getJSESSIONID];
        NSLog(@"JSESSIONID:%@",JSESSIONID);
        if (JSESSIONID.length) {
            NSDictionary *parameter = [[NSUserDefaults standardUserDefaults] objectForKey:@"parameter"];
            self.ticketParameter  = [[NSMutableDictionary alloc] initWithDictionary:parameter];
            [self.ticketParameter removeObjectForKey:SecondCountKey];
            [self taskWith:self.ticketParameter CompletionHandler:^(id responseObject, NSError *error) {
                NSLog(@"第%d个账号的第1次预约",i);
                [self callbackOperation:responseObject :error :1];
                /**
                 * 第二次的票
                 */
                NSDictionary *parameter = [[NSUserDefaults standardUserDefaults] objectForKey:@"parameter"];
                self.ticketParameter  = [[NSMutableDictionary alloc] initWithDictionary:parameter];
                [self.ticketParameter setObject:[self.ticketParameter objectForKey:SecondCountKey] forKey:PersonCount];
                [self.ticketParameter removeObjectForKey:SecondCountKey];
                
                [self taskWith:self.ticketParameter CompletionHandler:^(id responseObject, NSError *error) {
                    NSLog(@"第%d个账号的第2次预约",i);
                    [self callbackOperation:responseObject :error :2];
                    //删除Cookies换账号预约
                    [self deleteCookies];
                    i ++;
                    [self executeAllTasks];
                }];
                
            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        i++;
        NSLog(@"登陆error:%@",error);
        [self executeAllTasks];
    }];
    [operationQueue addOperation:operation];
}

/**
 * 处理回调
 */
-(void)callbackOperation:(id)responseObject :(NSError *)error :(int)count {
    if (!error) {
        NSString *string = [self stringWithData:responseObject];
        NSString *success = @"成功提示";
        //在string这个字符串中搜索success，判断有没有
        if ([string rangeOfString:success].location != NSNotFound) {
            n++;
            NSLog(@"预约成功!");
            //预约成功之后 count+1
            // 判断有没有存储此账号的次数 key 为email和明天的日期。
            NSString *tomorrowDay = [NSDate GetTomorrowDay];
            NSDictionary *accountDcitionary = [accountArray objectAtIndex:i];
            
            NSMutableDictionary * tempDic =
            [[NSMutableDictionary alloc] initWithDictionary:accountDcitionary];
            if (count==1) {
                //第一次预约
                [tempDic setValue:@"1" forKey:@"first"];
            }
            else if(count ==2)
            {
                //第二次预约
                [tempDic setValue:@"1" forKey:@"second"];
            }
            
            accountArray[i]= tempDic ;
            
            NSString *key = [NSString stringWithFormat:@"%@_%@",[accountDcitionary objectForKey:@"email"],tomorrowDay];
            int  count = [[[[NSUserDefaults standardUserDefaults] objectForKey:key] copy] intValue];
            count = count +1;
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",count] forKey:key];
            BOOL b = [[NSUserDefaults standardUserDefaults] synchronize];
            
            if (b) {
                NSLog(@"当天预约个数加1");
            }
            
        }
        else{
            NSLog(@"第%d个账号的第%d次预约失败!",i,count);
        }
    }
    else
    {
        NSLog(@"第%d个账号的第%d次预约error:%@!",i,count,error);
    }
}

/**
 * 用户登陆
 */
-(void)loginWith:(NSDictionary *)parameters CompletionHandler:(void (^)(id responseObject, NSError *error))block
{
    [manager POST:URL_Login parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (block) {
            block(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
}

/**
 * 取消预约
 */
-(void)cancelTicket:(NSDictionary *)dictionary{
    //1、先登陆
    //2、再查看预约
    //3、取消预约
    
    [self loginWith:dictionary CompletionHandler:^(id responseObject, NSError *error) {
        if (!error) {
            [self viewCancelWith:nil CompletionHandler:^(id responseObject, NSError *error) {
                if (!error) {
                    
                    //处理解析XML拿到 id
                    
                    NSDictionary *dictionary = @{@"id":@"字"};
                    [self cancelWith:dictionary CompletionHandler:^(id responseObject, NSError *error) {
                        if (!error) {
                            
                            /**
                             *   字符串 ·@"取消成功"
                             */
                            
                        }
                        else{
                            
                        }
                    }];
                    
                }
                else{
                    
                }
            }];
        }
        else{
            
        }
        
    }];
    
}

/**
 * 取消预约
 */
-(void)cancelWith:(NSDictionary *)parameters CompletionHandler:(void (^)(id responseObject, NSError *error))block
{
    [manager GET:URL_Cancel parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (block) {
            block(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
}

/**
 * 查看预约
 */
-(void)viewCancelWith:(NSDictionary *)parameters CompletionHandler:(void (^)(id responseObject, NSError *error))block
{
    [manager GET:URL_viewTicket parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (block) {
            block(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
}






/**
 * 获取cookies的JSESSIONID
 */
-(NSString *)getJSESSIONID{
    //NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:URL_Login]];
    for (NSHTTPCookie *cookie in cookies) {
        // NSLog(@"cookie:%@", cookie);
        if ([cookie.name isEqualToString:@"JSESSIONID"]) {
            //NSLog(@"JSESSIONID:%@",cookie.value);
            return cookie.value;
        }
        return nil;
    }
    return nil;
}

/**
 *  清除cookies
 */
-(void)deleteCookies{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *_tmpArray = [NSArray arrayWithArray:[cookieJar cookies]];
    for (id obj in _tmpArray) {
        [cookieJar deleteCookie:obj];
    }
}
/**
 *NSData 转 NSString
 */
-(NSString *)stringWithData:(id)data{
    if (data) {
        NSString *   string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return string;
    }
    return nil;
}





@end



