//
//  LPSearchHistoryFrame.m
//  EveryoneNews
//
//  Created by dongdan on 16/6/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPSearchHistoryFrame.h"
#import "LPSearchHistoryItem.h"

@implementation LPSearchHistoryFrame


- (void)setSearchHistoryItem:(LPSearchHistoryItem *)searchHistoryItem {
    _searchHistoryItem = searchHistoryItem;
    _historyLabelF = CGRectMake(15, 0, ScreenWidth, 54);
    _seperatorLabelF = CGRectMake(0, CGRectGetMaxY(_historyLabelF), ScreenWidth, 0.5);
    _cellHeight = CGRectGetMaxY(_seperatorLabelF);
}

@end
