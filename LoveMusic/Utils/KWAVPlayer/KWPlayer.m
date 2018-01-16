//
//  KWPlayer.m
//  LoveMusic
//
//  Created by 许开伟 on 2017/12/24.
//  Copyright © 2017年 kevin xu. All rights reserved.
//

#import "KWPlayer.h"
#import "NSURL+KWUrlLoader.h"
#import "KWFileHandler.h"
#import "NSString+KWFile.h"

@interface KWPlayer()<KWResourceLoaderDelegate>

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *currentItem;
@property (nonatomic, strong) KWResourceLoader *resourceLoader;

@property (nonatomic, strong) id timeObserve;

@end

@implementation KWPlayer

/**
 初始化一个播放器
 
 @param url 播放URL地址(网络或者本地地址)
 @return 返回一个播放器实例
 */
- (instancetype)initWithURL:(NSURL *)url{
    if (self = [super init]) {
        self.url = url;
        [self reloadCurrentItem];
    }
    return self;
}

- (void)reloadCurrentItem{
    //判断是本地播放还是网络播放
    if ([_url.absoluteString hasPrefix:@"http"]) {
        //判断有没有本地缓存
        NSString *cacheFilePath = [KWFileHandler cacheFileExistsWithURL:_url];
        if (cacheFilePath) {
            //有缓存，播放缓存
            NSURL *fileUrl = [NSURL fileURLWithPath:cacheFilePath];
            self.currentItem = [AVPlayerItem playerItemWithURL:fileUrl];
        }else{
            //网络播放
            //url请求格式设置成流(把我们目标URL地址的scheme替换为系统不能识别的scheme，
            //然后在我们调用网络请求去处理这个URL时把scheme切换为原来的scheme,
            //这样做的目的是为了AVAssetResourceLoader委托方式执行)
            NSURL *streamUrl = [self.url customSchemeURL];
            //组装一个播放资源
            AVURLAsset *asset = [AVURLAsset assetWithURL:streamUrl];
            
            //初始化一个资源加载器
            self.resourceLoader = [[KWResourceLoader alloc] init];
            self.resourceLoader.delegate = self;
            
            //指定播放资源加载委托
            [asset.resourceLoader setDelegate:self.resourceLoader
                                        queue:dispatch_get_main_queue()];
            
            //设置当前要播放的资源，准备播放
            self.currentItem = [AVPlayerItem playerItemWithAsset:asset];
        }
    }else{
        //本地播放
        self.currentItem = [AVPlayerItem playerItemWithURL:self.url];
    }
    
    //新建播放器，准备播放
    self.player = [AVPlayer playerWithPlayerItem:self.currentItem];
    
    //Observer
    [self addObserver];
    
    //State
    _state = SUPlayerStateWaiting;
}

//播放下一首
- (void)replaceItemWithURL:(NSURL *)url {
    self.url = url;
    [self reloadCurrentItem];
}

//播放
- (void)play {
    if (self.state == SUPlayerStatePaused || self.state == SUPlayerStateWaiting) {
        [self.player play];
    }
}

//暂停，可恢复播放
- (void)pause {
    if (self.state == SUPlayerStatePlaying) {
        [self.player pause];
    }
}

- (BOOL)isPlaying{
    if (self.state == SUPlayerStatePlaying) {
        return YES;
    }
    return NO;
}

//停止，销毁播放数据
- (void)stop {
    if (self.state == SUPlayerStateStopped) {
        return;
    }
    [self.player pause];
    [self.resourceLoader stopLoading];
    [self removeObserver];
    self.resourceLoader = nil;
    self.currentItem = nil;
    self.player = nil;
    self.progress = 0.0;
    self.duration = 0.0;
    self.state = SUPlayerStateStopped;
}

