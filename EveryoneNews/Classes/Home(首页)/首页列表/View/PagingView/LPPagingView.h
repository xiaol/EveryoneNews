//
//  LPPagingView.h
//  EveryoneNews
//
//  Created by apple on 15/12/1.
//  Copyright © 2015年 apple. All rights reserved.

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

/**
 *  代理方法: 滚动至具体位置时的回调 (不建议使用)
 *
 *  @param pagingView self
 *  @param offsetX    X轴偏移量
 */
- (void)pagingView:(LPPagingView *)pagingView didScrollToOffsetX:(CGFloat)offsetX;

/**
 *  代理方法: 滚动至具体位置时的回调, 告知滚动比例
 *
 *  @param pagingView    self
 *  @param ratio         ratio
 */
- (void)pagingView:(LPPagingView *)pagingView didScrollWithRatio:(CGFloat)ratio;
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

/**
 *  刷新某些页面
 *
 *  @param indexes NSNumber集合
 */
//- (void)reloadPagesAtPageIndexes:(NSArray *)indexes;

/**
 *  刷新某一页
 */
- (void)reloadPageAtPageIndex:(NSInteger)index;

- (UIView *)currentPage;

- (UIView *)pageAtPageIndex:(NSInteger)index;

/**
 *  删除某页
 *
 *  @param index <#index description#>
 */
- (void)deletePageAtIndex:(NSInteger)index;

/**
 *  插入某页
 *
 *  @param index <#index description#>
 */

- (void)insertPageAtIndex:(NSInteger)index;
/**
 *  交换两页
 *
 *  @param idx1 <#idx1 description#>
 *  @param idx2 <#idx2 description#>
 */

- (void)exchangePageAtIndex:(NSInteger)idx1 withPageAtIndex:(NSInteger)idx2;
- (void)movePageFromIndex:(NSInteger)from toIndex:(NSInteger)to;
@end
