//
//  MyMusicViewController.m
//  LoveMusic
//
//  Created by kevin xu on 16/1/6.
//  Copyright © 2016年 kevin xu. All rights reserved.
//

#import "MyMusicViewController.h"

@interface MyMusicViewController ()

@end

@implementation MyMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.topBarView setTopBarStyle:LMTopBarStylePlayButton];
    [self initSegementView];
}


- (void)initSegementView
{
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"已下载",@"下载中"]];
    [segment setTintColor:[UIColor whiteColor]];
    segment.selectedSegmentIndex = 0;
    [self.topBarView addSubview:segment];
    [segment autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [segment autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.topBarView withOffset:10];
}

@end
