//
//  PressCell.h
//  EveryoneNews
//
//  Created by apple on 15/10/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Press;
@class PressCell;
extern const CGFloat pressCellH;
extern const CGFloat pressThumbnailW;
extern const CGFloat pressThumbnailH;

@protocol PressCellDelegate <NSObject>
@optional
- (void)pressCell:(PressCell *)pressCell didRefreshPress:(Press *)press;
@end

@interface PressCell : UITableViewCell
@property (nonatomic, strong) Press *press;
@property (nonatomic, weak) id<PressCellDelegate> delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
