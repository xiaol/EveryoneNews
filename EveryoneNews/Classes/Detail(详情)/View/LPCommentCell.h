//
//  LPCommentCell.h
//  EveryoneNews
//
//  Created by dongdan on 16/3/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPComment;
@class LPCommentFrame;
@class LPCommentCell;
@protocol LPCommentCellDelegate<NSObject>

@optional
- (void)excellentCommentCell:(LPCommentCell *)commentCell commentFrame:(LPCommentFrame *)commentFrame;

@end

@interface LPCommentCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) LPComment *comment;
@property (nonatomic, strong) LPCommentFrame *commentFrame;
@property (nonatomic, weak) id<LPCommentCellDelegate> delegate;
@property (nonatomic, strong) UIButton *upButton;

@end
