//
//  AccountModel.m
//  CommerceManage
//
//  Created by 小花 on 2016/12/27.
//  Copyright © 2016年 vaic. All rights reserved.
//

#import "AccountModel.h"
#import "MJExtension.h"

@implementation AccountModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"userID":@"id"
             };
}

+ (instancetype)AccountStatusWithDict:(NSDictionary *)dict {
    AccountModel *account = [[self alloc] init];
    account.userID = dict[@"id"];
    account.phoneNo = dict[@"phoneNo"];
    account.niceName = dict[@"niceName"];
    account.userName = dict[@"userName"];
    account.imei = dict[@"imei"];
    account.userEmail = dict[@"userEmail"];
    
    return account;
}
/**
 *  当一个对象要归档进沙盒的时候就会调用  归档
 *  目的，在这个方法中说明这个对象的哪些属性写进沙盒
 *  @param encoder <#encoder description#>
 */

- (void)encodeWithCoder:(NSCoder *)encoder
{
 
    [encoder encodeObject:self.phoneNo forKey:@"phoneNo"];
    [encoder encodeObject:self.userID forKey:@"userID"];
    [encoder encodeObject:self.niceName forKey:@"niceName"];
    [encoder encodeObject:self.userName forKey:@"userName"];
    [encoder encodeObject:self.imei forKey:@"imei"];
    [encoder encodeObject:self.userEmail forKey:@"userEmail"];
    //
}

/**
 *  反归档 的时候会调用这个方法  解档
 *  目的：在这个方法中说明这个对象的哪些属性从沙河中解析出来
 从沙河中解析对象 反归档会调用这个方法 需要解析哪些属性
 *  @param decoder <#decoder description#>
 *
 *  @return <#return value description#>
 */
-(instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.phoneNo = [decoder decodeObjectForKey:@"phoneNo"];
        self.userID = [decoder decodeObjectForKey:@"userID"];
        self.niceName = [decoder decodeObjectForKey:@"niceName"];
        self.userName = [decoder decodeObjectForKey:@"userName"];
        self.imei = [decoder decodeObjectForKey:@"imei"];
        self.userEmail = [decoder decodeObjectForKey:@"userEmail"];
    }
    return self;
}


@end
