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

    for (LPChannelItem *channelItem in self.channelItemsArray) {
        // 已选频道
        if([channelItem.channelIsSelected  isEqual: @"1"] && channelItem.hidden == NO) {
            [self.selectedArray addObject:channelItem];
        }
        // 可选频道
        if([channelItem.channelIsSelected  isEqual: @"0"] && channelItem.hidden == NO) {
            [self.optionalArray addObject:channelItem];
        }
    }
 
}

- (void)showConcernChannelItem {
    self.channelItemsArray =  [LPChannelItemTool initChannelItems];
    LPChannelItem *concernChannelItem = nil;
    for (LPChannelItem *channelItem in self.channelItemsArray) {
        if ([channelItem.channelID isEqualToString:focusChannelID] && channelItem.hidden == YES) {
            channelItem.channelIsSelected = @"1";
            channelItem.hidden = NO;
            concernChannelItem = channelItem;
            break;
        }
        
    }
    // 已选频道栏添加关注
    int selectedCount = self.selectedArray.count;
    if (selectedCount >= 4) {
        [self.selectedArray insertObject:concernChannelItem atIndex:4];
    } else {
        [self.selectedArray insertObject:concernChannelItem atIndex:selectedCount];
    }
    int index = -1;
    for (int i = 0; i < self.optionalArray.count; i++) {
        LPChannelItem *channelItem = (LPChannelItem *)self.optionalArray[i];
        if ([channelItem.channelID isEqualToString:focusChannelID]) {
            index = i;
            break;
        }
    }
    // 可选频道中移除关注
    if (index > 0) {
        [self.optionalArray removeObjectAtIndex:index];
    }
    
    // 保存频道信息到本地
    [self.channelItemsArray removeAllObjects];
    for (LPChannelItem *channelItem in self.selectedArray) {
        channelItem.channelIsSelected = @"1";
        [self.channelItemsArray addObject:channelItem];
    }
    for (LPChannelItem *channelItem in self.optionalArray) {
        channelItem.channelIsSelected = @"0";
        [self.channelItemsArray addObject:channelItem];
    }
    [LPChannelItemTool saveChannelItems:self.channelItemsArray];
}

@end
