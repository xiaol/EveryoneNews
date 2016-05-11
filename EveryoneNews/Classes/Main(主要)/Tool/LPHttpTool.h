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
            success:(void (^)(id))success
            failure:(void (^)(NSError *))failure;

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
            success:(void (^)(id))success
            failure:(void (^)(NSError *))failure;

- (void)postJSONWithURL:(NSString *)url
             params:(NSDictionary *)params
            success:(void (^)(id json))success
            failure:(void (^)(NSError *error))failure;

/**
 *  发送一个POST请求(上传文件数据)
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param formData  文件参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
//+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;



- (void)getWithURL:(NSString *)url
            params:(NSDictionary *)params
      timeinterval:(CGFloat)interval
           success:(void (^)(id))success
           failure:(void (^)(NSError *))failure;

- (void)getWithURL:(NSString *)url
            params:(NSDictionary *)params
           success:(void (^)(id))success
           failure:(void (^)(NSError *))failure;

- (void)getImageWithURL:(NSString *)url
            params:(NSDictionary *)params
           success:(void (^)(id))success
           failure:(void (^)(NSError *))failure;

/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params timeinterval:(CGFloat)interval success:(void (^)(id))success failure:(void (^)(NSError *))failure;




- (void)cancelRequest;
@end
