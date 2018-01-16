//
//  LMTrackDetailCoverCell.m
//  LoveMusic
//
//  Created by kevin xu on 16/3/10.
//  Copyright © 2016年 kevin xu. All rights reserved.
//

#import "LMTrackDetailCoverCell.h"

#import "LMSongModel.h"

@interface LMTrackDetailCoverCell ()

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIView *playCountView;
@property (nonatomic, strong) UILabel *playCountLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *avaterImageView;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *subcribeLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UILabel *shareLabel;
@property (nonatomic, strong) UIButton *downButton;
@property (nonatomic, assign) BOOL didSetupConstraint;
@end

@implementation LMTrackDetailCoverCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.coverImageView = [[UIImageView alloc] initForAutoLayout];
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.coverImageView];
        
        self.playCountView = [UIView newAutoLayoutView];
        self.playCountView.hidden = YES;
        self.playCountView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
        [self.coverImageView addSubview:self.playCountView];
        
        self.playCountLabel = [UILabelFactory autoLabelWithTextColor:[UIColor whiteColor] font:APP_FONT_SMALL alignment:NSTextAlignmentRight];
        [self.playCountView addSubview:self.playCountLabel];
        
        self.titleLabel = [UILabelFactory autoLabelWithTextColor:[UIColor whiteColor] font:APP_FONT_LARGE alignment:NSTextAlignmentLeft];
        self.titleLabel.numberOfLines = 2;
        [self.contentView addSubview:self.titleLabel];
        
        self.avaterImageView = [[UIImageView alloc] initForAutoLayout];
        [self.contentView addSubview:self.avaterImageView];
        
        self.authorLabel = [UILabelFactory autoLabelWithTextColor:[UIColor lightTextColor] font:APP_FONT_THIRTEEN alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.authorLabel];
        
        self.subcribeLabel = [UILabelFactory autoLabelWithTextColor:[UIColor whiteColor] font:APP_FONT_NORMAL alignment:NSTextAlignmentCenter text:@"订阅"];
        [self.contentView addSubview:self.subcribeLabel];
        self.commentLabel = [UILabelFactory autoLabelWithTextColor:[UIColor whiteColor] font:APP_FONT_NORMAL alignment:NSTextAlignmentCenter text:@"评论"];
        [self.contentView addSubview:self.commentLabel];
        self.shareLabel = [UILabelFactory autoLabelWithTextColor:[UIColor whiteColor] font:APP_FONT_NORMAL alignment:NSTextAlignmentCenter text:@"分享"];
        [self.contentView addSubview:self.shareLabel];
        self.downButton = [[UIButton alloc] initForAutoLayout];
        self.downButton.titleLabel.font = APP_FONT_NORMAL;
        [self.downButton setTitle:@"下载" forState:UIControlStateNormal];
        [self.contentView addSubview:self.downButton];
        
        [self setNeedsUpdateConstraints];
        
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraint) {
        
        [self.coverImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(UNIVERSAL_HEIGHT(20), UNIVERSAL_WIDTH(20), UNIVERSAL_HEIGHT(50), 0) excludingEdge:ALEdgeRight];
        [self.coverImageView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:self.coverImageView];
        
        
        [self.playCountView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeBottom];
        [self.playCountView autoSetDimension:ALDimensionHeight toSize:UNIVERSAL_HEIGHT(20)];
        
        [self.playCountLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:2];
        [self.playCountLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        [self.titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.coverImageView withOffset:UNIVERSAL_WIDTH(15)];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:UNIVERSAL_HEIGHT(30)];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:UNIVERSAL_WIDTH(20)];
        
        [self.avaterImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:UNIVERSAL_HEIGHT(12)];
        [self.avaterImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.coverImageView withOffset:UNIVERSAL_WIDTH(15)];
        [self.avaterImageView autoSetDimensionsToSize:CGSizeMake(UNIVERSAL_HEIGHT(24), UNIVERSAL_HEIGHT(24))];
        self.avaterImageView.layer.cornerRadius = UNIVERSAL_HEIGHT(24)/2;
        self.avaterImageView.layer.masksToBounds = YES;
        
        [self.authorLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.avaterImageView];
        [self.authorLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.avaterImageView withOffset:UNIVERSAL_WIDTH(3)];
        
        NSArray *views = @[self.subcribeLabel, self.commentLabel, self.shareLabel, self.downButton];
        [self.subcribeLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:UNIVERSAL_HEIGHT(8)];
        [views autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeTop withFixedSpacing:20];
        [views autoAlignViewsToEdge:ALEdgeBottom];
    }
    
    [super updateConstraints];
}

- (void)bindModel:(LMSongTrack *)track
{
    [self.coverImageView setImageWithURL:[NSURL URLWithString:track.coverImgUrl]];
    
    self.titleLabel.text = track.name;
    
    NSString *playCountstr = [NSString stringWithFormat:@"%@",@(track.playCount)];
    if (track.playCount >= 100000) {
        playCountstr = [NSString stringWithFormat:@"%@万",@(track.playCount/10000)];
    }
    self.playCountLabel.text = NSSTRING_NOT_NIL(playCountstr);
    self.playCountView.hidden = NO;
    
    self.avaterImageView.image = [UIImage imageNamed:@"cover_sheet"];
    self.authorLabel.text = @"林枫之前";
}

@end
