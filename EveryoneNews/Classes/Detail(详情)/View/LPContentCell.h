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

@protocol  LPContentCellDelegate <NSObject>

@optional
- (void)contentCellDidClickCommentView:(LPContentCell *)cell;
- (void)contentCell:(LPContentCell *)cell didVisitOpinionURL:(NSString *)url;
@end

@interface LPContentCell : UITableViewCell

@property (nonatomic, strong) LPContentFrame *contentFrame;
@property (nonatomic, weak) id<LPContentCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSInteger)identifier;

@end
