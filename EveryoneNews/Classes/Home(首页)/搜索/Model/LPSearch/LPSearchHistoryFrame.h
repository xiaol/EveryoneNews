//
//  LPSearchHistoryFrame.h
//  EveryoneNews
//
//  Created by dongdan on 16/6/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPSearchHistoryItem;

@interface LPSearchHistoryFrame : NSObject

@property (nonatomic, assign) CGRect historyLabelF;
@property (nonatomic, assign) CGRect seperatorLabelF;

@property (nonatomic, strong) LPSearchHistoryItem *searchHistoryItem;
@property (nonatomic, assign) CGFloat cellHeight;

@end
