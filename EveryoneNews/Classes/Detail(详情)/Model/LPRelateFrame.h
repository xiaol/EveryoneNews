//
//  LPRelateFrame.h
//  EveryoneNews
//
//  Created by dongdan on 16/3/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPRelatePoint;
@interface LPRelateFrame : NSObject

@property (nonatomic, strong) LPRelatePoint *relatePoint;

@property (nonatomic, assign) CGRect datelayerF;
@property (nonatomic, assign) CGRect dateF;
@property (nonatomic, assign) CGPoint circlePoint;
@property (nonatomic, assign) CGFloat circleRadius;
@property (nonatomic, assign) CGRect contentLayerF;
@property (nonatomic, assign) CGRect contentImageViewF;
@property (nonatomic, assign) CGRect contentF;
@property (nonatomic, assign) CGRect imageViewF;

@end
