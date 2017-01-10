//
//  RSTFocusImage.m
//  RSTFocusImage
//
//  Created by rong on 16/4/28.
//  Copyright © 2016年 rong. All rights reserved.
//

#import "RSTFocusImage.h"
#import <CommonCrypto/CommonDigest.h>

@interface RSTFocusImage ()<UIScrollViewDelegate, tapImageViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *frontImgView;   //上一张图片
@property (strong, nonatomic) UIImageView *currentImgView; //当前显示的图片
@property (strong, nonatomic) UIImageView *behindImgView;  //下一张图片
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UIImage *placeholder;
@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) NSMutableArray *imageUrl;
@property (assign, nonatomic) CGFloat imgWidth;
@property (assign, nonatomic) CGFloat imgHeight;
@property (assign, nonatomic) NSInteger currentIndex;

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *categorys;



@end

@implementation RSTFocusImage

- (instancetype)initWithFrame:(CGRect)frame Images:(NSArray *)images Placeholder:(UIImage *)placeholder Titles:(NSArray *)titles Category:(NSArray *)category{
    
    self = [super initWithFrame:frame];
    if (self) {
        _interval = 3.0;
        _imgWidth = frame.size.width;
        _imgHeight = frame.size.height;
        _imageUrl = [NSMutableArray arrayWithArray:images];
        
        _titles = [NSMutableArray arrayWithArray:titles];
        _categorys = [NSMutableArray arrayWithArray:category];
        
        _placeholder = placeholder;
        [self initSubview];
        [self loadImage];
        [self startTimer];
    }
    return self;
}


- (void)initSubview{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 0, _imgWidth, _imgHeight);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
    }
    
    if (!_frontImgView) {
        _frontImgView = [[UIImageView alloc] init];
        _frontImgView.frame = CGRectMake(0, 0, _imgWidth, _imgHeight);
        _frontImgView.image = [self placeholder];
        [_scrollView addSubview:_frontImgView];
        
        //frontHeaderView
        _frontHeaderView = [[BannerImageView alloc] initWithFrame:CGRectMake(0, 0, _imgWidth, _imgWidth)];
        [_frontImgView addSubview:_frontHeaderView];
        
    }
    
    if (!_currentImgView) {
        _currentImgView = [[UIImageView alloc] init];
        _currentImgView.frame = CGRectMake(_imgWidth, 0,_imgWidth, _imgHeight);
        [_scrollView addSubview:_currentImgView];
        _currentImgView.image = [self placeholder];
        _currentImgView.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgWithIndex)];
//        [_currentImgView addGestureRecognizer:tap];
        
        //_currentHeaderView
        _currentHeaderView = [[BannerImageView alloc] initWithFrame:CGRectMake(0, 0, _imgWidth, _imgWidth)];
        _currentHeaderView.delegate = self;
        [_currentImgView addSubview:_currentHeaderView];
        
        
        _currentHeaderView.titleLabel.text = _titles[_currentIndex];
        _currentHeaderView.timeLabel.text = _categorys[_currentIndex];
        
//        _currentHeaderView.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgWithIndex)];
//        [_currentHeaderView addGestureRecognizer:tap];
        
    }

    if (!_behindImgView) {
        _behindImgView = [[UIImageView alloc] init];
        _behindImgView.frame = CGRectMake(_imgWidth*2, 0, _imgWidth, _imgHeight);
        [_scrollView addSubview:_behindImgView];
        _behindImgView.image = [self placeholder];
        
        //behindHeaderView
        _behindHeaderView = [[BannerImageView alloc] initWithFrame:CGRectMake(0, 0, _imgWidth, _imgHeight)];
        [_behindImgView addSubview:_behindHeaderView];
        
        
        _behindHeaderView.titleLabel.text = _titles[_currentIndex+1];
        _behindHeaderView.timeLabel.text = _categorys[_currentIndex+1];
        
    }
    

    
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.frame = CGRectMake(screenW-100, FitSize(155), 100, 20);
        [self addSubview:_pageControl];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = _imageUrl.count;
    }
    
    [_scrollView setContentSize:CGSizeMake(3*_imgWidth, _imgHeight)];
    [_scrollView setContentOffset:CGPointMake(_imgWidth, 0) animated:YES];
}

- (void)startTimer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_interval target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)stopTimer{
    [_timer invalidate];
    _timer = nil;
}

- (void)changeImage{
    [_scrollView setContentOffset:CGPointMake(_imgWidth*2, 0) animated:YES];
}

- (void)setShowPageControl:(BOOL)showPageControl{
    _showPageControl = showPageControl;
    if (showPageControl) {
        _pageControl.hidden = NO;
    }else{
        _pageControl.hidden = YES;
    }
}

