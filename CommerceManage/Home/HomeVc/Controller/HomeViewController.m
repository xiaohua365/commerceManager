//
//  HomeViewController.m
//  CommerceManage
//
//  Created by 小花 on 2016/12/26.
//  Copyright © 2016年 vaic. All rights reserved.
//

#import "HomeViewController.h"
#import "MessageViewController.h"
#import "AssociationViewController.h"
#import "SearchViewController.h"
#import "AreaViewController.h"

@interface HomeViewController ()<LPPageVCDataSource, LPPageVCDelegate>
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *vcArray;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
    
    
}



#pragma mark - HZPageVcDataSource & Delegate
- (NSInteger)numberOfContentForPageVC:(LPPageVC *)pageVC {
    
    return self.titleArray.count;
}

- (NSString *)pageVC:(LPPageVC *)pageVC titleAtIndex:(NSInteger)index {
    
    return self.titleArray[index];
}

- (UIViewController *)pageVC:(LPPageVC *)pageVC viewControllerAtIndex:(NSInteger)index {
    
    if (index < self.vcArray.count) {
        
        return self.vcArray[index];
    }else {
        UIViewController * vc = [[UIViewController alloc] init];
        return vc;
    }
}

- (void)pageVC:(LPPageVC *)pageVC didChangeToIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex {
    
    //    NSLog(@"LPPageVC - index %ld - fromIndex %ld",(long)toIndex,(long)fromIndex);
}

- (void)pageVC:(LPPageVC *)pageVC didClickEditMode:(LPPageVCEditMode)mode {
    
    AreaViewController *area = [[AreaViewController alloc] init];
   
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:area animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}


#pragma mark - getter
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"新闻   简讯", @"商情   资讯"];
    }
    return _titleArray;
}

- (NSArray *)vcArray {
    if (!_vcArray) {
        MessageViewController *message = [[MessageViewController alloc] init];
        AssociationViewController *association = [[AssociationViewController alloc] init];
        _vcArray = @[message, association];
    }
    return _vcArray;
}


#pragma mark - 重写父类搜索 
- (void)searchButtonClick {
    
    SearchViewController *search = [[SearchViewController alloc] init];
    if ([CommonTool shareInstance].segmentType == 0) {
        search.searchVcType = newsType;
    }else {
        search.searchVcType = businessType;
    }
    
    [self.navigationController pushViewController:search animated:NO];
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
