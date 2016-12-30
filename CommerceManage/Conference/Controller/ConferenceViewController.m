//
//  ConferenceViewController.m
//  CommerceManage
//
//  Created by 小花 on 2016/12/26.
//  Copyright © 2016年 vaic. All rights reserved.
//

#import "ConferenceViewController.h"
#import "ConferenceCell.h"
#import "NewsDetailViewController.h"
#import "SearchViewController.h"
#import "ConferenceModel.h"

static const NSString *numPerPage = @"6";
@interface ConferenceViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger pageNum;
@end

@implementation ConferenceViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadNewData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageNum = 1;
    [self.view addSubview:self.tableView];
    
}

#pragma mark - Load New Data
- (void)loadNewData {
    
    [self.dataArr removeAllObjects];
    self.pageNum = 1;
    
    [self loadTableViewData];
    
}

- (void)loadMoreData {
    
    self.pageNum++;
    
    [self loadTableViewData];
    
}
- (void)loadTableViewData {
    
    NSString *userID = [AccountTool account].userID;
    NSString *url = [NSString stringWithFormat:@"%@%@%@", URL_IP, PROJECT_NAME, MEETING_LIST];
    NSDictionary *para = @{@"pageNum":@(_pageNum),
                           @"numPerPage":numPerPage,
                           @"userId":userID
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"head"][@"rspCode"] isEqualToString:@"0"]) {
            
            NSArray *array = responseObject[@"body"][@"meetingList"];
            for (NSDictionary *dic in array) {
                ConferenceModel *model = [ConferenceModel mj_objectWithKeyValues:dic];
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


- (void)joinInWith:(NSString *)ID andButton:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    
    NSString *message = @"是否参加此会议？";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self joinManagerWith:ID andBtn:sender];
    }];
    [alert addAction:action];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)joinManagerWith:(NSString *)ID andBtn:(UIButton *)sender {
    
    NSString *userID = [AccountTool account].userID;
    NSString *url = [NSString stringWithFormat:@"%@%@%@", URL_IP, PROJECT_NAME, MEETING_CHANGE_JOIN];
    NSDictionary *para = @{@"userId":userID,
                           @"meetingId":ID,
                           @"joinType":@"1"
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"head"][@"rspCode"] isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:responseObject[@"head"][@"rspMsg"]];
            sender.selected = YES;
        }else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"head"][@"rspMsg"]];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
    
}



#pragma mark - tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FitSize(105);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConferenceCell *cell = [ConferenceCell cellWithTableView:tableView];
    
    if (self.dataArr.count > 0) {
        ConferenceModel *model = self.dataArr[indexPath.row];
        cell.model = model;
        cell.joinBlock = ^(UIButton *sender){
            [self joinInWith:model.ID andButton:sender];
        };
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
//    NewsDetailViewController *news = [[NewsDetailViewController alloc] init];
//    
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:news animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH-64-49) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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


#pragma mark - 重写父类的搜索方法,跳转到会议搜索
- (void)searchButtonClick {
    
    SearchViewController *search = [[SearchViewController alloc] init];
    search.searchVcType = meettingTypy;
    
    [self.navigationController pushViewController:search animated:NO];
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
