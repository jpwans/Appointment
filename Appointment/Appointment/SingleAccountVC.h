//
//  SingleAccountVC.h
//  Appointment
//
//  Created by Pellet Mo on 15/12/23.
//  Copyright © 2015年 mopellet. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SingleAccountVC : UIViewController

//账号字典信息
@property(nonatomic,strong)NSDictionary * dictionary;

- (IBAction)closeAction:(UIBarButtonItem *)sender;


@end
