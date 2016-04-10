//
//  LPRelateCell.h
//  EveryoneNews
//
//  Created by dongdan on 16/3/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPRelateFrame;
@class LPRelateCell;

@protocol LPRelateCellDelegate <NSObject>

@optional
- (void)relateCell:(LPRelateCell *)cell didClickURL:(NSString *)url;

@end
@interface LPRelateCell : UITableViewCell

@property (nonatomic, strong) LPRelateFrame *relateFrame;

@property (nonatomic, weak)  id<LPRelateCellDelegate> delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
