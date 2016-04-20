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

typedef void(^didClickButtonBlock)();

typedef void(^didClickTipButtonBlock)();

@protocol LPHomeViewCellDelegate<NSObject>

//- (void)homeViewCell:(LPHomeViewCell *)cell source:(NSString *)source;

@end
@interface LPHomeViewCell : UITableViewCell

@property (nonatomic, strong) CardFrame *cardFrame;

@property (nonatomic, copy) didClickButtonBlock didClickBlock;

@property (nonatomic, copy) didClickTipButtonBlock didClickTipBlock;

@property (nonatomic, weak) id<LPHomeViewCellDelegate> delegate;

- (void)didClickTipButtonBlock:(didClickTipButtonBlock)didClickTipButtonBlock;
@end
