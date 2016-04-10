//
//  LPShareCell.h
//  EveryoneNews
//
//  Created by dongdan on 16/3/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LPShareCell;

@protocol LPShareCellDelegate <NSObject>

- (void)cell:(LPShareCell *)shareCell shareIndex:(NSInteger) index;

@end

@interface LPShareCell : UITableViewCell

@property (nonatomic, weak) id<LPShareCellDelegate> delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
