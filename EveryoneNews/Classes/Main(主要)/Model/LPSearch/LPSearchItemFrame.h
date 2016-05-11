//
//  LPSearchItemFrame.h
//  EveryoneNews
//
//  Created by dongdan on 16/1/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LPSearchItem;
@interface LPSearchItemFrame : NSObject

@property (nonatomic, assign) CGRect titleFrame;
@property (nonatomic, assign) CGRect sourceFrame;
@property (nonatomic, assign) CGRect seperatorLineFrame;
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) LPSearchItem *searchItem;

@end
