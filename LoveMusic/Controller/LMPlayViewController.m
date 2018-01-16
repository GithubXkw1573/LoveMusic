//
//  LMPlayViewController.m
//  LoveMusic
//
//  Created by 许开伟 on 16/5/11.
//  Copyright © 2016年 kevin xu. All rights reserved.
//

#import "LMPlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "KWPlayer.h"

@interface LMPlayViewController ()
@property (nonatomic, strong) KWPlayer *player;
@property (nonatomic, assign) NSInteger songIndex;

//UI
@property (strong, nonatomic) UISlider *progressSlider;
@property (strong, nonatomic) UIImageView *coverIv;
@property (strong, nonatomic) UILabel *songName;
@property (strong, nonatomic) UILabel *currentTime;
@property (strong, nonatomic) UILabel *duration;
@property (strong, nonatomic) UIImageView *bgIv;
@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) UIButton *nextBtn;
@property (strong, nonatomic) UIButton *preBtn;

@end

@implementation LMPlayViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //播放logo动画
    self.topBarView.playing = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    //背景虚化效果
    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView * effe = [[UIVisualEffectView alloc]initWithEffect:blur];
    effe.alpha = 0.97;
    effe.frame = self.view.bounds;
    [self.view insertSubview:effe aboveSubview:self.bgIv];
    
    //导航栏
    [self.topBarView setTopBarStyle:LMTopBarStyleTransparent];
    self.topBarView.navigateTitle = self.song.name ? self.song.name : @"未知歌曲" ;
    [self.view bringSubviewToFront:self.topBarView];
    
    //初始化播放器
    NSURL * url = [NSURL URLWithString:[self songURLList][self.songIndex]];
    self.player = [[KWPlayer alloc] initWithURL:url];
    [self.player addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:nil];
    [self.player addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:nil];
    [self.player addObserver:self forKeyPath:@"cacheProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    //开始播放
    [self.player play];
    
    //更换封面信息
    [self updateSongInfoShow];
    
    //播放条添加点击seek
    [self.progressSlider addTarget:self action:@selector(changeProgress:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)changeProgress:(UISlider *)slider {
    float seekTime = self.player.duration * slider.value;
    [self.player seekToTime:seekTime];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"progress"]) {
        if (self.progressSlider.state != UIControlStateHighlighted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressSlider.value = self.player.progress;
                self.currentTime.text = [self convertStringWithTime:self.player.duration * self.player.progress];
            });
        }
    }
    if ([keyPath isEqualToString:@"duration"]) {
        if (self.player.duration > 0) {
            self.duration.text = [self convertStringWithTime:self.player.duration];
            self.duration.hidden = NO;
            self.currentTime.hidden = NO;
        }else {
            self.duration.hidden = YES;
            self.currentTime.hidden = YES;
        }
    }
    if ([keyPath isEqualToString:@"cacheProgress"]) {
        //        NSLog(@"缓存进度：%f", self.player.cacheProgress);
    }
}

- (void)play:(UIButton *)sender {
    if (sender.selected) {
        [self.player pause];
    }else {
        [self.player play];
    }
    sender.selected = !sender.selected;
    self.topBarView.playing = sender.selected;
    
    if (sender.selected) {
        [self.playButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause"]
                         forState:UIControlStateNormal];
    }else{
        [self.playButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play"]
                         forState:UIControlStateNormal];
    }
}

- (void)skipSong:(UIButton *)sender {
    self.songIndex ++;
    if (self.songIndex >= 4) self.songIndex = 0;
    
    [self.player stop];
    NSURL * url = [NSURL URLWithString:[self songURLList][self.songIndex]];
    [self.player replaceItemWithURL:url];
    [self.player play];
    [self updateSongInfoShow];
    
    self.playButton.selected = YES;
    [self.playButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause"]
                     forState:UIControlStateNormal];
    
    self.topBarView.playing = YES;
}

- (void)updateSongInfoShow {
    self.songName.text = [self songNameList][self.songIndex];
    
    [UIView transitionWithView:self.bgIv duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.bgIv.image = [UIImage imageNamed:[self songCoverList][self.songIndex]];
    } completion:nil];
    
    [UIView transitionWithView:self.coverIv duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.coverIv.image = [UIImage imageNamed:[self songCoverList][self.songIndex]];
    } completion:nil];
}

