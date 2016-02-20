//
//  ViewController.m
//  Appointment
//
//  Created by Pellet Mo on 15/12/22.
//  Copyright (c) 2015年 mopellet. All rights reserved.
//

#import "ViewController.h"
#import "AccountTableView.h"
#import "SingleAccountVC.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet AccountTableView *accountTableView;
@property (weak, nonatomic) IBOutlet UITextField *visitDateField;
@property (weak, nonatomic) IBOutlet UITextField *visitTimeStartField;
@property (weak, nonatomic) IBOutlet UITextField *visitTimeEndField;
@property (weak, nonatomic) IBOutlet UITextField *personCountField;
//@property (weak, nonatomic) IBOutlet UITextField *secondCountField;
@property (weak, nonatomic) IBOutlet UITextField *timeOpenField;
@property (weak, nonatomic) IBOutlet UIButton *timeOpenButton;
- (IBAction)timeOpenAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *countDownLable;

@property(nonatomic,strong) NSDate * timeDate;
@property(nonatomic,assign,getter=isOpen) BOOL  open;

@property(nonatomic,assign)BOOL timeOver;
@end


//NSDictionary * dictionary = @{@"groupTicket.visitDate":@"2015-12-23"
//                              ,@"groupTicket.visitTimeStart":@"07:30",
//                              @"groupTicket.visitTimeEnd":@"08:00",
//                              @"groupTicket.expectPersonCount":@"10"};
//461343032@qq.com密码19820823   OK
//825465943@qq.com 密码123456789 OK
//113547804@qq.com，密码033446  OK
//sfj@163.com 密码123456   ok
//1343488546qq@.com。密码999999999  xxxx
//435033209qq@.com。密码11196137 xxxx
//619469710@qq.com密码liuyong ok  被加黑了
//yanli@lijinglong.com密码198316  ok
//9323070582@qq.com密码19820320 ok
//1055266181@qq.com密码zmy1307051976 ok
//  NSDictionary * dictionary11   = @{@"email":@"xiaohai77525@vip.qq.com",@"password":@"090226"};




@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
    

}

/**
 *  初始化方法
 */
