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
@property (nonatomic, strong) NSString *meetingLoc; //会议地点
@property (nonatomic, strong) NSString *meetingName;
@property (nonatomic, strong) NSString *duration; //持续时间
@property (nonatomic, strong) NSString *status; //状态 0未召开 1正在召开 2会议结束
@property (nonatomic, strong) NSString *meetingTime; //会议召开时间
@property (nonatomic, strong) NSString *qrImg;
@property (nonatomic, strong) NSString *meetingContent; //会议内容
@property (nonatomic, strong) NSString *areaId;
@property (nonatomic, strong) NSString *joinType; //参会状态
@property (nonatomic, strong) NSString *checkType; //签到状态
@property (nonatomic, strong) NSString *ctime;  //发布时间

@end
