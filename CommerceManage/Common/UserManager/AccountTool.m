//
//  AccountTool.m
//  CommerceManage
//
//  Created by 小花 on 2016/12/27.
//  Copyright © 2016年 vaic. All rights reserved.
//

#import "AccountTool.h"

//账号信息存储路径
#define CCAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]

@implementation AccountTool

/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveAccount:(AccountModel *)account
{
    
    //将一个对象写入沙盒 需要用到一个NSKeyedArchiver 自定义对象的存储必须用这个
    [NSKeyedArchiver archiveRootObject:account toFile:CCAccountPath];
}

/**
 *  返回账号信息
 *
 *  @return 账号模型（如果账号过期，我们会返回nil）
 */
+ (AccountModel *)account
{
    //加载模型
    AccountModel *account=[NSKeyedUnarchiver unarchiveObjectWithFile:CCAccountPath];
    
    return account;
    
}

/**
 *  删除账号信息
 *
 *  @return 是否成功
 */
+ (BOOL)deleteAccount
{
    return [[NSFileManager defaultManager] removeItemAtPath:CCAccountPath error:nil];
    
}


/**
 是否登录

 @return 是否登录
 */
+ (BOOL)isLogin {
    
    AccountModel *model = [self account];
    if ([model.userID isEqualToString:@""] || model.userID == nil) {
        return NO;
    }else {
        return YES;
    }
    
}


@end
