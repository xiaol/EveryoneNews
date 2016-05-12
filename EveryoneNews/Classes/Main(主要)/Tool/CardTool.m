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

@implementation CardTool

+ (void)cardsWithParam:(CardParam *)param
               channelID:(NSString *)channelID
               success:(CardsFetchedSuccessHandler)success
               failure:(CardsFetchedFailureHandler)failure {
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    if (param.type == HomeCardsFetchTypeNew) { // 下拉刷新, 直接发送网络请求, 成功后存入数据库
        paramDict[@"cid"]    = param.channelID;
        paramDict[@"offset"] = param.count;
        paramDict[@"tstart"] = param.startTime;
        NSString *url = [NSString stringWithFormat:@"%@/bdp/news/refresh", ServerUrl];
        [LPHttpTool getWithURL:url
                        params:paramDict
                       success:^(id json) {
                           [Card createCardsWithDictArray:json[@"data"] channelID:param.channelID cardsArrayBlock:^(NSArray *cardsArray) {
                               success(cardsArray);
                           }];
                       }
                       failure:^(NSError *error) {
                           failure(error);
                       }];
    } else if (param.type == HomeCardsFetchTypeMore) { // 上拉加载更多，先从网络取数据，获取不到再从本地数据库拿数据
        paramDict[@"cid"]    = param.channelID;
        paramDict[@"offset"] = param.count;
        paramDict[@"tstart"] = param.startTime;
        NSString *url = [NSString stringWithFormat:@"%@/bdp/news/load", ServerUrl];
        [LPHttpTool getWithURL:url
                        params:paramDict
                       success:^(id json) {
                           [Card createCardsWithDictArray:json[@"data"] channelID:param.channelID cardsArrayBlock:^(NSArray *cardsArray) {
                               success(cardsArray);
                           }];
                       }
                       failure:^(NSError *error) {
                            [Card fetchCardsWithCardParam:param cardsArrayBlock:^(NSArray *cardsArray) {
                                if (cardsArray.count) {      // 命中, 直接返回结果
                                    success(cardsArray);
                                } else {
                                    failure(error);
                                }
                            }];
                           
                       }];

    } else {
        NSLog(@"%@ --- param is invalid !!!", NSStringFromClass([self class]));
    }
}

@end
