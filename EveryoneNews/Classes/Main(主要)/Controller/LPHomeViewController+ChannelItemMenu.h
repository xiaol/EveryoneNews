//
//  LPHomeViewController+ChannelItemMenu.h
//  EveryoneNews
//
//  Created by dongdan on 15/12/26.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPHomeViewController.h"
#import "LPSortCollectionReusableView.h"

@interface LPHomeViewController (ChannelItemMenu) <UIGestureRecognizerDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, LPSortCollectionReusableViewDelegate>
/**
 *  设置所有频道CellIdentifier
 */
- (void)setCellIdentifierOfAllChannelItems;

- (void)initAllChannelItems;

- (void)updatePageindexMapToChannelItemDictionary;
@end
