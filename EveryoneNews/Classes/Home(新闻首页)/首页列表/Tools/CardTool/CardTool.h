//
//  CardTool.h
//  EveryoneNews
//
//  Created by apple on 15/12/10.
//  Copyright © 2015年 apple. All rights reserved.
//  首页新闻数据的业务逻辑类 (位于UI层和工具层(网络/数据库请求)之间, 请面向该业务层来处理UI)

#import <Foundation/Foundation.h>


@class CardParam;
/**
 *  请求成功的回调类型
 *
 *  @param cards 模型数组参数
 */
typedef void (^CardsFetchedSuccessHandler)(NSArray *cards);
/**
 *  请求失败的回调类型
 */
typedef void (^CardsFetchedFailureHandler)(NSError *error);

@interface CardTool : NSObject

/**
 *  加载首页的新闻数据
 *
 *  @param param   请求参数模型
 *  @param success 成功时的回调
 *  @param failure 失败时的回调
 */
+ (void)cardsWithParam:(CardParam *)param
                channelID:(NSString *)channelID
               success:(CardsFetchedSuccessHandler)success
               failure:(CardsFetchedFailureHandler)failure;


+ (void)cardsConcernWithParam:(CardParam *)param
             channelID:(NSString *)channelID
               success:(CardsFetchedSuccessHandler)success
               failure:(CardsFetchedFailureHandler)failure;

+ (void)cancelCardsConcernWithParam:(CardParam *)param
                          channelID:(NSString *)channelID
                         sourceName:(NSString *)sourceName
                            success:(CardsFetchedSuccessHandler)success
                            failure:(CardsFetchedFailureHandler)failure;

@end
