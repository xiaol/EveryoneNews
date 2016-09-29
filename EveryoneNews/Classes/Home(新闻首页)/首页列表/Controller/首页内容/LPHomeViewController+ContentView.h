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

// 加载更多
- (void)loadMoreDataInPageAtPageIndex:(NSInteger)pageIndex;

- (void)loadDataAtPageIndex:(NSInteger)pageIndex basePage:(LPPagingViewBasePage *)basePage;

@end
