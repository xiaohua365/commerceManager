//
//  MessageTableCell.h
//  CommerceManage
//
//  Created by 小花 on 2016/12/26.
//  Copyright © 2016年 vaic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageNewsModel.h"

@interface MessageTableCell : UITableViewCell

@property (nonatomic, strong) MessageNewsModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