- (void)setInterval:(NSInteger)interval{
    _interval = interval;
    [self stopTimer];
    [self startTimer];
}

- (void)loadImage{
    _images = [NSMutableArray arrayWithCapacity:_imageUrl.count];
    for (int index = 0; index < _imageUrl.count; index ++) {
        UIImage *image = [self placeholder];
        [_images addObject:image];
        
//        NSString *urlStr = _imageUrl[index];
        NSString *urlStr = [NSString stringWithFormat:@"%@%@", URL_IP_IMG,_imageUrl[index]];
        [self getImageWithUrl:urlStr ImgIndex:index Finish:^(UIImage *image, NSInteger index) {
            [_images replaceObjectAtIndex:index withObject:image];
        }];
    }
}

- (UIImage *)placeholder{
    if (_placeholder) {
        return _placeholder;
    }else{
        UIImage *image = [UIImage imageNamed:@"img_v_r_v"];
        return image;
    }
}

- (void)getImageWithUrl:(NSString *)urlStr ImgIndex:(NSInteger)index Finish:(downloadFinish)finish{
    NSString *md5 = [self MD5WithUrl:urlStr];
    NSString *cachePath = [self cachePathWithMD5:md5];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
    if (isExist) {
        NSData *data = [NSData dataWithContentsOfFile:cachePath];
        UIImage *image = [UIImage imageWithData:data];
        
        finish(image,index);
        if (index == 0) {
            _currentImgView.image = image;
        }else if (index == 1){
            _behindImgView.image = image;
        }
    }else{
        [self downloadImageWithUrl:urlStr Index:index Finish:^(UIImage *image,NSInteger index) {
            if (image) {
                finish(image,index);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (index == 0) {
                        _currentImgView.image = image;
                    }else if (index == 1){
                        _behindImgView.image = image;
                    }
                });

                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSData *data = UIImagePNGRepresentation(image);
                    [data writeToFile:cachePath atomically:YES];
                });
            }
        } Failure:^(NSError *error) {
            NSLog(@"error:%@",error);
        }];
    }
}

- (NSString *)cachePathWithMD5:(NSString *)md5{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathStr = [path[0] stringByAppendingPathComponent:md5];
//    NSLog(@"沙河路径：%@",pathStr);
    return pathStr;
}

- (NSString *)MD5WithUrl:(NSString *)urlStr{
    const char *original_str = [urlStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02X",result[i]];
    }
    return hash;
}

- (void)downloadImageWithUrl:(NSString *)urlStr Index:(NSInteger)imgIndex Finish:(downloadFinish)finish Failure:(downloadFailure)failure{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
        
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            NSLog(@"data:%@ response :%@",data,response);
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                finish(image,imgIndex);
            }
            if (error) {
                failure(error);
            }
        }] resume];

    });
}

