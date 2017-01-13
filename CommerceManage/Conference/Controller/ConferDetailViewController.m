//
//  ConferDetailViewController.m
//  CommerceManage
//
//  Created by 小花 on 2017/1/10.
//  Copyright © 2017年 vaic. All rights reserved.
//

#import "ConferDetailViewController.h"

@interface ConferDetailViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *meetTitle;
@property (nonatomic, strong) UILabel *creatTime;
@property (nonatomic, strong) UILabel *conveneTime;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UIButton *joinBtn;

@end

static CGFloat marginHeigh = 15;
@implementation ConferDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = GRAY_COLOR;
    self.title = @"会议详情";
    
    [self makeSubViewLayout];
}

- (void)makeSubViewLayout {
    
    //scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    //标题
    self.meetTitle = [[UILabel alloc]  initWithFrame:CGRectMake(FitSize(10), marginHeigh, screenW-FitSize(10), 20)];
    self.meetTitle.text = self.conferModel.meetingName;
    self.meetTitle.textAlignment = NSTextAlignmentLeft;
//    self.meetTitle.textColor = APP_THEME_COLOR;
//    self.meetTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:FitSize(18)];
    self.meetTitle.font = [UIFont systemFontOfSize:FitSize(18)];
    [self.scrollView addSubview:self.meetTitle];
    
    //召开时间
    self.conveneTime = [[UILabel alloc] initWithFrame:CGRectMake(FitSize(10), CGRectGetMaxY(self.meetTitle.frame)+25, screenW-FitSize(20), 20)];
    NSString *time = [PublicFunction getDateWith:self.conferModel.meetingTime];
    self.conveneTime.text = [NSString stringWithFormat:@"召开时间:%@        参会地点:%@", time, self.conferModel.meetingLoc];
    self.conveneTime.textAlignment = NSTextAlignmentLeft;
    self.conveneTime.font = [UIFont systemFontOfSize:FitSize(15)];
    self.conveneTime.textColor = Black_COLOR;
    [self.scrollView addSubview:self.conveneTime];
    
    //发布时间
    self.creatTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.conveneTime.frame), CGRectGetMaxY(self.conveneTime.frame)+15, screenW-FitSize(20), 20)];
    NSString *creatTime = [PublicFunction getDateWith:self.conferModel.ctime];
    self.creatTime.text = [NSString stringWithFormat:@"发布时间:%@        来源:工商联", creatTime];
    self.creatTime.font = [UIFont systemFontOfSize:FitSize(15)];
    self.creatTime.textColor = Black_COLOR;
    self.creatTime.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:self.creatTime];
    
    //分割线
    self.line = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.creatTime.frame)+marginHeigh, screenW-20, 0.8)];
    self.line.backgroundColor = Color_RGBA(181, 180, 180, 1);
    [self.scrollView addSubview:self.line];
    
    //会议内容
    NSString *text = self.conferModel.meetingContent;
    CGSize size = [PublicFunction getAutoWidthWith:text andSize:CGSizeMake(screenW-FitSize(30), MAXFLOAT) andFont:FitSize(17)];
    self.content = [[UILabel alloc] initWithFrame:CGRectMake(FitSize(15), CGRectGetMaxY(self.creatTime.frame)+marginHeigh+30, screenW-FitSize(15)*2, size.height+30)];
    self.content.font = [UIFont systemFontOfSize:FitSize(16)];
    self.content.numberOfLines = 0;
    self.content.text = [NSString stringWithFormat:@"      %@", text];
    [self.scrollView addSubview:self.content];
    
    //报名按钮
    self.joinBtn = [[UIButton alloc] initWithFrame:CGRectMake((screenW-80)/2, CGRectGetMaxY(self.content.frame)+FitSize(50), 80, 35)];
    [self.joinBtn setImage:[UIImage imageNamed:@"button_part"] forState:UIControlStateNormal];
    [self.joinBtn setImage:[UIImage imageNamed:@"button_parted"] forState:UIControlStateSelected];
    if ([self.conferModel.joinType isEqualToString:@"1"]) {
        self.joinBtn.selected = YES;
    }else{
        self.joinBtn.selected = NO;
    }
    if ([self.conferModel.checkType isEqualToString:@"1"]) {
        [self.joinBtn setImage:[UIImage imageNamed:@"button_checked_in"] forState:UIControlStateSelected];
    }
    [self.joinBtn addTarget:self action:@selector(joinAction:) forControlEvents:UIControlEventTouchUpInside];
    self.joinBtn.layer.cornerRadius = 5;
    [self.scrollView addSubview:self.joinBtn];
    
    self.scrollView.contentSize = CGSizeMake(screenW, CGRectGetMaxY(self.joinBtn.frame)+FitSize(100));
    
}



- (void)joinAction:(UIButton *)sender {
    
    [self joinInWith:self.conferModel.ID andButton:sender];
    
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
