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

@property (nonatomic, assign) CGRect titleF;
@property (nonatomic, assign) CGRect imageViewF;
@property (nonatomic, assign) CGRect sourceSiteF;
@property (nonatomic, assign) CGRect seperatorViewF;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) NSInteger currentRowIndex;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, copy)  NSMutableAttributedString *titleHtmlString;

@end
