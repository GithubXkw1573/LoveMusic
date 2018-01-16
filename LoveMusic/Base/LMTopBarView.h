//
//  LMTopBarView.h
//  LoveMusic
//
//  Created by kevin xu on 16/3/9.
//  Copyright © 2016年 kevin xu. All rights reserved.
//
typedef NS_ENUM(NSInteger, LMTopBarStyle) {
    LMTopBarStyleDefault,
    LMTopBarStyleTitle,
    LMTopBarStyleBackButton,
    LMTopBarStylePlayButton,
    LMTopBarStyleTitleWithBackButton,
    LMTopBarStyleTitleWithPlayButton,
    LMTopBarStyleBackButtonAndPlayButton,
    LMTopBarStyleTitleWithBackButtonAndPlayButton,
    LMTopBarStyleTransparent,
};

#import <UIKit/UIKit.h>

@protocol LMTopBarViewDelegate <NSObject>

- (void)topBarBackButtonCliked;
- (void)topBarPlayButtonCliked:(UIButton *)playButton;

@end

@interface LMTopBarView : UIView

@property (nonatomic, weak) id<LMTopBarViewDelegate> delegate;
@property (assign, nonatomic) LMTopBarStyle topBarStyle;

@property (nonatomic, assign) BOOL playing;

- (instancetype)initWithDelegate:(id<LMTopBarViewDelegate>)delegate;

- (void)setNavigateTitle:(NSString *)title;
- (NSString *)navigateTitle;

- (void)setBackButtonImageWithName:(NSString *)imageName;

- (void)hidePlayBtn;
- (void)showPlayBtn;
- (void)changeToPlayingMode;
- (void)changeToPlayStopedMode;

@end
