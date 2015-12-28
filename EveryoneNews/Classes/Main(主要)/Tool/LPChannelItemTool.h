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

+ (NSString *)channelID:(NSString *)channelName;
// 清空所有频道上次访问日期
+ (void)initializeLastAccessDate;

@end
