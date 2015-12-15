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

@implementation Card (Create)

+ (NSArray *)createCardsWithDictArray:(NSArray *)dicts {
    NSMutableArray *cards = [NSMutableArray array];
     CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    for (NSDictionary *dict in dicts) {
        Card *card = [self createCardWithDict:dict inManagedObjectContext:cdh.context];
        [cards addObject:card];
    }
    // optional !!
    [cdh saveBackgroundContext];
    return cards;
}

+ (Card *)createCardWithDict:(NSDictionary *)dict
      inManagedObjectContext:(NSManagedObjectContext *)context {
    Card *card = nil;
    card = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:context];
    [context obtainPermanentIDsForObjects:@[card] error:nil];
    card.newId = [dict[@"url"] stringByBase64Encoding];
    card.title = dict[@"title"];
    card.sourceSiteURL = dict[@"pubUrl"];
    card.sourceSiteName = dict[@"pubName"];
    card.updateTime = [NSString stringWithFormat:@"%ld", (long)([dict[@"pubTime"] timestampWithDateFormat:@"YYYY-MM-dd HH:mm:ss"] * 1000)];
    card.updateTime = dict[@"pubTime"];
    card.channelId = dict[@"channelId"];
    card.type = dict[@"imgStyle"];
//    [CardRelate createCardRelatesWithDictArray:dict[@"relatePointsList"]
//                                          card:card
//                        inManagedObjectContext:context];
    [CardImage createCardImagesWithURLArray:dict[@"imgList"]
                                       card:card
                     inManagedObjectContext:context];
    return card;
}

@end
