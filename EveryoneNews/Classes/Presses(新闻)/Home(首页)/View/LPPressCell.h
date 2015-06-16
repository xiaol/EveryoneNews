//
//  LPPressCell.h
//  EveryoneNews
//
//  Created by apple on 15/5/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPPressFrame;

@interface LPPressCell : UITableViewCell

@property (nonatomic, strong) LPPressFrame *pressFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
