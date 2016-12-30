//
//  CommonTool.h
//  CommerceManage
//
//  Created by 小花 on 2016/12/27.
//  Copyright © 2016年 vaic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonTool : NSObject


/**
 0:讯息   1:协会+
 */
@property (nonatomic, assign) NSInteger segmentType;

+ (instancetype)shareInstance;

@end
