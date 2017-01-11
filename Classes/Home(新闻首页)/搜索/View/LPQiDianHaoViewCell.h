//
//  LPQiDianHaoViewCell.h
//  EveryoneNews
//
//  Created by dongdan on 16/7/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPQiDianHaoViewCell;
@class LPQiDianHao;

@protocol LPQiDianHaoViewCellDelegate <NSObject>

@optional
- (void)cell:(LPQiDianHaoViewCell *)cell didTapImageViewWithQiDianArray:(NSArray *)array;
- (void)cell:(LPQiDianHaoViewCell *)cell didTapImageViewWithQiDianHao:(LPQiDianHao *)qiDianHao;

@end

@interface LPQiDianHaoViewCell : UITableViewCell

@property (nonatomic, weak) id<LPQiDianHaoViewCellDelegate> delegate;


- (void)setupQiDianHaoWithArray:(NSArray *)array;

@end
