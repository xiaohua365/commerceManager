//
//  PublicFunction.h
//  CommerceManage
//
//  Created by 小花 on 2016/12/28.
//  Copyright © 2016年 vaic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicFunction : NSObject


/**
 获得日期时间

 @param ctime 时间戳

 @return 字符串时间
 */
+ (NSString *)getDateWith:(NSString *)ctime;

+ (NSString *)addSeparatorPointForPriceString:(NSString *)str;

//计算内容大小
+ (CGSize)getAutoWidthWith:(NSString *)text andSize:(CGSize)size andFont:(NSInteger)font;

//阳历转农历
+ (NSString *)getChineseCalendarWithDate:(NSString*)date;

//获取当前日期
+ (NSString *)getCurrentDate;
@end
