//
//  HotwordCloud.h
//  EveryoneNews
//
//  Created by apple on 15/9/24.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

//extern const CGFloat wordCloudH;
//extern const CGFloat wordH;
//extern const CGFloat hotwordCloudHeight;

@class HotwordCloud;

@protocol HotwordCloudDelegate <NSObject>

@optional
- (void)hotwordCloud:(HotwordCloud *)hotwordCloud didClickTitle:(NSString *)title;
- (void)hotwordCloudDidChangeWords:(HotwordCloud *)hotwordCloud;
@end

@interface HotwordCloud : UIView

@property (nonatomic, strong) NSArray *hotwords;
@property (nonatomic, weak) id<HotwordCloudDelegate> delegate;

+ (CGFloat)totalHeight;
- (void)stopAnimation;
@end
