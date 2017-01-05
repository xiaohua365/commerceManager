//
//  AssociationViewController.m
//  CommerceManage
//
//  Created by 小花 on 2016/12/26.
//  Copyright © 2016年 vaic. All rights reserved.
//

#import "AssociationViewController.h"
#import "MessageTableCell.h"
#import "BusinessWKViewController.h"

@interface AssociationViewController ()<UITableViewDelegate, UITableViewDataSource> {
    NSInteger _pageNum;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

static const NSString *numPerPage = @"6";

@implementation AssociationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _pageNum = 1;
    [self.view addSubview:self.tableView];
    [self loadTableViewData];
}

- (void)loadTableViewData {
    NSString *url = [NSString stringWithFormat:@"%@%@%@", URL_IP, PROJECT_NAME, BUSINESS_LIST];
    NSDictionary *para = @{
                           @"pageNum":@(_pageNum),
                           @"numPerPage":numPerPage,
                           };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"head"][@"rspCode"] isEqualToString:@"0"]) {
            NSArray *newList = responseObject[@"body"][@"businessList"];
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



- (void)loadNewData {
    [self.dataArr removeAllObjects];
    _pageNum = 1;
    [self loadTableViewData];
    
}

- (void)loadMoreData {
    _pageNum++;
    [self loadTableViewData];
}

- (void)endRefresh {
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}




#pragma mark - tabelView Delegate & dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FitSize(180);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableCell *cell = [MessageTableCell cellWithTableView:tableView];
    if (self.dataArr.count > 0) {
        cell.model = self.dataArr[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    MessageNewsModel *model = self.dataArr[indexPath.row];
    BusinessWKViewController *detail = [[BusinessWKViewController alloc] init];
    detail.businessID = model.ID;
    
    self.navigationController.viewControllers[0].hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    self.navigationController.viewControllers[0].hidesBottomBarWhenPushed = NO;
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH-64-49-40) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadNewData];
        }];
        _tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self loadMoreData];
        }];
    }
    return _tableView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
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
