//
//  AccountTool.h
//  CommerceManage
//
//  Created by 小花 on 2016/12/27.
//  Copyright © 2016年 vaic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountModel.h"

@interface AccountTool : NSObject

/**
*  存储账号信息
*
*  @param account 账号模型
*/
+ (void)saveAccount:(AccountModel *)account;

/**
*  返回账号信息
*
*  @return 账号模型（如果账号过期，我们会返回nil）
*/
+ (AccountModel *)account;

/**
*  删除账号信息
*
*  @return 是否成功
*/
+(BOOL)deleteAccount;

/**
 是否登录

 @return 是否登录
 */
+ (BOOL)isLogin;

@end
