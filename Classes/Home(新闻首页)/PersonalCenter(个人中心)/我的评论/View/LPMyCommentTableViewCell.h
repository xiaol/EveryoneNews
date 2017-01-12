//
//  LPMyCommentTableViewCell.h
//  EveryoneNews
//
//  Created by dongdan on 16/6/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LPMyCommentFrame;
@class LPMyCommentTableViewCell;


@protocol LPMyCommentTableViewCellDelegate <NSObject>

- (void)didTapTitleView:(LPMyCommentTableViewCell *)cell commentFrame:(LPMyCommentFrame *)commentFrame;
- (void)deleteButtonDidClick:(LPMyCommentTableViewCell *)cell commentFrame:(LPMyCommentFrame *)commentFrame;
- (void)upButtonDidClick:(LPMyCommentTableViewCell *)cell;

@end

@interface LPMyCommentTableViewCell : UITableViewCell

@property (nonatomic, strong) LPMyCommentFrame *commentFrame;
@property (nonatomic, weak) id<LPMyCommentTableViewCellDelegate> delegate;


@end
