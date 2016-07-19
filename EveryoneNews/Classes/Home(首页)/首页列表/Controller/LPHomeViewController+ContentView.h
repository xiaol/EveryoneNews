//
//  LPHomeViewController+PagingView.h
//  EveryoneNews
//
//  Created by dongdan on 15/12/26.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPHomeViewController.h"
#import "LPPagingViewPage.h"
#import "LPHomeViewCell.h"
#import "LPPagingViewConcernPage.h"


@interface LPHomeViewController (PagingView) <LPPagingViewDataSource, LPPagingViewDelegate, LPPagingViewPageDelegate, UIGestureRecognizerDelegate, LPPagingViewConcernPageDelegate>

// 加载已选频道栏所有数据
- (void)setupInitialPagingViewData;

- (void)loadMoreDataInPageAtPageIndex:(NSInteger)pageIndex;

- (void)channelItemDidAddToCoreData:(NSInteger)pageIndex;

- (void)showLoadingView;

- (void)hideLoadingView;

- (void)handleDataAfterChannelItemChanged:(NSInteger)index;
 
@end
