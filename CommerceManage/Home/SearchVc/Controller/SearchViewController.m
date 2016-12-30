//
//  SearchViewController.m
//  WoVideo
//
//  Created by haizi on 16/6/29.
//  Copyright © 2016年 hexin. All rights reserved.
//

#import "SearchViewController.h"
#import "UIImageView+WebCache.h"
#import "NewsResultController.h"
#import "CommonTool.h"
#import "MeetResultController.h"



@interface SearchViewController ()<UISearchBarDelegate, CAAnimationDelegate>
{
    UITableView *_tableView;
    UISearchBar * searchbar;
    NSString *fileName;
    NSMutableDictionary *ClassDic;
    NSMutableArray *Search_array;
    NSMutableArray *array;
    UILabel *_sepLine;
    
//    SearchModel *search_model;
}
@end

@implementation SearchViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:TRUE animated:NO];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationItem setHidesBackButton:NO animated:NO];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = Color_RGBA(244, 244, 244, 1);
    
#if 0
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImgView.image = [UIImage imageNamed:@"search_cc.jpg"];
    bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    bgImgView.userInteractionEnabled = YES;
    [self.view addSubview:bgImgView];
    
    
    // 毛玻璃效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = self.view.frame;
    [bgImgView addSubview:effectview];
#endif
    array = [NSMutableArray array];
    Search_array = [NSMutableArray array];
    
//    search_model = [[SearchModel alloc] init];
    
    searchbar = [[UISearchBar alloc] init];
    searchbar.delegate = self;
    
    searchbar.backgroundImage = [[UIImage alloc] init];
    searchbar.barTintColor = [UIColor clearColor];
    
    [searchbar setTintColor:[UIColor whiteColor]];
    [searchbar becomeFirstResponder];
    searchbar.showsCancelButton = NO;
    searchbar.barTintColor = [UIColor whiteColor];
    [searchbar setImage:[UIImage imageNamed:@"icon_search"]
                  forSearchBarIcon:UISearchBarIconSearch
                             state:UIControlStateNormal];
    [self.view addSubview:searchbar];
    [searchbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(FitSize(25));
        make.left.mas_equalTo(FitSize(10));
        make.right.mas_equalTo(FitSize(-60));
        make.height.mas_equalTo(FitSize(40));
    }];
    
    
    UITextField *searchField = [searchbar valueForKey:@"searchField"];
    if (searchField) {
        [searchField setBackgroundColor: [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1]];
        searchField.layer.cornerRadius = 14.0f;
        searchField.layer.masksToBounds = YES;
        
        NSString *holderText;
        
        
        switch (self.searchVcType) {
            case newsType:
                holderText = @"搜索你所需要的-新闻信息";
                break;
            case businessType:
                holderText = @"搜索你所需要的-商业信息";
                break;
            case meettingTypy:
                holderText = @"搜索你所需要的-会议信息";
                break;
            default:
                holderText = @"搜索你所需要的-新闻信息";
                break;
        }
        
        
        searchField.placeholder = holderText;
        [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        searchField.textColor = [UIColor whiteColor];
    
    }

    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    releaseButton.frame = CGRectMake(screenW-60, 50, 40, 22);
    [releaseButton setTitle:@"取消" forState:UIControlStateNormal];
    releaseButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [releaseButton setTitleColor:[UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:1] forState:UIControlStateNormal];
    [releaseButton addTarget:self action:@selector(releaseInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:releaseButton];
    [releaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchbar.mas_right).offset(FitSize(10));
        make.centerY.mas_equalTo(searchbar.mas_centerY);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    
    UILabel *hisLabel = [[UILabel alloc] init];
    hisLabel.text = @"搜索历史";
    hisLabel.textAlignment = NSTextAlignmentCenter;
    hisLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    [self.view addSubview:hisLabel];
    [hisLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchbar.mas_bottom).offset(FitSize(10));
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearBtn setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearAllAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearBtn];
    [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(FitSize(-20));
        make.width.height.mas_equalTo(FitSize(16));
        make.centerY.mas_equalTo(hisLabel.mas_centerY);
    }];
    
    _sepLine = [[UILabel alloc] init];
    _sepLine.backgroundColor = [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1];
    [self.view addSubview:_sepLine];
    [_sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hisLabel.mas_bottom).mas_offset(FitSize(15));
        make.height.mas_equalTo(1);
        make.left.right.mas_equalTo(0);
    }];
    

    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    if (self.searchVcType == newsType) {
        Search_array = [setting objectForKey:@"NewsSearchArr"];
    }else if (self.searchVcType == businessType){
        Search_array = [setting objectForKey:@"BusinessSearchArr"];
    }else if (self.searchVcType == meettingTypy) {
        Search_array = [setting objectForKey:@"MeetSearchArr"];
    }
    [setting synchronize];
    
    
    
    for (int i = 0; i < Search_array.count; i++) {
        NSString *title = Search_array[i];
        CGSize textSize = [self getAutoWidthWith:title andSize:CGSizeMake(1000, 20) andFont:16];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
        [button setTitle:Search_array[i] forState:UIControlStateNormal];
        button.tag = 100+i;
        [button addTarget:self action:@selector(hisButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_sepLine.mas_bottom).offset(FitSize(20)+i*(20+FitSize(20)));
            make.height.mas_equalTo(20);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.width.mas_equalTo(textSize.width+20);
        }];
        
    }
    
}

