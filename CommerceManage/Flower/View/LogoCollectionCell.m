//
//  LogoCollectionCell.m
//  CommerceManage
//
//  Created by 小花 on 2017/1/12.
//  Copyright © 2017年 vaic. All rights reserved.
//

#import "LogoCollectionCell.h"

@implementation LogoCollectionCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setUp];
    }
    return self;
    
}

- (void)setUp {
    [self.contentView addSubview:self.imgView];
    self.imgView.center = self.contentView.center;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        CGFloat width = self.contentView.bounds.size.width*3/4;
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width/155*30)];
//        _imgView.backgroundColor = [UIColor redColor];
    }
    return _imgView;
}




@end
