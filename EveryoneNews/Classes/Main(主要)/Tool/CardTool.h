//
//  CardTool.h
//  EveryoneNews
//
//  Created by apple on 15/12/10.
//  Copyright © 2015年 apple. All rights reserved.
//  首页新闻数据的业务逻辑类 (位于UI处理层和工具类(网络/数据库请求)之间)

#import <Foundation/Foundation.h>

@class CardParam;

typedef void (^CardsFetchedSuccessHandler)(NSArray *cards);
typedef void (^CardsFetchedFailureHandler)(NSError *error);

@interface CardTool : NSObject

/**
 *  加载首页的新闻数据
 *
 *  @param param   请求参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)cardsWithParam:(CardParam *)param
               success:(CardsFetchedSuccessHandler)success
               failure:(CardsFetchedFailureHandler)failure;

@end
