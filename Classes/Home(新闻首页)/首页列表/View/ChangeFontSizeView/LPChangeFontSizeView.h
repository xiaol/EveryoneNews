//
//  LPChangeFontSizeView.h
//  EveryoneNews
//
//  Created by dongdan on 16/4/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPChangeFontSizeView;
@class LPFontSize;

@protocol LPChangeFontSizeViewDelegate <NSObject>

@optional

- (void)changeFontSizeView:(LPChangeFontSizeView *)changeFontSizeView reloadTableViewWithFontSize:(LPFontSize *)lpfontSize;

- (void)finishButtonDidClick:(LPChangeFontSizeView *)changeFontSizeView;

@end

@interface LPChangeFontSizeView : UIView

@property (nonatomic, weak) id<LPChangeFontSizeViewDelegate> delegate;

@end
