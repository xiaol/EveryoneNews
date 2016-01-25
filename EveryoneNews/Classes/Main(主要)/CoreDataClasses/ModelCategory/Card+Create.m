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

+ (NSArray *)createCardsWithDictArray:(NSArray *)dicts {
    NSMutableArray *cards = [NSMutableArray array];
     CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    for (NSDictionary *dict in dicts) {
//        // 判断本地文件中是否存在相应的url，存在则不保存
//        NSArray *array = [Card fetchCardsWithSourceSiteURL:dict[@"pubUrl"]];
//        if (array.count < 1) {
//            Card *card = [self createCardWithDict:dict inManagedObjectContext:cdh.context];
//            [cards addObject:card];
//        }

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
    card.newId = [[dict[@"url"] stringByBase64Encoding] stringByTrimmingString:@"="];
    card.title = dict[@"title"];
    card.sourceSiteURL = dict[@"pubUrl"];
    card.sourceSiteName = dict[@"pubName"];
    card.updateTime = [NSString stringWithFormat:@"%lld", (long long)([dict[@"pubTime"] timestampWithDateFormat:@"YYYY-MM-dd HH:mm:ss"] * 1000)];
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
