//
//  PublicFunction.h
//  CommerceManage
//
//  Created by 小花 on 2016/12/28.
//  Copyright © 2016年 vaic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicFunction : NSObject

+ (NSString *)getDateWith:(NSString *)ctime;

+ (NSString *)addSeparatorPointForPriceString:(NSString *)str;

@end
