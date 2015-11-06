//
//  LPTagCloudView.h
//  EveryoneNews
//
//  Created by apple on 15/8/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPTagCloudView;

@protocol LPTagCloudViewDelegate <NSObject>
@optional
- (void)tagCloudViewDidClickStartButton:(LPTagCloudView *)tagCloudView ;
@end

@interface LPTagCloudView : UIView
@property (nonatomic, assign) NSInteger pageCapacity;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, weak) id<LPTagCloudViewDelegate> delegate;
@end
