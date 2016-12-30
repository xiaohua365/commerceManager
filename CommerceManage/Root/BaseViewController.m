//
//  BaseViewController.m
//  CommerceManage
//
//  Created by 小花 on 2016/12/26.
//  Copyright © 2016年 vaic. All rights reserved.
//

#import "BaseViewController.h"
#import "SubLBXScanViewController.h"
#import "SearchViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingNavigationBar];
}




- (void)settingNavigationBar {
    UIButton* rightBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"icon_scan"] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 22, 22);
    UIBarButtonItem* rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(RightCicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:rightBtnItem, nil] ];
    
    UIView *shareNavleftView = [[UIView alloc] init];
    shareNavleftView.frame = CGRectMake(0.0, 0.0, 40.0, 38.0);
    UIImageView *img = [[UIImageView alloc] init];
    img.image = [UIImage imageNamed:@"top_logo"];
    img.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    img.frame = shareNavleftView.frame;
    [shareNavleftView addSubview:img];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareNavleftView];
    
    
    
    UIView* titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FitSize(263), FitSize(29))];
    titleView.layer.cornerRadius = 12;
    titleView.clipsToBounds = YES;
    UIImage *image = [UIImage imageNamed:@"img_search"];
    
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:image forState:UIControlStateNormal];
    [searchBtn setImage:image forState:UIControlStateHighlighted];
    [searchBtn addTarget:self action:@selector(SearchClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:searchBtn];
    self.navigationItem.titleView = titleView;
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(titleView.mas_centerX);
        make.centerY.mas_equalTo(titleView.mas_centerY);
        make.width.mas_equalTo(FitSize(263));
        make.height.mas_equalTo(FitSize(29));
    }];
    
}


- (void)RightCicked:(UIButton *)sender {
    [self scanButtonClick];
}


- (void)SearchClick:(UIButton *)sender {
    [self searchButtonClick];
}

- (void)scanButtonClick {
    SubLBXScanViewController *vc = [SubLBXScanViewController new];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed=NO;
    NSLog(@"二维码");
}

- (void)searchButtonClick {
    
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
