//
//  CardRelate+Create.m
//  EveryoneNews
//
//  Created by apple on 15/12/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "CardRelate+Create.h"
#import "Card.h"

@implementation CardRelate (Create)

+ (NSSet *)createCardRelatesWithDictArray:(NSArray *)dicts
                                     card:(Card *)card
                   inManagedObjectContext:(NSManagedObjectContext *)context {
    NSMutableSet *set = [NSMutableSet set];
    for (NSDictionary *dict in dicts) {
        CardRelate *relate = [self createCardRelateWithDict:dict card:card inManagedObjectContext:context];
        [set addObject:relate];
    }
    return set;
}

+ (CardRelate *)createCardRelateWithDict:(NSDictionary *)dict
                                    card:(Card *)card
                  inManagedObjectContext:(NSManagedObjectContext *)context {
    CardRelate *relate = nil;
    relate = [NSEntityDescription insertNewObjectForEntityForName:@"CardRelate" inManagedObjectContext:context];
    [context obtainPermanentIDsForObjects:@[relate] error:nil];
    relate.sourceSiteName = dict[@"sourceSiteName"];
    relate.sourceUrl = dict[@"sourceUrl"];
    relate.compress = dict[@"compress"];
    relate.similarity = dict[@"similarity"];
    relate.card = card;
    return relate;
}

@end
