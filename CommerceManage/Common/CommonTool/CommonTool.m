//
//  CommonTool.m
//  CommerceManage
//
//  Created by 小花 on 2016/12/27.
//  Copyright © 2016年 vaic. All rights reserved.
//

#import "CommonTool.h"


static CommonTool* _instance = nil;
@implementation CommonTool

+ (instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        _instance.segmentType = 0; //初始为0 即：初始时是讯息
    }) ;
    
    return _instance ;
}



@end
