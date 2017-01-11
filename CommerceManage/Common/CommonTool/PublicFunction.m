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



@end
