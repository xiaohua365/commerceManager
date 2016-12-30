//
//  ChangePWViewController.m
//  CommerceManage
//
//  Created by 小花 on 2016/12/28.
//  Copyright © 2016年 vaic. All rights reserved.
//

#import "ChangePWViewController.h"

@interface ChangePWViewController ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *oldLabel;
@property (nonatomic, strong) UILabel *pwLabel;
@property (nonatomic, strong) UILabel *sureLabel;

@property (nonatomic, strong) UILabel *firstLine;
@property (nonatomic, strong) UILabel *secondLine;

@property (nonatomic, strong) UITextField *oldField;
@property (nonatomic, strong) UITextField *pwField;
@property (nonatomic, strong) UITextField *sureField;

@property (nonatomic, strong) UIButton *makeButton;

@end

@implementation ChangePWViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.oldField becomeFirstResponder];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改密码";
    self.view.backgroundColor = Color_RGBA(244, 244, 244, 1);
    
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.oldLabel];
    [self.bgView addSubview:self.firstLine];
    [self.bgView addSubview:self.pwLabel];
    [self.bgView addSubview:self.secondLine];
    [self.bgView addSubview:self.sureLabel];
    [self.bgView addSubview:self.oldField];
    [self.bgView addSubview:self.pwField];
    [self.bgView addSubview:self.sureField];
    [self.view addSubview:self.makeButton];
}

- (void)changeAction:(UIButton *)sender {
    
    if (![self.pwField.text isEqualToString:self.sureField.text] || [self.pwField.text isEqualToString:@""] || [self.sureField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"密码与确认密码不一致"];
        return;
    }
    
    NSString *phone = [AccountTool account].phoneNo;
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@", URL_IP, PROJECT_NAME, USER_CHANGE_PW];
    NSDictionary *para = @{
                           @"phone":phone,
                           @"passWord":self.pwField.text,
                           @"oldPassWord":self.oldField.text
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"head"][@"rspCode"] isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:responseObject[@"head"][@"rspMsg"]];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"head"][@"rspMsg"]];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}


- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, FitSize(10), screenW, FitSize(150))];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UILabel *)oldLabel {
    if (!_oldLabel) {
        _oldLabel = [[UILabel alloc] initWithFrame:CGRectMake(FitSize(20), FitSize(15), FitSize(80), FitSize(20))];
        _oldLabel.text = @"原始密码";
        _oldLabel.font = [UIFont systemFontOfSize:FitSize(17)];
    }
    return _oldLabel;
}

- (UILabel *)pwLabel {
    if (!_pwLabel) {
        _pwLabel = [[UILabel alloc] initWithFrame:CGRectMake(FitSize(20), FitSize(65), FitSize(80), FitSize(20))];
        _pwLabel.text = @"新密码";
        _pwLabel.font = [UIFont systemFontOfSize:FitSize(17)];
    }
    return _pwLabel;
}

- (UILabel *)sureLabel {
    if (!_sureLabel) {
        _sureLabel = [[UILabel alloc] initWithFrame:CGRectMake(FitSize(20), FitSize(115), FitSize(80), FitSize(20))];
        _sureLabel.text = @"确认密码";
        _sureLabel.font = [UIFont systemFontOfSize:FitSize(17)];
    }
    return _sureLabel;
}

- (UILabel *)firstLine {
    if (!_firstLine) {
        _firstLine = [[UILabel alloc] initWithFrame:CGRectMake(0, FitSize(50), screenW, 1)];
        _firstLine.backgroundColor = Color_RGBA(244, 244, 244, 1);
    }
    return _firstLine;
}

- (UILabel *)secondLine {
    if (!_secondLine) {
        _secondLine = [[UILabel alloc] initWithFrame:CGRectMake(0,FitSize(100), screenW, 1)];
        _secondLine.backgroundColor = Color_RGBA(244, 244, 244, 1);
    }
    return _secondLine;
}

- (UITextField *)oldField {
    if (!_oldField) {
        _oldField = [[UITextField alloc] initWithFrame:CGRectMake(FitSize(100), FitSize(15), FitSize(200), FitSize(20))];
        _oldField.secureTextEntry = YES;
        
    }
    return _oldField;
}

- (UITextField *)pwField {
    if (!_pwField) {
        _pwField = [[UITextField alloc] initWithFrame:CGRectMake(FitSize(100), FitSize(65), FitSize(200), FitSize(20))];
        _pwField.secureTextEntry = YES;
    }
    return _pwField;
}

- (UITextField *)sureField {
    if (!_sureField) {
        _sureField = [[UITextField alloc] initWithFrame:CGRectMake(FitSize(100), FitSize(115), FitSize(200), FitSize(20))];
        _sureField.secureTextEntry = YES;
    }
    return _sureField;
}

- (UIButton *)makeButton {
    if (!_makeButton) {
        _makeButton = [[UIButton alloc] initWithFrame:CGRectMake(FitSize(20), FitSize(180), screenW-FitSize(40), FitSize(40))];
        [_makeButton setImage:[UIImage imageNamed:@"change_password_page_button_save"] forState:UIControlStateNormal];
        [_makeButton addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _makeButton;
    
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