//跳到指定位置播放
- (void)seekToTime:(CGFloat)seconds {
    if (self.state == SUPlayerStatePlaying || self.state == SUPlayerStatePaused) {
        // 暂停后滑动slider后    暂停播放状态
        // 播放中后滑动slider后   自动播放状态
        //        [self.player pause];
        self.resourceLoader.seekRequired = YES;
        [self.player seekToTime:CMTimeMakeWithSeconds(seconds, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
            NSLog(@"seekComplete!!");
            if ([self isPlaying]) {
                [self.player play];
            }
        }];;
    }
}

#pragma mark - NSNotification 打断处理

- (void)audioSessionInterrupted:(NSNotification *)notification{
    //通知类型
    NSDictionary * info = notification.userInfo;
    // AVAudioSessionInterruptionTypeBegan ==
    if ([[info objectForKey:AVAudioSessionInterruptionTypeKey] integerValue] == 1) {
        [self.player pause];
    }else{
        [self.player play];
    }
}


#pragma mark - KVO
- (void)addObserver {
    AVPlayerItem * songItem = self.currentItem;
    //播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:songItem];
    //播放进度
    __weak typeof(self) weakSelf = self;
    self.timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        CGFloat current = CMTimeGetSeconds(time);
        CGFloat total = CMTimeGetSeconds(songItem.duration);
        weakSelf.duration = total;
        weakSelf.progress = current / total;
    }];
    [self.player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
    [songItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [songItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [songItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    [songItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver {
    AVPlayerItem * songItem = self.currentItem;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.timeObserve) {
        [self.player removeTimeObserver:self.timeObserve];
        self.timeObserve = nil;
    }
    [songItem removeObserver:self forKeyPath:@"status"];
    [songItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [songItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [songItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [self.player removeObserver:self forKeyPath:@"rate"];
    [self.player replaceCurrentItemWithPlayerItem:nil];
}

/**
 *  通过KVO监控播放器状态
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    AVPlayerItem * songItem = object;
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray * array = songItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue]; //本次缓冲的时间范围
        NSTimeInterval totalBuffer = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration); //缓冲总长度
        NSLog(@"共缓冲%.2f",totalBuffer);
    }
    if ([keyPath isEqualToString:@"rate"]) {
        if (self.player.rate == 0.0) {
            _state = SUPlayerStatePaused;
        }else {
            _state = SUPlayerStatePlaying;
        }
    }
}

- (void)playbackFinished {
    NSLog(@"播放完成");
    [self stop];
}

#pragma mark - KWLoaderResourceDelegate
- (void)loader:(KWResourceLoader *)loader cacheProgress:(CGFloat)progress {
    self.cacheProgress = progress;
}

#pragma mark - Property Set
- (void)setProgress:(CGFloat)progress {
    [self willChangeValueForKey:@"progress"];
    _progress = progress;
    [self didChangeValueForKey:@"progress"];
}

- (void)setState:(SUPlayerState)state {
    [self willChangeValueForKey:@"progress"];
    _state = state;
    [self didChangeValueForKey:@"progress"];
}

- (void)setCacheProgress:(CGFloat)cacheProgress {
    [self willChangeValueForKey:@"progress"];
    _cacheProgress = cacheProgress;
    [self didChangeValueForKey:@"progress"];
}

- (void)setDuration:(CGFloat)duration {
    if (duration != _duration && !isnan(duration)) {
        [self willChangeValueForKey:@"duration"];
        NSLog(@"duration %f",duration);
        _duration = duration;
        [self didChangeValueForKey:@"duration"];
    }
}

#pragma mark - CacheFile
- (BOOL)currentItemCacheState {
    if ([self.url.absoluteString hasPrefix:@"http"]) {
        if (self.resourceLoader) {
            return self.resourceLoader.cacheFinished;
        }
        return YES;
    }
    return NO;
}

- (NSString *)currentItemCacheFilePath {
    if (![self currentItemCacheState]) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@/%@", [NSString cacheFolderPath], [NSString fileNameWithURL:self.url]];;
}

+ (BOOL)clearCache {
    [KWFileHandler clearCache];
    return YES;
}

@end
