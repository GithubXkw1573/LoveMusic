//
//  HomeViewController.m
//  LoveMusic
//
//  Created by kevin xu on 16/1/6.
//  Copyright © 2016年 kevin xu. All rights reserved.
//
typedef NS_ENUM(NSInteger, HomeSectionType) {
    HomeSectionTypeTopList,//官方榜
    HomeSectionTypePlayList,//推荐歌单
    HomeSectionTypeAlbumList,//最新专辑
    HomeSectionTypeCount //section 个数
};

#import "HomeViewController.h"

#import "LMHomeModel.h"
#import "LMHomePlaySheetCell.h"
#import "LMHomeCollectHeadView.h"
#import "LMHomeTopEntrenceCell.h"

#import "TrackDetailController.h"
#import "TestMasonryViewController.h"

#import "KWDownloader.h"

@interface HomeViewController ()<UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UICollectionView *homeCollectionView;
@property (nonatomic, strong) LMHomeModel *homeModel;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self intTopBarView];
    
    [self initHomeCollectionView];
    
    [self requestHomeData];
    
    
//    NSString *testUrlStr = @"http://114.215.204.97:29102/api/file/download/2016/3/5/14/d7ee9775-368a-4708-9e84-8c10cc8ec559";
//    NSURL *testUrl = [NSURL URLWithString:testUrlStr];
//    
//    [[KWDownloader sharedownlader] downloadFileWithUrlString:testUrl];
    
//    [self showLoadingView];
    
}

- (void)intTopBarView{
    [self.topBarView setTopBarStyle:LMTopBarStylePlayButton];
    [self initSearchBar];
    [self initSearchCancelButton];
}

- (void)initSearchBar
{
    self.searchBar = [[UISearchBar alloc] initForAutoLayout];
    [self setSearchBarBackgroundClearColor];
    _searchBar.delegate = self;
    [self.topBarView addSubview:_searchBar];
    _searchBar.placeholder = @"发现好音乐";
    [_searchBar autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(20, 60, 0, 60)];
}

- (void)setSearchBarBackgroundClearColor
{
    UIView *textFieldSuperView = [self.searchBar.subviews firstObject];
    if (textFieldSuperView) {
        [[[textFieldSuperView subviews] firstObject] removeFromSuperview];
    }
    [self.searchBar setBackgroundColor:[UIColor clearColor]];
}

- (void)initSearchCancelButton
{
    self.cancelButton = [UIButton newAutoLayoutView];
    [self.topBarView addSubview:self.cancelButton];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.cancelButton addTarget:self action:@selector(searchCanced) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton.hidden = YES;
    [self.cancelButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [self.cancelButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.searchBar];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.topBarView hidePlayBtn];
    self.cancelButton.hidden = NO;
}

- (void)searchCanced
{
    [self.topBarView showPlayBtn];
    self.cancelButton.hidden = YES;
    [self.searchBar resignFirstResponder];
}

