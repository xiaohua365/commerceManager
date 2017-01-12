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
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSArray *urlArr;

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
    
    
    cell.imgView.image = [UIImage imageNamed:self.dataArr[indexPath.item]];
    cell.layer.borderColor = [UIColor grayColor].CGColor;
//    cell.layer.borderWidth = 1;
//    cell.layer.cornerRadius = 3;
    return cell;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *url = self.urlArr[indexPath.item];
    NSURL *URL = [NSURL URLWithString:url];
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:URL]) {
        [app openURL:URL];
    }
    
    
}


- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        NSMutableArray *mArr = [NSMutableArray array];
        for (int i = 0; i < 23; i++) {
            NSString *imageStr = [NSString stringWithFormat:@"img_%d", i];
            [mArr addObject:imageStr];
        }
        _dataArr = [NSMutableArray arrayWithArray:mArr];
    }
    return _dataArr;
    
}

- (NSArray *)urlArr {
    if (!_urlArr) {
        _urlArr = @[@"http://www.aceway.com.cn",  //汉铭集团
                    @"http://www.atzuche.com/",   //凹凸租车
                    @"http://www.rwybaoan.com/",  //戎威远保安
                    @"http://www.bankofbeijing.com.cn/",  //北京银行
                    @"http://www.bjrcb.com/",  //北京农商银行
                    @"",  //北京消费金融
                    @"http://www.chanjet.com/",  //用友——畅捷通
                    @"http://www.315job.com/", //东方汇佳
                    @"http://www.gujinlai.com/", //北京古今来
                    @"http://www.icbc.com.cn", //中国工行银行
                    @"http://www.hxb.com.cn/home/cn/", //华夏银行
                    @"http://www.lccb.com.cn/", //廊坊银行
                    @"http://www.chanjet.com/collection", //工作圈
                    @"http://www.bjrhjt.cn/subject/subject-cylm.html", //镕辉佳特
                    @"http://www.cnguardee.com/index.html", //特卫安防
                    @"http://www.cib.com.cn/cn/index.html", //兴业银行
                    @"https://www.yyfax.com/h5/activity/channel.html?code=lhbb", //用友——友金所推广链接
                    @"http://www.yonyou.com/index.html?t=0.9121916741132736", //用友集团
                    @"http://www.psbc.com/cn/index.html", //邮储银行
                    @"http://www.cmbc.com.cn/", //中国民生银行
                    @"http://www.abchina.com/cn/、", //农业银行
                    @"http://www.boc.cn/", //中国银行
                    @"http://www.zjhcpa.com.cn/", //中建华集团
                    ];
    }
    return _urlArr;
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
