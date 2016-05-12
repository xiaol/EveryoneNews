//
//  LPConcernPressCell.h
//  EveryoneNews
//
//  Created by apple on 15/7/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LPConcernPressFrame;

@interface LPConcernPressCell : UITableViewCell

@property (nonatomic, strong) LPConcernPressFrame *concernPressFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
