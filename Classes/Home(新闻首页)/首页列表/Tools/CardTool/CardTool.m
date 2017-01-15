//
//  CardTool.m
//  EveryoneNews
//
//  Created by apple on 15/12/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "CardTool.h"
#import "LPHttpTool.h"
#import "CardParam.h"
#import "Card+Create.h"
#import "Card+Fetch.h"
#import "MJExtension.h"
#import "CoreDataHelper.h"
#import "LPLoginTool.h"
#import "LPAdRequestTool.h"

@interface CardTool ()

@end

@implementation CardTool
#pragma mark - feed流新接口  包含广告位 视频

+ (void)getAdsImpression:(NSString *)adsImpression {
    [LPHttpTool getWithURL:adsImpression params:nil success:^(id json) {
        
       //NSLog(@"%@", json);
    } failure:^(NSError *error) {
       // NSLog(@"adsError:%@", error);
    }];
}

+ (void)cardsWithParam:(CardParam *)param
             channelID:(NSString *)channelID
               success:(CardsFetchedSuccessHandler)success
               failure:(CardsFetchedFailureHandler)failure {
    NSString *authorization = [userDefaults objectForKey:@"uauthorization"];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"cid"] = @([channelID longLongValue]);
    paramDict[@"tcr"] = param.startTime;
    paramDict[@"tmk"] = @(0);
    
    if ([param.nid longLongValue] > 0) {
        paramDict[@"nid"] = @([param.nid longLongValue]);
    }
    paramDict[@"t"] = @(1);
    // 显示https图片地址
    paramDict[@"s"] =@(1);
    // 是否显示视频
    paramDict[@"v"] = @(1);
    
    // 如果Authorization为空，则请求完Authorization后再请求数据
    if (!authorization) {
        // 第一次进入存储游客Authorization
        NSString *url = [NSString stringWithFormat:@"%@/v2/au/sin/g",ServerUrlVersion2];
        NSMutableDictionary *paramUser = [NSMutableDictionary dictionary];
        // 2 游客用户
        paramUser[@"utype"] = @(2);
        // 1 iOS 平台
        paramUser[@"platform"] = @(1);
        paramUser[@"province"]  = @"";
        paramUser[@"city"] = @"";
        paramUser[@"district"] = @"";
        [LPHttpTool postJSONResponseAuthorizationWithURL:url params:paramUser success:^(id json, NSString *authorization) {
            if ([json[@"code"] integerValue] == 2000) {
                NSDictionary *dict = (NSDictionary *)json[@"data"];
                [userDefaults setObject:dict[@"uid"] forKey:@"uid"];
                [userDefaults setObject:@"2" forKey:@"uIconDisplay"];
                [userDefaults setObject:dict[@"utype"] forKey:@"utype"];
                [userDefaults setObject:dict[@"password"] forKey:@"password"];
                [userDefaults setObject:authorization forKey:@"uauthorization"];
                [userDefaults synchronize];
                    paramDict[@"uid"] = ![userDefaults objectForKey:@"uid"] ? @(0):[userDefaults objectForKey:@"uid"];
                    paramDict[@"b"] = [LPAdRequestTool adBase64];
                    paramDict[@"tcr"] = @([param.startTime longLongValue]);
                    [self qiDianPostCardsWithUserParam:param paramDict:paramDict authorization:authorization success:success failure:failure];
            }
        }  failure:^(NSError *error) {
            NSLog(@"error:%@", error);
        }];
    } else {
        paramDict[@"uid"] = ![userDefaults objectForKey:@"uid"] ? @(0):[userDefaults objectForKey:@"uid"];
        paramDict[@"b"] = [LPAdRequestTool adBase64];
        paramDict[@"tcr"] = @([param.startTime longLongValue]);
        [self qiDianPostCardsWithUserParam:param paramDict:paramDict authorization:authorization success:success failure:failure];
    }
}


