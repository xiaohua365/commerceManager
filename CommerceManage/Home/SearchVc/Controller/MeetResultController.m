//
//  MeetResultController.m
//  CommerceManage
//
//  Created by 小花 on 2016/12/29.
//  Copyright © 2016年 vaic. All rights reserved.
//

#import "MeetResultController.h"
#import "ConferenceCell.h"
#import "ConferDetailViewController.h"

static const NSString *numPerPage = @"100";
@interface MeetResultController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation MeetResultController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会议搜索结果";
    _pageNum = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self setBackBtn];
//    [self searchManager];
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

- (void)refreshData {
    [self.dataArr removeAllObjects];
    [self.tableView reloadData];
    [self searchManager];
}

- (void)searchManager {
    
    NSString *userID = [AccountTool account].userID;
    NSString *url = [NSString stringWithFormat:@"%@%@%@", URL_IP, PROJECT_NAME, MEETING_LIST];
    NSDictionary *para = @{@"pageNum":@(_pageNum),
                           @"numPerPage":numPerPage,
                           @"userId":userID,
                           @"meetingName":_searchStr
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"head"][@"rspCode"] isEqualToString:@"0"]) {
            
            NSArray *array = responseObject[@"body"][@"meetingList"];
            for (NSDictionary *dic in array) {
                ConferenceModel *model = [ConferenceModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            
            [self.tableView reloadData];
        }else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"head"][@"rspMsg"]];
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
    
    
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
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
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
    
    ConferDetailViewController *detail = [[ConferDetailViewController alloc] init];
    detail.conferModel = self.dataArr[indexPath.row];
    
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH) style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
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
