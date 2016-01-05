//
//  PlayMusicHelper.m
//  Appointment
//
//  Created by Pellet Mo on 15/12/29.
//  Copyright © 2015年 mopellet. All rights reserved.
//


#import "PlayMusicHelper.h"

@implementation PlayMusicHelper

+(instancetype)defaultPlayMusicHelpyer
{
    static PlayMusicHelper* instance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance =[[self alloc]init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.player=[[AVPlayer alloc]init];
    }
    return self;
}


//根据mp3连接播放音乐
-(void)playMusicWithUrlString:(NSString*)mp3String
{
    
    //如果正在播放移除上个观察者
    if (self.player.currentItem) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    
    AVPlayerItem*item=[[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:mp3String]];
    
    //监听item的状态
    [item addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
    

    //换碟 把item替换成当前要播放的item
    [self.player replaceCurrentItemWithPlayerItem:item];
    
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        
        //拿到当前播放的状态
        AVPlayerItemStatus status=[change[@"new"]integerValue];
        
        switch (status) {
            case AVPlayerItemStatusUnknown:
                NSLog(@"不识别");
                break;
            case AVPlayerItemStatusReadyToPlay:
                NSLog(@"准备播放");
                [self play];
                break;
            case AVPlayerItemStatusFailed:
                NSLog(@"错误");
                break;
                
            default:
                break;
        }
    }
}


//播放
-(void)play
{
    [self.player play];
}

//暂停
-(void)pause
{
    [self.player pause];
}



@end
