//
//  NewsResultController.m
//  CommerceManage
//
//  Created by 小花 on 2016/12/29.
//  Copyright © 2016年 vaic. All rights reserved.
//

#import "NewsResultController.h"
#import "MessageNewsModel.h"
#import "MessageTableCell.h"
#import "NewsWKViewController.h"
#import "BusinessWKViewController.h"


typedef enum : NSUInteger {
    newsSearch,
    businessSearch
} searchType;

static const NSString *pageNum = @"1";
static const NSString *numPerPage = @"100";

@interface NewsResultController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, assign) searchType searchType;
@end

@implementation NewsResultController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    self.searchType = [CommonTool shareInstance].segmentType==0 ? newsSearch:businessSearch;
    self.title = [CommonTool shareInstance].segmentType==0 ?@"新闻搜索结果":@"商业搜索结果";
    
    [self setBackBtn];
    [self searchManager];
}

- (void)setBackBtn {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIButton *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [returnBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:returnBtn];
    
    [returnBtn setImage:[UIImage imageNamed:@"page_icon_arrow_back"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    
    self.navigationItem.leftBarButtonItem = leftBtn;
}

- (void)backAction:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}



- (void)searchManager {
    NSString *url;
    NSDictionary *para = @{@"pageNum":pageNum,
                         @"numPerPage":numPerPage,
                         @"title":self.searchStr};
    switch (self.searchType) {
        case newsSearch:
            url = [NSString stringWithFormat:@"%@%@%@", URL_IP, PROJECT_NAME,GENERAL_NEWS];
            break;
        case businessSearch:
            url = [NSString stringWithFormat:@"%@%@%@", URL_IP, PROJECT_NAME,BUSINESS_LIST];
            break;
        default:
            url = [NSString stringWithFormat:@"%@%@%@", URL_IP, PROJECT_NAME,GENERAL_NEWS];

            break;
    }
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager POST:url parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"head"][@"rspCode"] isEqualToString:@"0"]) {
            NSArray *array;
            if (self.searchType == newsSearch) {
                array = responseObject[@"body"][@"newsList"];
            }else {
                array = responseObject[@"body"][@"businessList"];
            }
            
            for (NSDictionary *dic in array) {
                MessageNewsModel *model = [MessageNewsModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            
            [self.tableView reloadData];
        }else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"head"][@"rspMsg"]];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"搜索失败"];
    }];
    
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FitSize(105);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
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
    
    if (self.searchType == newsSearch) {
        NewsWKViewController *news = [[NewsWKViewController alloc] init];
        news.newsID = model.ID;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:news animated:YES];
    }
    
    if (self.searchType == businessSearch) {
        BusinessWKViewController *business = [[BusinessWKViewController alloc] init];
        business.businessID = model.ID;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:business animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH) style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
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
