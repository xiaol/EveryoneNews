//
//  LPChannelItemTool.h
//  EveryoneNews
//
//  Created by dongdan on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPChannelItem.h"

//保存频道信息path
#define kChannelItemsSavePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"channelItems.data"]

@interface LPChannelItemTool : NSObject

+ (void)saveChannelItems:(NSMutableArray *)channelItems;

+ (NSMutableArray *)getChannelItems;
/**
 *  频道选中状态修改
 *
 *  @param channelIsSelected 是否选中 1 选中 0 未选中
 *  @param title             频道名称
 */
+ (void)updateChannelIsSelectedWithTitle:(NSString *)channelIsSelected title:(NSString *)title;
@end
