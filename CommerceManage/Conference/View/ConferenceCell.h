//
//  ConferenceCell.h
//  CommerceManage
//
//  Created by 小花 on 2016/12/26.
//  Copyright © 2016年 vaic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConferenceModel.h"

@interface ConferenceCell : UITableViewCell
@property (nonatomic, strong) ConferenceModel *model;

@property (nonatomic, copy) void(^joinBlock)(UIButton *sender);
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
