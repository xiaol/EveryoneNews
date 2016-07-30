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

#pragma mark - 初始化各个频道访问日期
+ (void)initializeLastAccessDate {
    NSMutableArray *channelItems = [LPChannelItemTool getChannelItems];
    NSMutableArray *newChannelItems = [[NSMutableArray alloc] init];
    for (LPChannelItem *channelItem in channelItems) {
        channelItem.lastAccessDate = nil;
        [newChannelItems addObject:channelItem];
    }
    [LPChannelItemTool saveChannelItems:newChannelItems];
}

#pragma mark - 保存频道到本地
+ (void)saveChannelItems:(NSMutableArray *)channelItems {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:channelItems forKey:@"channelItems"];
    [archiver finishEncoding];
    [data writeToFile:kChannelItemsSavePath atomically:YES];    
}

#pragma mark - 获取本地频道
+ (NSMutableArray *)getChannelItems {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *channelItems;
    if([fileManager fileExistsAtPath:kChannelItemsSavePath]) {
        // 读取文件
        NSMutableData *data = [NSMutableData dataWithContentsOfFile:kChannelItemsSavePath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        channelItems = (NSMutableArray *)[unarchiver decodeObjectForKey:@"channelItems"];
        [unarchiver finishDecoding];
        // 判断当前版本是否是最新版本
        if ([userDefaults objectForKey:LPIsVersionFirstLoad]) {
            return channelItems;
        } else {
            return [LPChannelItemTool initChannelItems];
        }
        
    } else {
        return [LPChannelItemTool initChannelItems];
    }
}

#pragma mark - 初始化所有频道
+ (NSMutableArray *)initChannelItems {
    
   NSMutableArray *channelItems = [[NSMutableArray alloc] init];
    
    LPChannelItem *item0 = [[LPChannelItem alloc] initWithChannelID:@"1" channelName:@"奇点" channelIsSelected:@"1"];
    LPChannelItem *item1 = [[LPChannelItem alloc] initWithChannelID:@"4" channelName:@"科技" channelIsSelected:@"1"];
    LPChannelItem *item2 = [[LPChannelItem alloc] initWithChannelID:@"2" channelName:@"社会" channelIsSelected:@"1"];
    LPChannelItem *item3 = [[LPChannelItem alloc] initWithChannelID:@"7" channelName:@"财经" channelIsSelected:@"1"];
    LPChannelItem *item4 = [[LPChannelItem alloc] initWithChannelID:@"6" channelName:@"体育" channelIsSelected:@"1"];
    
    LPChannelItem *item5 = [[LPChannelItem alloc] initWithChannelID:@"5" channelName:@"汽车" channelIsSelected:@"1"];
    LPChannelItem *item6 = [[LPChannelItem alloc] initWithChannelID:@"9" channelName:@"国际" channelIsSelected:@"1"];
    LPChannelItem *item7 = [[LPChannelItem alloc] initWithChannelID:@"10" channelName:@"时尚" channelIsSelected:@"1"];
    LPChannelItem *item8 = [[LPChannelItem alloc] initWithChannelID:@"14" channelName:@"探索" channelIsSelected:@"1"];
    LPChannelItem *item9 = [[LPChannelItem alloc] initWithChannelID:@"25" channelName:@"科学" channelIsSelected:@"1"];
    
    LPChannelItem *item10 = [[LPChannelItem alloc] initWithChannelID:@"3" channelName:@"娱乐" channelIsSelected:@"1"];
    LPChannelItem *item11 = [[LPChannelItem alloc] initWithChannelID:@"23" channelName:@"趣图" channelIsSelected:@"1"];
    LPChannelItem *item12 = [[LPChannelItem alloc] initWithChannelID:@"21" channelName:@"搞笑" channelIsSelected:@"1"];
    LPChannelItem *item13 = [[LPChannelItem alloc] initWithChannelID:@"17" channelName:@"养生" channelIsSelected:@"1"];
    LPChannelItem *item14 = [[LPChannelItem alloc] initWithChannelID:@"11" channelName:@"游戏" channelIsSelected:@"1"];
    
    LPChannelItem *item15 = [[LPChannelItem alloc] initWithChannelID:@"16" channelName:@"育儿" channelIsSelected:@"1"];
    LPChannelItem *item16 = [[LPChannelItem alloc] initWithChannelID:@"24" channelName:@"健康" channelIsSelected:@"0"];
    LPChannelItem *item17 = [[LPChannelItem alloc] initWithChannelID:@"22" channelName:@"互联网" channelIsSelected:@"0"];
    LPChannelItem *item18 = [[LPChannelItem alloc] initWithChannelID:@"20" channelName:@"股票" channelIsSelected:@"0"];
    LPChannelItem *item19 = [[LPChannelItem alloc] initWithChannelID:@"8" channelName:@"军事" channelIsSelected:@"0"];
    
    LPChannelItem *item20 = [[LPChannelItem alloc] initWithChannelID:@"13" channelName:@"历史" channelIsSelected:@"0"];
    LPChannelItem *item21 = [[LPChannelItem alloc] initWithChannelID:@"18" channelName:@"故事" channelIsSelected:@"0"];
    LPChannelItem *item22 = [[LPChannelItem alloc] initWithChannelID:@"12" channelName:@"旅游" channelIsSelected:@"0"];
    LPChannelItem *item23 = [[LPChannelItem alloc] initWithChannelID:@"19" channelName:@"美文" channelIsSelected:@"0"];
    LPChannelItem *item24 = [[LPChannelItem alloc] initWithChannelID:@"15" channelName:@"美食" channelIsSelected:@"0"];
    
    LPChannelItem *item25 = [[LPChannelItem alloc] initWithChannelID:@"26" channelName:@"美女" channelIsSelected:@"0"];
    LPChannelItem *item26 = [[LPChannelItem alloc] initWithChannelID:@"35" channelName:@"点集" channelIsSelected:@"1"];
    LPChannelItem *item27 = [[LPChannelItem alloc] initWithChannelID:@"29" channelName:@"外媒" channelIsSelected:@"1"];
    LPChannelItem *item28 = [[LPChannelItem alloc] initWithChannelID:@"30" channelName:@"影视" channelIsSelected:@"0"];
    LPChannelItem *item29 = [[LPChannelItem alloc] initWithChannelID:@"31" channelName:@"奇闻" channelIsSelected:@"0"];
    LPChannelItem *item30 = [[LPChannelItem alloc] initWithChannelID:@"32" channelName:@"萌宠" channelIsSelected:@"0"];
    
    LPChannelItem *item31 = [[LPChannelItem alloc] initWithChannelID:@"1" channelName:@"自媒体" channelIsSelected:@"0"];
    LPChannelItem *item32 = [[LPChannelItem alloc] initWithChannelID:focusChannelID channelName:@"关注" channelIsSelected:@"0"];
    
    NSArray *array = [NSArray arrayWithObjects:item0,item1,item2,item3,item27,item26
                                              ,item4,item5,item6,item7,item8,item9
                                              ,item10,item11,item12,item13,item14,item15
                                              ,item16,item17,item18,item19,item20,item21
                                              ,item22,item23,item24,item25,item28,item29
                                              ,item30,item31,item32, nil];
    [channelItems addObjectsFromArray:array];
    
    return channelItems;
}

#pragma mark - 获取频道ID
+ (NSString *)channelID:(NSString *)channelName {
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"奇点",@"1",
                                @"社会",@"2",
                                @"娱乐",@"3",
                                @"科技",@"4",
                                @"汽车",@"5",
                                @"体育",@"6",
                                @"财经",@"7",
                                @"军事",@"8",
                                @"国际",@"9",
                                @"时尚",@"10",
                                @"游戏",@"11",
                                @"旅游",@"12",
                                @"历史",@"13",
                                @"探索",@"14",
                                @"美食",@"15",
                                @"育儿",@"16",
                                @"养生",@"17",
                                @"故事",@"18",
                                @"美文",@"19",
                                @"股票",@"20",
                                @"搞笑",@"21",
                                @"互联网",@"22",
                                @"趣图",@"23",
                                @"健康",@"24",
                                @"科学",@"25",
                                @"美女",@"26",
                                @"外媒",@"29",
                                @"影视",@"30",
                                @"奇闻",@"31",
                                @"萌宠",@"32",
                                @"点集",@"35",
                                @"自媒体",@"36",
                                @"关注",focusChannelID,
                                
                                nil];
    NSString *channelID = @"";
    for (NSString *key in dictionary) {
        if([dictionary[key] isEqualToString:channelName]) {
            channelID = key;
            break;
        }
    }
    return channelID;
}

@end
