//
//  LPPageVC.m
//  LPNavPageVCTest
//
//  Created by LPDev on 16/4/19.
//  Copyright © 2016年 anonymous. All rights reserved.
//

#import "LPPageVC.h"
#import "Masonry.h"
#import "CommonTool.h"

/**
 *  Segment 的 高度
 */
const CGFloat   LPPageVCSegmentHeight           = 40.f;

/**
 *  Segment 的 指示器 的 高度
 */
const CGFloat   LPPageVCSegmentIndicatorHeight  = 1.5f;

/**
 *  可见的最大的Pages
 */
const NSInteger LPPageVCMaxVisiblePages         = 5;

@interface LPPageVC () <UIScrollViewDelegate> {
    
    UIView * _segmentContainerView; // Container 容器
    UIView * _contentContainerView; // Container 容器
    UIView * _indicatorView;        // indicator 指示器
    
    BOOL _doneLayout; // 完成 布局
    BOOL _editMode;   // edit 状态
}

@property (nonatomic, assign) NSInteger numberOfContent;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger lastIndex;

@property (nonatomic, strong) NSMutableArray * segmentTitles;

@property (nonatomic, strong) UIColor * normalTextColor;
@property (nonatomic, strong) UIColor * higlightTextColor;

@property (nonatomic, strong) NSMutableDictionary * reusableVCDic; // reusable 可再用的

@end

@implementation LPPageVC

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        // ..aDecoder
    }
    
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self defaultSetup];
}

#pragma mark defaultSetup - default setup - 默认设置
- (void)defaultSetup {
 
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    /**
     简单点说就是automaticallyAdjustsScrollViewInsets根据按所在界面的status bar，navigationbar，与tabbar的高度，自动调整scrollview的 inset,设置为no，不让viewController调整，我们自己修改布局即可~
     */
    
    _editMode = LPPageVCEditModeDefault;
    
    _higlightTextColor = APP_THEME_COLOR;
    _normalTextColor = [UIColor blackColor];
    
    _currentIndex = 0;

    // 接下来是创建UI .. 首先是创建 segment 的滚动视图
    
    _segmentScrollView = [[UIScrollView alloc] init];
    
    _segmentScrollView.showsHorizontalScrollIndicator = NO; // 是否显示水平滚动条
    _segmentScrollView.showsVerticalScrollIndicator = NO;   // 是否显示垂直滚动条
    
    _segmentScrollView.scrollsToTop = NO; // To Top
    
    [self.view addSubview:_segmentScrollView];
    
    [_segmentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.view);
        // 左和当前视图约束
        make.top.mas_equalTo(self.mas_topLayoutGuide);  // mas_topLayoutGuide 头部视图区域
        // 上和Top Nav约束
        make.height.mas_equalTo(LPPageVCSegmentHeight); // 高度
        // 高度等于自己设置的高度 - LPPageVCSegmentHeight
    }];
 
#pragma mark - 创建editButton
    // edit按钮的背景视图
    UIControl * editBgView = [[UIControl alloc] init];
    [editBgView addTarget:self action:@selector(editButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:editBgView];
    
    [editBgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.bottom.mas_equalTo(_segmentScrollView);
        // 上下和_segmentScrollView对齐
        make.left.mas_equalTo(_segmentScrollView.mas_right);
        // 左和_segmentScrollView右边对齐
        make.right.mas_equalTo(self.view);
        // 右和当前视图对齐
        make.width.mas_equalTo(_segmentScrollView.mas_height);
        // 宽度等于_segmentScrollView的高度 - 也即是editButton是个正方形
    }];
    
    // edit按钮左边的横线
