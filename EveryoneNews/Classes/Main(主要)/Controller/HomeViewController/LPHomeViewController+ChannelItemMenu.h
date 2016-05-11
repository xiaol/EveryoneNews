//
//  LPHomeViewController+ChannelItemMenu.h
//  EveryoneNews
//
//  Created by dongdan on 15/12/26.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPHomeViewController.h"
#import "LPSortCollectionReusableView.h"



@interface LPHomeViewController (ChannelItemMenu) <UIGestureRecognizerDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, LPSortCollectionReusableViewDelegate, LPMenuCollectionViewCellDelegate>

// 设置所有频道唯一标识
- (void)setCellIdentifierOfAllChannelItems;

// 设置频道和页码对应关系（用于添加删除和交换频道）
- (void)updatePageindexMapToChannelItemDictionary;
@end
