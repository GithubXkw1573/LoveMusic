//
//  LMHomeCollectHeadView.m
//  LoveMusic
//
//  Created by kevin xu on 16/3/2.
//  Copyright © 2016年 kevin xu. All rights reserved.
//

#import "LMHomeCollectHeadView.h"


@interface LMHomeCollectHeadView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *moreThemeButton;
@property (nonatomic, strong) UIView *indicateLine;
@end

@implementation LMHomeCollectHeadView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        self.indicateLine = [UIView newAutoLayoutView];
        self.indicateLine.backgroundColor = [UIColor redColor];
        self.indicateLine.layer.cornerRadius = 1.2;
        self.indicateLine.layer.masksToBounds=YES;
        [self addSubview:self.indicateLine];
        [self.indicateLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
        [self.indicateLine autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self withMultiplier:0.5];
        [self.indicateLine autoSetDimension:ALDimensionWidth toSize:UNIVERSAL_HEIGHT(3)];
        [self.indicateLine autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        _titleLabel = [UILabelFactory autoLabelWithTextColor:[UIColor blackColor] font:APP_FONT_FIFTEEN alignment:NSTextAlignmentLeft];
        [self addSubview:_titleLabel];
        [self.titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.indicateLine withOffset:5];
        [self.titleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        
        
//        _moreThemeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _moreThemeButton.backgroundColor = [UIColor clearColor];
//        [_moreThemeButton setImage:[UIImage imageNamed:@"arrow_2"] forState:UIControlStateNormal];
//        _moreThemeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 2, 0);
//        _moreThemeButton.titleLabel.font = [UIFont systemFontOfSize:12];
//        [_moreThemeButton setTitle:@"更多" forState:UIControlStateNormal];
//        [_moreThemeButton setTitleColor:[TNColorFactory globalThemeColor] forState:UIControlStateNormal];
//        [_moreThemeButton addTarget:self action:@selector(moreClicked) forControlEvents:UIControlEventTouchUpInside];
//        _moreThemeButton.frame = CGRectMake(self.width - 60, 15, 50, 20);
//        [self addSubview:_moreThemeButton];
    }
    return self;
}

- (void)bindTitle:(NSString *)titleText
{
    self.titleLabel.text = titleText;
}

@end
