//
//  LPPagingViewVideoPage.h
//  EveryoneNews
//
//  Created by dongdan on 2017/1/3.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "LPPagingViewBasePage.h"

@class LPPagingViewVideoPage;
@class LPVideoDetailViewController;
@class Card;
@class LPLoadingView;

@protocol LPPagingViewVideoPageDelegate<LPPagingViewBasePageDelegate>

@optional
- (void)videoPage:(LPPagingViewVideoPage *)videoPage pushViewController:(LPVideoDetailViewController *)videoDetailController;
- (void)videoPage:(LPPagingViewVideoPage *)videoPage card:(Card *)card;

@end

@interface LPPagingViewVideoPage : LPPagingViewBasePage

- (void)autotomaticLoadNewData;
- (void)tapStatusBarScrollToTop;

// 正在加载视图
@property (nonatomic, strong) LPLoadingView *loadingView;


@end
