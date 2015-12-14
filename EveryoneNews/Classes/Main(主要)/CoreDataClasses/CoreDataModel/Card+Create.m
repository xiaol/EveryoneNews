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
    return cards;
}

+ (Card *)createCardWithDict:(NSDictionary *)dict
      inManagedObjectContext:(NSManagedObjectContext *)context {
    Card *card = nil;
    card = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:context];
    [context obtainPermanentIDsForObjects:@[card] error:nil];
    card.channelId = dict[@"channelId"];
    card.sourceSiteName = dict[@"sourceSiteName"];
    card.updateTime = [dict[@"updateTime"] absoluteDateString];
    card.title = dict[@"title"];
    card.commentNum = dict[@"commentNum"];
    card.newId = dict[@"newsId"];
    card.type = dict[@"type"];
    card.collection = dict[@"collection"];
    [CardRelate createCardRelatesWithDictArray:dict[@"relatePointsList"]
                                          card:card
                        inManagedObjectContext:context];
    [CardImage createCardImagesWithURLArray:dict[@"imgUrls"]
                                       card:card
                     inManagedObjectContext:context];
    return card;
}

@end
