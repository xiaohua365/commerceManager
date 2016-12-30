//
//  AreaViewController.m
//  CommerceManage
//
//  Created by 小花 on 2016/12/29.
//  Copyright © 2016年 vaic. All rights reserved.
//

#import "AreaViewController.h"

@interface AreaViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *taleView;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation AreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"切换地区";
    [self.view addSubview:self.taleView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FitSize(50);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.dataArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:FitSize(17)];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *message = [NSString stringWithFormat:@"是否要切换到%@？", self.dataArr[indexPath.row]];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *text = [NSString stringWithFormat:@"您已切换到%@", self.dataArr[indexPath.row]];
        [SVProgressHUD showSuccessWithStatus:text];
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:action];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (UITableView *)taleView {
    if (!_taleView) {
        _taleView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH-64) style:UITableViewStylePlain];
        _taleView.delegate = self;
        _taleView.dataSource = self;
        _taleView.showsVerticalScrollIndicator = NO;
    }
    return _taleView;
}

- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = @[@"市工商联",@"东城区",@"朝阳区",@"西城区",@"海淀区",@"丰台区",@"门头沟区",@"石景山区",@"房山区",@"通州区",@"顺义区",@"昌平区",@"大兴区",@"怀柔区",@"平谷区",@"延庆区",@"密云区"];
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
