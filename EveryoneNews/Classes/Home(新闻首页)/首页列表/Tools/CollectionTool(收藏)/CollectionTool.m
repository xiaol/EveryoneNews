//
//  CollectionTool.m
//  EveryoneNews
//
//  Created by dongdan on 16/8/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CollectionTool.h"
#import "LPHttpTool.h"
#import "LPMyCollectionCard.h"
#import "LPMyCollectionCardFrame.h"

@implementation CollectionTool

+ (void)collectionQuerySuccess:(CollectionQuerySuccessHandler)success failure:(CollectionQueryFailureHandler)failure {
    NSString *authorization = [userDefaults objectForKey:@"uauthorization"];
    NSString *uid = [[userDefaults objectForKey:@"uid"] stringValue];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = uid;
    NSString *url = [NSString stringWithFormat:@"%@/v2/ns/au/cols", ServerUrlVersion2];
    [LPHttpTool getJsonAuthorizationWithURL:url authorization:authorization params:paramDict success:^(id json) {
        // 有数据
        if ([json[@"code"] integerValue] == 2000) {
            NSArray *jsonData = json[@"data"];
            NSMutableArray *collectionArray = [NSMutableArray array];
            for (NSDictionary *dict in jsonData) {
                LPMyCollectionCard *card = [[LPMyCollectionCard alloc] init];
                card.nid = dict[@"nid"];
                card.title = dict[@"title"];
                card.sourceSiteURL = dict[@"purl"];
                card.sourceSiteName = dict[@"pname"];
                card.updateTime = [NSString stringWithFormat:@"%lld", (long long)([dict[@"ptime"] timestampWithDateFormat:@"YYYY-MM-dd HH:mm:ss"] * 1000)];
                card.cardImages = dict[@"imgs"];
                card.docId = dict[@"docid"];
                card.commentsCount = dict[@"comment"];
                card.channelId = dict[@"channel"];
                
                if ([dict[@"rtype"] integerValue] == videoNewsType) {
                    card.rtype = [dict[@"rtype"] integerValue];
                    card.thumbnail = dict[@"thumbnail"];
                    card.duration = [dict[@"duration"] integerValue];
                    card.videoURL = dict[@"videourl"];
                }
   
                [collectionArray addObject:card];
            }
            success(collectionArray);
        }
        // 没有数据
        else if ([json[@"code"] integerValue] == 2002) {
            NSArray *collectionArray = [[NSArray alloc] init];
            success(collectionArray);
        }
    } failure:^(NSError *error) {
        failure(error);
        
        NSLog(@"%@", error);
    }];
}

+ (void)deleteCollection:(NSString *)nid deleteFlag:(CollectionDeleteFlag)deleteFlag {
    NSString *authorization = [userDefaults objectForKey:@"uauthorization"];
    NSString *uid = [[userDefaults objectForKey:@"uid"] stringValue];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = uid;
    paramDict[@"nid"] = nid;
    NSString *url = [NSString stringWithFormat:@"%@/v2/ns/cols", ServerUrlVersion2];
    [LPHttpTool deleteAuthorizationJSONWithURL:url authorization:authorization params:paramDict success:^(id json) {
        NSLog(@"%@", json);
        if ([json[@"code"] integerValue] == 2000) {
            deleteFlag(LPSuccess);
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

+ (void)addConcernWithNid:(NSString *)nid codeFlag:(CodeFlag)codeFlag {
    
    NSString *authorization = [userDefaults objectForKey:@"uauthorization"];
    NSString *uid = [[userDefaults objectForKey:@"uid"] stringValue];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@/v2/ns/cols?uid=%@&nid=%@", ServerUrlVersion2, uid, nid];
    [LPHttpTool postAuthorizationJSONWithURL:url authorization:authorization params:paramDict success:^(id json) {
        if ([json[@"code"] integerValue] == 2000) {
            codeFlag(LPSuccess);
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

+ (void)cancelConcernWithNid:(NSString *)nid  codeFlag:(CodeFlag)codeFlag {
    
    NSString *authorization = [userDefaults objectForKey:@"uauthorization"];
    NSString *uid = [[userDefaults objectForKey:@"uid"] stringValue];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = uid;
    paramDict[@"nid"] = nid;
    NSString *url = [NSString stringWithFormat:@"%@/v2/ns/cols", ServerUrlVersion2];
    [LPHttpTool deleteAuthorizationJSONWithURL:url authorization:authorization params:paramDict success:^(id json) {
        if ([json[@"code"] integerValue] == 2000) {
            codeFlag(LPSuccess);
        }
    } failure:^(NSError *error) {
         NSLog(@"%@", error);
    }];
}

@end
