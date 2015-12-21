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
        
    } else {
        channelItems = [[NSMutableArray alloc] init];
        LPChannelItem *item0 = [[LPChannelItem alloc] init];
        LPChannelItem *item1 = [[LPChannelItem alloc] init];
        LPChannelItem *item2 = [[LPChannelItem alloc] init];
        LPChannelItem *item3 = [[LPChannelItem alloc] init];
        LPChannelItem *item4 = [[LPChannelItem alloc] init];
        LPChannelItem *item5 = [[LPChannelItem alloc] init];
        LPChannelItem *item6 = [[LPChannelItem alloc] init];
        LPChannelItem *item7 = [[LPChannelItem alloc] init];
        LPChannelItem *item8 = [[LPChannelItem alloc] init];
        LPChannelItem *item9 = [[LPChannelItem alloc] init];
        LPChannelItem *item10 = [[LPChannelItem alloc] init];
        LPChannelItem *item11 = [[LPChannelItem alloc] init];
        LPChannelItem *item12 = [[LPChannelItem alloc] init];
        LPChannelItem *item13 = [[LPChannelItem alloc] init];
        LPChannelItem *item14 = [[LPChannelItem alloc] init];
        LPChannelItem *item15 = [[LPChannelItem alloc] init];
        LPChannelItem *item16 = [[LPChannelItem alloc] init];
        LPChannelItem *item17 = [[LPChannelItem alloc] init];
        LPChannelItem *item18 = [[LPChannelItem alloc] init];
        LPChannelItem *item19 = [[LPChannelItem alloc] init];
        LPChannelItem *item20 = [[LPChannelItem alloc] init];
        LPChannelItem *item21 = [[LPChannelItem alloc] init];
        LPChannelItem *item22 = [[LPChannelItem alloc] init];
        LPChannelItem *item23 = [[LPChannelItem alloc] init];
        LPChannelItem *item24 = [[LPChannelItem alloc] init];
        LPChannelItem *item25 = [[LPChannelItem alloc] init];

        
        item0.channelID = @"1";
        item0.channelName = @"推荐";
        item0.channelIsSelected = @"1";
        
        item1.channelID = @"2";
        item1.channelName = @"社会";
        item1.channelIsSelected = @"1";
        
        item2.channelID = @"3";
        item2.channelName = @"娱乐";
        item2.channelIsSelected = @"1";
        
        item3.channelID = @"4";
        item3.channelName = @"科技";
        item3.channelIsSelected = @"1";
        
        item4.channelID = @"5";
        item4.channelName = @"汽车";
        item4.channelIsSelected = @"1";
        
        item5.channelID = @"6";
        item5.channelName = @"体育";
        item5.channelIsSelected = @"1";
        
        item6.channelID = @"7";
        item6.channelName = @"财经";
        item6.channelIsSelected = @"1";
        
        item7.channelID = @"8";
        item7.channelName = @"军事";
        item7.channelIsSelected = @"1";
        
        item8.channelID = @"9";
        item8.channelName = @"国际";
        item8.channelIsSelected = @"1";
        
        item9.channelID = @"10";
        item9.channelName = @"时尚";
        item9.channelIsSelected = @"1";
        
        item10.channelID = @"11";
        item10.channelName = @"游戏";
        item10.channelIsSelected = @"1";
        
        item11.channelID = @"12";
        item11.channelName = @"旅游";
        item11.channelIsSelected = @"0";
        
        item12.channelID = @"13";
        item12.channelName = @"历史";
        item12.channelIsSelected = @"0";
        
        item13.channelID = @"14";
        item13.channelName = @"探索";
        item13.channelIsSelected = @"0";
        
        item14.channelID = @"15";
        item14.channelName = @"美食";
        item14.channelIsSelected = @"0";
        
        item15.channelID = @"16";
        item15.channelName = @"育儿";
        item15.channelIsSelected = @"0";
        
        item16.channelID = @"17";
        item16.channelName = @"养生";
        item16.channelIsSelected = @"0";
        
        item17.channelID = @"18";
        item17.channelName = @"故事";
        item17.channelIsSelected = @"0";
        
        item18.channelID = @"19";
        item18.channelName = @"美文";
        item18.channelIsSelected = @"0";
        
        item19.channelID = @"20";
        item19.channelName = @"股票";
        item19.channelIsSelected = @"0";
        
        item20.channelID = @"21";
        item20.channelName = @"搞笑";
        item20.channelIsSelected = @"0";
        
        item21.channelID = @"22";
        item21.channelName = @"互联网";
        item21.channelIsSelected = @"0";
        
        item22.channelID = @"23";
        item22.channelName = @"趣图";
        item22.channelIsSelected = @"0";
        
        item23.channelID = @"24";
        item23.channelName = @"健康";
        item23.channelIsSelected = @"0";
        
        item24.channelID = @"25";
        item24.channelName = @"科学";
        item24.channelIsSelected = @"0";
        
        item25.channelID = @"26";
        item25.channelName = @"美女";
        item25.channelIsSelected = @"0";
        
        [channelItems addObject:item0];
        [channelItems addObject:item1];
        [channelItems addObject:item2];
        [channelItems addObject:item3];
        [channelItems addObject:item4];
        [channelItems addObject:item5];
        [channelItems addObject:item6];
        [channelItems addObject:item7];
        [channelItems addObject:item8];
        [channelItems addObject:item9];
        [channelItems addObject:item10];
        [channelItems addObject:item11];
        [channelItems addObject:item12];
        [channelItems addObject:item13];
        [channelItems addObject:item14];
        [channelItems addObject:item15];
        [channelItems addObject:item16];
        [channelItems addObject:item17];
        [channelItems addObject:item18];
        [channelItems addObject:item19];
        [channelItems addObject:item20];
        [channelItems addObject:item21];
        [channelItems addObject:item22];
        [channelItems addObject:item23];
        [channelItems addObject:item24];
        [channelItems addObject:item25];
    }
    return channelItems;
}

+ (NSString *)channelID:(NSString *)channelName {
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
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
                                nil];
    NSString *channelID = @"4";
    for (NSString *key in dictionary) {
        if([dictionary[key] isEqualToString:channelName]) {
            channelID = key;
            break;
        }
    }
    return channelID;
}

@end
