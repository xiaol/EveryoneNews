//
//  LPRelateCell.h
//  EveryoneNews
//
//  Created by apple on 15/6/12.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPWaterfallViewCell.h"
@class LPWaterfallView, LPRelatePoint;

@interface LPRelateCell : LPWaterfallViewCell

+ (instancetype)cellWithWaterfallView:(LPWaterfallView *)waterfallView;

@property (nonatomic, strong) LPRelatePoint *relatePoint;

@end
