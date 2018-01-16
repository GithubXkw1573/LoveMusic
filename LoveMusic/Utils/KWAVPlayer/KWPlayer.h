//
//  KWPlayer.h
//  LoveMusic
//
//  Created by 许开伟 on 2017/12/24.
//  Copyright © 2017年 kevin xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWResourceLoader.h"

typedef NS_ENUM(NSInteger, SUPlayerState) {
    SUPlayerStateWaiting,//等待中
    SUPlayerStatePlaying,//播放中
    SUPlayerStatePaused,//暂停
    SUPlayerStateStopped,//停止
    SUPlayerStateBuffering,//缓存中
    SUPlayerStateError //错误
};

@interface KWPlayer : NSObject<KWResourceLoaderDelegate>

@property (nonatomic, assign) SUPlayerState state;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) CGFloat cacheProgress;

/**
 初始化一个播放器
 
 @param url 播放URL地址(网络或者本地地址)
 @return 返回一个播放器实例
 */
- (instancetype)initWithURL:(NSURL *)url;

/**
 *  播放下一首歌曲，url：歌曲的网络地址或者本地地址
 *  逻辑：stop -> replace -> play
 */
- (void)replaceItemWithURL:(NSURL *)url;

/**
 *  播放
 */
- (void)play;

/**
 *  暂停
 */
- (void)pause;

/**
 *  停止
 */
- (void)stop;

/**
 *  正在播放
 */
- (BOOL)isPlaying;

/**
 *  跳到某个时间进度
 */
- (void)seekToTime:(CGFloat)seconds;

/**
 *  当前歌曲缓存情况 YES：已缓存  NO：未缓存（seek过的歌曲都不会缓存）
 */
- (BOOL)currentItemCacheState;

/**
 *  当前歌曲缓存文件完整路径
 */
- (NSString *)currentItemCacheFilePath;

/**
 *  清除缓存
 */
+ (BOOL)clearCache;

@end
