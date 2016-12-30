//
//  ConferenceModel.h
//  CommerceManage
//
//  Created by 小花 on 2016/12/29.
//  Copyright © 2016年 vaic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConferenceModel : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *meetingLoc;
@property (nonatomic, strong) NSString *meetingName;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *meetingTime;
@property (nonatomic, strong) NSString *qrImg;
@property (nonatomic, strong) NSString *meetingContent;
@property (nonatomic, strong) NSString *areaId;
@property (nonatomic, strong) NSString *joinType; //参会状态
@property (nonatomic, strong) NSString *checkType; //签到状态

@end
