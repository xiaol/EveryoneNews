//
//  RelateCell.h
//  EveryoneNews
//
//  Created by apple on 15/5/20.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "LPWaterfallViewCell.h"
@class LPWaterfallView, Relate;

@interface RelateCell : LPWaterfallViewCell

+ (instancetype)cellWithWaterfallView:(LPWaterfallView *)waterfallView;

@property (nonatomic, strong) Relate *relate;

@end
