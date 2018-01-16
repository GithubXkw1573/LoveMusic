//
//  LMTopBarView.m
//  LoveMusic
//
//  Created by kevin xu on 16/3/9.
//  Copyright © 2016年 kevin xu. All rights reserved.
//

#import "LMTopBarView.h"
#import "KWPlayDynamicView.h"

@interface LMTopBarView ()
@property (nonatomic, strong) UIView *topBarView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) KWPlayDynamicView *playBtn;

@end

@implementation LMTopBarView

- (instancetype)initWithDelegate:(id<LMTopBarViewDelegate>)delegate
{
    if (self = [super initForAutoLayout]) {
        self.backgroundColor = [UIColor redColor];
        self.delegate = delegate;
    }
    return self;
}

- (void)setTopBarStyle:(LMTopBarStyle)topBarStyle
{
    if (_topBarStyle == topBarStyle) {
        return;
    }
    _topBarStyle = topBarStyle;
    for(UIView *v in self.subviews){
        [v removeFromSuperview];
    }
    switch (topBarStyle) {
        case LMTopBarStyleDefault:
            self.backgroundColor = [UIColor redColor];
            break;
        case LMTopBarStyleTitle:{
            self.backgroundColor = [UIColor redColor];
            [self addSubview:self.titleLabel];
            [self.titleLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self withOffset:10];
            [self.titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
            [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20 relation:NSLayoutRelationGreaterThanOrEqual];
        }
            break;
        case LMTopBarStyleBackButton:{
            self.backgroundColor = [UIColor redColor];
            [self addSubview:self.backButton];
            [self.backButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(20, 0, 0, 0) excludingEdge:ALEdgeRight];
            [self.backButton autoSetDimension:ALDimensionWidth toSize:50];
        }
            break;
        case LMTopBarStyleTitleWithBackButton:{
            self.backgroundColor = [UIColor redColor];
            [self addSubview:self.backButton];
            [self.backButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(20, 0, 0, 0) excludingEdge:ALEdgeRight];
            [self.backButton autoSetDimension:ALDimensionWidth toSize:50];
            [self addSubview:self.titleLabel];
            [self.titleLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.backButton];
            [self.titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
            [self.titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.backButton withOffset:10 relation:NSLayoutRelationGreaterThanOrEqual];
        }
            break;
        case LMTopBarStylePlayButton:{
            self.backgroundColor = [UIColor redColor];
            [self addSubview:self.playBtn];
            [self.playBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(20, 0, 0, 0) excludingEdge:ALEdgeLeft];
            [self.playBtn autoSetDimension:ALDimensionWidth toSize:50];
            [self.playBtn layoutIfNeeded];
            [self.playBtn stopAnimation];
        }
            break;
        case LMTopBarStyleTitleWithPlayButton:{
            self.backgroundColor = [UIColor redColor];
            [self addSubview:self.titleLabel];
             [self.titleLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self withOffset:10];
             [self.titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
            
            [self addSubview:self.playBtn];
            [self.playBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(20, 0, 0, 0) excludingEdge:ALEdgeLeft];
            [self.playBtn autoSetDimension:ALDimensionWidth toSize:50];
            [self.titleLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.playBtn withOffset:10 relation:NSLayoutRelationGreaterThanOrEqual];
            [self.playBtn layoutIfNeeded];
            [self.playBtn stopAnimation];
        }
            break;
        case LMTopBarStyleBackButtonAndPlayButton:{
            self.backgroundColor = [UIColor redColor];
            [self addSubview:self.backButton];
            [self.backButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(20, 0, 0, 0) excludingEdge:ALEdgeRight];
            [self.backButton autoSetDimension:ALDimensionWidth toSize:50];
            
            [self addSubview:self.playBtn];
            [self.playBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(20, 0, 0, 0) excludingEdge:ALEdgeLeft];
            [self.playBtn autoSetDimension:ALDimensionWidth toSize:50];
            [self.playBtn layoutIfNeeded];
            [self.playBtn stopAnimation];
        }
            break;
        case LMTopBarStyleTitleWithBackButtonAndPlayButton:{
            self.backgroundColor = [UIColor redColor];
            [self addSubview:self.backButton];
            [self.backButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(20, 0, 0, 0) excludingEdge:ALEdgeRight];
            [self.backButton autoSetDimension:ALDimensionWidth toSize:50];
            [self addSubview:self.titleLabel];
            [self.titleLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.backButton];
            [self.titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
            [self.titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.backButton withOffset:10 relation:NSLayoutRelationGreaterThanOrEqual];
            [self addSubview:self.playBtn];
            [self.playBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(20, 0, 0, 0) excludingEdge:ALEdgeLeft];
            [self.playBtn autoSetDimension:ALDimensionWidth toSize:50];
            [self.playBtn layoutIfNeeded];
            [self.playBtn stopAnimation];
        }
            break;
        case LMTopBarStyleTransparent:{
            self.backgroundColor = [UIColor clearColor];
            [self addSubview:self.backButton];
            [self.backButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(20, 0, 0, 0) excludingEdge:ALEdgeRight];
            [self.backButton autoSetDimension:ALDimensionWidth toSize:50];
            [self addSubview:self.titleLabel];
            [self.titleLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.backButton];
            [self.titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
            [self.titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.backButton withOffset:10 relation:NSLayoutRelationGreaterThanOrEqual];
            [self addSubview:self.playBtn];
            [self.playBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(20, 0, 0, 0) excludingEdge:ALEdgeLeft];
            [self.playBtn autoSetDimension:ALDimensionWidth toSize:50];
            [self.playBtn layoutIfNeeded];
            [self.playBtn stopAnimation];
        }
            break;
        default:
            break;
    }
    if (topBarStyle != LMTopBarStyleTransparent) {
        [self addSubview:self.bottomLine];
        [self.bottomLine autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop];
        [self.bottomLine autoSetDimension:ALDimensionHeight toSize:0.5];
    }

}

- (void)setNavigateTitle:(NSString *)title{
    self.titleLabel.text = title;
}

- (NSString *)navigateTitle{
    return self.titleLabel.text;
}

- (void)setBackButtonImageWithName:(NSString *)imageName{
    [self.backButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)changeToPlayingMode{
    self.playBtn.highlighted = YES;
}

- (void)changeToPlayStopedMode{
    self.playBtn.highlighted = NO;
}

- (void)hidePlayBtn{
    self.playBtn.hidden = YES;
}

- (void)showPlayBtn{
    self.playBtn.hidden = NO;
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initForAutoLayout];
        [_backButton setImage:[UIImage imageNamed:@"sys_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(returnBackClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabelFactory autoLabelWithTextColor:[UIColor whiteColor] font:APP_FONT(17) alignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

- (UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initForAutoLayout];
        _bottomLine.backgroundColor = [UIColor colorwithHexString:@"#c6c6c6"];
    }
    return _bottomLine;
}

- (UIButton *)playBtn
{
    if (!_playBtn) {
        _playBtn = [[KWPlayDynamicView alloc] init];
        [_playBtn addTarget:self action:@selector(playBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (void)returnBackClicked
{
    if ([_delegate respondsToSelector:@selector(topBarBackButtonCliked)]) {
        [_delegate topBarBackButtonCliked];
    }
}

- (void)playBtnClicked:(id)sender
{
    if ([_delegate respondsToSelector:@selector(topBarPlayButtonCliked:)]) {
        [_delegate topBarPlayButtonCliked:self.playBtn];
    }
}

- (void)setPlaying:(BOOL)playing{
    _playing = playing;
    if (playing) {
        [self.playBtn startAnimation];
    }else{
        [self.playBtn stopAnimation];
    }
}
@end
