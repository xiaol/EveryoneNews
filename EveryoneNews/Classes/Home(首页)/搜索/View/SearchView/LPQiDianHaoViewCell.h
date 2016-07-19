//
//  LPQiDianHaoViewCell.h
//  EveryoneNews
//
//  Created by dongdan on 16/7/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPQiDianHaoViewCell;
@protocol LPQiDianHaoViewCellDelegate <NSObject>

@optional
- (void)cell:(LPQiDianHaoViewCell *)cell didTapWithQiDianMoreImageView:(UIImageView *)imageView;


@end

@interface LPQiDianHaoViewCell : UITableViewCell

@property (nonatomic, weak) id<LPQiDianHaoViewCellDelegate> delegate;

@end
