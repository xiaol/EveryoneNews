//
//  DataCacheTool.m
//  EveryoneNews
//
//  Created by apple on 15/5/5.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "DataCacheTool.h"
#import "FMDB.h"
#import "NSString+LP.h"

@implementation DataCacheTool

// 全局队列变量
static FMDatabaseQueue *_queue;

/**
 *  类加载时建表(only once)~
 */
+(void)initialize
{
    // 数据库文件路径
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"news.sqlite"];
    // 创建队列
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    // 创建表格(3个字段：PK, 新闻时间, 新闻全数据)
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists t_news (id integer primary key autoincrement, time text, dict blob);"];
    }];
}

+ (void)addRows:(NSArray *)dictArray
{
    for (NSDictionary *dict in dictArray) {
        [self addRow:dict];
    }
}

+ (void)addRow:(NSDictionary *)dict
{
    [_queue inDatabase:^(FMDatabase *db) {
        NSString *time = [dict[@"updateTime"] timeFormat];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
        [db executeUpdate:@"insert into t_news (time, dict) values (?, ?);", time, data];
    }];
}

//+ (BOOL)hasNewData
//{
//    __block BOOL has = NO;
//    [_queue inDatabase:^(FMDatabase *db) {
//        FMResultSet *rs = nil;
//        rs = [db executeQuery:@"select * from t_news order by time desc limit 0, ?;", 1];
//        if (rs.next) {
//            NSString *time = [rs stringForColumn:@"time"];
//            NSString *nowTime = [NSString stringFromDate:[NSDate date]];
//            if (([[nowTime timeFormat] longLongValue]-[time longLongValue]) < (24*60*60)) {
//                has = YES;
//            }
//        }
//    }];
//    return has;
//}

+ (NSArray *)rowsWithCount:(int)count
{
    __block NSMutableArray *dictArray = nil;
    [_queue inDatabase:^(FMDatabase *db) {
        dictArray = [NSMutableArray array];
        FMResultSet *rs = nil;
        rs = [db executeQuery:@"select * from t_news order by time desc limit 0, ?;", count];
        while (rs.next) {
            NSData *data = [rs dataForColumn:@"dict"];
            NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [dictArray addObject:dict];
        }
    }];
    return dictArray;
}
@end
