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
@property (nonatomic, weak) AFHTTPRequestOperation *operation;
@end

@implementation LPHttpTool
+ (void)postWithURL:(NSString *)url
             params:(NSDictionary *)params
       timeinterval:(CGFloat)interval
            success:(void (^)(id))success
            failure:(void (^)(NSError *))failure {
    // 1.创建请求管理对象    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer.timeoutInterval = interval;
    mgr.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    //    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    // 2.发送请求
    [mgr POST:url parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if (success) {
              success(responseObject);
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];
}

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [self postWithURL:url params:params timeinterval:5 success:success failure:failure];
}

- (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    [self postWithURL:url params:params timeinterval:5.0 success:success failure:failure];
}

- (void)postWithURL:(NSString *)url params:(NSDictionary *)params timeinterval:(CGFloat)interval success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = interval;
    self.operation = [manager POST:url parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if (success) {
              success(responseObject);
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];
}

//+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(id))success failure:(void (^)(NSError *))failure
//{
//    // 1.创建请求管理对象
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    
//    // 2.发送请求
//    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> totalFormData) {
//        for (IWFormData *formData in formDataArray) {
//            [totalFormData appendPartWithFileData:formData.data name:formData.name fileName:formData.filename mimeType:formData.mimeType];
//        }
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
//}

- (void)getWithURL:(NSString *)url params:(NSDictionary *)params timeinterval:(CGFloat)interval success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer.timeoutInterval = interval;
    mgr.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    // 2.发送请求
    self.operation = [mgr GET:url parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (success) {
             success(responseObject);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (failure) {
             failure(error);
         }
     }];
}

- (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    [self getWithURL:url params:params timeinterval:5.0 success:success failure:failure];
}

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params timeinterval:(CGFloat)interval success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer.timeoutInterval = interval;
    mgr.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    // 2.发送请求
    [mgr GET:url parameters:params
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          if (success) {
                              success(responseObject);
                          }
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          if (failure) {
                              failure(error);
                          }
                      }];
}

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    return [self getWithURL:url params:params timeinterval:5.0 success:success failure:failure];
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
