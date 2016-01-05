//
//  PlayMusicHelper.h
//  Appointment
//
//  Created by Pellet Mo on 15/12/29.
//  Copyright © 2015年 mopellet. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

@interface PlayMusicHelper : NSObject

/**
 * 单例
 */
+(instancetype)defaultPlayMusicHelpyer;

@property(nonatomic,strong) AVPlayer *player;
@property(nonatomic,copy)void(^currentTimeBlock)(CGFloat);
//播放音乐的方法
-(void)playMusicWithUrlString:(NSString*)mp3String;

//播放
-(void)play;

//暂停
-(void)pause;

@property(nonatomic,strong) NSTimer*timer;

//是否正在播放
@property(nonatomic,assign)BOOL ifPlaying;

//音乐播放完成调用的block
@property(nonatomic,copy)void(^playEndBlock)();

@end
