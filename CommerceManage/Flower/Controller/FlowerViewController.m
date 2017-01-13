//
//  FlowerViewController.m
//  CommerceManage
//
//  Created by 小花 on 2017/1/6.
//  Copyright © 2017年 vaic. All rights reserved.
//

#import "FlowerViewController.h"
#import "LogoCollectionCell.h"

@interface FlowerViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSArray *dataArr;


@end

@implementation FlowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpLeftItem];
    [self setCollectionView];
}

- (void)setUpLeftItem {

    
    UIView *shareNavleftView = [[UIView alloc] init];
    shareNavleftView.frame = CGRectMake(0.0, 0.0, 40.0, 38.0);
    UIImageView *img = [[UIImageView alloc] init];
    img.image = [UIImage imageNamed:@"top_logo"];
    img.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    img.frame = shareNavleftView.frame;
    [shareNavleftView addSubview:img];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareNavleftView];
}

- (void)setCollectionView {
    _layout = [[UICollectionViewFlowLayout alloc] init];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH-49-64) collectionViewLayout:_layout];
    _collectionView.backgroundColor = Color_RGBA(243, 243, 243, 1);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    
//    [_collectionView registerNib:[UINib nibWithNibName:@"LogoCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"LogoCollectionCell"];
    [_collectionView registerClass:[LogoCollectionCell  class] forCellWithReuseIdentifier:@"LogoCollectionCell"];
    
    
    [self.view addSubview:_collectionView];
    
    
    _layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 1);
    //footer
    _layout.footerReferenceSize = CGSizeMake(self.view.frame.size.width, 1);
    //(screenW)/2/155*30
    _layout.itemSize = CGSizeMake((screenW-1)/2, FitSize(70));
    
    _layout.minimumInteritemSpacing = 0;
    _layout.minimumLineSpacing = 1;//最小行间距
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return self.dataArr.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LogoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LogoCollectionCell" forIndexPath:indexPath];
    
    
    cell.imgView.image = [UIImage imageNamed:self.dataArr[indexPath.item][@"logo"]];
    cell.layer.borderColor = [UIColor grayColor].CGColor;
//    cell.layer.borderWidth = 1;
//    cell.layer.cornerRadius = 3;
    return cell;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *url = self.dataArr[indexPath.item][@"url"];
    NSURL *URL = [NSURL URLWithString:url];
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:URL]) {
        [app openURL:URL];
    }
    
    
}


- (NSArray *)dataArr {
    if (!_dataArr) {
        
        _dataArr = @[@{@"logo":@"img_0",  //汉铭集团 0
                         @"url":@"http://www.aceway.com.cn"},
                     @{@"logo":@"img_1", //凹凸租车 1
                       @"url":@"http://www.atzuche.com/"},
                     @{@"logo":@"img_17",//用友集团 17
                       @"url":@"http://www.yonyou.com/index.html?t=0.9121916741132736"},
                     @{@"logo":@"img_6",//用友——畅捷通 6
                       @"url":@"http://www.chanjet.com/"},
                     @{@"logo":@"img_12",//工作圈 12
                       @"url":@"http://www.chanjet.com/collection"},
                     @{@"logo":@"img_16",//用友——友金所推广链接 16
                       @"url":@"https://www.yyfax.com/h5/activity/channel.html?code=lhbb"},
                     @{@"logo":@"img_2",//戎威远保安 2
                       @"url":@"http://www.rwybaoan.com/"},
                     @{@"logo":@"img_3",//北京银行 3
                       @"url":@"http://www.bankofbeijing.com.cn/"},
                     @{@"logo":@"img_4",//北京农商银行 4
                       @"url":@"http://www.bjrcb.com/"},
                     @{@"logo":@"img_5",//北京消费金融 5
                       @"url":@"http://www.bobcfc.com/"},
                     @{@"logo":@"img_7",//东方汇佳 7
                       @"url":@"http://www.315job.com/"},
                     @{@"logo":@"img_8",//北京古今来 8
                       @"url":@"http://www.gujinlai.com/"},
                     @{@"logo":@"img_9",//中国工行银行 9
                       @"url":@"http://www.icbc.com.cn"},
                     @{@"logo":@"img_10",//华夏银行 10
                       @"url":@"http://www.hxb.com.cn/home/cn/"},
                     @{@"logo":@"img_11",//廊坊银行 11
                       @"url":@"http://www.lccb.com.cn/"},
                     @{@"logo":@"img_13",//镕辉佳特 13
                       @"url":@"http://www.bjrhjt.cn/subject/subject-cylm.html"},
                     @{@"logo":@"img_14",//特卫安防 14
                       @"url":@"http://www.cnguardee.com/index.html"},
                     @{@"logo":@"img_15",//兴业银行 15
                       @"url":@"http://www.cib.com.cn/cn/index.html"},
                     @{@"logo":@"img_18",//邮储银行 18
                       @"url":@"http://www.psbc.com/cn/index.html"},
                     @{@"logo":@"img_19",//中国民生银行 19
                       @"url":@"http://www.cmbc.com.cn/"},
                     @{@"logo":@"img_20",//农业银行 20
                       @"url":@"http://www.abchina.com/cn/"},
                     @{@"logo":@"img_21",//中国银行 21
                       @"url":@"http://www.boc.cn/"},
                     @{@"logo":@"img_22", //中建华集团 22
                       @"url":@"http://www.zjhcpa.com.cn/"},
                     ];
    }
    return _dataArr;
    
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
