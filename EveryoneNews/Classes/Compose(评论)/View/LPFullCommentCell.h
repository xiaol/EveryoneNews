//
//  LPFullCommentCell.h
//  EveryoneNews
//
//  Created by dongdan on 15/10/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LPFullCommentFrame;
@class LPFullCommentCell;
@class LPComment;

@protocol  LPFullCommentCellDelegate <NSObject>
@optional
- (void)fullCommentCell:(LPFullCommentCell *)cell comment:(LPComment *)comment;
@end

@interface LPFullCommentCell : UITableViewCell

@property (nonatomic, strong) UIButton *upButton;
@property (nonatomic, strong) LPFullCommentFrame *fullCommentFrame;
@property (nonatomic, weak) id<LPFullCommentCellDelegate> delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
