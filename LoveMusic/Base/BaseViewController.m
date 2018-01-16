//
//  BaseViewController.m
//  LoveMusic
//
//  Created by kevin xu on 16/1/6.
//  Copyright © 2016年 kevin xu. All rights reserved.
//

#import "BaseViewController.h"

#import "KWCycleLoadingView.h"
#import "KWPlayDynamicView.h"

@interface BaseViewController ()<LMTopBarViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) KWPlayDynamicView *playBtn;
@property (nonatomic, assign) BOOL playing;
@property (nonatomic, strong) KWCycleLoadingView *loadingView;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置控制器的主背景色，不要让app自己去渲染计算背景色，那样会很耗性能
    self.view.backgroundColor = [UIColor colorwithHexString:@"#f4f4f4"];
    //禁用自带的导航栏
    self.navigationController.navigationBarHidden = YES;
    //添加自定义导航栏
    [self addLMTopBarView];
    //添加自定义加载等待遮罩
    [self addLMHudView];
    //处理自定义导航栏手势
    [self popGesture];
    //设置tabar样式
    [self setTabBarApperance];
}

/*!
 *  @author Kevin Xu, 2016-03-10 13:03
 *
 *  @brief 自定义返回让系统手势返回继续有效
 *
 *  @since 1.00
 */
- (void)popGesture{
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
}

/*!
 *  @author Kevin Xu, 2016-03-10 10:03
 *
 *  @brief 添加自定义的通用的只有标题的导航栏
 *
 *  @since 1.00
 */
- (void)addLMTopBarView
{
    //先移除可能已经添加过的导航栏
    [self.topBarView removeFromSuperview];
    self.topBarView = nil;
    //重新添加
    [self.view addSubview:self.topBarView];
    //layout 布局
    [self.topBarView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeBottom];
    [self.topBarView autoSetDimension:ALDimensionHeight toSize:TOP_TOOL_BAR_HEIGHT];
    //默认是只有标题
    [self.topBarView setTopBarStyle:LMTopBarStyleTitle];
}

- (void)addLMHudView
{
    [self.loadingView removeFromSuperview];
    self.loadingView = nil;
    
    [self.view addSubview:self.loadingView];
    self.loadingView.backgroundColor = [UIColor lightGrayColor];
    //layout
    [self.loadingView autoCenterInSuperview];
    [self.loadingView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view withMultiplier:0.5];
    [self.loadingView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:self.loadingView];
    //init hidden
    [self hideLoadingView];
    
}


- (void)showLoadingView
{
    self.loadingView.hidden = NO;
    [self.view bringSubviewToFront:self.loadingView];
    [self.loadingView layoutIfNeeded];
    [self.loadingView startAnimation];
}

- (void)hideLoadingView
{
    self.loadingView.hidden = YES;
}

/*!
 *  @author Kevin Xu, 2016-03-10 11:03
 *
 *  @brief 设置tabar样式
 *
 *  @since 1.00
 */
- (void)setTabBarApperance
{
    self.tabBarController.tabBar.barTintColor = [UIColor darkGrayColor];
    self.tabBarController.tabBar.tintColor = [UIColor whiteColor];
}

/**
 *  @author Kevin  Xu, 16-05-09 09:05:11
 *
 *  @brief 页面消失前移除loading
 *
 *  @param animated <#animated description#>
 *
 *  @since <#1.0#>
 */
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self hideLoadingView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.playing) {
        [self.playBtn startAnimation];
    }else{
        [self.playBtn stopAnimation];
    }
}

- (UIView *)topBarView
{
    if (!_topBarView) {
        //默认是添加一个只有标题的导航栏,子控制器可以重新修改
        _topBarView = [[LMTopBarView alloc] initWithDelegate:self];
    }
    return _topBarView;
}

- (KWCycleLoadingView *)loadingView
{
    if (!_loadingView) {
        _loadingView = [KWCycleLoadingView new];
    }
    return _loadingView;
}

- (void)topBarBackButtonCliked{
    if (self.navigationController) {
        if ([self.navigationController viewControllers].count > 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)topBarPlayButtonCliked:(UIButton *)playButton{
    self.playing = !_playing;
    self.playBtn = (KWPlayDynamicView *)playButton;
    if (self.playing) {
        [self.playBtn startAnimation];
    }else{
        [self.playBtn stopAnimation];
    }
}

- (void)playAnimation{
    self.playing = YES;
    [self.playBtn startAnimation];
}

@end