//    UIView * lineView = [[UIView alloc] init];
//    lineView.backgroundColor = [UIColor lightGrayColor];
//    
//    [editBgView addSubview:lineView];
// 
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//       
//        make.left.top.bottom.mas_equalTo(editBgView);
//        // 左 上 下 都和editBgView对齐
//        make.width.mas_equalTo(1);
//        // 但是这个横线的宽度仅仅为1 ..
//    }];
    
    //阴影效果图片
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"img_projection"];
    [editBgView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.mas_equalTo(editBgView);
        // 左 上 下 都和editBgView对齐
        make.right.mas_equalTo(editBgView.mas_left).offset(-1);
        make.width.mas_equalTo(7);
        // 但是这个横线的宽度仅仅为1 ..
    }];
    
    
    
    
    
    // 创建edit按钮
    UIButton * editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setBackgroundImage:[UIImage imageNamed:@"icon_gexinghua"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [editBgView addSubview:editButton];
    
    [editButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        // 这就简单了 == editBgView
        make.center.mas_equalTo(editBgView);
    }];
    
    
    
    _segmentContainerView = [[UIView alloc] init];
    [_segmentScrollView addSubview:_segmentContainerView];
    _segmentContainerView.layer.borderWidth = 1;
    _segmentContainerView.layer.borderColor = Color_RGBA(244, 244, 244, 1).CGColor;
    [_segmentContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        // edges 其实就是top,left,bottom,right的一个简化
        make.edges.mas_equalTo(_segmentScrollView);
        // 高度 == _segmentScrollView == LPPageVCSegmentHeight
        make.height.mas_equalTo(_segmentScrollView);
    }];
    
    _indicatorView = [[UIView alloc] init];
    _indicatorView.backgroundColor = _higlightTextColor;
    
    [_segmentScrollView addSubview:_indicatorView];
    
    // 内容视图 -- 就是当前VC展示Table的地方
    _contentScrollView = [[UIScrollView alloc] init];
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.scrollsToTop = NO;
    _contentScrollView.delegate = self;
    _contentScrollView.pagingEnabled = YES;
    
    [self.view addSubview:_contentScrollView];
    
    [_contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(_segmentScrollView.mas_bottom);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
    }];
    
    _contentContainerView = [[UIView alloc] init];
    
    [_contentScrollView addSubview:_contentContainerView];
    
    [_contentContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.mas_equalTo(_contentScrollView);
        make.height.mas_equalTo(_contentScrollView);
    }];
    
    
    // Code ..
    
    _segmentTitles = [[NSMutableArray alloc] init];
    
    _reusableVCDic = [[NSMutableDictionary alloc] init];
    
    _doneLayout = NO;
}

#pragma mark - reloadDataAtIndex:index
- (void)reloadDataAtIndex:(NSUInteger)index {
    
    NSString * title = [_dataSource pageVC:self titleAtIndex:index];
    
    [_segmentTitles replaceObjectAtIndex
     :index withObject:title];
    
    UILabel * label = (UILabel *)[_segmentContainerView viewWithTag:1000 + index];
    label.text = title;
    
    UIViewController * oldVC = [_reusableVCDic objectForKey:@(index)];
    [oldVC removeFromParentViewController];
    [oldVC.view removeFromSuperview];
    
    UIViewController * newVC = [_dataSource pageVC:self viewControllerAtIndex:index];
    [self addChildViewController:newVC];
    
    UIView * contentBgView = [_contentContainerView viewWithTag:2000 + index];
    [contentBgView addSubview:newVC.view];
    
    [newVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.mas_equalTo(contentBgView);
    }];
    
    [_reusableVCDic setObject:newVC forKey:@(index)];
    
    if ([_delegate respondsToSelector:@selector(pageVC:didChangeToIndex:fromIndex:)] && _currentIndex == index) {
        [_delegate pageVC:self didChangeToIndex:index fromIndex:-1];
    }
}

