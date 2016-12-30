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
        [self setUp];
    }
    return self;
}

- (void)setUp {
    
    [self.contentView addSubview:self.imgView];
    [self.imgView addSubview:self.grayView];
    [self.grayView addSubview:self.titleLabel];
    [self.grayView addSubview:self.timeLabel];
    
    [self makeSubViewsLayout];
}

- (void)makeSubViewsLayout {
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(FitSize(70));
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(FitSize(25));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(FitSize(5));
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(FitSize(20));
    }];
    
    
}


- (void)setModel:(MessageNewsModel *)model {
    _model = model;
    NSString *imgUrl = [NSString stringWithFormat:@"%@%@", URL_IP_IMG, model.fmImg];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:PLACEHOLDER_IMG];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@", @"工商联", [PublicFunction getDateWith:model.ctime]];
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
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:FitSize(18)];//加粗
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:FitSize(14)];
    }
    return _timeLabel;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
