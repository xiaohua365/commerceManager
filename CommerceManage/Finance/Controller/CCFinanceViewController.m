//
//  CCFinanceViewController.m
//  CommerceManage
//
//  Created by 小花 on 2017/1/16.
//  Copyright © 2017年 vaic. All rights reserved.
//

#import "CCFinanceViewController.h"
#import "MMComBoBoxView.h"
#import "MMItem.h"
#import "MMHeader.h"
#import "MMAlternativeItem.h"
#import "MMSelectedPath.h"

@interface CCFinanceViewController ()<MMComBoBoxViewDataSource, MMComBoBoxViewDelegate>
@property (nonatomic, strong) NSMutableArray *mutableArray;
@end

@implementation CCFinanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpFilterView];
}

- (void)setUpFilterView {
    
    //第一个item
    MMItem *rootItem1 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"全部"];
    rootItem1.selectedType = MMPopupViewSingleSelection;
    for (int i = 0; i < 20; i++) {
        [rootItem1 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"蛋糕系列%d",i] subTileName:[NSString stringWithFormat:@"%ld",random()%10000]]];
    }
    
    //第二个item
    MMItem *rootItem2 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"排序"];
    //first floor
    [rootItem2 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"智能排序"]]];
    [rootItem2 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"离我最近"]]];
    [rootItem2 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"好评优先"]]];
    [rootItem2 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"人气最高"]]];
    
    //第三个item
    MMItem *rootItem3 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"附近"];
    for (int i = 0; i < 30; i++){
        MMItem *item3_A = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[NSString stringWithFormat:@"市区%d",i]];
        [rootItem3 addNode:item3_A];
        for (int j = 0; j < random()%30; j ++) {
            if (i == 0 &&j == 0) {
                [item3_A addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"市区%d县%d",i,j]subTileName:[NSString stringWithFormat:@"%ld",random()%10000]]];
            }else{
                [item3_A addNodeWithoutMark:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"市区%d县%d",i,j]subTileName:[NSString stringWithFormat:@"%ld",random()%10000]]];
            }
        }
    }
    
    self.mutableArray = [NSMutableArray array];
    [self.mutableArray addObject:rootItem1];
    [self.mutableArray addObject:rootItem2];
    [self.mutableArray addObject:rootItem3];
    
    MMComBoBoxView *view = [[MMComBoBoxView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 40)];
    view.dataSource = self;
    view.delegate = self;
    [self.view addSubview:view];
    [view reload];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, view.bottom, self.view.width, self.view.height - 64)];
    imageView.image = [UIImage imageNamed:@"1.jpg"];
    [self.view addSubview:imageView];
    
}

#pragma mark - MMComBoBoxViewDataSource
- (NSUInteger)numberOfColumnsIncomBoBoxView :(MMComBoBoxView *)comBoBoxView {
    return self.mutableArray.count;
}
- (MMItem *)comBoBoxView:(MMComBoBoxView *)comBoBoxView infomationForColumn:(NSUInteger)column {
    return self.mutableArray[column];
}

#pragma mark - MMComBoBoxViewDelegate
- (void)comBoBoxView:(MMComBoBoxView *)comBoBoxViewd didSelectedItemsPackagingInArray:(NSArray *)array atIndex:(NSUInteger)index {
    MMItem *rootItem = self.mutableArray[index];
    switch (rootItem.displayType) {
        case MMPopupViewDisplayTypeNormal:
        case MMPopupViewDisplayTypeMultilayer:{
            //拼接选择项
            NSMutableString *title = [NSMutableString string];
            __block NSInteger firstPath;
            [array enumerateObjectsUsingBlock:^(MMSelectedPath * path, NSUInteger idx, BOOL * _Nonnull stop) {
                [title appendString:idx?[NSString stringWithFormat:@";%@",[rootItem findTitleBySelectedPath:path]]:[rootItem findTitleBySelectedPath:path]];
                if (idx == 0) {
                    firstPath = path.firstPath;
                }
            }];
            NSLog(@"当title为%@时，所选字段为 %@",rootItem.title ,title);
            break;}
        case MMPopupViewDisplayTypeFilters:{
            [array enumerateObjectsUsingBlock:^(MMSelectedPath * path, NSUInteger idx, BOOL * _Nonnull stop) {
                //当displayType为MMPopupViewDisplayTypeFilters时有MMAlternativeItem类型和MMItem类型两种
                if (path.isKindOfAlternative == YES) { //MMAlternativeItem类型
                    MMAlternativeItem *alternativeItem = rootItem.alternativeArray[path.firstPath];
                    NSLog(@"当title为%@时，选中状态为 %d",alternativeItem.title,alternativeItem.isSelected);
                } else {
                    MMItem *firstItem = rootItem.childrenNodes[path.firstPath];
                    MMItem *SecondItem = rootItem.childrenNodes[path.firstPath].childrenNodes[path.secondPath];
                    NSLog(@"当title为%@时，所选字段为 %@",firstItem.title,SecondItem.title);
                }
            }];
            break;}
        default:
            break;
    }
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
