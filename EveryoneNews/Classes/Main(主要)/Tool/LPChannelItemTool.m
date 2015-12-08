//
//  LPChannelItemTool.m
//  EveryoneNews
//
//  Created by dongdan on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPChannelItemTool.h"
#import "LPChannelItem.h"

@implementation LPChannelItemTool

+ (void)saveChannelItems:(NSMutableArray *)channelItems {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:channelItems forKey:@"channelItems"];
    [archiver finishEncoding];
    [data writeToFile:kChannelItemsSavePath atomically:YES];    
}

+ (NSMutableArray *)getChannelItems {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *channelItems;
    if([fileManager fileExistsAtPath:kChannelItemsSavePath]) {
        // 读取文件
        NSMutableData *data = [NSMutableData dataWithContentsOfFile:kChannelItemsSavePath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        channelItems = (NSMutableArray *)[unarchiver decodeObjectForKey:@"channelItems"];
        [unarchiver finishDecoding];
        
    }
    return channelItems;
}

+ (void)updateChannelIsSelectedWithTitle:(NSString *)channelIsSelected title:(NSString *)title {
    NSMutableArray *channelItems = [LPChannelItemTool getChannelItems];
    NSMutableArray *newChannelItems = [[NSMutableArray alloc] init];;
    for (LPChannelItem *channelItem in channelItems) {
        if([channelItem.channelName isEqualToString:title]) {
            channelItem.channelIsSelected = channelIsSelected;
        }
        [newChannelItems addObject:channelItem];
    }
    [LPChannelItemTool saveChannelItems:newChannelItems];
}
@end
