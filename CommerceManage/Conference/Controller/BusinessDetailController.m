//
//  BusinessDetailController.m
//  CommerceManage
//
//  Created by 小花 on 2016/12/29.
//  Copyright © 2016年 vaic. All rights reserved.
//

#import "BusinessDetailController.h"
#import "BusinessDetailModel.h"
#import "SDPhotoBrowser.h"

@interface BusinessDetailController ()<UIWebViewDelegate, UIScrollViewDelegate, SDPhotoBrowserDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) BusinessDetailModel *businessModel;
@property (nonatomic, strong) NSMutableArray *imageArr;

@end

@implementation BusinessDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商业详情";
    
    [self.view addSubview:self.webView];
    [self loadNewsDetailData];
}


- (void)loadNewsDetailData {
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@", URL_IP,PROJECT_NAME, BUSINESS_DETAIL];
    NSDictionary *para = @{@"businessId":self.businessID};
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"head"][@"rspCode"] isEqualToString:@"0"]) {
            
            NSDictionary *dic = responseObject[@"body"][@"business"];
            
            _businessModel = [BusinessDetailModel mj_objectWithKeyValues:dic];
            
            [self.webView loadRequest:[self getHtmlURL]];
        }else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"head"][@"rspMsg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
        
    }];
    
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //scrollView已经有拖拽手势，直接拿到scrollView的拖拽手势
    UIPanGestureRecognizer *pan = scrollView.panGestureRecognizer;
    //获取到拖拽的速度 >0 向下拖动 <0 向上拖动
    CGFloat velocity = [pan velocityInView:scrollView].y;
    
    if (velocity <- 5) {
        //向上拖动，隐藏导航栏
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        self.webView.y = 20.0f;
    }else if (velocity > 5) {
        //向下拖动，显示导航栏
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.webView.y = .0f;
    }else if(velocity == 0){
        //停止拖拽
    }
}



#pragma -mark 通知新类容页面的html格式化模板加载
- (NSURLRequest *) getHtmlURL
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"business_detail" ofType:@"html"];
    NSURL *url=[NSURL fileURLWithPath:filePath];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    return urlRequest;
}


// webView加载完后执行脚本
-(void) webViewDidFinishLoad:(UIWebView *)mWebView
{
    NSString *content = self.businessModel.contentS;
    
    content = [content stringByReplacingOccurrencesOfString:@"\r\n" withString:@"</br>"];
    content = [content stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
   
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setTitle('%@')" , self.businessModel.title]];
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setContent(\"%@\")", content]];
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setSource('%@')" , @"工商联"]];
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setPuttime(' %@')" , [PublicFunction getDateWith:self.businessModel.ctime]]];
    
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setTel('%@')" , self.businessModel.plane]];
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setPhone('%@')" , self.businessModel.phoneNo]];
    
    NSString *price = [PublicFunction addSeparatorPointForPriceString:self.businessModel.inAmount];
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setTouzi('%@')" , [NSString stringWithFormat:@"%@元", price]]];
 
    
    [self getTapImageUrl];
    [self getImagesJSFunction];
}

#pragma mark - 注入获取图片的js方法
- (void)getImagesJSFunction {
    //这里是js，主要目的实现对url的获取
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgScr = '';\
    for(var i=0;i<objs.length;i++){\
    imgScr = imgScr + objs[i].src + '+';\
    };\
    return imgScr;\
    };";
    
    [self.webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
    
    NSString *urlResurlt = [self.webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    
    self.imageArr = [NSMutableArray arrayWithArray:[urlResurlt componentsSeparatedByString:@"+"]];
    [self.imageArr removeLastObject];
}

#pragma mark - 获取点击图片的url
- (void)getTapImageUrl {
    //调整字号
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '95%'";
    [self.webView stringByEvaluatingJavaScriptFromString:str];
    
    //js方法遍历图片添加点击事件 返回图片个数
    static  NSString * const CCGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    for(var i=0;i<objs.length;i++){\
    objs[i].onclick=function(){\
    document.location=\"myweb:imageClick:\"+this.src;\
    };\
    };\
    return objs.length;\
    };";
    
    [self.webView stringByEvaluatingJavaScriptFromString:CCGetImages];//注入js方法
    
//    注入自定义的js方法后别忘了调用 否则不会生效
    NSString *resurlt = [self.webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
//    调用js方法
    NSLog(@"---调用js方法--%@  %s  jsMehtods_result = %@",self.class,__func__,resurlt);
}




#pragma -mark js回调
//js回调函数
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[request URL] absoluteString];
    
    //hasPrefix 判断创建的字符串内容是否以pic:字符开始
    if ([requestString hasPrefix:@"myweb:imageClick:"]) {
        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
        //        NSLog(@"image url------%@", imageUrl);
        
        NSLog(@"%@", imageUrl);
        //        [self showImageWith:imageUrl];
        [self showSDPhotoBrowerWith:imageUrl];
        return NO;
    }
    return YES;
}


#pragma -mark JS脚本
//执行js脚本
- (id) javaScriptFromString:(NSString *) str
{
    return [self.webView stringByEvaluatingJavaScriptFromString:str];
}


- (void)showSDPhotoBrowerWith:(NSString *)url {
    
    NSInteger index = [self.imageArr indexOfObject:url];
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = index;
    photoBrowser.imageCount = self.imageArr.count;
    photoBrowser.sourceImagesContainerView = self.view;
    
    [photoBrowser show];
}

#pragma mark  SDPhotoBrowserDelegate

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    // 不建议用此种方式获取小图，这里只是为了简单实现展示而已
    
    
    //    return [UIImage imageNamed:@"1"];
    return nil;
    
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = self.imageArr[index];
    return [NSURL URLWithString:urlStr];
}



- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH-20)];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.backgroundColor = [UIColor whiteColor];
        _webView.scalesPageToFit = YES;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.delegate = self;
        _webView.dataDetectorTypes = UIDataDetectorTypeNone;
        _webView.scrollView.delegate = self;
    }
    return _webView;
}

- (NSMutableArray *)imageArr {
    if (!_imageArr) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
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
