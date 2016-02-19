//
//  SingleAccountVC.m
//  Appointment
//
//  Created by Pellet Mo on 15/12/23.
//  Copyright © 2015年 mopellet. All rights reserved.
//

#import "SingleAccountVC.h"
@interface SingleAccountVC()
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UITextField *visitDateField;
@property (weak, nonatomic) IBOutlet UITextField *visitTimeStart;
@property (weak, nonatomic) IBOutlet UITextField *visitTimeEnd;
@property (weak, nonatomic) IBOutlet UITextField *personCount;
@property (weak, nonatomic) IBOutlet UILabel *operationCount;
@property (weak, nonatomic) IBOutlet UIButton *ticketButton;


@end

@implementation SingleAccountVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title                   = @"账号信息";
    NSLog(@"%@",self.dictionary);
    self.emailField.text         = [self.dictionary objectForKey:@"email"];
    self.password.text           = [self.dictionary objectForKey:@"password"];
    NSDictionary * parameter     = [[NSUserDefaults standardUserDefaults] objectForKey:@"parameter"];
    NSLog(@"%@",parameter);
    if (parameter) {
        self.visitDateField.text     = [parameter objectForKey:VisitDate];
        self.visitTimeStart.text     = [parameter objectForKey:VisitTimeStart];
        self.visitTimeEnd.text       = [parameter objectForKey:VisitTimeEnd];
        self.personCount.text        = [parameter objectForKey:PersonCount];
    }
    else{
        NSString * visitDate         = [NSDate GetTomorrowDay];
        NSString * visitTimeStart    = @"07:00";
        NSString * visitTimeEnd      = @"08:00";
        NSString * expectPersonCount = @"10";
        NSDictionary * dictionary    = @{
                                         VisitDate:visitDate,
                                         VisitTimeStart:visitTimeStart,
                                         VisitTimeEnd:visitTimeEnd,
                                         PersonCount:expectPersonCount
                                         };
        [[NSUserDefaults standardUserDefaults] setObject:dictionary forKey:@"parameter"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.visitDateField.text     = visitDate;
        self.visitTimeStart.text     = visitTimeStart;
        self.visitTimeEnd.text       = visitTimeEnd;
        self.personCount.text        = expectPersonCount;
    }
    
    
    [self reloadUI];
}


/**
 *  刷新UI
 */
- (void)reloadUI{
    int  count = [self getTicketCount];
    NSString * operationString = [NSString stringWithFormat:@"您已经成功预约了%d次！",count];
    [self.operationCount setText:operationString];
    if (count>=2) {//每天只能预约两次票 当大于2次的时候就不能用了
        self.ticketButton.enabled = NO;
    }
}

/**
 * 获取已经预约次数
 */
- (int)getTicketCount{
    // 判断有没有存储此账号的次数 key 为email和明天的日期。
    NSString *tomorrowDay = [NSDate GetTomorrowDay];
    NSString *key = [NSString stringWithFormat:@"%@_%@",[self.dictionary objectForKey:@"email"],tomorrowDay];
    int  count = [[[[NSUserDefaults standardUserDefaults] objectForKey:key] copy] intValue];
    return count;
}

/**
 * 设置预约次数
 */
- (BOOL)setTicketCount:(int)count{
    NSString *tomorrowDay = [NSDate GetTomorrowDay];
    NSString *key = [NSString stringWithFormat:@"%@_%@",[self.dictionary objectForKey:@"email"],tomorrowDay];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",count] forKey:key];
    BOOL b = [[NSUserDefaults standardUserDefaults] synchronize];
    return b;
}

- (IBAction)closeAction:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * 开始预约
 */
- (IBAction)ticketStart:(id)sender {
    
    NSString * visitDate          = self.visitDateField.text;
    NSString * visitTimeStart     = self.visitTimeStart.text;
    NSString * visitTimeEnd       = self.visitTimeEnd.text;
    NSString * expectPersonCount  = self.personCount.text;
    NSDictionary * dictionary     = @{
                                      VisitDate:visitDate,
                                      VisitTimeStart:visitTimeStart,
                                      VisitTimeEnd:visitTimeEnd,
                                      PersonCount:expectPersonCount
                                      };
    [MBProgressHUD showMessage:@"开始预约..."];
    [[NetworkHelper instance] singleTaskWith:self.dictionary ticketParameter:dictionary CompletionHandler:^(id responseObject) {
        [MBProgressHUD hideHUD];
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"预约:%@",string);
        NSString *success = @"成功提示";
        //在string这个字符串中搜索success，判断有没有
        if ([string rangeOfString:success].location != NSNotFound) {
            NSLog(@"预约成功!");
            [MBProgressHUD showSuccess:@"预约成功!"];
            /**
             *  预约成功数字加 1
             */
            int count = [self getTicketCount];
            count = count +1;
            if ([self setTicketCount:count]) {
                [self reloadUI];
            }
        }
        else{
            
            [MBProgressHUD showError:@"预约失败!"];
        }
        [[NetworkHelper instance] deleteCookies];
    }];
}

/**
 * 取消预约
 */
- (IBAction)cancelAction:(id)sender {
    [[NetworkHelper instance] cancelWith:nil CompletionHandler:^(id responseObject, NSError *error) {
        if (!error) {
            
            
            // 预约次数减1
            int count = [self getTicketCount];
            if (count) {
                count = count -1;
                if ([self setTicketCount:count]) {
                    [self reloadUI];
                }
            }
            else{
                [MBProgressHUD showError:@"您当前没有预约！"];
            }
            
        }
        else{
            [MBProgressHUD showError:@"网络错误"];
        }
    }];
}


@end