#pragma mark - reloadData
- (void)reloadData {
    
    _doneLayout = NO;
    
    [_reusableVCDic removeAllObjects];
    
    _numberOfContent = [_dataSource numberOfContentForPageVC:self];
    
    if (!_numberOfContent) {
        
        return;
    }
    
    [_segmentTitles removeAllObjects];
    
    [_segmentContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_contentContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIView * lastSegmentView = nil;
    UIView * lastContentView = nil;
    
    if ([_delegate respondsToSelector:@selector(pageVC:willChangeToIndex:fromIndex:)]) {
        
        [_delegate pageVC:self willChangeToIndex:0 fromIndex:-1];
    }
    
    _currentIndex = 0;
    
    for (NSInteger index = 0; index < _numberOfContent; ++index) {
        
        // load segment
        
        NSString * title = [_dataSource pageVC:self titleAtIndex:index];
        
        [_segmentTitles addObject:title];
        
        UILabel *label = [[UILabel alloc] init];
        label.userInteractionEnabled = YES;
        label.text = [NSString stringWithFormat:@"%@", title];
        label.textColor = _normalTextColor;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.highlightedTextColor = _higlightTextColor;
        label.tag = 1000 + index;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSegmentItemAction:)];
        [label addGestureRecognizer:tapGesture];
        
        [_segmentContainerView insertSubview:label belowSubview:_indicatorView];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.bottom.mas_equalTo(_segmentContainerView);
            if (lastSegmentView) {
                
                make.left.mas_equalTo(lastSegmentView.mas_right);
            
            } else {
                
                make.left.mas_equalTo(_segmentContainerView.mas_left);
            }
            make.width.mas_equalTo((screenW-LPPageVCSegmentHeight)/2);
        }];
        
        lastSegmentView = label;
        
        UIView * view = [[UIView alloc] init];
        view.tag = 2000 + index;
        
        [_contentContainerView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.bottom.mas_equalTo(_contentContainerView);
            if (lastContentView) {
                
                make.left.mas_equalTo(lastContentView.mas_right);
            
            } else {
            
                make.left.mas_equalTo(_contentContainerView.mas_left);
            }
            make.width.mas_equalTo(CGRectGetWidth([[UIScreen mainScreen] bounds]));
        }];
        
        lastContentView = view;
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = Color_RGBA(223, 223, 223, 1);
        [_segmentContainerView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lastSegmentView).mas_offset(1);
            make.left.mas_equalTo(lastSegmentView.mas_right);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(LPPageVCSegmentHeight-1);
        }];
        
        if (index < 3) {
            
            UIViewController * controller = [_dataSource pageVC:self viewControllerAtIndex:index];
            
            [self addChildViewController:controller];
            
            [_reusableVCDic setObject:controller forKey:@(index)];
            
            [view addSubview:controller.view];
            
            [controller.view mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.edges.mas_equalTo(view);
            }];
        }
    }

    [_segmentContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(lastSegmentView.mas_right);
    }];
    
    [_contentContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(lastContentView.mas_right);
    }];
    
    UILabel *currentLabel = (UILabel *)[_segmentContainerView viewWithTag:1000 + _currentIndex];
    
    currentLabel.highlighted = YES;
    
    [self.view layoutIfNeeded];
    
    CGRect frame = currentLabel.frame;
    
    _indicatorView.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetHeight(frame)-LPPageVCSegmentIndicatorHeight, CGRectGetWidth(frame), LPPageVCSegmentIndicatorHeight);
    
    _contentScrollView.contentOffset = CGPointMake(0, 0);
    
    if ([_delegate respondsToSelector:@selector(pageVC:didChangeToIndex:fromIndex:)]) {
        
        [_delegate pageVC:self didChangeToIndex:0 fromIndex:-1];
    }
}

- (void)tapSegmentItemAction:(UITapGestureRecognizer *)gesture {
    
    UIView *view = [gesture view];
    NSUInteger index = view.tag - 1000;
    
    if ([_delegate respondsToSelector:@selector(pageVC:didClickAtIndex:)]) {
        
        [_delegate pageVC:self didClickAtIndex:index];
    }
    
    [_contentScrollView setContentOffset:CGPointMake(index * CGRectGetWidth(_contentScrollView.frame), 0) animated:YES];
    [CommonTool shareInstance].segmentType = index;
}

#pragma mark - Setter & Getter
- (void)setDataSource:(id<LPPageVCDataSource>)dataSource {
    
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        if (_dataSource) {
            [self reloadData];
        }
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    
    if (_currentIndex != currentIndex) {
        if ([_delegate respondsToSelector:@selector(pageVC:willChangeToIndex:fromIndex:)]) {
            [_delegate pageVC:self willChangeToIndex:currentIndex fromIndex:_currentIndex];
        }
        UILabel *oldLabel = (UILabel *)[_segmentContainerView viewWithTag:1000 + _currentIndex];
        UILabel *newLable = (UILabel *)[_segmentContainerView viewWithTag:1000 + currentIndex];
        oldLabel.highlighted = NO;
        newLable.highlighted = YES;
        _lastIndex = _currentIndex;
        _currentIndex = currentIndex;
        
        [UIView animateWithDuration:0.3 animations:^{
            UILabel *currentLabel = (UILabel *)[_segmentContainerView viewWithTag:1000 + _currentIndex];
            CGRect frame = currentLabel.frame;
            _indicatorView.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetHeight(frame)-LPPageVCSegmentIndicatorHeight, CGRectGetWidth(frame), LPPageVCSegmentIndicatorHeight);
        }];
        
        [self updateSegmentContentOffset];
        
        if ([_delegate respondsToSelector:@selector(pageVC:didChangeToIndex:fromIndex:)]) {
            [_delegate pageVC:self didChangeToIndex:_currentIndex fromIndex:_lastIndex];
        }
    }
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    if (index >= _numberOfContent) {
        
        return nil;
    }
    return _reusableVCDic[@(index)];
}

