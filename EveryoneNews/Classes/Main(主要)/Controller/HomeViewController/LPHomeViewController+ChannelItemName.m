//
//  LPHomeViewController+ChannelItemName.m
//  EveryoneNews
//
//  Created by dongdan on 16/4/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPHomeViewController+ChannelItemName.h"
#import "LPChannelItemTool.h"

@implementation LPHomeViewController (ChannelItemName)

#pragma mark - 初始化所有频道名称
- (void)initializeChannelItemName {
    self.channelItemsArray =  [LPChannelItemTool getChannelItems];
    // 已选分类
    for (LPChannelItem *channelItem in self.channelItemsArray) {
        if([channelItem.channelIsSelected  isEqual: @"1"]) {
            [self.selectedArray addObject:channelItem];
        }
    }
    // 可选分类
    for (LPChannelItem *channelItem in self.channelItemsArray) {
        if([channelItem.channelIsSelected  isEqual: @"0"]) {
            [self.optionalArray addObject:channelItem];
        }
    }
}


@end
