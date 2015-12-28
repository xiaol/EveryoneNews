//
//  LPHomeViewController+PagingView.h
//  EveryoneNews
//
//  Created by dongdan on 15/12/26.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPHomeViewController.h"

@interface LPHomeViewController (PagingView) <LPPagingViewDataSource, LPPagingViewDelegate>

- (void)setInitialChannelItemDictionary;
- (void)loadMoreDataInPageAtPageIndex:(NSInteger)pageIndex;
@end
