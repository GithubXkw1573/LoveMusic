//
//  TestMasonryViewController.m
//  LoveMusic
//
//  Created by 许开伟 on 16/4/20.
//  Copyright © 2016年 kevin xu. All rights reserved.
//

#import "TestMasonryViewController.h"
#import "TestMasonryCell.h"

@interface TestMasonryViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TestMasonryCell *shardUtilCell;
@property (nonatomic, strong) NSMutableDictionary *cellHeightDictionary;
@end

@implementation TestMasonryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeData];
    [self setNavBarApperance];
    [self loadTableView];
}

- (void)makeData
{
    NSDictionary *data1 = @{@"name":@"临风之情",
                            @"subtitle":@"今天天气好好啊！",
                            @"image":@"http://pic24.nipic.com/20121022/1417516_151626862000_2.jpg"};
    
    NSDictionary *data2 = @{@"name":@"清风徐来到你身边",
                            @"subtitle":@"今天天气好好啊！今天天气好好啊！今天天气好好啊！今天天气好好啊！今天天气好好啊！今天天气好好啊！",
                            @"image":@"http://img3.doubanio.com/view/commodity_review/large/public/p200907257.jpg"};
    
    NSDictionary *data3 = @{@"name":@"Leon",
                            @"subtitle":@"今天天气好好啊！今天天气好好啊！今天天气好好啊！今天天气好好啊！今天天气好好啊！今天天气好好啊！今天天气好好啊！今天天气好好啊！今天天气好好啊！今天天气好好啊！今天天气好好啊！今天天气好好啊！",
                            @"image":@"http://pic26.nipic.com/20130114/9252150_140310235330_2.jpg"};
    
    self.data = @[data1,data2,data3];
}

- (void)setNavBarApperance
{
    [self.topBarView setTopBarStyle:LMTopBarStyleTitleWithBackButton];
    [self.topBarView setNavigateTitle:@"Masonry Test"];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)loadTableView
{
    WeakSelf(ws);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.left.and.right.and.bottom.equalTo(ws.view);
        maker.top.equalTo(ws.view).with.offset(TOP_TOOL_BAR_HEIGHT);
    }];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        //设置预估cell高度,避免cell每次都把所有的cell都计算一边
        _tableView.estimatedRowHeight = 100;
        [_tableView registerClass:[TestMasonryCell class] forCellReuseIdentifier:NSStringFromClass([TestMasonryCell class])];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TestMasonryCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TestMasonryCell class]) forIndexPath:indexPath];
    [cell bindData:self.data[indexPath.row % 3]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //先取缓存高度
    NSNumber *cellHeight = self.cellHeightDictionary[indexPath];
    if ([cellHeight floatValue]) {
        return [cellHeight floatValue];
    }
    [self.shardUtilCell bindData:self.data[indexPath.row % 3]];
    CGFloat calHeight = [self.shardUtilCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1.f;
    self.cellHeightDictionary[indexPath] = [NSNumber numberWithFloat:calHeight];
    return calHeight;
}

/**
 *  @author Kevin  Xu, 16-04-21 14:04:51
 *
 *  @brief 这个cell不显示，用来系统计算cell高度的
 *
 *  @return util cell
 *
 *  @since <#1.0#>
 */
- (TestMasonryCell *)shardUtilCell
{
    if (!_shardUtilCell) {
        _shardUtilCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TestMasonryCell class])];
    }
    return _shardUtilCell;
}

- (NSMutableDictionary *)cellHeightDictionary
{
    if (!_cellHeightDictionary) {
        _cellHeightDictionary = [NSMutableDictionary dictionary];
    }
    return _cellHeightDictionary;
}



@end
