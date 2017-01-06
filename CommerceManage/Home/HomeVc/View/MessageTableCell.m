//
//  MessageTableCell.m
//  CommerceManage
//
//  Created by 小花 on 2016/12/26.
//  Copyright © 2016年 vaic. All rights reserved.
//

#import "MessageTableCell.h"

@interface MessageTableCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIView *grayView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation MessageTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = nil;
    cellID = NSStringFromClass([self class]);
    MessageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[MessageTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
    
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUp];
    }
    return self;
}

- (void)setUp {
    
    [self.contentView addSubview:self.imgView];
//    [self.imgView addSubview:self.grayView];
//    [self.grayView addSubview:self.titleLabel];
//    [self.grayView addSubview:self.timeLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    
    [self makeSubViewsLayout];
}

- (void)makeSubViewsLayout {
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(FitSize(15));
        make.right.mas_equalTo(FitSize(-15));
        make.width.mas_equalTo(FitSize(120));
        make.height.mas_equalTo(FitSize(75));
    }];
    
//    [self.grayView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
//    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(FitSize(15));
        make.left.mas_equalTo(FitSize(15));
        make.right.mas_equalTo(self.imgView.mas_left).mas_offset(FitSize(-5));
        make.height.mas_equalTo(FitSize(45));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-FitSize(10));
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.imgView.mas_left).mas_offset(FitSize(-15));
        make.height.mas_equalTo(FitSize(20));
    }];
    
    
}


- (void)setModel:(MessageNewsModel *)model {
    _model = model;
    NSString *imgUrl = [NSString stringWithFormat:@"%@%@", URL_IP_IMG, model.fmImg];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:PLACEHOLDER_IMG];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@", @"北京工商联", [PublicFunction getDateWith:model.ctime]];
    self.titleLabel.text = model.title;
    
}



- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}

- (UIView *)grayView {
    if (!_grayView) {
        _grayView = [[UIView alloc] init];
        _grayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }
    return _grayView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:FitSize(17)];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = Color_RGBA(51, 51, 51, 1);
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = Color_RGBA(153, 153, 153, 1);
        _timeLabel.font = [UIFont systemFontOfSize:FitSize(15)];
    }
    return _timeLabel;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