#pragma mark - Private Function
- (void)updateSegmentContentOffset {
    
    UILabel *currentLabel = (UILabel *)[_segmentContainerView viewWithTag:1000 + _currentIndex];
    CGRect  rect = currentLabel.frame;
    CGFloat midX = CGRectGetMidX(rect);
    CGFloat offset = 0;
    CGFloat contentWidth = _segmentScrollView.contentSize.width;
    CGFloat halfWidth = CGRectGetWidth(_segmentScrollView.bounds) / 2.0;
    if (midX < halfWidth) {
      
        offset = 0;
        
    } else if (midX > contentWidth - halfWidth) {
        
        offset = contentWidth - 2 * halfWidth;
        
    } else {
      
        offset = midX - halfWidth;
    }
    
    [_segmentScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}

- (void)transitionFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
    
    NSInteger removeIndex = 0;
    NSInteger addIndex = 0;
    
//    NSLog(@"%@ - %@", @(fromIndex), @(toIndex));

    if (toIndex > fromIndex) {
      
        removeIndex = fromIndex - 1;
        addIndex = toIndex + 1;
        
    } else {
        
        removeIndex = fromIndex + 1;
        addIndex = toIndex - 1;
    }
    
    if (addIndex >= 0 && addIndex < _numberOfContent) {
        if (!_reusableVCDic[@(addIndex)]) {
            UIViewController *toController = [_dataSource pageVC:self viewControllerAtIndex:addIndex];
            [self addChildViewController:toController];
            [_reusableVCDic setObject:toController forKey:@(addIndex)];
            UIView *contentBgView = [_contentContainerView viewWithTag:2000 + addIndex];
            [contentBgView addSubview:toController.view];
            [toController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(contentBgView);
            }];
        }
    }
    
    if (!_reusableVCDic[@(toIndex)]) {
        UIViewController *toController = [_dataSource pageVC:self viewControllerAtIndex:toIndex];
        [self addChildViewController:toController];
        [_reusableVCDic setObject:toController forKey:@(toIndex)];
        UIView *contentBgView = [_contentContainerView viewWithTag:2000 + toIndex];
        [contentBgView addSubview:toController.view];
        [toController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(contentBgView);
        }];
    }
    
    if (removeIndex >= 0 && removeIndex < _numberOfContent && [_reusableVCDic allKeys].count > LPPageVCMaxVisiblePages) {
        UIViewController *fromController = _reusableVCDic[@(removeIndex)];
        [fromController removeFromParentViewController];
        [fromController.view removeFromSuperview];
        [_reusableVCDic removeObjectForKey:@(removeIndex)];
    }
    
    [self setCurrentIndex:toIndex];
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
}

// 其实是走的 ScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger contentOffsetX = scrollView.contentOffset.x;
    NSInteger index = floor((contentOffsetX - CGRectGetWidth(scrollView.frame) / 2) / CGRectGetWidth(scrollView.frame))+1;
    [self transitionFromIndex:_currentIndex toIndex:index];
    [CommonTool shareInstance].segmentType = index;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    NSInteger contentOffsetX = scrollView.contentOffset.x;
    NSInteger index = floor((contentOffsetX - CGRectGetWidth(scrollView.frame) / 2) / CGRectGetWidth(scrollView.frame))+1;
    [self transitionFromIndex:_currentIndex toIndex:index];
    
    [CommonTool shareInstance].segmentType = index;
}

#pragma mark - Button Action
- (void)editButtonAction {
    
    _editMode = 1 - _editMode;
    
    if ([_delegate respondsToSelector:@selector(pageVC:didClickEditMode:)]) {
        
        [_delegate pageVC:self didClickEditMode:_editMode];
    }
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
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
