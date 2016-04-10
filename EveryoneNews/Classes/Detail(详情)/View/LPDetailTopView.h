//
//  LPDetailTopView.h
//  EveryoneNews
//
//  Created by dongdan on 15/11/19.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LPDetailTopView;

@protocol LPDetailTopViewDelegate <NSObject>

@optional
- (void)backButtonDidClick:(LPDetailTopView *)detailTopView;
- (void)fulltextCommentDidClick:(LPDetailTopView *)detailTopView;

@end
@interface LPDetailTopView : UIView

@property (nonatomic, assign) NSInteger badgeNumber;
@property (nonatomic, weak) id<LPDetailTopViewDelegate> delegate;

@end
