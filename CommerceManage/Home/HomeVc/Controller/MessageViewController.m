//
//  MessageViewController.m
//  CommerceManage
//
//  Created by 小花 on 2016/12/26.
//  Copyright © 2016年 vaic. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableCell.h"
#import "WeatherView.h"
#import "TableHeaderView.h"
#import "BannerModel.h"
#import "MessageNewsModel.h"
#import "NewsWKViewController.h"
#import "WeatherModel.h"
#import "SDCycleScrollView.h"

static const NSString *numPerPage = @"6";

@interface MessageViewController ()<UITableViewDelegate, UITableViewDataSource,SDCycleScrollViewDelegate> {
    UIView *_headerView;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <MessageNewsModel *>*dataArr;
@property (nonatomic, strong) NSMutableArray <BannerModel *>*bannerData;

@property (nonatomic, strong) NSMutableArray *bananerImgs;
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) NSMutableArray *catoryArr;
@property (nonatomic, strong) WeatherView *weatherView;
@property (nonatomic, strong) WeatherModel *weatherModel;
@property (nonatomic, strong) SDCycleScrollView *CycleView;
@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageNum = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    _weatherView = [[WeatherView alloc] initWithFrame:CGRectMake(0, 0, screenW, FitSize(56))];
    [self loadBannerData];
    [self loadWeatherData];
    [self loadTableViewData];
}

- (void)loadBannerData {
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@", URL_IP, PROJECT_NAME, BANNER_NEWS];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"head"][@"rspCode"] isEqualToString:@"0"]) {
            NSArray *bannerList = responseObject[@"body"][@"newsBannerList"];
            NSLog(@"%@", bannerList);
            for (NSDictionary *dic in bannerList) {
                BannerModel *model = [BannerModel mj_objectWithKeyValues:dic];
                [self.bannerData addObject:model];
            }
            [self initBannerView];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
        [self endRefresh];
    }];
    
    
}

- (void)loadWeatherData {
    NSString *url = [NSString stringWithFormat:@"%@%@%@", URL_IP, PROJECT_NAME, WEATHER];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"head"][@"rspCode"] isEqualToString:@"0"]) {
            NSDictionary *dic = responseObject[@"body"][@"weather"];
            WeatherModel *model = [WeatherModel mj_objectWithKeyValues:dic];
            model.carNoLimit = responseObject[@"body"][@"carNoLimit"];
            self.weatherModel = model;
            _weatherView.model = model;
        }else {
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}



- (void)initBannerView {
    
    
    
    CGFloat bannerY = CGRectGetHeight(_weatherView.frame);
    
    if (self.bannerData.count > 0) {
    
        [self.titleArr removeAllObjects];
        [self.bananerImgs removeAllObjects];
        [self.catoryArr removeAllObjects];
        
        for (BannerModel *model in self.bannerData) {
            [self.titleArr addObject:model.title];
            [self.bananerImgs addObject:[NSString stringWithFormat:@"%@%@", URL_IP_IMG,model.fmImg]];
            
            NSString *catory = [NSString stringWithFormat:@"%@ %@", @"工商联", [PublicFunction getDateWith:model.ctime]];
            [self.catoryArr addObject:catory];
        }
        
        if (self.titleArr.count < 2) {
            [self.titleArr addObject:@"工商联"];
        }
        self.CycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, bannerY, screenW, FitSize(180)) delegate:self placeholderImage:[UIImage imageNamed:@"top_logo"]];
        self.CycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        self.CycleView.titlesGroup = self.titleArr;
        self.CycleView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        self.CycleView.imageURLStringsGroup = self.bananerImgs;
    }
    
    CGFloat focusY = CGRectGetHeight(self.CycleView.frame);
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, bannerY + focusY)];
    
    [_headerView addSubview:self.weatherView];
    if (self.bannerData.count > 0) {
        [_headerView addSubview:self.CycleView];
    }
    
    
    self.tableView.tableHeaderView = _headerView;
    
}

- (void)loadTableViewData {
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@", URL_IP, PROJECT_NAME, GENERAL_NEWS];
    NSDictionary *para = @{
                           @"pageNum":@(_pageNum),
                           @"numPerPage":numPerPage,
                           };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"head"][@"rspCode"] isEqualToString:@"0"]) {
            NSArray *newList = responseObject[@"body"][@"newsList"];
            for (NSDictionary *dic in newList) {
                MessageNewsModel *model = [MessageNewsModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            
            if ([self.tableView.header isRefreshing]) {
                [SVProgressHUD showSuccessWithStatus:@"刷新成功"];
            }
            
            [self.tableView reloadData];
            
        }else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"head"][@"rspMsg"]];
        }
        
        [self endRefresh];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
        [self endRefresh];
    }];
}


- (void)endRefresh {
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}


#pragma mark - Load New Data
- (void)loadNewData {
    
    [self.dataArr removeAllObjects];
    [self.bannerData removeAllObjects];
    self.pageNum = 1;
    
    [self loadBannerData];
    [self loadWeatherData];
    [self loadTableViewData];
    
}

- (void)loadMoreData {
    
    self.pageNum++;
    
    [self loadTableViewData];
    
}




#pragma mark - tableView Delegate & dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return FitSize(105);

    }else {
        return 100;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        MessageTableCell *cell = [MessageTableCell cellWithTableView:tableView];
        if (self.dataArr.count > 0 ) {
            cell.model = self.dataArr[indexPath.row];
        }
        return cell;
        
    }else {
        return nil;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    TableHeaderView *header = [[TableHeaderView alloc] initWithFrame:CGRectMake(0, 0, screenW, FitSize(100))];
    header.title = @"最新讯息";
    
    return header;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return FitSize(50);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsWKViewController *detail = [[NewsWKViewController alloc] init];
    MessageNewsModel *model = self.dataArr[indexPath.row];
    detail.newsID = model.ID;
    
    self.navigationController.viewControllers[0].hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    self.navigationController.viewControllers[0].hidesBottomBarWhenPushed = NO;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NewsWKViewController *detail = [[NewsWKViewController alloc] init];
    BannerModel *model = self.bannerData[index];
    detail.newsID = model.ID;
    
    self.navigationController.viewControllers[0].hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    self.navigationController.viewControllers[0].hidesBottomBarWhenPushed = NO;
}


#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH-64-49-40) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.backgroundView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadNewData];
        }];
        _tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self loadMoreData];
        }];
        
    }
    return _tableView;
}


- (NSMutableArray<MessageNewsModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableArray *)bananerImgs {
    if (!_bananerImgs) {
        _bananerImgs = [NSMutableArray array];
    }
    return _bananerImgs;
}

- (NSMutableArray *)titleArr {
    if (!_titleArr) {
        _titleArr = [NSMutableArray array];
    }
    return _titleArr;
}

                          
- (NSMutableArray *)catoryArr {
    if (!_catoryArr) {
        _catoryArr = [NSMutableArray array];
    }
    return _catoryArr;
}


- (NSMutableArray<BannerModel *> *)bannerData {
    if (!_bannerData) {
        _bannerData = [NSMutableArray array];
    }
    return _bannerData;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
