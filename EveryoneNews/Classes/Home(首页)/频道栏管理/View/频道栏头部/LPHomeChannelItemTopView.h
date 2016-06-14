//
//  LPHomeChannelItemTopView.h
//  EveryoneNews
//
//  Created by dongdan on 16/5/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPHomeChannelItemTopView;
@protocol LPHomeChannelItemTopViewDelegate <NSObject>

@optional
- (void)backButtonDidClick:(LPHomeChannelItemTopView *)homeChannelItemTopView;

@end

@interface LPHomeChannelItemTopView : UIView

@property (nonatomic, weak) id<LPHomeChannelItemTopViewDelegate> delegate;

@end
