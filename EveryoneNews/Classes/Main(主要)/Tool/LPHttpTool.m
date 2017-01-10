//
//  LPHttpTool.m
//  EveryoneNews
//
//  Created by apple on 15/6/8.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPHttpTool.h"
#import "AFNetworking.h"

@interface LPHttpTool ()
@property (nonatomic, weak) NSURLSessionTask *operation;
@end

@implementation LPHttpTool

+ (void)postWithURL:(NSString *)url
             params:(NSDictionary *)params
       timeinterval:(CGFloat)interval
            success:(void (^)(id json))success
            failure:(void (^)(NSError *error))failure {
    // 1.创建请求管理对象    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = interval;
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    [self postWithURL:url params:params timeinterval:5 success:success failure:failure];
}

- (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure {
    [self postWithURL:url params:params timeinterval:5.0 success:success failure:failure];
}

- (void)postWithURL:(NSString *)url params:(NSDictionary *)params timeinterval:(CGFloat)interval success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = interval;
    self.operation =  [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];

}

- (void)putWithURL:(NSString *)url
            params:(NSDictionary *)params
           success:(void (^)(id json))success
           failure:(void (^)(NSError *error))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5.0;
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager PUT:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

- (void)postJSONWithURL:(NSString *)url
                 params:(NSDictionary *)params
                success:(void (^)(id json))success
                failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 允许JSON字符串最外层既不是NSArray也不是NSDictionary，但必须是有效的JSON Fragment
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)postJSONWithURL:(NSString *)url
                 params:(NSDictionary *)params
                success:(void (^)(id json))success
                failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 允许JSON字符串最外层既不是NSArray也不是NSDictionary，但必须是有效的JSON Fragment
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

- (void)getWithURL:(NSString *)url
            params:(NSDictionary *)params
      timeinterval:(CGFloat)interval
           success:(void (^)(id json))success
           failure:(void (^)(NSError *error))failure {
    // 1.创建请求管理对象
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer.timeoutInterval = interval;
    mgr.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    // 2.发送请求
    self.operation = [mgr GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];

}

- (void)getWithURL:(NSString *)url
            params:(NSDictionary *)params
           success:(void (^)(id json))success
           failure:(void (^)(NSError *error))failure {
    [self getWithURL:url params:params timeinterval:5.0 success:success failure:failure];
}

+ (void)getWithURL:(NSString *)url
            params:(NSDictionary *)params
      timeinterval:(CGFloat)interval
           success:(void (^)(id json))success
           failure:(void (^)(NSError *error))failure {
    // 1.创建请求管理对象
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer.timeoutInterval = interval;
    mgr.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    // 2.发送请求
    [mgr GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getWithURL:(NSString *)url
            params:(NSDictionary *)params
           success:(void (^)(id))success
           failure:(void (^)(NSError *))failure {
    return [self getWithURL:url params:params timeinterval:15.0 success:success failure:failure];
}


#pragma mark - Post Response Header
+ (void)postJSONResponseAuthorizationWithURL:(NSString *)url
                                      params:(NSDictionary *)params
                                     success:(void (^)(id json,NSString *authorization))success
                                     failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    manager.requestSerializer =  [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 允许JSON字符串最外层既不是NSArray也不是NSDictionary，但必须是有效的JSON Fragment
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    // 清除客户端的Cookie
    manager.requestSerializer.HTTPShouldHandleCookies = NO;
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            
            if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse *headerResponse = (NSHTTPURLResponse *)task.response;
                NSDictionary *headerDict = [headerResponse allHeaderFields];
                success(responseObject, [headerDict objectForKey:@"Authorization"]);
            }
            
//            NSLog(@"%@", responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        NSLog(@"%@", error);
        
    }];
    
}

#pragma mark - Post Request Header
+ (void)postAuthorizationJSONWithURL:(NSString *)url
                       authorization:(NSString *)authorization
                              params:(NSDictionary *)params
                             success:(void (^)(id json))success
                             failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    manager.requestSerializer.timeoutInterval = 15.0f;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 允许JSON字符串最外层既不是NSArray也不是NSDictionary，但必须是有效的JSON Fragment
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"*" forHTTPHeaderField:@"X-Requested-With"];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}


#pragma mark - Delete Request Header
+ (void)deleteAuthorizationJSONWithURL:(NSString *)url
                       authorization:(NSString *)authorization
                              params:(NSDictionary *)params
                             success:(void (^)(id json))success
                             failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    manager.requestSerializer.timeoutInterval = 15.0f;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 允许JSON字符串最外层既不是NSArray也不是NSDictionary，但必须是有效的JSON Fragment
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"*" forHTTPHeaderField:@"X-Requested-With"];
    
    [manager DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


#pragma mark - Get Request Json Header
+ (void)getJsonAuthorizationWithURL:(NSString *)url
                  authorization:(NSString *)authorization
                         params:(NSDictionary *)params
                        success:(void (^)(id json))success
                        failure:(void (^)(NSError *error))failure {
    return [self getJsonAuthorizationWithURL:url authorization:authorization params:params timeinterval:5.0f success:success failure:failure];
}

+ (void)getJsonAuthorizationWithURL:(NSString *)url
                  authorization:(NSString *)authorization
                         params:(NSDictionary *)params
                   timeinterval:(CGFloat)interval
                        success:(void (^)(id json))success
                        failure:(void (^)(NSError *error))failure {
    
    // 1.创建请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 15.0f;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 允许JSON字符串最外层既不是NSArray也不是NSDictionary，但必须是有效的JSON Fragment
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"*" forHTTPHeaderField:@"X-Requested-With"];

    // 2.发送请求
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
            
        }
        [task cancel];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }

    }];
    
}

- (void)getImageWithURL:(NSString *)url
                 params:(NSDictionary *)params
                success:(void (^)(id))success
                failure:(void (^)(NSError *))failure {
    // 1.创建请求管理对象
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFImageResponseSerializer serializer];
    mgr.requestSerializer.timeoutInterval = 5;
    mgr.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    // 2.发送请求
    [mgr GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)cancelRequest {
    if (!self.operation) return;
    [self.operation cancel];
    self.operation = nil;
}

+ (instancetype)http {
    return [[self alloc] init];
}
@end