#pragma mark - 计算label宽度，自适应
- (CGSize)getAutoWidthWith:(NSString *)text andSize:(CGSize)size andFont:(NSInteger)font {
    NSDictionary *attributes1 = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    CGSize textSize = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes1 context:nil].size;
    
    return textSize;
}


#pragma mark - 历史搜索button点击
- (void)hisButtonClick:(UIButton *)sender {
    
    NSInteger index = sender.tag-100;
    NSString *text = [NSString stringWithFormat:@"%@",[Search_array objectAtIndex:index]];
    
    switch (self.searchVcType) {
        case newsType:
        case businessType:
            [self pushNewsResuluControllerWith:text];
            break;
        case meettingTypy:
            [self pushMeettingResultControllerWith:text];
            break;
        default:
            [self pushNewsResuluControllerWith:text];
            break;
    }
    
}


#pragma mark - 清除所有搜索按钮
- (void)clearAllAction:(UIButton *)sender {
    
    for (int i = 0; i<Search_array.count; i++) {
        UIButton *btn = [self.view viewWithTag:100+i];
        [btn removeFromSuperview];
    }
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    
    if (self.searchVcType == newsType) {
        
        [setting removeObjectForKey:@"NewsSearchArr"];
    }else if (self.searchVcType == businessType){
    
        [setting removeObjectForKey:@"BusinessSearchArr"];
    }else if (self.searchVcType == meettingTypy) {
        
        [setting removeObjectForKey:@"MeetSearchArr"];
    }
    
    
    [setting synchronize];
    Search_array = nil;
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [UIView animateWithDuration:0.5 animations:^{
        [searchbar resignFirstResponder];
    }];
    
}





- (void)releaseInfo:(UIButton *)sender{
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;

    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

/*键盘搜索按钮*/
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    
    [array addObject:[NSString stringWithFormat:@"%@",searchbar.text]];
    for (int i=0; i<Search_array.count; i++) {
        [array addObject:[Search_array objectAtIndex:i]];
    }
    
    if (array.count > 10) {
        [array removeLastObject];
    }
    
    if (self.searchVcType == newsType) {
        [setting setObject:array forKey:@"NewsSearchArr"];
    }else if (self.searchVcType == businessType){
        [setting setObject:array forKey:@"BusinessSearchArr"];
    }else if (self.searchVcType == meettingTypy) {
        [setting setObject:array forKey:@"MeetSearchArr"];
    }
    
    
    [setting synchronize];
    
    NSString *text = searchbar.text;
    switch (self.searchVcType) {
        case newsType:
        case businessType:
            [self pushNewsResuluControllerWith:text];
            break;
        case meettingTypy:
            [self pushMeettingResultControllerWith:text];
            break;
        default:
            [self pushNewsResuluControllerWith:text];
            break;
    }
    
    
}

- (void)pushNewsResuluControllerWith:(NSString *)text {
    NewsResultController *searchVC = [[NewsResultController alloc] init];
    searchVC.searchStr = text;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)pushMeettingResultControllerWith:(NSString *)text {
 
    MeetResultController *meet = [[MeetResultController alloc] init];
    meet.searchStr = text;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:meet animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}


//- (void)CacheData{
//    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
//    fileName = [path stringByAppendingPathComponent:@"Search.plist"];
//    ClassDic = [NSMutableDictionary dictionary];
//}
//- (void)classHuanCun{
//    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Search.plist"];
//    //根据路径获取test.plist的全部内容
//    NSMutableDictionary *infolist= [[[NSMutableDictionary alloc]initWithContentsOfFile:path]mutableCopy];
//    NSMutableDictionary *Class_item = [infolist objectForKey:@"Search_item"];
//    
//
//    
//}
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
