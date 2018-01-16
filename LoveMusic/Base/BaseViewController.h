//
//  BaseViewController.h
//  LoveMusic
//
//  Created by kevin xu on 16/1/6.
//  Copyright © 2016年 kevin xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMTopBarView.h"

@interface BaseViewController : UIViewController

@property (nonatomic, strong) LMTopBarView *topBarView;


- (void)showLoadingView;
- (void)hideLoadingView;

- (void)topBarBackButtonCliked;

@end
