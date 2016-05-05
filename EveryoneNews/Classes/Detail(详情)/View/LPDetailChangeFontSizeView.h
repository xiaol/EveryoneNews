//
//  LPDetailChangeFontSizeView.h
//  EveryoneNews
//
//  Created by dongdan on 16/5/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPDetailChangeFontSizeView;
@protocol LPDetailChangeFontSizeViewDelegate <NSObject>

@optional
- (void)changeFontSizeView:(LPDetailChangeFontSizeView *)changeFontSizeView reloadTableViewWithFontSize:(NSInteger)fontSize fontSizeType:(NSString *)fontSizeType currentDetailContentFontSize:(NSInteger)currentDetailContentFontSize currentDetaiTitleFontSize:(NSInteger)currentDetaiTitleFontSize currentDetailCommentFontSize:(NSInteger)currentDetailCommentFontSize currentDetailRelatePointFontSize:(NSInteger)currentDetailRelatePointFontSize currentDetailSourceFontSize:(NSInteger)currentDetailSourceFontSize;

- (void)finishButtonDidClick:(LPDetailChangeFontSizeView *)changeFontSizeView;

@end

@interface LPDetailChangeFontSizeView : UIView

@property (nonatomic, assign) NSInteger homeViewFontSize;

// 详情页内容字体大小
@property (nonatomic, assign) NSInteger currentDetailContentFontSize;
// 详情页标题字体大小
@property (nonatomic, assign) NSInteger currentDetaiTitleFontSize;
// 详情页来源字体大小
@property (nonatomic, assign) NSInteger currentDetailSourceFontSize;
// 详情页评论字体大小
@property (nonatomic, assign) NSInteger currentDetailCommentFontSize;

@property (nonatomic, assign) NSInteger currentDetailRelatePointFontSize;

@property (nonatomic, weak) id<LPDetailChangeFontSizeViewDelegate> delegate;

@end
