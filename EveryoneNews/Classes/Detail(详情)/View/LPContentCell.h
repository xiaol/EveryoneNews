//
//  LPContentCell.h
//  EveryoneNews
//
//  Created by apple on 15/6/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPContentFrame;
@class LPContentCell;
@protocol LPContentCellDelegate <NSObject>

@optional
- (void)tableViewDidReload:(LPContentCell *)contentCell;

@end

@interface LPContentCell : UITableViewCell

@property (nonatomic, strong) LPContentFrame *contentFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id<LPContentCellDelegate> delegate;

@end