#pragma mark - 奇点频道请求数据接口
+ (void)qiDianPostCardsWithUserParam:(CardParam *)param
                       paramDict:(NSMutableDictionary *)paramDict
                   authorization:(NSString *)authorization
                         success:(CardsFetchedSuccessHandler)success
                         failure:(CardsFetchedFailureHandler)failure {
    
    if (param.type == HomeCardsFetchTypeNew) { // 下拉刷新, 直接发送网络请求, 成功后存入数据库
        
        NSString *url = [NSString stringWithFormat:@"%@/v2/ns/fed/ra", ServerUrlVersion2];
        
        [LPHttpTool postAuthorizationJSONWithURL:url authorization:authorization params:paramDict success:^(id json) {
            // 有数据
            if ([json[@"code"] integerValue] == 2000) {
                [Card createCardsWithDictArray:json[@"data"] channelID:param.channelID cardsArrayBlock:^(NSArray *cardsArray) {
                    success(cardsArray);
                }];
            }
            // 没有数据
            else if ([json[@"code"] integerValue] == 2002) {
                NSArray *cardsArray = [[NSArray alloc] init];
                success(cardsArray);
            }
            // 用户验证错误
            else if ([json[@"code"] integerValue] == 4003) {
                [LPLoginTool loginVerify];
                NSArray *cardsArray = [[NSArray alloc] init];
                success(cardsArray);
            }
        } failure:^(NSError *error) {
            failure(error);
        }];
    } else if (param.type == HomeCardsFetchTypeMore) { // 上拉加载更多，先从网络取数据，获取不到再从本地数据库拿数据
        
        NSString *url = [NSString stringWithFormat:@"%@/v2/ns/fed/la", ServerUrlVersion2];
        [LPHttpTool postAuthorizationJSONWithURL:url authorization:authorization params:paramDict success:^(id json) {
            if ([json[@"code"] integerValue] == 2000) {
                [Card createCardsWithDictArray:json[@"data"] channelID:param.channelID cardsArrayBlock:^(NSArray *cardsArray) {
                    success(cardsArray);
                }];
            }
            // 没有数据
            else if ([json[@"code"] integerValue] == 2002) {
                NSArray *cardsArray = [[NSArray alloc] init];
                success(cardsArray);
            }
            // 用户验证错误
            else if ([json[@"code"] integerValue] == 4003) {
                [LPLoginTool loginVerify];
                NSArray *cardsArray = [[NSArray alloc] init];
                success(cardsArray);
            }
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
    
    
}

#pragma mark - 请求feed流数据
+ (void)cardsWithUserParam:(CardParam *)param
                 paramDict:(NSMutableDictionary *)paramDict
             authorization:(NSString *)authorization
               success:(CardsFetchedSuccessHandler)success
               failure:(CardsFetchedFailureHandler)failure {
    
    if (param.type == HomeCardsFetchTypeNew) { // 下拉刷新, 直接发送网络请求, 成功后存入数据库
        
        NSString *url = [NSString stringWithFormat:@"%@/v2/ns/fed/r", ServerUrlVersion2];
        [LPHttpTool getJsonAuthorizationWithURL:url authorization:authorization params:paramDict success:^(id json) {
            
            // 有数据
            if ([json[@"code"] integerValue] == 2000) {
                [Card createCardsWithDictArray:json[@"data"] channelID:param.channelID cardsArrayBlock:^(NSArray *cardsArray) {
                    success(cardsArray);
                }];
            }
            // 没有数据
            else if ([json[@"code"] integerValue] == 2002) {
                NSArray *cardsArray = [[NSArray alloc] init];
                success(cardsArray);
            }
            // 用户验证错误
            else if ([json[@"code"] integerValue] == 4003) {
                [LPLoginTool loginVerify];
                NSArray *cardsArray = [[NSArray alloc] init];
                success(cardsArray);
            }
            
        } failure:^(NSError *error) {
            failure(error);
        }];
    } else if (param.type == HomeCardsFetchTypeMore) { // 上拉加载更多，先从网络取数据，获取不到再从本地数据库拿数据
        
        NSString *url = [NSString stringWithFormat:@"%@/v2/ns/fed/l", ServerUrlVersion2];
        [LPHttpTool getJsonAuthorizationWithURL:url authorization:authorization params:paramDict success:^(id json) {
            if ([json[@"code"] integerValue] == 2000) {
                [Card createCardsWithDictArray:json[@"data"] channelID:param.channelID cardsArrayBlock:^(NSArray *cardsArray) {
                    success(cardsArray);
                }];
            }
            // 没有数据
            else if ([json[@"code"] integerValue] == 2002) {
                NSArray *cardsArray = [[NSArray alloc] init];
                success(cardsArray);
            }
            // 用户验证错误
            else if ([json[@"code"] integerValue] == 4003) {
                [LPLoginTool loginVerify];
                NSArray *cardsArray = [[NSArray alloc] init];
                success(cardsArray);
            }
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
}


#pragma mark - 取消关注
+ (void)cancelCardsConcernWithParam:(CardParam *)param
                    channelID:(NSString *)channelID
                         sourceName:(NSString *)sourceName
                      success:(CardsFetchedSuccessHandler)success
                      failure:(CardsFetchedFailureHandler)failure {
    
    NSString *authorization = [userDefaults objectForKey:@"uauthorization"];
    NSString *uid = [userDefaults objectForKey:@"uid"];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = uid;
    paramDict[@"tcr"] = param.startTime;
 
    NSString *url = [NSString stringWithFormat:@"%@/v2/ns/pbs/cocs/l", ServerUrlVersion2];
    [LPHttpTool getJsonAuthorizationWithURL:url authorization:authorization params:paramDict success:^(id json) {
        // 有数据
        if ([json[@"code"] integerValue] == 2000) {
            [Card cancelConcernCardsWithDictArray:json[@"data"]  channelID:param.channelID  sourceName:sourceName cardsArrayBlock:^(NSArray *cardsArray) {
                success(cardsArray);
            }];
        }
        // 没有数据
        else if ([json[@"code"] integerValue] == 2002) {
            NSArray *cardsArray = [[NSArray alloc] init];
            success(cardsArray);
        }
        // 用户验证错误
        else if ([json[@"code"] integerValue] == 4003) {
            [LPLoginTool loginVerify];
            NSArray *cardsArray = [[NSArray alloc] init];
            success(cardsArray);
        }
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - 加载关注列表数据
+ (void)cardsConcernWithParam:(CardParam *)param
                    channelID:(NSString *)channelID
                      success:(CardsFetchedSuccessHandler)success
                      failure:(CardsFetchedFailureHandler)failure {
    NSString *authorization = [userDefaults objectForKey:@"uauthorization"];
    NSString *uid = [userDefaults objectForKey:@"uid"];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = uid;
    paramDict[@"tcr"] = param.startTime;
    
    if (![[[userDefaults objectForKey:@"utype"] stringValue] isEqualToString:@"2"]) {
        if (param.type == HomeCardsFetchTypeNew) {
            
            NSString *url = [NSString stringWithFormat:@"%@/v2/ns/pbs/cocs/r", ServerUrlVersion2];
            [LPHttpTool getJsonAuthorizationWithURL:url authorization:authorization params:paramDict success:^(id json) {
                // 有数据
                if ([json[@"code"] integerValue] == 2000) {
                    [Card createCardsWithDictArray:json[@"data"] channelID:param.channelID cardsArrayBlock:^(NSArray *cardsArray) {
                        success(cardsArray);
                    }];
                }
                // 没有数据
                else if ([json[@"code"] integerValue] == 2002) {
                    NSArray *cardsArray = [[NSArray alloc] init];
                    success(cardsArray);
                }
                // 用户验证错误
                else if ([json[@"code"] integerValue] == 4003) {
                    [LPLoginTool loginVerify];
                    NSArray *cardsArray = [[NSArray alloc] init];
                    success(cardsArray);
                }
                
            } failure:^(NSError *error) {
                failure(error);
            }];
            
        }  else if (param.type == HomeCardsFetchTypeMore) {
            NSString *url = [NSString stringWithFormat:@"%@/v2/ns/pbs/cocs/l", ServerUrlVersion2];
            [LPHttpTool getJsonAuthorizationWithURL:url authorization:authorization params:paramDict success:^(id json) {
                // 有数据
                if ([json[@"code"] integerValue] == 2000) {
                    [Card createCardsWithDictArray:json[@"data"] channelID:param.channelID cardsArrayBlock:^(NSArray *cardsArray) {
                        success(cardsArray);
                    }];
                }
                // 没有数据
                else if ([json[@"code"] integerValue] == 2002) {
                    NSArray *cardsArray = [[NSArray alloc] init];
                    success(cardsArray);
                }
                // 用户验证错误
                else if ([json[@"code"] integerValue] == 4003) {
                    [LPLoginTool loginVerify];
                    NSArray *cardsArray = [[NSArray alloc] init];
                    success(cardsArray);
                }
                
            } failure:^(NSError *error) {
                failure(error);
            }];
        }
    }
}

@end
