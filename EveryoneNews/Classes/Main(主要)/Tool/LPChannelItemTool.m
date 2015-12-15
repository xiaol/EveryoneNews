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
        
        item0.channelID = @"TJ0001";
        item0.channelName = @"推荐";
        item0.channelIsSelected = @"1";
        
        item1.channelID = @"RD0002";
        item1.channelName = @"热点";
        item1.channelIsSelected = @"1";
        
        item2.channelID = @"JX0003";
        item2.channelName = @"精选";
        item2.channelIsSelected = @"1";
        
        item3.channelID = @"SH0004";
        item3.channelName = @"社会";
        item3.channelIsSelected = @"1";
        
        item4.channelID = @"WM0005";
        item4.channelName = @"外媒";
        item4.channelIsSelected = @"1";
        
        item5.channelID = @"YL0006";
        item5.channelName = @"娱乐";
        item5.channelIsSelected = @"1";
        
        item6.channelID = @"KJ0007";
        item6.channelName = @"科技";
        item6.channelIsSelected = @"1";
        
        item7.channelID = @"TY0008";
        item7.channelName = @"体育";
        item7.channelIsSelected = @"1";
        
        item8.channelID = @"CJ0009";
        item8.channelName = @"财经";
        item8.channelIsSelected = @"1";
        
        item9.channelID = @"SS0010";
        item9.channelName = @"时尚";
        item9.channelIsSelected = @"1";
        
        item10.channelID = @"GX0011";
        item10.channelName = @"搞笑";
        item10.channelIsSelected = @"1";
        
        item11.channelID = @"YS0012";
        item11.channelName = @"影视";
        item11.channelIsSelected = @"0";
        
        item12.channelID = @"YY0013";
        item12.channelName = @"音乐";
        item12.channelIsSelected = @"0";
        
        item13.channelID = @"ZKW0014";
        item13.channelName = @"重口味";
        item13.channelIsSelected = @"0";
        
        item14.channelID = @"MC0015";
        item14.channelName = @"萌宠";
        item14.channelIsSelected = @"0";
        
        item15.channelID = @"ECY0016";
        item15.channelName = @"二次元";
        item15.channelIsSelected = @"0";
        
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
    }
    return channelItems;
}

@end
