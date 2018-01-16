//
//  TestMasonryCell.m
//  LoveMusic
//
//  Created by 许开伟 on 16/4/20.
//  Copyright © 2016年 kevin xu. All rights reserved.
//

#import "TestMasonryCell.h"

#import "HJCornerRadius.h"

@interface TestMasonryCell ()
@property (nonatomic, strong) UIImageView *customImageView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *subtitle;
@property (nonatomic, assign) BOOL constraintDidSetup;

@end

@implementation TestMasonryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews
{
    [self.contentView addSubview:self.customImageView];
    
    [self.contentView addSubview:self.title];
    
    [self.contentView addSubview:self.subtitle];
    
    //通知页面更新约束
    [self setNeedsUpdateConstraints];
}


- (void)bindData:(NSDictionary *)dic
{
    self.title.text = dic[@"name"];
    self.subtitle.text = dic[@"subtitle"];
    NSString *url = dic[@"image"];
    [self.customImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"cover_sheet"]];
}

- (void)updateConstraints
{
    //这里防止多次添加约束
    if (!self.constraintDidSetup) {
        WeakSelf(ws);
        [self.customImageView mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.left.and.top.equalTo(ws.contentView).with.offset(15.f);
            maker.size.mas_equalTo(CGSizeMake(30.f, 30.f));
        }];
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.left.equalTo(ws.customImageView.mas_right).with.offset(20.f);
            maker.right.equalTo(ws.contentView).with.offset(-20);
            maker.centerY.equalTo(ws.customImageView);
        }];
        
        [self.subtitle mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.left.equalTo(ws.title);
            maker.right.equalTo(ws.contentView).with.offset(-20);
            maker.top.equalTo(ws.title.mas_bottom).with.offset(15.f);
            maker.bottom.equalTo(ws.contentView).with.offset(-15.f);
        }];
        
        self.constraintDidSetup = YES;
    }
    
    [super updateConstraints];
}

- (UIImageView *)customImageView
{
    if (!_customImageView) {
        _customImageView = [[UIImageView alloc] init];
        _customImageView.backgroundColor = [UIColor whiteColor];
        //非离屏渲染方式设置圆角（但是这里一屏圆角个数在20个以内，fps帧还能维持在57以上，采取CPU方式反而比GPU更慢，不合适）
//        _customImageView.aliCornerRadius = 15;
        _customImageView.layer.cornerRadius = 15;
        _customImageView.layer.masksToBounds = YES;
    }
    return _customImageView;
}

- (UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = APP_FONT_LARGE;
        _title.backgroundColor = [UIColor whiteColor];
        _title.textColor = [UIColor colorwithHexString:@"#333333"];
        _title.textAlignment = NSTextAlignmentLeft;
        //这里要给label 设定最大宽度，重要！！！
        _title.preferredMaxLayoutWidth = SCREEN_WIDTH - 75;
        
    }
    return _title;
}

- (UILabel *)subtitle
{
    if (!_subtitle) {
        _subtitle = [[UILabel alloc] init];
        _subtitle.font = APP_FONT_NORMAL;
        _subtitle.backgroundColor = [UIColor whiteColor];
        _subtitle.textColor = [UIColor colorwithHexString:@"#666666"];
        _subtitle.textAlignment = NSTextAlignmentLeft;
        _subtitle.numberOfLines = 0;
        _subtitle.preferredMaxLayoutWidth = SCREEN_WIDTH - 75;
    }
    return _subtitle;
}

@end
