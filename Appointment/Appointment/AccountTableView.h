//
//  AccountTableView.h
//  Appointment
//
//  Created by Pellet Mo on 15/12/22.
//  Copyright © 2015年 mopellet. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AccountTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *arrays;

@end
