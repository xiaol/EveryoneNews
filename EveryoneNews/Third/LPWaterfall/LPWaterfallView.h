//
//  LPWaterfallView.h
//  WaterFlow
//
//  Created by apple on 15/4/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LPWaterfallViewMarginTypeTop,
    LPWaterfallViewMarginTypeBottom,
    LPWaterfallViewMarginTypeLeft,
    LPWaterfallViewMarginTypeRight,
    LPWaterfallViewMarginTypeColumn, // 每一列
    LPWaterfallViewMarginTypeRow, // 每一行
}LPWaterfallViewMarginType;

@class LPWaterfallView;
@class LPWaterfallViewCell;

#pragma mark - 数据源方法

@protocol LPWaterfallViewDataSource <NSObject>

@required
/**
 *  一共有多少个数据
 */
- (NSUInteger)numberOfCellsInWaterfallView:(LPWaterfallView *)waterfallView;
/**
 *  返回index位置对应的cell
 */
- (LPWaterfallViewCell *)waterfallView:(LPWaterfallView *)waterfallView cellAtIndex:(NSUInteger)index;

@optional
/**
 *  一共有多少列
 */
- (NSUInteger)numberOfColumnsInWaterfallView:(LPWaterfallView *)waterfallView;

@end

#pragma mark - 代理方法
@protocol LPWaterfallViewDelegate <UIScrollViewDelegate>
@optional
/**
 *  第index位置cell对应的高度
 */
- (CGFloat)waterfallView:(LPWaterfallView *)waterfallView heightAtIndex:(NSUInteger)index;
/**
 *  选中第index位置的cell
 */
- (void)waterfallView:(LPWaterfallView *)waterfallView didSelectAtIndex:(NSUInteger)index;
/**
 *  返回间距
 */
- (CGFloat)waterfallView:(LPWaterfallView *)waterfallView marginForType:(LPWaterfallViewMarginType)type;
@end



@interface LPWaterfallView : UIScrollView
/**
 *  数据源
 */
@property (nonatomic, weak) id<LPWaterfallViewDataSource> dataSource;
/**
 *  代理
 */
@property (nonatomic, weak) id<LPWaterfallViewDelegate> delegate;

/**
 *  刷新数据（只要调用这个方法，会重新向数据源和代理发送请求，请求数据）
 */
// - (void)reloadData;
- (void)reloadData;

/**
 *  cell的宽度
 */
- (CGFloat)cellWidth;

- (CGFloat)waterfallHeight;

/**
 *  根据标识去缓存池去查找可循环利用的cell
 *
 *  @param identifier
 *
 *  @return
 */
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;


@end