-(void)viewInit{
    (void)[[NSString alloc] init];
    
    //    NSArray* account              = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    //
    //    if (!account.count) {
    //        NSMutableArray* accountArray  = [[NSMutableArray alloc] init];
    //        NSDictionary * dictionary1    = @{@"email":@"461343032@qq.com",@"password":@"19820823"};
    //        NSDictionary * dictionary2    = @{@"email":@"825465943@qq.com",@"password":@"123456789"};
    //        NSDictionary * dictionary3    = @{@"email":@"113547804@qq.com",@"password":@"033446"};
    //        NSDictionary * dictionary4    = @{@"email":@"sfj@163.com",@"password":@"123456"};
    //        NSDictionary * dictionary5    = @{@"email":@"yanli@lijinglong.com",@"password":@"198316"};
    //        NSDictionary * dictionary6    = @{@"email":@"9323070582@qq.com",@"password":@"19820320"};
    //        NSDictionary * dictionary7   = @{@"email":@"1055266181@qq.com",@"password":@"zmy1307051976"};
    //        NSDictionary * dictionary8   = @{@"email":@"xiaohai77525@vip.qq.com",@"password":@"090226"};
    //
    //        [accountArray addObject:dictionary1];
    //        [accountArray addObject:dictionary2];
    //        [accountArray addObject:dictionary3];
    //        [accountArray addObject:dictionary4];
    //        [accountArray addObject:dictionary5];
    //        [accountArray addObject:dictionary6];
    //        [accountArray addObject:dictionary7];
    //        [accountArray addObject:dictionary8];
    //        [[NSUserDefaults standardUserDefaults] setObject:accountArray forKey:@"account"];
    //        [[NSUserDefaults standardUserDefaults] synchronize];
    //        [self tableReload];
    //    }
    
    
    // 获取预约参数
    NSDictionary * parameter = [[NSUserDefaults standardUserDefaults] objectForKey:@"parameter"];
    NSLog(@"%@",parameter);
    if (parameter) {
        if ([[parameter objectForKey:VisitDate] isEqualToString:[NSDate GetTomorrowDay]]) {
            self.visitDateField.text      = [parameter objectForKey:VisitDate];
        }
        else{
            self.visitDateField.text      = [NSDate GetTomorrowDay];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:parameter];
            [dic setObject:[NSDate GetTomorrowDay] forKey:VisitDate];
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"parameter"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        self.visitTimeStartField.text = [parameter objectForKey:VisitTimeStart];
        self.visitTimeEndField.text   = [parameter objectForKey:VisitTimeEnd];
        self.personCountField.text    = [parameter objectForKey:PersonCount];
//        self.secondCountField.text = [parameter objectForKey:SecondCountKey];
    }
    else{
        NSString * visitDate          = [NSDate GetTomorrowDay];
        NSString * visitTimeStart     = @"07:30";
        NSString * visitTimeEnd       = @"08:00";
//        NSString * expectPersonCount  = @"10";
        NSString * secondCount = @"10";
       NSString * count =  [[NSUserDefaults standardUserDefaults] objectForKey:DefaultKey];
        NSString * expectPersonCount  = count.length?count:@"10";
        NSDictionary * dictionary     = @{
                                          VisitDate:visitDate,
                                          VisitTimeStart:visitTimeStart,
                                          VisitTimeEnd:visitTimeEnd,
                                          PersonCount:expectPersonCount
//                                          SecondCountKey : secondCount
                                          };
        [[NSUserDefaults standardUserDefaults] setObject:dictionary forKey:@"parameter"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.visitDateField.text      = visitDate;
        self.visitTimeStartField.text = visitTimeStart;
        self.visitTimeEndField.text   = visitTimeEnd;
        self.personCountField.text    = expectPersonCount;
//        self.secondCountField.text = secondCount;
    }
    

 
    // 注册相关通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendValue:) name:Noti_SendValue object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable:) name:Noti_ReloadTable object:nil];
    
    //定时器
    UIDatePicker * startPicker = [[UIDatePicker alloc] init];
    startPicker.datePickerMode = UIDatePickerModeTime;
    //    startPicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [startPicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    self.timeOpenField.inputView  = startPicker;
    [startPicker addTarget:self action:@selector(startPickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    //触摸收键盘
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchDownToKeyboard:)];
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
}

/**
 * 触摸收键盘
 */
- (void)touchDownToKeyboard:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

/**
 * 改变timeOpenField的值
 */
-(void)startPickerValueChanged:(UIDatePicker *)picker{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init] ;
    [dateformatter setDateFormat:@"HH:mm"];
    self.timeOpenField.text =  [dateformatter stringFromDate:picker.date];
    NSLog(@"%@",picker.date);
    self.timeDate = picker.date;
}

#pragma mark 通知相关

-(void)sendValue:(NSNotification *)notification{
    SingleAccountVC * singleAccountVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"SingleAccountVC"];
    singleAccountVC.dictionary = [notification userInfo];
    [self presentViewController:singleAccountVC animated:YES completion:nil];
}

-(void)reloadTable:(NSNotification *)notification{
    [self tableReload];
    
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Noti_SendValue object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Noti_ReloadTable object:nil];
}

/**
 * 保存参数
 */
- (IBAction)saveAction:(id)sender {
    NSString * visitDate          = self.visitDateField.text;
    NSString * visitTimeStart     = self.visitTimeStartField.text;
    NSString * visitTimeEnd       = self.visitTimeEndField.text;
    NSString * expectPersonCount  = self.personCountField.text;
//    NSString * secondCount = self.secondCountField.text;
    NSDictionary * dictionary     = @{
                                      VisitDate:visitDate,
                                      VisitTimeStart:visitTimeStart,
                                      VisitTimeEnd:visitTimeEnd,
                                      PersonCount:expectPersonCount
//                                      SecondCountKey:secondCount
                                      };
    
    [[NSUserDefaults standardUserDefaults] setObject:self.personCountField.text forKey:DefaultKey];
    
    [[NSUserDefaults standardUserDefaults] setObject:dictionary forKey:@"parameter"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}



/**
 * 添加新用户
 */
- (IBAction)joinAction:(id)sender {
    if (self.accountField.text.length && self.passwordField.text.length) {
        NSDictionary * dictionary     = @{@"email":self.accountField.text,@"password":self.passwordField.text};
        
        //验证登陆  账号密码的正确错误
        [[NetworkHelper instance] loginWith:dictionary CompletionHandler:^(id responseObject, NSError *error) {
            if (!error) {
                NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSString *success = @"进入预约系统";
                //在string这个字符串中搜索success，判断有没有
                if ([string rangeOfString:success].location != NSNotFound) {
                    NSLog(@"登陆成功!");
                    BOOL b                        = [[Utils instance] insertAccount:dictionary];
                    if (b) {
                        NSLog(@"添加成功！");
                        [MBProgressHUD showSuccess:@"添加成功"];
                        [self tableReload];
                    }
                    else{
                        [MBProgressHUD showError:@"您已添加该账号"];
                    }
                    
                }
                else{
                    [MBProgressHUD showError:@"您的账号或密码输入错误"];
                }
                
            }
            else{
                [MBProgressHUD showError:@"网络请求发生错误"];
            }
            
        }];
    }
}

/**
 *  刷新表格
 */
-(void)tableReload{
    self.accountTableView.arrays  = [[[NSUserDefaults standardUserDefaults] objectForKey:@"account"] mutableCopy];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.accountTableView reloadData];
    });
    
}


