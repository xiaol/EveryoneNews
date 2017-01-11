//
//  CardConcern+Create.m
//  EveryoneNews
//
//  Created by dongdan on 16/7/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CardConcern+Create.h"
#import "CardSourceColor.h"

@implementation CardConcern (Create)

//+ (CardConcern *)createCardWithKeyword:(NSString *)keyword
//                                  card:(Card *)card
//                inManagedObjectContext:(NSManagedObjectContext *)context {
//    CardConcern *concern = nil;
//    concern = [NSEntityDescription insertNewObjectForEntityForName:@"CardConcern" inManagedObjectContext:context];
//    [context obtainPermanentIDsForObjects:@[concern] error:nil];
//    concern.keyword = keyword;
//    concern.card = card;
//    concern.keywordColor = [self sourceColorWithKeyword:keyword context:context];
//    concern.utype = [NSNumber numberWithInteger:[[userDefaults objectForKey:@"utype"] integerValue]];
//    return concern;
//}
//
//+ (NSString *)sourceColorWithKeyword:(NSString *)keyword context:(NSManagedObjectContext *)context {
//    // 先查询数据库中颜色是否存在，不存在则添加
//    CardSourceColor *cardSourceColor = nil;
//    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"CardSourceColor" inManagedObjectContext:context];
//    [fetch setEntity:entityDescription];
//    [fetch setPredicate:[NSPredicate predicateWithFormat:@"sourceName = %@",keyword]];
//    
//    NSError * error = nil;
//    NSArray *fetchedObjects;
//    fetchedObjects = [context executeFetchRequest:fetch error:&error];
//    if ([fetchedObjects count] == 0 ) {
//        cardSourceColor = [NSEntityDescription insertNewObjectForEntityForName:@"CardSourceColor" inManagedObjectContext:context];
//        NSString *randomColor = [self randomColor];
//        cardSourceColor.sourceName = keyword;
//        cardSourceColor.sourceColor = randomColor;
//        return randomColor;
//        
//    } else {
//        cardSourceColor = [fetchedObjects objectAtIndex:0];
//        return cardSourceColor.sourceColor;
//    }
//}
//
//+ (NSString *)randomColor {
//    NSArray *colorArray = @[@"#f46b75", @"#a87dd7",@"5994e3", @"#85ca4b", @"#eba85d", @"#64b6eb"];
//    NSInteger i = arc4random() % 5;
//    return colorArray[i];
//}

@end
