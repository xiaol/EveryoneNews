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
@interface LPCommentCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) LPComment *comment;
@property (nonatomic, strong) LPCommentFrame *commentFrame;

@end
