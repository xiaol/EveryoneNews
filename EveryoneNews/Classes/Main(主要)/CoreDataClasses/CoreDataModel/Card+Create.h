//
//  Card+Create.h
//  EveryoneNews
//
//  Created by apple on 15/12/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "Card.h"

@interface Card (Create)

+ (Card *)createCardWithDict:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)createCardsWithDictArray:(NSArray *)dicts;

@end
