//
//  CountdownView.h
//  EveryoneNews
//
//  Created by apple on 15/5/6.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CircleProgressView;
@class DateScrollView;

@protocol CountdownViewDelegate <NSObject>

@optional
- (void)countdownViewDidCancel;

@end

@interface CountdownView : UIView

@property (nonatomic, assign) int updateTime;

@property (nonatomic, assign) BOOL type;

@property (nonatomic, weak) id<CountdownViewDelegate> delegate;


@property (nonatomic, weak) CircleProgressView *circleView;
@property (nonatomic, weak) DateScrollView *dateView;
@property (nonatomic, weak) UIButton *cancelBtn;

@end
