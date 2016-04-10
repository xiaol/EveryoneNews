//
//  LPHomeViewCell.h
//  EveryoneNews
//
//  Created by dongdan on 15/12/16.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPHomeViewCell;

@class CardFrame;

typedef void(^didClickButtonBlock)(UIButton * button);

@protocol LPHomeViewCellDelegate<NSObject>

//- (void)homeViewCell:(LPHomeViewCell *)cell source:(NSString *)source;

@end
@interface LPHomeViewCell : UITableViewCell

@property (nonatomic, strong) CardFrame *cardFrame;

@property (nonatomic, copy) didClickButtonBlock didClickBlock;
//- (void)setDidClickButtonBlock:(didClickButtonBlock)didClickButtonBlock;

@property (nonatomic, weak) id<LPHomeViewCellDelegate> delegate;
@end