- (void)initHomeCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.homeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.homeCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.homeCollectionView.alwaysBounceVertical = YES;
    [self.view insertSubview:self.homeCollectionView belowSubview:self.topBarView];
    [self.homeCollectionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.homeCollectionView.contentInset = UIEdgeInsetsMake(TOP_TOOL_BAR_HEIGHT, 0, 0, 0);
    self.homeCollectionView.backgroundColor = [UIColor whiteColor];
    self.homeCollectionView.dataSource = self;
    self.homeCollectionView.delegate = self;
    
    
    [self.homeCollectionView registerClass:[LMHomePlaySheetCell class] forCellWithReuseIdentifier:NSStringFromClass([LMHomePlaySheetCell class])];
    
    [self.homeCollectionView registerClass:[LMHomeTopEntrenceCell class] forCellWithReuseIdentifier:NSStringFromClass([LMHomeTopEntrenceCell class])];
    
    [self.homeCollectionView registerClass:[LMHomeCollectHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([LMHomeCollectHeadView class])];
}

- (void)requestHomeData
{
    [LMHomeModel getHomeDataWithCompletedBlock:^(LMHomeModel *model, NSError *error){
        
        if (!error) {
            self.homeModel = model;
            [self.homeCollectionView reloadData];
        }
    }];
}

#pragma mark - uicollectionView dataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return HomeSectionTypeCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case HomeSectionTypeTopList:
            return 3;
            break;
        case HomeSectionTypePlayList:
            return self.homeModel.playSheetList.count;
            break;
        case HomeSectionTypeAlbumList:
            return self.homeModel.albumList.count;
            break;
        default:
            break;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case HomeSectionTypeTopList:
        {
            LMHomeTopEntrenceCell *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LMHomeTopEntrenceCell class]) forIndexPath:indexPath];
            NSArray *idArray = @[@(self.homeModel.newTopListId),@(self.homeModel.hotTopListId),@(self.homeModel.soarTopListId)];
            [itemCell bindTopType:indexPath.item idValue:[idArray[indexPath.item] integerValue]];
            return itemCell;
        }
            break;
        case HomeSectionTypePlayList:
        {
            LMHomePlaySheetCell *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LMHomePlaySheetCell class]) forIndexPath:indexPath];
            LMPlayList *sheet = self.homeModel.playSheetList[indexPath.item];
            [itemCell bindSheetModel:sheet];
            return itemCell;
        }
            break;
        case HomeSectionTypeAlbumList:
        {
            LMHomePlaySheetCell *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LMHomePlaySheetCell class]) forIndexPath:indexPath];
            LMZAlbum *album = self.homeModel.albumList[indexPath.item];
            [itemCell bindAlbumModel:album];
            return itemCell;
        }
            break;
        default:
            break;
    }
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSArray *titleArray = @[@"官方榜",@"推荐歌单",@"最新专辑"];
    LMHomeCollectHeadView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([LMHomeCollectHeadView class]) forIndexPath:indexPath];
    [headView bindTitle:titleArray[section]];
    return headView;
}

#pragma mark - uicollectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case HomeSectionTypeTopList:
        {
            NSArray *idArray = @[@(self.homeModel.newTopListId),@(self.homeModel.hotTopListId),@(self.homeModel.soarTopListId)];
            [self jumpToTrackDetailControllerWithTrackId:[idArray[indexPath.item] integerValue]];
        }
            break;
        case HomeSectionTypePlayList:
        {
            LMPlayList *playlist = self.homeModel.playSheetList[indexPath.item];
            [self jumpToTrackDetailControllerWithTrackId:playlist.id];
        }
            break;
        case HomeSectionTypeAlbumList:
        {
            LMZAlbum *album = self.homeModel.albumList[indexPath.item];
//            [self jumpToTrackDetailControllerWithTrackId:album.id];
            TestMasonryViewController *masCt = [TestMasonryViewController new];
            masCt.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:masCt animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - uicollectionFlowlayout delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case HomeSectionTypeTopList:
            return CGSizeMake(SCREEN_WIDTH/3, SCREEN_WIDTH/3);
            break;
        case HomeSectionTypePlayList:
        case HomeSectionTypeAlbumList:
        {
            CGFloat width = (SCREEN_WIDTH - 2*10 - 2*8)/3;
            return CGSizeMake(width, width + UNIVERSAL_HEIGHT(48));
        }
            break;
        default:
            break;
    }
    return CGSizeZero;
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    switch (section) {
        case HomeSectionTypeTopList:
            return UIEdgeInsetsZero;
            break;
        case HomeSectionTypePlayList:
        case HomeSectionTypeAlbumList:
        {
            return UIEdgeInsetsMake(5, 10, 10, 10);
        }
            break;
        default:
            break;
    }
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, UNIVERSAL_HEIGHT(32));
}

- (void)jumpToTrackDetailControllerWithTrackId:(NSInteger)trackId
{
    TrackDetailController *track = [TrackDetailController new];
    track.trackId = trackId;
    track.hidesBottomBarWhenPushed = NO;
    [self.navigationController pushViewController:track animated:YES];
}

@end
