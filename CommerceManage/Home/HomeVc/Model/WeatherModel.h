//
//  WeatherModel.h
//  CommerceManage
//
//  Created by 小花 on 2017/1/12.
//  Copyright © 2017年 vaic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherModel : NSObject

@property (nonatomic, strong) NSString *code;  //天气状态代码
@property (nonatomic, strong) NSString *dayTxt; //白天天气描述
@property (nonatomic, strong) NSString *minW;  //最低温度
@property (nonatomic, strong) NSString *maxW;  //最高气温
@property (nonatomic, strong) NSString *carNoLimit;  //限行车号
@property (nonatomic, strong) NSString *pmten;  //PM
@property (nonatomic, strong) NSString *times;   //当前日期

@end
