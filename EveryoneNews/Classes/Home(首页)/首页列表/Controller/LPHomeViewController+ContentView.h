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
- (void)setupPagingViewData;

// 加载更多
- (void)loadMoreDataInPageAtPageIndex:(NSInteger)pageIndex;

// 请求网络数据存储数据库
- (void)channelItemDidAddToCoreData:(NSInteger)pageIndex;

@end
