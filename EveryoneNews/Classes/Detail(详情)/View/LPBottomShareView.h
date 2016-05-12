//
//  LPBottomShareView.h
//  EveryoneNews
//
//  Created by dongdan on 16/4/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LPBottomShareView;
@protocol LPBottomShareViewDelegate <NSObject>

@optional
- (void)shareView:(LPBottomShareView *)shareView cancelButtonDidClick:(UIButton *)cancelButton;

- (void)shareView:(LPBottomShareView *)shareView index:(NSInteger)index;

@end

@interface LPBottomShareView : UIView


@property (nonatomic, weak) id<LPBottomShareViewDelegate> delegate;

@end
