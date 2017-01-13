//
//  WeatherView.m
//  CommerceManage
//
//  Created by 小花 on 2016/12/26.
//  Copyright © 2016年 vaic. All rights reserved.
//

#import "WeatherView.h"

@interface WeatherView ()

@property (nonatomic, strong) UIImageView   *temperImage;
@property (nonatomic, strong) UILabel       *temperLabel;
@property (nonatomic, strong) UILabel       *line;
@property (nonatomic, strong) UILabel       *dateLabel;
@property (nonatomic, strong) UILabel       *PMLabel;
@property (nonatomic, strong) UIImageView   *weatherImage;
@property (nonatomic, strong) UILabel       *weatherLabel;

@end

@implementation WeatherView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.temperImage];
    [self addSubview:self.temperLabel];
    [self addSubview:self.line];
    [self addSubview:self.dateLabel];
    [self addSubview:self.PMLabel];
    [self addSubview:self.weatherImage];
    [self addSubview:self.weatherLabel];
    
    [self makeSubViewLayout];
}

- (void)makeSubViewLayout {
    
    [self.temperImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(FitSize(15));
        make.left.mas_equalTo(FitSize(10));
        make.width.mas_equalTo(FitSize(12));
        make.height.mas_equalTo(FitSize(26));
    }];
    
    [self.temperLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.temperImage.mas_right).mas_offset(FitSize(3));
        make.top.mas_equalTo(FitSize(15));
        make.width.mas_equalTo(FitSize(45));
        make.height.mas_equalTo(FitSize(26));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.temperLabel.mas_right).mas_offset(FitSize(5));
        make.top.mas_equalTo(FitSize(15));
        make.width.mas_equalTo(FitSize(1));
        make.height.mas_equalTo(FitSize(26));
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(FitSize(15));
        make.left.mas_equalTo(self.line.mas_right).mas_offset(FitSize(10));
        make.width.mas_equalTo(FitSize(200));
        make.height.mas_equalTo(FitSize(10));
    }];
    [self.PMLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dateLabel.mas_bottom).mas_offset(FitSize(7));
        make.left.mas_equalTo(self.line.mas_right).mas_offset(FitSize(10));
        make.width.mas_equalTo(FitSize(200));
        make.height.mas_equalTo(FitSize(10));
    }];
    
    [self.weatherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(FitSize(-7));
        make.right.mas_equalTo(FitSize(-5));
        make.width.mas_equalTo(FitSize(90));
        make.height.mas_equalTo(FitSize(20));
    }];
    
    [self.weatherImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.weatherLabel.mas_top).mas_offset(FitSize(0));
        make.centerX.mas_equalTo(self.weatherLabel.mas_centerX);
        make.width.mas_equalTo(FitSize(20));
        make.height.mas_equalTo(FitSize(18));
    }];
}


- (void)setModel:(WeatherModel *)model {
    self.temperLabel.text = [NSString stringWithFormat:@"%@°C", model.maxW];
    NSString *weatherImg = [NSString stringWithFormat:@"%@%@.png",WEATHER_IMG, model.code];
    [self.weatherImage sd_setImageWithURL:[NSURL URLWithString:weatherImg] placeholderImage:[UIImage imageNamed:@"icon_partly-cloudy"]];
    
    NSString *weather = [NSString stringWithFormat:@"%@ %@/%@°C", model.dayTxt,model.minW,model.maxW];
    self.weatherLabel.text = weather;
    
    NSString *pmText = [NSString stringWithFormat:@"PM %@   限行尾号 %@", model.pmten,  model.carNoLimit];
    self.PMLabel.attributedText = [self getAttributedStringWithString:pmText];
    
    NSString *currentDate = [PublicFunction getCurrentDate];
    NSString *chineseDate = [PublicFunction getChineseCalendarWithDate:currentDate];
    self.dateLabel.text = [NSString stringWithFormat:@"%@  %@", currentDate, chineseDate];
    
}

- (NSAttributedString *)getAttributedStringWithString:(NSString *)text {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    NSInteger length = text.length;
    [attrStr addAttribute:NSForegroundColorAttributeName value:APP_THEME_COLOR range:NSMakeRange(2, 3)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(length-3, 3)];
    return attrStr;
}



- (UIImageView *)temperImage {
    if (!_temperImage) {
        _temperImage = [[UIImageView alloc] init];
        _temperImage.image = [UIImage imageNamed:@"icon_thermometer"];
    }
    return _temperImage;
}

- (UILabel *)temperLabel {
    if (!_temperLabel) {
        _temperLabel = [[UILabel alloc] init];
        _temperLabel.font = [UIFont systemFontOfSize:FitSize(16)];
        _temperLabel.textColor = APP_THEME_COLOR;
        _temperLabel.text = @"-24°C";
    }
    return _temperLabel;
}
- (UILabel *)line {
    if (!_line) {
        _line = [[UILabel alloc] init];
        _line.backgroundColor = [UIColor grayColor];
    }
    return _line;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.text = @"1970-1-1  十一月十四  星期四";
        _dateLabel.font = [UIFont systemFontOfSize:FitSize(14)];
    }
    return _dateLabel;
}

- (UILabel *)PMLabel {
    if (!_PMLabel) {
        _PMLabel = [[UILabel alloc] init];
        NSString *text = @"PM 17   限行尾号 3，8";
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
        NSInteger length = text.length;
        [attrStr addAttribute:NSForegroundColorAttributeName value:APP_THEME_COLOR range:NSMakeRange(2, 3)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(length-3, 3)];
        _PMLabel.font = [UIFont systemFontOfSize:FitSize(13)];
        _PMLabel.attributedText = attrStr;
    }
    return _PMLabel;
}

- (UIImageView *)weatherImage {
    if (!_weatherImage) {
        _weatherImage = [[UIImageView alloc] init];
        _weatherImage.image = [UIImage imageNamed:@"icon_partly-cloudy"];
    }
    return _weatherImage;
}

- (UILabel *)weatherLabel {
    if (!_weatherLabel) {
        _weatherLabel = [[UILabel alloc] init];
//        _weatherLabel.numberOfLines = 0;
        [_weatherLabel sizeToFit];
        _weatherLabel.adjustsFontSizeToFitWidth = YES;
        _weatherLabel.text = @"多云6/-5°C";
        _weatherLabel.textAlignment = NSTextAlignmentCenter;
        _weatherLabel.textColor = APP_THEME_COLOR;
        _weatherLabel.font = [UIFont systemFontOfSize:FitSize(14)];
    }
    return _weatherLabel;
}


@end
