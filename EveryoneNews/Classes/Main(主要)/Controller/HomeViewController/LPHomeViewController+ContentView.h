//
//  LPHomeViewController+PagingView.h
//  EveryoneNews
//
//  Created by dongdan on 15/12/26.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPHomeViewController.h"
#import "LPPagingViewPage.h"

@interface LPHomeViewController (PagingView) <LPPagingViewDataSource, LPPagingViewDelegate, LPPagingViewPageDelegate, UIGestureRecognizerDelegate>

- (void)setInitialChannelItemDictionary;
- (void)loadMoreDataInPageAtPageIndex:(NSInteger)pageIndex;
- (void)loadIndictorShow;
- (void)channelItemDidAddToCoreData:(NSInteger)pageIndex;
@end
