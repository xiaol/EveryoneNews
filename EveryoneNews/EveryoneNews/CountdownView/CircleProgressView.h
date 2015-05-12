//
//  CircleProgressView.h
//  EveryoneNews
//
//  Created by apple on 15/5/6.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CircleProgressViewDelegate <NSObject>

@optional
-(void)circleProgressDidFinish;

@end

@interface CircleProgressView : UIView

@property (nonatomic, assign) int updateTime;
@property (nonatomic, weak) id<CircleProgressViewDelegate> delegate;
@end
