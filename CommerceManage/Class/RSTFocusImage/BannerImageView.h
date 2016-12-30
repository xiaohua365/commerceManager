//
//  BannerImageView.h
//  CommerceManage
//
//  Created by 小花 on 2016/12/26.
//  Copyright © 2016年 vaic. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol tapImageViewDelegate <NSObject>

- (void)tapImageViewDelegateAction;

@end

@interface BannerImageView : UIView

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIView *grayView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, weak) id<tapImageViewDelegate>delegate;

@end
