//
//  LPPagingView.h
//  EveryoneNews
//
//  Created by apple on 15/12/1.
//  Copyright © 2015年 apple. All rights reserved.
//

/**
 *  paging view API
 */

#import <UIKit/UIKit.h>

@class LPPagingView;

/**
 *  paging view 数据源
 */
@protocol LPPagingViewDataSource <NSObject>

@required
/**
 *  数据源必选方法: 给出page元件的个数
 *
 *  @param pagingView self
 *
 *  @return page的个数
 */
- (NSInteger)numberOfPagesInPagingView:(LPPagingView *)pagingView;
/**
 *  数据源必选方法: 实现page元件
 *
 *  @param pagingView self
 *  @param pageIndex  元件索引
 *
 *  @return page
 */
- (UIView *)pagingView:(LPPagingView *)pagingView pageForPageIndex:(NSInteger)pageIndex;
@end

/**
 *  paging view 代理
 */
@protocol LPPagingViewDelegate <UIScrollViewDelegate>

@optional
/**
 *  代理方法: 滚动至第pageIndex页时的回调
 *
 *  @param pagingView self
 *  @param pageIndex  页码
 */
- (void)pagingView:(LPPagingView *)pagingView didScrollToPageIndex:(NSInteger)pageIndex;

@end

@interface LPPagingView : UIScrollView <UIScrollViewDelegate>
/**
 *  数据源属性
 */
@property (nonatomic, weak) id<LPPagingViewDataSource> dataSource;
/**
 *  代理属性
 */
@property (nonatomic, weak) id<LPPagingViewDelegate> delegate;
/**
 *  当前页码
 */
@property (nonatomic, assign) NSInteger currentPageIndex;

/**
 *  设置当前页码, 以动画方式滚动至此
 *
 *  @param currentPageIndex 页码
 *  @param animated         是否有动画
 */
- (void)setCurrentPageIndex:(NSInteger)currentPageIndex animated:(BOOL)animated;

/**
 *  元件出池方法
 *
 *  @param identifier 复用ID
 *
 *  @return 元件
 */
- (UIView *)dequeueReusablePageWithIdentifier:(NSString *)identifier;
/**
 *  注册元件类型
 *
 *  @param identifier 复用ID
 */
- (void)registerClass:(Class)pageClass forPageWithReuseIdentifier:(NSString *)identifier;

/**
 *  刷新 paging view
 */
- (void)reloadData;

@end
