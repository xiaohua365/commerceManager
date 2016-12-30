//
//  BackBaseViewController.m
//  CommerceManage
//
//  Created by 小花 on 2016/12/30.
//  Copyright © 2016年 vaic. All rights reserved.
//

#import "BackBaseViewController.h"

@interface BackBaseViewController ()

@end

@implementation BackBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackBtn];
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

- (void)backAction:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
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
