//
//  LPContentCell.h
//  EveryoneNews
//
//  Created by apple on 15/6/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPContentFrame;

@interface LPContentCell : UITableViewCell

@property (nonatomic, strong) LPContentFrame *contentFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
