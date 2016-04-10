//
//  Card+Create.m
//  EveryoneNews
//
//  Created by apple on 15/12/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "Card+Create.h"
#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "CardImage+Create.h"
#import "CardRelate+Create.h"
#import <objc/runtime.h>
#import "Card+Fetch.h"

@implementation Card (Create)


+ (void)createCardsWithDictArray:(NSArray *)dicts
                    channelID:(NSString *)channelID cardsArrayBlock:(cardsArrayBlock)cardsArrayBlock {
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    [cdh.importContext performBlock:^{
        NSMutableArray *cards = [NSMutableArray array];
        for (NSDictionary *dict in dicts) {
            Card *card = [self createCardWithDict:dict channelID:channelID inManagedObjectContext:cdh.importContext];
            [cards addObject:card];
        }
        NSError *error = nil;
        [cdh.importContext save:&error];
        [cdh.context performBlock:^{
            [cdh saveBackgroundContext];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            cardsArrayBlock([cards copy]);
        });
    }];
}

+ (Card *)createCardWithDict:(NSDictionary *)dict channelID:(NSString *)channelID
      inManagedObjectContext:(NSManagedObjectContext *)context {
    Card *card = nil;
    card = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:context];
    [context obtainPermanentIDsForObjects:@[card] error:nil];
    card.newId = [[dict[@"url"] stringByBase64Encoding] stringByTrimmingString:@"="];
    card.title = dict[@"title"];
    card.sourceSiteURL = dict[@"pubUrl"];
    card.sourceSiteName = dict[@"pubName"];
    card.updateTime = [NSString stringWithFormat:@"%lld", (long long)([dict[@"pubTime"] timestampWithDateFormat:@"YYYY-MM-dd HH:mm:ss"] * 1000)];
    // 热点频道存入数据库需要更新当前频道编号
    card.channelId = ([channelID  isEqual: @"1"] ? @(1):dict[@"channelId"]);
    card.type = dict[@"imgStyle"];
    card.docId = dict[@"docid"];
    card.commentsCount = dict[@"commentsCount"];
    
    
//    [CardRelate createCardRelatesWithDictArray:dict[@"relatePointsList"]
//                                          card:card
//                        inManagedObjectContext:context];
    [CardImage createCardImagesWithURLArray:dict[@"imgList"]
                                       card:card
                     inManagedObjectContext:context];
    return card;
}

//- (NSString *)description {
//    unsigned int count = 0;
//    objc_property_t *properties = class_copyPropertyList(self.class, &count);
//    for (NSInteger i = 0; i < count; i++) {
//        const char *name = property_getName(properties[i]);
//        NSLog(@"%s", name);
//    }
//    free(properties);
//    return nil;
//}

@end
