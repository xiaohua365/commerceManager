//
//  TableHeaderView.m
//  CommerceManage
//
//  Created by 小花 on 2016/12/26.
//  Copyright © 2016年 vaic. All rights reserved.
//

#import "TableHeaderView.h"

@interface TableHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *line;

@end

@implementation TableHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.backgroundColor = [UIColor whiteColor];
    _line = [[UIView alloc] initWithFrame:CGRectMake(FitSize(10), FitSize(15), 4, FitSize(20))];
    _line.backgroundColor = APP_THEME_COLOR;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(FitSize(30), FitSize(15), 200, FitSize(20))];
    _titleLabel.font = [UIFont systemFontOfSize:FitSize(16)];
    
    [self addSubview:_line];
    [self addSubview:_titleLabel];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}


@end
