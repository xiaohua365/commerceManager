//
//  ConferenceCell.m
//  CommerceManage
//
//  Created by 小花 on 2016/12/26.
//  Copyright © 2016年 vaic. All rights reserved.
//

#import "ConferenceCell.h"

@interface ConferenceCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *organLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *joinBtn;
@end

@implementation ConferenceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = nil;
    cellID = NSStringFromClass([self class]);
    ConferenceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ConferenceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
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
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.organLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.joinBtn];
    
    [self makeSubViewLayout];
}

- (void)makeSubViewLayout {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(FitSize(15));
        make.right.mas_equalTo(FitSize(-115));
        make.top.mas_equalTo(FitSize(20));
        make.height.mas_equalTo(FitSize(45));
    }];
    
    [self.organLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(FitSize(15));
        make.width.mas_equalTo(FitSize(80));
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(FitSize(10));
        make.height.mas_equalTo(FitSize(10));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.organLabel.mas_right).mas_offset(FitSize(10));
        make.width.mas_equalTo(FitSize(80));
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(FitSize(10));
        make.height.mas_equalTo(FitSize(10));
    }];
    
    [self.joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(FitSize(-15));
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(FitSize(80));
        make.height.mas_equalTo(FitSize(35));
    }];
}


- (void)joinBtnClick:(UIButton *)sender {
    
    if (self.joinBlock) {
        self.joinBlock(sender);
    }
    
}

- (void)setModel:(ConferenceModel *)model {
    _model = model;
    self.titleLabel.text = model.meetingName;
    self.timeLabel.text = [PublicFunction getDateWith:model.meetingTime];
    if ([model.joinType isEqualToString:@"1"]) {
        self.joinBtn.selected = YES;
    }else{
        self.joinBtn.selected = NO;
    }
    if ([model.checkType isEqualToString:@"1"]) {
        [self.joinBtn setImage:[UIImage imageNamed:@"button_checked_in"] forState:UIControlStateSelected];
    }
    
}




#pragma mark - getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textColor = Color_RGBA(51, 51, 51, 1);
        _titleLabel.font = [UIFont systemFontOfSize:FitSize(15)];
    }
    return _titleLabel;
}


- (UILabel *)organLabel {
    if (!_organLabel) {
        _organLabel = [[UILabel alloc] init];
        _organLabel.textColor = Color_RGBA(153, 153, 153, 1);
        _organLabel.font = [UIFont systemFontOfSize:FitSize(13)];
        _organLabel.text = @"北京工商联";
    }
    return _organLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:FitSize(13)];
        _timeLabel.textColor = Color_RGBA(153, 153, 153, 1);
    }
    return _timeLabel;
}

- (UIButton *)joinBtn {
    if (!_joinBtn) {
        _joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_joinBtn setImage:[UIImage imageNamed:@"button_part"] forState:UIControlStateNormal];
        [_joinBtn setImage:[UIImage imageNamed:@"button_parted"] forState:UIControlStateSelected];
        [_joinBtn addTarget:self action:@selector(joinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _joinBtn;
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
