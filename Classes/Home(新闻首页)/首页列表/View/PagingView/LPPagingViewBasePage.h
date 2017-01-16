//
//  LPPagingViewBasePage.h
//  EveryoneNews
//
//  Created by dongdan on 16/8/31.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPPagingViewBasePage;
@protocol LPPagingViewBasePageDelegate<NSObject>

@optional

// 列表页下滑操作
- (void)homeListDidScroll;
// 进入详情页面
- (void)pushDetailViewController;

// 切换频道栏
- (void)switchChannel;

// 下拉刷新
- (void)homeListRefreshData;

@end

@interface LPPagingViewBasePage : UIView

@property (nonatomic, strong) NSMutableArray *cardFrames;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) NSString *pageChannelName;
@property (nonatomic, assign) CGPoint offset;

@property (nonatomic, weak) id<LPPagingViewBasePageDelegate> delegate;

@end
