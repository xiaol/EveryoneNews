//
//  LPFeature.h
//  EveryoneNews
//
//  Created by apple on 15/7/28.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPFeature : NSObject
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *headerImg;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, strong) NSArray *zhihuPoints;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSArray *contents;
@property (nonatomic, assign, getter = isFromFront) BOOL fromFront;
- (NSMutableAttributedString *)titleString;
@end
