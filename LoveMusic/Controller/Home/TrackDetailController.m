//
//  TrackDetailController.m
//  LoveMusic
//
//  Created by kevin xu on 16/3/8.
//  Copyright © 2016年 kevin xu. All rights reserved.
//

#import "TrackDetailController.h"

#import "LMTrackDetailCoverCell.h"
#import "LMSongModel.h"
#import "LMPlayViewController.h"

@interface TrackDetailController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) NSLayoutConstraint *headerImageBottom;
@property (nonatomic, strong) NSLayoutConstraint *headerTop;
@property (nonatomic, strong) LMSongTrack *track;
@end

@implementation TrackDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.topBarView setTopBarStyle:LMTopBarStyleTransparent];
    [self.topBarView setNavigateTitle:@"歌单"];
    
    [self initHeaderImageView];
    
    [self initTableView];
    
    [self requestData];
}

- (void)initHeaderImageView
{
    self.headerView = [[UIView alloc] initForAutoLayout];
    self.headerView.hidden = YES;
    [self.view insertSubview:self.headerView belowSubview:self.topBarView];
    self.headerTop = [self.headerView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.headerView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.headerView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.headerView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:self.headerView withMultiplier:0.7];
    self.headerImageView = [[UIImageView alloc] initForAutoLayout];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.clipsToBounds = YES;
    [self.headerView addSubview:self.headerImageView];
    [self.headerImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.headerImageView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    self.headerImageBottom = [self.headerImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.headerImageView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    //添加毛玻璃效果
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    [self.headerImageView addSubview:effectView];
    effectView.translatesAutoresizingMaskIntoConstraints = NO;
    [effectView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initForAutoLayout];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view insertSubview:self.tableView belowSubview:self.topBarView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(TOP_TOOL_BAR_HEIGHT, 0, 0, 0) excludingEdge:ALEdgeBottom];
    [self.tableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:(UIView *)self.bottomLayoutGuide];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    [self.tableView registerClass:[LMTrackDetailCoverCell class] forCellReuseIdentifier:NSStringFromClass([LMTrackDetailCoverCell class])];
    
}


- (void)requestData
{
    [LMSongTrack getSongTrackByTrackId:self.trackId withCompletedBlock:^(LMSongTrack *track, NSError *error){
        if (!error && track) {
            self.headerView.hidden = NO;
            self.track = track;
            [self updateHeaderBackImage];
            [self.tableView reloadData];
        }else{
            self.headerView.hidden = YES;
        }
    }];
}

- (void)updateHeaderBackImage{
    [self.headerImageView setImageWithURL:[NSURL URLWithString:self.track.coverImgUrl]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return self.track.tracks.count;
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *blueView = [UIView new];
        blueView.backgroundColor = [UIColor blueColor];
        return blueView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 50;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        LMTrackDetailCoverCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LMTrackDetailCoverCell class]) forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        [cell bindModel:self.track];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
        LMSongModel *song = self.track.tracks[indexPath.item];
        cell.textLabel.text = song.name;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGRectGetHeight(self.headerView.frame) - TOP_TOOL_BAR_HEIGHT;
    }
    return 44;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <0) {
        self.headerTop.constant = 0;
        self.headerImageBottom.constant = - offsetY;
    }else{
        if (offsetY > CGRectGetHeight(self.headerView.frame) - TOP_TOOL_BAR_HEIGHT) {
            
        }else{
            self.headerTop.constant = - offsetY;
        }
    }
    
    if (offsetY > CGRectGetHeight(self.headerView.frame) * 0.5) {
        [self.topBarView setNavigateTitle:self.track.name];
    }else{
        [self.topBarView setNavigateTitle:@"歌单"];
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section > 0) {
        LMSongModel *song = self.track.tracks[indexPath.item];
        LMPlayViewController *playVc = [[LMPlayViewController alloc] init];
        playVc.song = song;
        playVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:playVc animated:YES];
    }
}

@end
