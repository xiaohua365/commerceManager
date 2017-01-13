//
//  LoginViewController.m
//  CommerceManage
//
//  Created by 小花 on 2016/12/27.
//  Copyright © 2016年 vaic. All rights reserved.
//

#import "LoginViewController.h"
#import "TabbarViewController.h"
#import<CommonCrypto/CommonDigest.h>

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *logoImg;
@property (nonatomic, strong) UILabel *phoneNum;
@property (nonatomic, strong) UILabel *passWord;
@property (nonatomic, strong) UITextField *phoneTxtField;
@property (nonatomic, strong) UITextField *pwTxtField;
@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) UILabel *firstLine;
@property (nonatomic, strong) UILabel *secondLine;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *phoneNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNum"];
    if (phoneNum != nil) {
        self.phoneTxtField.text = phoneNum;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.logoImg];
    [self.view addSubview:self.phoneNum];
    [self.view addSubview:self.passWord];
    [self.view addSubview:self.phoneTxtField];
    [self.view addSubview:self.pwTxtField];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.firstLine];
    [self.view addSubview:self.secondLine];
    
    [self makeSubViewsLayout];
}

- (void)makeSubViewsLayout {
    
    [self.logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(FitSize(105));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(FitSize(70));
        make.height.mas_equalTo(FitSize(100));
    }];
    
    [self.phoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(FitSize(275));
        make.left.mas_equalTo(FitSize(25));
        make.width.mas_equalTo(FitSize(85));
        make.height.mas_equalTo(FitSize(20));
    }];
    
    [self.phoneTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneNum.mas_right).mas_offset(FitSize(5));
        make.top.mas_equalTo(self.phoneNum.mas_top);
        make.width.mas_equalTo(FitSize(200));
        make.height.mas_equalTo(FitSize(20));
    }];
    
    [self.firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(FitSize(25));
        make.right.mas_equalTo(FitSize(-25));
        make.top.mas_equalTo(self.phoneNum.mas_bottom).mas_offset(FitSize(10));
        make.height.mas_equalTo(1);
    }];
    
    [self.passWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(FitSize(25));
        make.top.mas_equalTo(self.firstLine.mas_bottom).mas_equalTo(FitSize(15));
        make.width.mas_equalTo(FitSize(85));
        make.height.mas_equalTo(FitSize(20));
    }];
    
    [self.pwTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.passWord.mas_right).mas_offset(FitSize(5));
        make.top.mas_equalTo(self.passWord.mas_top);
        make.width.mas_equalTo(FitSize(200));
        make.height.mas_equalTo(FitSize(20));
    }];
    
    [self.secondLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(FitSize(25));
        make.right.mas_equalTo(FitSize(-25));
        make.top.mas_equalTo(self.passWord.mas_bottom).mas_offset(FitSize(10));
        make.height.mas_equalTo(1);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(FitSize(25));
        make.right.mas_equalTo(FitSize(-25));
        make.top.mas_equalTo(self.secondLine.mas_bottom).mas_equalTo(FitSize(40));
        make.height.mas_equalTo(FitSize(40));
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_phoneTxtField resignFirstResponder];
    [_pwTxtField resignFirstResponder];
}

- (void)loginAction:(UIButton *)sender {
    
    [self loginManager];
}

- (void)loginManager {
    [self showAnimation];
    NSString *url = [NSString stringWithFormat:@"%@%@%@", URL_IP, PROJECT_NAME, USER_LOGIN];
//    NSString *md5Pw = [self md5:self.pwTxtField.text];
    NSDictionary *para = @{
                           @"phone":self.phoneTxtField.text,
                           @"passWord":self.pwTxtField.text
                           };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"head"][@"rspCode"] isEqualToString:@"0"]) {
            NSDictionary *user = responseObject[@"body"][@"user"];
            [self stopAnimation];
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            [self loginSuccess];
            [self saveUserInfoWith:user];
            
        }else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"head"][@"rspMsg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
        [self stopAnimation];
    }];
    
}

- (void)saveUserInfoWith:(NSDictionary *)dic {
    
    AccountModel *account = [AccountModel mj_objectWithKeyValues:dic];
    [AccountTool saveAccount:account];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.phoneTxtField.text forKey:@"phoneNum"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)showAnimation {
    //创建UIActivityIndicatorView背底半透明View
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH)];
    [view setTag:108];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.5];
    [self.view addSubview:view];
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [_activityIndicator setCenter:view.center];
    [_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [view addSubview:_activityIndicator];
    [_activityIndicator startAnimating];
}

- (void)stopAnimation {
    [_activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
}



- (void)loginSuccess {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [window.layer addAnimation:transition forKey:nil];
    
    TabbarViewController *tabbar = [[TabbarViewController alloc] init];
    window.rootViewController = tabbar;
    
}





- (UIImageView *)logoImg {
    if (!_logoImg) {
        _logoImg = [[UIImageView alloc] init];
        _logoImg.image = [UIImage imageNamed:@"login_page_img_logo"];
    }
    return _logoImg;
}

- (UILabel *)phoneNum {
    if (!_phoneNum) {
        _phoneNum = [[UILabel alloc] init];
        _phoneNum.textColor = Color_RGBA(51, 51, 51, 1);
        _phoneNum.text = @"手机号码";
        _phoneNum.font = [UIFont systemFontOfSize:FitSize(17)];
    }
    return _phoneNum;
}

- (UILabel *)passWord {
    if (!_passWord) {
        _passWord = [[UILabel alloc] init];
        _passWord.textColor = Color_RGBA(51, 51, 51, 1);
        _passWord.text = @"密码";
        _passWord.font = [UIFont systemFontOfSize:FitSize(17)];
        
    }
    return _passWord;
}

- (UITextField *)phoneTxtField {
    if (!_phoneTxtField) {
        _phoneTxtField = [[UITextField alloc] init];
        _phoneTxtField.placeholder = @"请输入手机号";
        _phoneTxtField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTxtField.delegate = self;
        _phoneTxtField.font = [UIFont systemFontOfSize:FitSize(17)];
//        [_phoneTxtField becomeFirstResponder];
    }
    return _phoneTxtField;
}

- (UITextField *)pwTxtField {
    if (!_pwTxtField) {
        _pwTxtField = [[UITextField alloc] init];
        _pwTxtField.placeholder = @"请输入密码";
        _pwTxtField.delegate = self;
        _pwTxtField.secureTextEntry = YES;
        _pwTxtField.font = [UIFont systemFontOfSize:FitSize(17)];
    }
    return _pwTxtField;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setImage:[UIImage imageNamed:@"login_page_button_login"] forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UILabel *)firstLine {
    if (!_firstLine) {
        _firstLine = [[UILabel alloc] init];
        _firstLine.backgroundColor = Color_RGBA(204, 204, 204, 1);
    }
    return _firstLine;
}

- (UILabel *)secondLine {
    if (!_secondLine) {
        _secondLine = [[UILabel alloc] init];
        _secondLine.backgroundColor = Color_RGBA(204, 204, 204, 1);
    }
    return _secondLine;
}


- (NSString *)md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
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
