//
//  AccountTableView.m
//  Appointment
//
//  Created by Pellet Mo on 15/12/22.
//  Copyright © 2015年 mopellet. All rights reserved.
//

#import "AccountTableView.h"

@implementation AccountTableView
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.dataSource =self;
        self.delegate=self;
        self.arrays = [[[NSUserDefaults standardUserDefaults] objectForKey:@"account"] mutableCopy];
        
    }
    return self;
}




#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrays.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"Cell";
    UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    NSDictionary *dictionary = self.arrays[indexPath.row];
    if (dictionary) {
        cell.textLabel.text = [dictionary objectForKey:@"email"];
        NSString * first = [dictionary objectForKey:@"first"];
        NSString * second = [dictionary objectForKey:@"second"];
        NSString * showText = @"";
        if ([first isEqualToString:@"1"]) {
            //  第一张票预约成功
            showText = @"票1已预约";
        }
        else{
            //  第一张票预约失败
            showText = @"票1未预约";
        }
        
        if ([second isEqualToString:@"1"]) {
            // 第二张票预约成功
           showText= [NSString stringWithFormat:@"%@,票2已预约",showText];
        }
        else{
            // 第二张票预约失败
            showText= [NSString stringWithFormat:@"%@,票2未预约",showText];
        }
        cell.detailTextLabel.text = showText;
    }
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, self.frame.size.width, 24.0)];
    customView.backgroundColor = [UIColor whiteColor];
    UILabel * leftLabel = [[UILabel alloc] initWithFrame:CGRectZero];

    leftLabel.textColor = [UIColor lightGrayColor];
    leftLabel.highlightedTextColor = [UIColor whiteColor];
    leftLabel.font = [UIFont boldSystemFontOfSize:14];
    leftLabel.frame = CGRectMake(20.0, 0.0, self.frame.size.width/2-20, 24.0);
    [leftLabel setText:@"账号"];
    
    UILabel * rightLabel = [[UILabel alloc] initWithFrame:CGRectZero];

    rightLabel.textColor = [UIColor lightGrayColor];
    rightLabel.highlightedTextColor = [UIColor whiteColor];
    rightLabel.font = [UIFont boldSystemFontOfSize:14];
    rightLabel.frame = CGRectMake(leftLabel.frame.origin.x+leftLabel.frame.size.width, 0.0, self.frame.size.width/2-20, 24.0);
    [rightLabel setText:@"预约状态"];
    [rightLabel setTextAlignment:NSTextAlignmentRight];
    [customView addSubview:leftLabel];
    [customView addSubview:rightLabel];
    return customView;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.arrays removeObjectAtIndex:indexPath.row];
        [self deleteForUserDefault:indexPath.row];
        
        [self deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
/**
 * 删除
 */
-(void)deleteForUserDefault:(NSInteger )index{
    NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    NSMutableArray *tempArray = [[[NSMutableArray alloc] initWithArray:array] mutableCopy];
    [tempArray removeObjectAtIndex:index];
    [[NSUserDefaults standardUserDefaults] setObject:tempArray forKey:@"account"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/**
 * 点击
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
//    [[NSNotificationCenter defaultCenter] postNotificationName:Noti_SendValue object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:Noti_SendValue object:self userInfo:self.arrays[indexPath.row]];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [tableView deselectRowAtIndexPath:indexPath animated:NO];
    });
}

@end
