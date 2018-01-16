//
//  LMHomePlaySheetCell.m
//  LoveMusic
//
//  Created by kevin xu on 16/3/2.
//  Copyright © 2016年 kevin xu. All rights reserved.
//

#import "LMHomePlaySheetCell.h"
#import "LMPlayList.h"
#import "LMZAlbum.h"

@interface LMHomePlaySheetCell ()
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *arstistName;
@property (nonatomic, strong) UIView *playCountView;
@property (nonatomic, strong) UILabel *playCountLabel;
@property (nonatomic, assign) BOOL didSetupConstraint;
@property (nonatomic, assign) CellContentType *cellContentType;
@end

@implementation LMHomePlaySheetCell

- (instancetype)initForAutoLayout
{
    if (self = [super initForAutoLayout]) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.coverImageView = [[UIImageView alloc] initForAutoLayout];
        self.coverImageView.backgroundColor = [UIColor clearColor];
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.coverImageView];
        
        self.playCountView = [UIView newAutoLayoutView];
        self.playCountView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
        [self.coverImageView addSubview:self.playCountView];
        
        self.playCountLabel = [UILabelFactory autoLabelWithTextColor:[UIColor whiteColor] font:APP_FONT_SMALL alignment:NSTextAlignmentRight];
        [self.playCountView addSubview:self.playCountLabel];
        
        self.descLabel = [UILabelFactory autoLabelWithTextColor:[UIColor darkGrayColor] font:APP_FONT_SMALL alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.descLabel];
        
        self.arstistName = [UILabelFactory autoLabelWithTextColor:[UIColor grayColor] font:APP_FONT_SMALL alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.arstistName];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraint) {
        
        [self.coverImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeBottom];
        [self.coverImageView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:_coverImageView];
        
        [self.playCountView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeBottom];
        [self.playCountView autoSetDimension:ALDimensionHeight toSize:UNIVERSAL_HEIGHT(20)];
        
        [self.playCountLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:2];
        [self.playCountLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        [self.descLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.descLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.coverImageView withOffset:UNIVERSAL_HEIGHT(5)];
        [self.descLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.coverImageView];
        
        [self.arstistName autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.descLabel withOffset:UNIVERSAL_HEIGHT(2)];
        [self.arstistName autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.arstistName autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.coverImageView];
        
        self.didSetupConstraint = YES;
    }
    
    [super updateConstraints];
}

- (void)bindSheetModel:(LMPlayList *)sheet
{
    [self.coverImageView setImageWithURL:[NSURL URLWithString:sheet.picUrl] placeholderImage:[UIImage imageNamed:@""]];
    self.playCountView.hidden = NO;
    NSString *playCountstr = [NSString stringWithFormat:@"%.0f",sheet.playCount];
    if (sheet.playCount >= 10000) {
        playCountstr = [NSString stringWithFormat:@"%.0f万",sheet.playCount/10000];
    }
    self.playCountLabel.text = NSSTRING_NOT_NIL(playCountstr);
    self.descLabel.numberOfLines = 2;
    self.descLabel.text = sheet.name;
    self.descLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.arstistName.hidden = YES;
    
    [self setNeedsUpdateConstraints];
}

- (void)bindAlbumModel:(LMZAlbum *)album
{
    [self.coverImageView setImageWithURL:[NSURL URLWithString:album.picUrl] placeholderImage:[UIImage imageNamed:@""]];
    self.playCountView.hidden = YES;
    self.descLabel.numberOfLines = 1;
    self.descLabel.text = album.name;
    self.descLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.arstistName.hidden = NO;
    self.arstistName.text = album.artistName;
    
    [self setNeedsUpdateConstraints];
}

@end