- (IBAction)multiAction:(id)sender {
    /**
     *  执行多任务
     */
    [[NetworkHelper instance] multitasking];
    
}

- (IBAction)openUrl:(id)sender {
    NSString *urlText = [ NSString stringWithFormat:URL_Main];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
}

/**
 * 清空列表
 */
- (IBAction)emptySource:(id)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"account"];
    [self tableReload];
    
}

/**
 *  定时开始
 */
- (IBAction)timeOpenAction:(UIButton *)sender {
    //判断账号列表
    NSMutableArray *  accountArray  = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    if (!accountArray.count) {
        [MBProgressHUD showError:@"请先添加账号!"];
        return;
    }
    
    NSLog(@"%d",self.isOpen);
    if (!self.isOpen) {
        if ([self setTimeout]) {
            
            [self setActivity];
        }
        else {
            [self checkOpen];
            [MBProgressHUD showError:@"开始时间不得小于当前时间"];
        }
    }
    [self checkOpen];
}

-(BOOL)setTimeout{
    NSString * nowTime = [NSDate getCurrentTime];
    NSString * openTime = self.timeOpenField.text;
    NSArray *nowTimeArray = [nowTime componentsSeparatedByString:@":"];
    NSArray *openTimeArray = [openTime componentsSeparatedByString:@":"];
    int tempOpen =  [[openTimeArray firstObject] intValue]*60 + [[openTimeArray lastObject] intValue];
    int tempNow =[[nowTimeArray firstObject] intValue]*60 + [[nowTimeArray lastObject] intValue];
    int poor =tempOpen -tempNow;
    if (poor>=0) {
        timeout = poor*60;
        return YES;
    }
    else{
        return NO;
    }
}

static int timeout = 0;//秒数

-(void)setActivity{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.open) {
            if ([self.timeOpenField.text isEqualToString:[NSDate getCurrentTime]]) {
                //执行方法
                [self timeExecute];
                return ;
            }
        }else{
            return ;
        }
        /**
         *  算出时分秒
         */
        int minutes = timeout / 60;
        int hours = 0;
        NSString *hoursStr = @"00";
        if (minutes>60) {
            hours = minutes/60;
            NSLog(@"hours:%d",hours);
            minutes = minutes - hours*60;
            hoursStr = hours>=10?
            [NSString stringWithFormat:@"%d",hours]:[NSString stringWithFormat:@"0%d",hours];
        }
        NSString *minutesStr = minutes>=10?
        [NSString stringWithFormat:@"%d",minutes]:[NSString stringWithFormat:@"0%d",minutes];
        int seconds = timeout % 60;
        NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
        dispatch_async(dispatch_get_main_queue(), ^{
            /**
             *  更改界面
             */
            [self.countDownLable setText:
             [NSString stringWithFormat:@"%@:%@:%@",hoursStr,minutesStr,strTime]];
        });
        timeout--;
        [self setActivity];
    });
}
/**
 *
 */
-(void)timeExecute{
    NSLog(@"延时执行");
    [[NetworkHelper instance] multitasking];
    [self checkOpen];
}

/**
 *  切换开关
 */
-(void)checkOpen{
    [self.timeOpenButton setTitle:self.open?@"定时开启":@"取消执行" forState:UIControlStateNormal];
    [self.countDownLable setText:self.open?@"00:00:00":self.countDownLable.text];
    self.timeOpenField.enabled  = self.open;
    self.open= !self.isOpen;
}



@end
