//
//  SearchViewController.h
//  WoVideo
//
//  Created by haizi on 16/6/29.
//  Copyright © 2016年 hexin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    newsType,
    businessType,
    meettingTypy
} searchVcType;

@interface SearchViewController : UIViewController

@property (nonatomic, assign) searchVcType searchVcType;

@end
