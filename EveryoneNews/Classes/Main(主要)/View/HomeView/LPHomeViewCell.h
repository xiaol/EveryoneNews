//
//  LPHomeViewCell.h
//  EveryoneNews
//
//  Created by dongdan on 15/12/16.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LPHomeViewFrame;

@interface LPHomeViewCell : UITableViewCell

@property (nonatomic, strong) LPHomeViewFrame *homeViewFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
