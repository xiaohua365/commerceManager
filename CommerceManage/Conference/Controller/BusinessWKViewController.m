//
//  BusinessWKViewController.m
//  CommerceManage
//
//  Created by 小花 on 2017/1/5.
//  Copyright © 2017年 vaic. All rights reserved.
//

#import "BusinessWKViewController.h"
#import "BusinessDetailModel.h"
#import "SDPhotoBrowser.h"
#import <WebKit/WebKit.h>
#import "WeakScriptMessageDelegate.h"

@interface BusinessWKViewController ()<WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate, SDPhotoBrowserDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) BusinessDetailModel *businessModel;
@property (nonatomic, strong) WKWebViewConfiguration *config;

@property (nonatomic, strong) NSMutableArray *imageArr;
@end

@implementation BusinessWKViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"商业详情";
    [self getTapImageUrl];
    [self getAllImageUrl];
    [self webViewAddJSScript];
    
    [self.view addSubview:self.webView];
    [self loadBusinessDetailData];
}

- (void)loadBusinessDetailData {
    
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

#pragma -mark 加载本地HTML模板
- (NSURLRequest *) getHtmlURL
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"business_detail" ofType:@"html"];
    NSURL *url=[NSURL fileURLWithPath:filePath];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    return urlRequest;
}


// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    NSString *content = self.businessModel.contentS;
    
    content = [content stringByReplacingOccurrencesOfString:@"\r\n" withString:@"</br>"];
    content = [content stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
    
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"setTitle('%@')" , self.businessModel.title] completionHandler:nil];
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"setContent(\"%@\")", content] completionHandler:nil];
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"setSource('%@')" , @"工商联"] completionHandler:nil];
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"setPuttime(' %@')" , [PublicFunction getDateWith:self.businessModel.ctime]] completionHandler:nil];
    
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"setTel('%@')" , self.businessModel.plane] completionHandler:nil];
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"setPhone('%@')" , self.businessModel.phoneNo] completionHandler:nil];
    
    NSString *price = [PublicFunction addSeparatorPointForPriceString:self.businessModel.inAmount];
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"setTouzi('%@')" , [NSString stringWithFormat:@"%@元", price]] completionHandler:nil];
    
    
    [self.webView evaluateJavaScript:@"getImages()" completionHandler:nil];
    [self.webView evaluateJavaScript:@"getImage()" completionHandler:nil];
    
}


//OC在JS调用方法做的处理
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"JS 调用了 %@ 方法，传回参数 %@",message.name,message.body);
    if ([message.name isEqualToString:@"getImages"]) {
        NSString * urlResurlt = message.body;
        self.imageArr = [NSMutableArray arrayWithArray:[urlResurlt componentsSeparatedByString:@"+"]];
        [self.imageArr removeLastObject];
    }
    
    if ([message.name isEqualToString:@"getImageUrl"]) {
        
        if (message.body != nil || ![message.body isEqualToString:@""]) {
            [self showSDPhotoBrowerWith:message.body];
        }
    }
    
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


#pragma mark - scrollView Delegate
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


#pragma mark - 注入获取点击图片的url
- (void)getTapImageUrl {
    
    //js方法遍历图片添加点击事件
    static  NSString * const CCGetImages =
    @"function getImage(){\
    var objs = document.getElementsByTagName(\"img\");\
    for(var i=0;i<objs.length;i++){\
    objs[i].onclick=function(){\
    window.webkit.messageHandlers.getImageUrl.postMessage(this.src);\
    };\
    };\
    return objs.length;\
    };";
    
    
    WKUserScript *funScript = [[WKUserScript alloc] initWithSource:CCGetImages injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKWebViewConfiguration *config = self.webView.configuration;
    
    [config.userContentController addUserScript:funScript];
    
    
}

//获取所有图片的url
- (void)getAllImageUrl {
    //这里是js，主要目的实现对url的获取
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgScr = '';\
    for(var i=0;i<objs.length;i++){\
    imgScr = imgScr + objs[i].src + '+';\
    };\
    window.webkit.messageHandlers.getImages.postMessage(imgScr);\
    return imgScr;\
    };";
    
    WKUserScript *jsScript = [[WKUserScript alloc] initWithSource:jsGetImages injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    [self.webView.configuration.userContentController addUserScript:jsScript];//注入js方法
    
}

#pragma mark - webView addScript
- (void)webViewAddJSScript {
    [self.webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"getImageUrl"];
    [self.webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"getImages"];
}


#pragma mark - getter 
- (WKWebView *)webView {
    if (!_webView) {
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH-20) configuration:self.config];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.scrollView.delegate = self;
    }
    return _webView;
}

- (WKWebViewConfiguration *)config {
    if (!_config) {
        //初始化一个WKWebViewConfiguration对象
        _config = [WKWebViewConfiguration new];
        //初始化偏好设置属性：preferences
        _config.preferences = [WKPreferences new];
        //The minimum font size in points default is 0;
        _config.preferences.minimumFontSize = 10;
        //是否支持JavaScript
        _config.preferences.javaScriptEnabled = YES;
        //不通过用户交互，是否可以打开窗口
        _config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    }
    return _config;
}

- (NSMutableArray *)imageArr {
    if (!_imageArr) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}


- (void)dealloc {
    [[self.webView configuration].userContentController removeScriptMessageHandlerForName:@"getImageUrl"];
    [[self.webView configuration].userContentController removeScriptMessageHandlerForName:@"getImages"];
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
