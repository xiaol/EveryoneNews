//
//  LPConcernPressFrame.h
//  EveryoneNews
//
//  Created by apple on 15/7/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LPConcernPress;

@interface LPConcernPressFrame : NSObject
@property (nonatomic, assign, readonly) CGRect titleLabelF;
@property (nonatomic, assign, readonly) CGRect tagLabelF;
@property (nonatomic, assign, readonly) CGRect imageViewF;
@property (nonatomic, assign, readonly) CGFloat cellHeight;
@property (nonatomic, strong) LPConcernPress *concernPress;
@end
