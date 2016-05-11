//
//  LPDetailContentCell.h
//  EveryoneNews
//
//  Created by dongdan on 15/12/31.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPDetailContentFrame;
@interface LPDetailContentCell : UITableViewCell

@property (nonatomic, strong) LPDetailContentFrame *contentFrame;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