- (void)tapImageViewDelegateAction {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapFocusWithIndex:)]) {
        [self.delegate tapFocusWithIndex:self.pageControl.currentPage];
    }
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = _scrollView.contentOffset.x;
    if (offset >= _imgWidth*2) {//左滑
        _currentIndex ++;
        
        _scrollView.contentOffset = CGPointMake(_imgWidth, 0);
        if (_currentIndex == _images.count-1) {
            _frontImgView.image = _images[_currentIndex-1];
            _currentImgView.image = _images[_currentIndex];
            _behindImgView.image = _images.firstObject;
            _pageControl.currentPage = _currentIndex;
           
            
            _frontHeaderView.titleLabel.text = _titles[_currentIndex-1];
            _frontHeaderView.timeLabel.text = _categorys[_currentIndex-1];

            
            _currentHeaderView.titleLabel.text = _titles[_currentIndex];
            _currentHeaderView.timeLabel.text = _categorys[_currentIndex];
            
            _behindHeaderView.titleLabel.text = _titles.firstObject;
            _behindHeaderView.timeLabel.text = _categorys.firstObject;
             _currentIndex = -1;
            
            
        }else if (_currentIndex == _images.count){
            _frontImgView.image = _images.lastObject;
            _currentImgView.image = _images.firstObject;
            _behindImgView.image = _images[1];
            _pageControl.currentPage = 0;
            
            
            _frontHeaderView.titleLabel.text = _titles.lastObject;
            _frontHeaderView.timeLabel.text = _categorys.lastObject;
            
            _currentHeaderView.titleLabel.text = _titles.firstObject;
            _currentHeaderView.timeLabel.text = _categorys.firstObject;
            
            _behindHeaderView.titleLabel.text = _titles[1];
            _behindHeaderView.timeLabel.text = _categorys[1];
            
            _currentIndex = 0;
            
        } else if (_currentIndex == 0){
            _frontImgView.image = _images.lastObject;
            _currentImgView.image = _images[_currentIndex];
            _behindImgView.image = _images[_currentIndex+1];
            _pageControl.currentPage = _currentIndex;
            
            _frontHeaderView.titleLabel.text = _titles.lastObject;
            _frontHeaderView.timeLabel.text = _categorys.lastObject;
            
            _currentHeaderView.titleLabel.text = _titles[_currentIndex];
            _currentHeaderView.timeLabel.text = _categorys[_currentIndex];

            
            _behindHeaderView.titleLabel.text = _titles[_currentIndex+1];
            _behindHeaderView.timeLabel.text = _categorys[_currentIndex+1];
            
            
        }else{
            _frontImgView.image = _images[_currentIndex -1];
            _currentImgView.image = _images[_currentIndex];
            _behindImgView.image = _images[_currentIndex +1];
            _pageControl.currentPage = _currentIndex;
            
            _frontHeaderView.titleLabel.text = _titles[_currentIndex -1];
            _frontHeaderView.timeLabel.text = _categorys[_currentIndex -1];
            
            _currentHeaderView.titleLabel.text = _titles[_currentIndex];
            _currentHeaderView.timeLabel.text = _categorys[_currentIndex];
            
            _behindHeaderView.titleLabel.text = _titles[_currentIndex+1];
            _behindHeaderView.timeLabel.text = _categorys[_currentIndex+1];
            
        }
    }else if (offset <= 0){//右滑
        _currentIndex --;
        _scrollView.contentOffset = CGPointMake(_imgWidth, 0);
        if (_currentIndex == -2) {
            _currentIndex = _images.count-2;
            _frontImgView.image = _images[_images.count-1];
            _currentImgView.image = _images[_currentIndex];
            _behindImgView.image = _images.firstObject;
            
            _frontHeaderView.titleLabel.text = _titles[_images.count-1];
            _frontHeaderView.timeLabel.text = _categorys[_images.count-1];

            
            _currentHeaderView.titleLabel.text = _titles[_currentIndex];
            _currentHeaderView.timeLabel.text = _categorys[_currentIndex];

            
            _behindHeaderView.titleLabel.text = _titles.firstObject;
            _behindHeaderView.timeLabel.text = _categorys.firstObject;

        }else if (_currentIndex == -1) {
            _currentIndex = _images.count-1;
            _frontImgView.image = _images[_currentIndex-1];
            _currentImgView.image = _images[_currentIndex];
            _behindImgView.image = _images.firstObject;
            
            _frontHeaderView.titleLabel.text = _titles[_currentIndex-1];
            _frontHeaderView.timeLabel.text = _categorys[_currentIndex-1];
            
            _currentHeaderView.titleLabel.text = _titles[_currentIndex];
            _currentHeaderView.timeLabel.text = _categorys[_currentIndex];
            
            _behindHeaderView.titleLabel.text = _titles.firstObject;
            _behindHeaderView.timeLabel.text = _categorys.firstObject;
            
        }else if (_currentIndex == 0){
            _frontImgView.image = _images.lastObject;
            _currentImgView.image = _images[_currentIndex];
            _behindImgView.image = _images[_currentIndex +1];
            
            _frontHeaderView.titleLabel.text = _titles.lastObject;
            _frontHeaderView.timeLabel.text = _categorys.lastObject;
            
            _currentHeaderView.titleLabel.text = _titles[_currentIndex];
            _currentHeaderView.timeLabel.text = _categorys[_currentIndex];
            
            _behindHeaderView.titleLabel.text = _titles[_currentIndex +1];
            _behindHeaderView.timeLabel.text = _categorys[_currentIndex +1];

        }else{
            _frontImgView.image = _images[_currentIndex -1];
            _currentImgView.image = _images[_currentIndex];
            _behindImgView.image = _images[_currentIndex +1];
            
            _frontHeaderView.titleLabel.text = _titles[_currentIndex -1];
            _frontHeaderView.timeLabel.text = _categorys[_currentIndex -1];
            
            _currentHeaderView.titleLabel.text = _titles[_currentIndex];
            _currentHeaderView.timeLabel.text = _categorys[_currentIndex];
            
            _behindHeaderView.titleLabel.text = _titles[_currentIndex +1];
            _behindHeaderView.timeLabel.text = _categorys[_currentIndex +1];
            
        }
        _pageControl.currentPage = _currentIndex;
    }
}

//手指开始滑动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
}

//手指离开
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
}






@end
