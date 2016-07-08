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

typedef void(^didClickDeleteButtonBlock)(UIButton *deleteButton);

typedef void(^didClickTipButtonBlock)();

typedef void(^didClickTitleBlock) (LPHomeViewCell *cell, CardFrame *cardFrame);

@protocol LPHomeViewCellDelegate<NSObject>

- (void)homeViewCell:(LPHomeViewCell *)cell didSelectedCardFrame:(CardFrame *)cardFrame;

@end
@interface LPHomeViewCell : UITableViewCell

@property (nonatomic, strong) CardFrame *cardFrame;

@property (nonatomic, copy) didClickDeleteButtonBlock didClickDeleteBlock;

@property (nonatomic, copy) didClickTipButtonBlock didClickTipBlock;

@property (nonatomic, copy) didClickTitleBlock didClickTitleBlock;

@property (nonatomic, weak) id<LPHomeViewCellDelegate> delegate;

- (void)didClickTipButtonBlock:(didClickTipButtonBlock)didClickTipButtonBlock;

- (void)didClickDeleteButtonBlock:(didClickDeleteButtonBlock)didClickDeleteButtonBlock;

- (void)didClickTitleBlock:(didClickTitleBlock)didClickTitleBlock;
@end
