//
//  TabbarViewController.m
//  CommerceManage
//
//  Created by 小花 on 2016/12/26.
//  Copyright © 2016年 vaic. All rights reserved.
//

#import "TabbarViewController.h"
#import "NavViewController.h"
#import "HomeViewController.h"
#import "ConferenceViewController.h"
#import "AddressViewController.h"
#import "MineViewController.h"
#import "FlowerViewController.h"

@interface TabbarViewController ()

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    self.tabBar.barTintColor = [UIColor whiteColor];
//    self.tabBar.tintColor = [UIColor greenColor];
    self.tabBar.translucent = NO;
    
    [self addChildViewControllers];
    
}

- (void)addChildViewControllers{
    
    
    [self addChildViewController:[[HomeViewController alloc]init] andTitle:@"首页" andImageName:@"tab_home_nor" andSelectedImageName:@"tab_home"];
    [self addChildViewController:[[ConferenceViewController alloc]init] andTitle:@"会务" andImageName:@"tab_business_nor" andSelectedImageName:@"tab_business"];
    [self addChildViewController:[[FlowerViewController alloc] init] andTitle:@"万花筒" andImageName:@"tab_wan_nor" andSelectedImageName:@"tab_wan"];
    [self addChildViewController:[[AddressViewController alloc]init] andTitle:@"专家" andImageName:@"tab_financial_nor" andSelectedImageName:@"tab_financial"];
    [self addChildViewController:[[MineViewController alloc]init] andTitle:@"我的" andImageName:@"tab_mine_nor" andSelectedImageName:@"tab_mine"];
    
}


- (void)addChildViewController:(UIViewController *)VC andTitle:(NSString *)title andImageName:(NSString *)imageName andSelectedImageName:(NSString *)SelectedimageName{
    
    VC.title=title;
    VC.tabBarItem.image=[[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    VC.tabBarItem.selectedImage=[[UIImage imageNamed:[NSString stringWithFormat:@"%@",SelectedimageName]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    self.tabBar.tintColor=[UIColor colorWithRed:13/255.0 green:184/255.0 blue:246/255.0 alpha:1];
    
    NavViewController *nav=[[NavViewController alloc]initWithRootViewController:VC];
    
    
    [self addChildViewController:nav];
    
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
