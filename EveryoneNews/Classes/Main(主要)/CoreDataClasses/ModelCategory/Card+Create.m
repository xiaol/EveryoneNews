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
        [cdh saveBackgroundContext];
        dispatch_async(dispatch_get_main_queue(), ^{
            cardsArrayBlock([cards copy]);
        });
    }];
}

+ (Card *)createCardWithDict:(NSDictionary *)dict channelID:(NSString *)channelID
      inManagedObjectContext:(NSManagedObjectContext *)context {

    Card *card = nil;
    // 判断本地种是否有相同的newId, 有就不做添加操作
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Card" inManagedObjectContext:context];
    [fetch setEntity:entityDescription];
   // NSString *newId = [[dict[@"url"] stringByBase64Encoding] stringByTrimmingString:@"="];
    [fetch setPredicate:[NSPredicate predicateWithFormat:@"nid = %@ and channelId = %@",dict[@"nid"], channelID]];
    
    NSError * error = nil;
    NSArray *fetchedObjects;
    fetchedObjects = [context executeFetchRequest:fetch error:&error];
    
    if ([fetchedObjects count] == 0 ) {
        card = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:context];
        [context obtainPermanentIDsForObjects:@[card] error:nil];
        card.nid = dict[@"nid"];
        card.title = dict[@"title"];
        card.sourceSiteURL = dict[@"purl"];
        card.sourceSiteName = dict[@"pname"];
        card.updateTime = [NSString stringWithFormat:@"%lld", (long long)([dict[@"ptime"] timestampWithDateFormat:@"YYYY-MM-dd HH:mm:ss"] * 1000)];
        // 热点频道存入数据库需要更新当前频道编号
        card.channelId = ([channelID  isEqual: @"1"] ? @(1):dict[@"channel"]);
        card.type = dict[@"style"];
        card.docId = dict[@"docid"];
        card.commentsCount = dict[@"comment"];
        //    [CardRelate createCardRelatesWithDictArray:dict[@"relatePointsList"]
        //                                          card:card
        //                        inManagedObjectContext:context];
        [CardImage createCardImagesWithURLArray:dict[@"imgs"]
                                           card:card
                         inManagedObjectContext:context];
    } else {
        card = [fetchedObjects objectAtIndex:0];
    }
    return card;
}

#pragma mark - 收藏
+ (void)updateCard:(Card *)card {
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    [cdh.importContext performBlock:^{
        [cdh saveBackgroundContext];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"更新成功");
        });
    }];
}

@end
