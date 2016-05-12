//
//  LPMenuCollectionViewCell.h
//  EveryoneNews
//
//  Created by dongdan on 15/12/11.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPChannelItem.h"

@class LPMenuButton;
@class LPMenuCollectionViewCell;
@protocol LPMenuCollectionViewCellDelegate <NSObject>

@optional
- (void)didClickMenuCollectionViewCell:(LPMenuCollectionViewCell *)menuCollectionViewCell;

@end

@interface LPMenuCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) LPChannelItem *channelItem;
@property (nonatomic, strong) LPMenuButton *menuButton;

@property (nonatomic, weak) id<LPMenuCollectionViewCellDelegate> delegate;

@end
