//
//  MineViewController.m
//  CommerceManage
//
//  Created by 小花 on 2016/12/26.
//  Copyright © 2016年 vaic. All rights reserved.
//

#import "MineViewController.h"
#import "LoginViewController.h"
#import "ChangeInfoViewController.h"

@interface MineViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *userBgView;
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;


@end

@implementation MineViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    self.nameLabel.text = [AccountTool account].niceName;
    self.numLabel.text = [AccountTool account].phoneNo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initSubViews];
}

- (void)initSubViews {
    
    //背景
    self.userBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, FitSize(140))];
    self.userBgView.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, screenW, screenH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.bounces = NO;
    [self.view addSubview:self.tableView];
    
    //头像
    self.iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(FitSize(30), FitSize(50), FitSize(71), FitSize(64))];
    self.iconImg.image = [UIImage imageNamed:@"personal_page_logo"];
    [self.userBgView addSubview:self.iconImg];
    
    //昵称、手机号
    CGFloat nameX = CGRectGetMaxX(self.iconImg.frame);
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameX+25, FitSize(60), 150, FitSize(20))];

    self.nameLabel.font = [UIFont systemFontOfSize:FitSize(18)];
    [self.userBgView addSubview:self.nameLabel];
    
    self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameX+25, FitSize(85), 150, 15)];
    self.numLabel.textColor = Color_RGBA(153, 153, 153, 1);
    self.numLabel.font = [UIFont systemFontOfSize:FitSize(16)];
    [self.userBgView addSubview:self.numLabel];
    
    self.tableView.tableHeaderView = self.userBgView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FitSize(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return FitSize(10);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"MineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = self.dataArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:FitSize(17)];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 3) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM", [[SDImageCache sharedImageCache] getSize]/1000.0/1000.0];
    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        ChangeInfoViewController *changeInfo = [[ChangeInfoViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:changeInfo animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    if (indexPath.row == 3) {
        [self alertView];
    }
    
    if (indexPath.row == 5) {
        [self logoutAction];
    }
    
    
}

- (void)alertView {
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清空缓存" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //清理缓存
        [[SDImageCache sharedImageCache] clearDisk];  //清楚磁盘缓存
        
        [[SDImageCache sharedImageCache] clearMemory];    //清楚内存缓存
        
        [_tableView reloadData];
        
    }];
    UIAlertAction *cancle=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:cancle];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)logoutAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否退出登录?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self deleteUserInfo];
    }];
    [alert addAction:action];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)deleteUserInfo {
    if ([AccountTool deleteAccount]) {
        [SVProgressHUD showSuccessWithStatus:@"退出成功"];
        [self logoutSuccess];
    }
}

- (void)logoutSuccess {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [window.layer addAnimation:transition forKey:nil];
    
    LoginViewController *login = [[LoginViewController alloc] init];
    window.rootViewController = login;
    
    
}



- (NSArray *)dataArr {
    
    if (!_dataArr) {
        _dataArr = @[@"账号管理", @"助理管理",@"新消息通知",@"清除缓存",@"关于",@"退出登录",];
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
