//
//  LPHttpTool.h
//  EveryoneNews
//
//  Created by apple on 15/6/8.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPHttpTool : NSObject

+ (instancetype)http;
/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postWithURL:(NSString *)url
             params:(NSDictionary *)params
            success:(void (^)(id json))success
            failure:(void (^)(NSError *error))failure;

+ (void)postWithURL:(NSString *)url
             params:(NSDictionary *)params
       timeinterval:(CGFloat)interval
            success:(void (^)(id json))success
            failure:(void (^)(NSError *error))failure;

- (void)putWithURL:(NSString *)url
            params:(NSDictionary *)params
           success:(void (^)(id json))success
           failure:(void (^)(NSError *error))failure;

- (void)postWithURL:(NSString *)url
             params:(NSDictionary *)params
            success:(void (^)(id json))success
            failure:(void (^)(NSError *error))failure;

- (void)postWithURL:(NSString *)url
             params:(NSDictionary *)params
       timeinterval:(CGFloat)interval
            success:(void (^)(id json))success
            failure:(void (^)(NSError *))failure;

- (void)postJSONWithURL:(NSString *)url
             params:(NSDictionary *)params
            success:(void (^)(id json))success
            failure:(void (^)(NSError *error))failure;


- (void)getWithURL:(NSString *)url
            params:(NSDictionary *)params
      timeinterval:(CGFloat)interval
           success:(void (^)(id json))success
           failure:(void (^)(NSError *error))failure;

- (void)getWithURL:(NSString *)url
            params:(NSDictionary *)params
           success:(void (^)(id json))success
           failure:(void (^)(NSError *error))failure;

- (void)getImageWithURL:(NSString *)url
            params:(NSDictionary *)params
           success:(void (^)(id json))success
           failure:(void (^)(NSError *))failure;

+ (void)getWithURL:(NSString *)url
            params:(NSDictionary *)params
           success:(void (^)(id json))success
           failure:(void (^)(NSError *error))failure;

+ (void)getWithURL:(NSString *)url
            params:(NSDictionary *)params
      timeinterval:(CGFloat)interval
           success:(void (^)(id json))success
           failure:(void (^)(NSError *error))failure;

+ (void)postJSONWithURL:(NSString *)url
                 params:(NSDictionary *)params
                success:(void (^)(id json))success
                failure:(void (^)(NSError *error))failure;

+ (void)deleteAuthorizationJSONWithURL:(NSString *)url
                         authorization:(NSString *)authorization
                                params:(NSDictionary *)params
                               success:(void (^)(id json))success
                               failure:(void (^)(NSError *error))failure;

+ (void)postJSONResponseAuthorizationWithURL:(NSString *)url
                                      params:(NSDictionary *)params
                                     success:(void (^)(id json, NSString *authorization))success
                                     failure:(void (^)(NSError *error))failure;

+ (void)postAuthorizationJSONWithURL:(NSString *)url
                       authorization:(NSString *)authorization
                              params:(NSDictionary *)params
                             success:(void (^)(id json))success
                             failure:(void (^)(NSError *error))failure;


+ (void)getJsonAuthorizationWithURL:(NSString *)url
                  authorization:(NSString *)authorization
                         params:(NSDictionary *)params
                        success:(void (^)(id json))success
                        failure:(void (^)(NSError *error))failure;


+ (void)getJsonAuthorizationWithURL:(NSString *)url
                  authorization:(NSString *)authorization
                         params:(NSDictionary *)params
                   timeinterval:(CGFloat)interval
                        success:(void (^)(id json))success
                        failure:(void (^)(NSError *error))failure;

- (void)cancelRequest;
@end
