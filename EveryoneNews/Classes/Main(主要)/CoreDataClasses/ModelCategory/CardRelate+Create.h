//
//  CardRelate+Create.h
//  EveryoneNews
//
//  Created by apple on 15/12/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "CardRelate.h"
@class Card;

@interface CardRelate (Create)

+ (NSSet *)createCardRelatesWithDictArray:(NSArray *)dicts
                                     card:(Card *)card
                   inManagedObjectContext:(NSManagedObjectContext *)context;
+ (CardRelate *)createCardRelateWithDict:(NSDictionary *)dict
                                    card:(Card *)card
                  inManagedObjectContext:(NSManagedObjectContext *)context;

@end
