//
//  PublicFunction.m
//  CommerceManage
//
//  Created by 小花 on 2016/12/28.
//  Copyright © 2016年 vaic. All rights reserved.
//

#import "PublicFunction.h"

@implementation PublicFunction

+ (NSString *)getDateWith:(NSString *)ctime {
    
    NSTimeInterval time=[ctime doubleValue]/1000;
    NSDate * detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
    
}

+ (NSString *)addSeparatorPointForPriceString:(NSString *)str {
    NSMutableString *priceStr = str.mutableCopy;
    NSRange range = [priceStr rangeOfString:@"."];
    NSInteger index = 0;
    if (range.length > 0 ) {
        index = range.location;
    }else {
        index = str.length;
    }
    while ((index - 3) > 0) {
        index -= 3;
        [priceStr insertString:@"," atIndex:index];
    }
    priceStr = [priceStr stringByReplacingOccurrencesOfString:@"." withString:@","].mutableCopy;
    
    return priceStr;
}


+ (CGSize)getAutoWidthWith:(NSString *)text andSize:(CGSize)size andFont:(NSInteger)font {
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    CGSize textSize = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return textSize;
}


+ (NSString *)getChineseCalendarWithDate:(NSString*)date{
    
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
                             @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",
                             @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
                             @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",
                             @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
                             @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];
    
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    
    
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    NSArray *chineseWeekDays = [NSArray arrayWithObjects:
                                @"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"
                                , nil];
    
    //    [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    NSDate *dateTemp = nil;
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    
    dateTemp = [dateFormater dateFromString:date];
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay |  NSCalendarUnitWeekday;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:dateTemp];
    
    NSLog(@"%ld_%ld_%ld  %@",(long)localeComp.year,(long)localeComp.month,(long)localeComp.day, localeComp.date);
    
//    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    NSString *week_day = [chineseWeekDays objectAtIndex:localeComp.weekday-1];
    
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@%@  %@",m_str,d_str,week_day];
    
    
    
    return chineseCal_str;
}

+ (NSString *)getCurrentDate {
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    return dateString;
}


@end
