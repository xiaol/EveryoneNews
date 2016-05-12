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
    NSString *newId = [[dict[@"url"] stringByBase64Encoding] stringByTrimmingString:@"="];
    [fetch setPredicate:[NSPredicate predicateWithFormat:@"newId = %@ and channelId = %@",newId, channelID]];
    
    NSError * error = nil;
    NSArray *fetchedObjects;
    fetchedObjects = [context executeFetchRequest:fetch error:&error];
    
    if ([fetchedObjects count] == 0 ) {
        card = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:context];
        [context obtainPermanentIDsForObjects:@[card] error:nil];
        card.newId = newId;
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
    } else {
        card = [fetchedObjects objectAtIndex:0];
    }
    return card;
}


-(BOOL)Collected{

    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    
    Card *card = [cdh.context existingObjectWithID:self.objectID error:nil];
    
    if ([card.isCollected isEqual:[[NSNumber alloc]initWithInt:1]]) {
        
        card.isCollected = [[NSNumber alloc]initWithInt:0];
    }else{
        card.isCollected = [[NSNumber alloc]initWithInt:1];
    }
    
//    card.isCollected = (card.isCollected == [[NSNumber alloc]initWithInt:1] ? [[NSNumber alloc]initWithInt:0] : [[NSNumber alloc]initWithInt:1]);
    
    return [cdh.context save:nil];
}



@end
