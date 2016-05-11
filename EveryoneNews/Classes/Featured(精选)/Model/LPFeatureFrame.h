//
//  LPFeatureFrame.h
//  EveryoneNews
//
//  Created by apple on 15/7/30.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPFeature;

@interface LPFeatureFrame : NSObject
@property (nonatomic, strong) LPFeature *feature;
@property (nonatomic, strong) NSMutableArray *contentFrames;


@property (nonatomic, assign) CGRect headerF;
@property (nonatomic, assign) CGRect headerImageViewF;
@property (nonatomic, assign) CGRect filterViewF;
@property (nonatomic, assign) CGRect maskLayerF;
@property (nonatomic, assign) CGRect hudF;
@property (nonatomic, assign) CGRect titleLabelF;

@property (nonatomic, assign) CGRect zhihuViewF;

@property (nonatomic, strong) NSArray *itemFrames;

@property (nonatomic, assign) CGSize viewSize;
@end
