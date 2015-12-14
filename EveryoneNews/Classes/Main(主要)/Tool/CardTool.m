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

@implementation CardTool

+ (void)cardsWithParam:(CardParam *)param
               success:(CardsFetchedSuccessHandler)success
               failure:(CardsFetchedFailureHandler)failure {
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    if (param.type == HomeCardsFetchTypeNew) {
        paramDict[@"cid"] = param.channelID;
        paramDict[@"offset"] = param.count;
        paramDict[@"tstart"] = param.startTime;
        NSString *url = [NSString stringWithFormat:@"%@bdp/news/refresh", ServerUrl];
        [LPHttpTool getWithURL:url
                        params:paramDict
                       success:^(id json) {
                           NSArray *cards = [Card createCardsWithDictArray:json];
                           success(cards);
                       }
                       failure:^(NSError *error) {
                           failure(error);
                       }];
        
    } else if (param.type == HomeCardsFetchTypeMore) {
        //  先从数据库获取, 如未命中, 转网络请求
        NSArray *cards = [Card fetchCardsWithCardParam:param];
        if (cards.count) {
            success(cards);
        } else {
            paramDict[@"cid"] = param.channelID;
            paramDict[@"offset"] = param.count;
            paramDict[@"tstart"] = param.startTime;
            NSString *url = [NSString stringWithFormat:@"%@bdp/news/load", ServerUrl];
            [LPHttpTool getWithURL:url
                            params:paramDict
                           success:^(id json) {
                               NSArray *cards = [Card createCardsWithDictArray:json];
                               success(cards);
                           }
                           failure:^(NSError *error) {
                               failure(error);
                           }];
        }
    } else if (param.type == HomeCardsFetchTypeToday) {
        
    } else {
        NSLog(@"param is wrong!");
    }
}

@end
