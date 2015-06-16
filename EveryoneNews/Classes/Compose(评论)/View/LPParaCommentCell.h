//
//  LPParaCommentCell.h
//  EveryoneNews
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPParaCommentFrame;

@interface LPParaCommentCell : UITableViewCell

@property (nonatomic, strong) LPParaCommentFrame *paraCommentFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
