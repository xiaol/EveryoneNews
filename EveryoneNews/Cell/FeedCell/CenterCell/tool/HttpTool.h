//
//  HttpTool.h
//  EveryoneNews
//
//  Created by apple on 15/5/12.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpTool : NSObject


/**
 *  发送一个get请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 成功后的回调
 *  @param failure 失败后的回调
 */
+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params
           success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;


/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 成功后的回调
 *  @param failure 失败后的回调
 */
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;


@end
