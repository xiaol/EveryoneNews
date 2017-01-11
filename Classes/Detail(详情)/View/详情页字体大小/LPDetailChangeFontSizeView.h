//
//  LPDetailChangeFontSizeView.h
//  EveryoneNews
//
//  Created by dongdan on 16/5/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPDetailChangeFontSizeView;
@class LPFontSize;
@protocol LPDetailChangeFontSizeViewDelegate <NSObject>

@optional

- (void)changeFontSizeView:(LPDetailChangeFontSizeView *)changeFontSizeView reloadTableViewWithFontSize:(LPFontSize *)lpFontSize;

- (void)finishButtonDidClick:(LPDetailChangeFontSizeView *)changeFontSizeView;

@end

@interface LPDetailChangeFontSizeView : UIView

@property (nonatomic, weak) id<LPDetailChangeFontSizeViewDelegate> delegate;

@end
