//
//  LMHomeTopEntrenceCell.m
//  LoveMusic
//
//  Created by kevin xu on 16/3/3.
//  Copyright © 2016年 kevin xu. All rights reserved.
//

#import "LMHomeTopEntrenceCell.h"

@interface HomeEntrenceButton : UIButton
@property (nonatomic, strong) UIImageView *myImageView;
@property (nonatomic, strong) UILabel *myTitleLabel;
@property (nonatomic, assign) NSInteger typeId;
- (instancetype)initForAutoLayoutWithImage:(NSString *)imageName title:(NSString *)title;
@end

@implementation HomeEntrenceButton

- (instancetype)initForAutoLayoutWithImage:(NSString *)imageName title:(NSString *)title
{
    if (self = [super initForAutoLayout]) {
        self.myImageView = [UIImageView newAutoLayoutView];
        self.myImageView.image = [UIImage imageNamed:imageName];
        self.myImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.myImageView];
        [self.myImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 5, 0, 5) excludingEdge:ALEdgeBottom];
        [self.myImageView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:self.myImageView];
        
        self.myTitleLabel = [UILabelFactory autoLabelWithTextColor:[UIColor darkGrayColor] font:APP_FONT_THIRTEEN alignment:NSTextAlignmentCenter text:title];
        [self addSubview:self.myTitleLabel];
        [self.myTitleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.myImageView withOffset:UNIVERSAL_HEIGHT(5)];
        [self.myTitleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    }
    return self;
}

@end

@interface LMHomeTopEntrenceCell ()
@property (nonatomic, strong) HomeEntrenceButton *hotItem;
@end

@implementation LMHomeTopEntrenceCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.hotItem = [[HomeEntrenceButton alloc] initForAutoLayoutWithImage:@"entrence_hot" title:@"云音乐热歌榜"];
        [self.contentView addSubview:self.hotItem];
        [self.hotItem addTarget:self action:@selector(EntrenceButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.hotItem autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.hotItem autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:UNIVERSAL_HEIGHT(10)];
        [self.hotItem autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.contentView withMultiplier:3/5.f];
        
        UIView *bottomLine = [UIView newAutoLayoutView];
        bottomLine.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:bottomLine];
        [bottomLine autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, UNIVERSAL_HEIGHT(10), 0) excludingEdge:ALEdgeTop];
        [bottomLine autoSetDimension:ALDimensionHeight toSize:0.5];
    }
    return self;
}

- (void)bindTopType:(NSInteger)topType idValue:(NSInteger)idVlaue
{
    self.hotItem.typeId = idVlaue;
    switch (topType) {
        case TopListTypeNew:
        {
            self.hotItem.myTitleLabel.text = @"云音乐新歌榜";
            
        }
            break;
        case TopListTypeHot:
        {
            self.hotItem.myTitleLabel.text = @"云音乐热歌榜";
            
        }
            break;
        case TopListTypeSoar:
        {
            self.hotItem.myTitleLabel.text = @"云音乐飙升榜";
            
        }
            break;
        default:
            break;
    }
}


- (void)EntrenceButtonClicked
{
    
}

@end
