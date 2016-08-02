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

@interface LPHomeViewCell : UITableViewCell

@property (nonatomic, strong) CardFrame *cardFrame;

@property (nonatomic, copy) didClickDeleteButtonBlock didClickDeleteBlock;

@property (nonatomic, copy) didClickTipButtonBlock didClickTipBlock;


- (void)didClickTipButtonBlock:(didClickTipButtonBlock)didClickTipButtonBlock;

- (void)didClickDeleteButtonBlock:(didClickDeleteButtonBlock)didClickDeleteButtonBlock;

@end
