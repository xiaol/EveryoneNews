//
//  LPChangeFontSizeView.h
//  EveryoneNews
//
//  Created by dongdan on 16/4/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPChangeFontSizeView;

@protocol LPChangeFontSizeViewDelegate <NSObject>

@optional
- (void)changeFontSizeView:(LPChangeFontSizeView *)changeFontSizeView reloadTableViewWithFontSize:(NSInteger)fontSize fontSizeType:(NSString *)fontSizeType currentDetailContentFontSize:(NSInteger)currentDetailContentFontSize currentDetaiTitleFontSize:(NSInteger)currentDetaiTitleFontSize currentDetailCommentFontSize:(NSInteger)currentDetailCommentFontSize currentDetailRelatePointFontSize:(NSInteger)currentDetailRelatePointFontSize;

- (void)finishButtonDidClick:(LPChangeFontSizeView *)changeFontSizeView;

@end

@interface LPChangeFontSizeView : UIView

@property (nonatomic, assign) NSInteger homeViewFontSize;

// 详情页内容字体大小
@property (nonatomic, assign) NSInteger currentDetailContentFontSize;
// 详情页标题字体大小
@property (nonatomic, assign) NSInteger currentDetaiTitleFontSize;

// 详情页评论字体大小
@property (nonatomic, assign) NSInteger currentDetailCommentFontSize;

@property (nonatomic, assign) NSInteger currentDetailRelatePointFontSize;

@property (nonatomic, weak) id<LPChangeFontSizeViewDelegate> delegate;

@end
