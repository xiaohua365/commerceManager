//
//  AccountModel.h
//  CommerceManage
//
//  Created by 小花 on 2016/12/27.
//  Copyright © 2016年 vaic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountModel : NSObject <NSCoding>

@property (nonatomic, strong) NSString *phoneNo;
@property (nonatomic, strong) NSString *niceName;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *imei;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userEmail;

+ (instancetype)AccountStatusWithDict: (NSDictionary *)dict;

@end
