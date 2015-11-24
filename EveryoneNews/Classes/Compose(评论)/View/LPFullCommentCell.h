//
//  LPFullCommentCell.h
//  EveryoneNews
//
//  Created by dongdan on 15/10/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LPParaCommentFrame;
@class LPFullCommentCell;
@class LPComment;
@class LPUpView;

@protocol  LPFullCommentCellDelegate <NSObject>
@optional
- (void)fullCommentCell:(LPFullCommentCell *)cell upView:(LPUpView *)upView comment:(LPComment *)comment;
@end

@interface LPFullCommentCell : UITableViewCell
// 点赞视图
@property (nonatomic, strong) LPUpView *upView;
// 评论框
@property (nonatomic, strong) LPParaCommentFrame *paraCommentFrame;
@property (nonatomic, weak) id<LPFullCommentCellDelegate> delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
