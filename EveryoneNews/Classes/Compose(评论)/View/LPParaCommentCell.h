//
//  LPParaCommentCell.h
//  EveryoneNews
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPParaCommentFrame;
@class LPParaCommentCell;
@class LPComment;
@class LPUpView;

@protocol  LPParaCommentCellCellDelegate <NSObject>
@optional
- (void)paraCommentCell:(LPParaCommentCell *)cell didClickUpView:(LPUpView *)upView withUpComment:(LPComment *)comment;
@end

@interface LPParaCommentCell : UITableViewCell

@property (nonatomic, strong) LPParaCommentFrame *paraCommentFrame;
@property (nonatomic, weak) id<LPParaCommentCellCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
