//
//  LPContentFrame.h
//  EveryoneNews
//
//  Created by apple on 15/6/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LPContent;
@interface LPContentFrame : NSObject
@property (nonatomic, strong) LPContent *content;
@property (nonatomic, assign) CGRect bodyLabelF;
@property (nonatomic, assign) CGRect upBtnF;
@property (nonatomic, assign) CGRect userIconF;
@property (nonatomic, assign) CGRect commentLabelF;
@property (nonatomic, assign) CGRect commentsCountBtnF;
@property (nonatomic, assign) CGRect plusBtnF;
@property (nonatomic, assign) CGRect commentViewF;

@property (nonatomic ,assign) CGRect abstractSeperatorViewF;

// 针对图像cell
@property (nonatomic, assign) CGRect photoViewF;
@property (nonatomic, assign) CGRect photoDescViewF;

// opinion cell
@property (nonatomic, assign) CGRect dividerViewF;
@property (nonatomic, assign) CGRect arrowViewF;
@property (nonatomic, assign) CGRect pointerViewF;
@property (nonatomic, assign) CGRect iconViewF;
@property (nonatomic, assign) CGRect sourceViewF;
@property (nonatomic, assign) CGRect supplementViewF;

@property (nonatomic, assign) CGFloat cellHeight;
@end
