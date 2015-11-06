//
//  ContentCell.h
//  EveryoneNews
//
//  Created by apple on 15/10/27.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContentFrame;

@interface ContentCell : UITableViewCell
@property (nonatomic, strong) ContentFrame *contentFrame;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
