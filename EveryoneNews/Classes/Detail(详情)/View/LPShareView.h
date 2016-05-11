//
//  LPShareView.h
//  EveryoneNews
//
//  Created by dongdan on 16/3/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPShareView;

@protocol LPShareViewDelegate <NSObject>

@optional
- (void)view:(LPShareView *)view didClickAtIndex:(NSInteger)index;

@end
@interface LPShareView : UIView

@property (nonatomic, weak) id<LPShareViewDelegate> delegate;
@end