- (NSString *)convertStringWithTime:(float)time {
    if (isnan(time)) time = 0.f;
    int min = time / 60.0;
    int sec = time - min * 60;
    NSString * minStr = min > 9 ? [NSString stringWithFormat:@"%d",min] : [NSString stringWithFormat:@"0%d",min];
    NSString * secStr = sec > 9 ? [NSString stringWithFormat:@"%d",sec] : [NSString stringWithFormat:@"0%d",sec];
    NSString * timeStr = [NSString stringWithFormat:@"%@:%@",minStr, secStr];
    return timeStr;
}

- (void)setupUI{
    self.bgIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    self.coverIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    self.progressSlider = [[UISlider alloc] init];
    self.songName = [[UILabel alloc] init];
    self.songName.textColor = [UIColor whiteColor];
    self.currentTime = [[UILabel alloc] init];
    self.duration = [[UILabel alloc] init];
    
    self.playButton = [[UIButton alloc] init];
    self.playButton.selected = YES;
    [self.playButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause"]
                     forState:UIControlStateNormal];
    [self.playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    self.nextBtn = [[UIButton alloc] init];
    [self.nextBtn setImage:[UIImage imageNamed:@"cm2_fm_btn_next"]
                  forState:UIControlStateNormal];
    [self.nextBtn addTarget:self action:@selector(skipSong:) forControlEvents:UIControlEventTouchUpInside];
    self.preBtn = [[UIButton alloc] init];
    [self.preBtn setImage:[UIImage imageNamed:@"cm2_play_btn_prev"]
                  forState:UIControlStateNormal];
    [self.preBtn addTarget:self action:@selector(skipSong:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.bgIv];
    [self.view addSubview:self.coverIv];
    [self.view addSubview:self.progressSlider];
    [self.view addSubview:self.songName];
    [self.view addSubview:self.currentTime];
    [self.view addSubview:self.duration];
    [self.view addSubview:self.playButton];
    [self.view addSubview:self.nextBtn];
    [self.view addSubview:self.preBtn];
    
    [self.bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.coverIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgIv).offset(40);
        make.right.equalTo(self.bgIv).offset(-40);
        make.top.equalTo(self.bgIv).offset(120);
        make.height.equalTo(self.coverIv.mas_width);
    }];
    
    [self.songName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.coverIv.mas_bottom).offset(50);
    }];
    
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgIv).offset(40);
        make.right.equalTo(self.bgIv).offset(-40);
        make.top.equalTo(self.songName.mas_bottom).offset(30);
        make.height.mas_equalTo(20);
    }];
    
    [self.currentTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.progressSlider);
        make.top.equalTo(self.progressSlider.mas_bottom);
    }];
    
    [self.duration mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.progressSlider);
        make.top.equalTo(self.progressSlider.mas_bottom);
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.progressSlider.mas_bottom).offset(40);
    }];

    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playButton.mas_right).offset(40);
        make.centerY.equalTo(self.playButton);
    }];
    [self.preBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.playButton.mas_left).offset(-40);
        make.centerY.equalTo(self.playButton);
    }];
}

- (NSArray *)songNameList {
    return @[@"夏天的味道", @"没那种命", @"体会-于文文", @"老街-李荣浩"];
}

- (NSArray *)songURLList {
    return @[@"http://download.lingyongqian.cn/music/AdagioSostenuto.mp3",
             @"http://download.lingyongqian.cn/music/ForElise.mp3",
             @"http://m10.music.126.net/20180116201719/2c7bc68e76c62b886aa080f16ffc40e3/ymusic/befe/77e1/8df4/5b4549d941b0916b3f34bb41a145ad59.mp3",
             @"http://m10.music.126.net/20180116203008/29e523ee6f944b6877bc37b6a6e84040/ymusic/9044/1e77/f75b/6a86f5fb1dbde0bf07f26ee8e618d4a0.mp3"];
}

- (NSArray *)songCoverList {
    return @[@"p190415_128k.jpg", @"p1458183_128k.jpg", @"p1393354_128k.jpg", @"p966452_128k.jpg"];
}

@end
