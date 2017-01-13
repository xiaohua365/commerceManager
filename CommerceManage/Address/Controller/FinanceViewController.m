//
//  FinanceViewController.m
//  CommerceManage
//
//  Created by 小花 on 2017/1/13.
//  Copyright © 2017年 vaic. All rights reserved.
//

#import "FinanceViewController.h"
#import "YMPullView.h"

@interface FinanceViewController ()
@property (nonatomic, strong) YMPullView *pullView;
@end

@implementation FinanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pullView = [[YMPullView alloc] initWithFrame:CGRectMake(0, 0, screenW, FitSize(50))];
    [self.view addSubview:self.pullView];
    
    [self setUpPullViewItem];
}

- (void)setUpPullViewItem {
    NSMutableArray *pullItemArray = [NSMutableArray array];
    
    //初始化第一个view
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
        view.backgroundColor = [UIColor grayColor];
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 10, 100, 30)];
        [view addSubview:textView];
        
        YMPullViewModel *model = [[YMPullViewModel alloc] init];
        model.title = @"规格";
        model.view = view;
        model.view.backgroundColor = [UIColor redColor];
        [pullItemArray addObject:model];
        
    }
    
    //初始化第二个view
    {
        YMPullViewModel *model = [[YMPullViewModel alloc] init];
        model.title = @"栽植方式";
        model.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        model.view.backgroundColor = [UIColor yellowColor];
        [pullItemArray addObject:model];
    }
    
    //初始化第三个view
    {
        YMPullViewModel *model = [[YMPullViewModel alloc] init];
        model.title = @"苗源地";
        model.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 400)];
        model.view.backgroundColor = [UIColor greenColor];
        [pullItemArray addObject:model];
    }
    
    //赋值
    _pullView.itemArray = (NSArray<YMPullViewModel> *)pullItemArray;
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
