//
//  DataCacheTool.h
//  EveryoneNews
//
//  Created by apple on 15/5/5.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Param;

@interface DataCacheTool : NSObject

/**
 *  写缓存，即为sqlite添加记录
 *
 *  @param dictArray 要写入的字典数组
 */
+(void)addRows:(NSArray *)dictArray;
//+(void)addRow:(NSDictionary *)dict;

///**
// *  检查数据库中是否有最新数据
// *
// *  @return
// */
//+(BOOL)hasNewData;


/**
 *  根据参数（时间戳、返回数量）读取缓存
 *
 *  @param param 依据的参数
 *
 *  @return 字典数组
 */
+(NSArray *)rowsWithCount:(int)count;

@end
