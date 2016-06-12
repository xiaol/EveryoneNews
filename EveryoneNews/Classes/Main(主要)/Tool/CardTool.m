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

@interface CardTool ()

@end

@implementation CardTool

+ (void)cardsWithParam:(CardParam *)param
               channelID:(NSString *)channelID
               success:(CardsFetchedSuccessHandler)success
               failure:(CardsFetchedFailureHandler)failure {
    
    NSString *authorization = [userDefaults objectForKey:@"uauthorization"];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"cid"] = channelID;
    paramDict[@"tcr"] = param.startTime;
    paramDict[@"tmk"] = @"0";
    
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
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
}


//- (void)deleteCardFromCoreData:(CardFrame *)cardFrame {
//    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
//    Card *card = cardFrame.card;
//    [cdh.importContext performBlock:^{
//        [cdh.importContext deleteObject:card];
//        [cdh saveBackgroundContext];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.currentPage = nil;
//            self.currentCardFrame = nil;
//            self.currentIndexPath = nil;
//        });
//    }];
//}

@end
