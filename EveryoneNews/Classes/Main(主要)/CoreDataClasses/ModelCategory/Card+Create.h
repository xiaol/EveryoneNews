//
//  Card+Create.h
//  EveryoneNews
//
//  Created by apple on 15/12/10.
//  Copyright © 2015年 apple. All rights reserved.
//  该分类负责: 创建Feed页卡片并存入数据库

#import "Card.h"

typedef void (^cardsArrayBlock)(NSArray *cardsArray);
typedef void (^cardIsCollectedBlock)(BOOL isCollected, BOOL isExists);

@interface Card (Create)

+ (Card *)createCardWithDict:(NSDictionary *)dict channelID:(NSString *)channelID inManagedObjectContext:(NSManagedObjectContext *)context;
/**
 *  依据字典数组(json)创建模型数组cards, 并存入数据库
 *
 *  @param dicts: json data
 *
 *  @return 模型数组
 */
//+ (NSArray *)createCardsWithDictArray:(NSArray *)dicts
//                               channelID:(NSString *)channelID;


// 创建模型数组，存入数据库
+ (void)createCardsWithDictArray:(NSArray *)dicts
                       channelID:(NSString *)channelID cardsArrayBlock:(cardsArrayBlock)cardsArrayBlock;


+ (void)updateCard:(Card *)card;

+ (void)createCardWithDict:(NSDictionary *)cardDict commentDict:(NSDictionary *)commentDict;

+ (void)createCardWithDict:(NSDictionary *)cardDict isCollected:(BOOL)isCollected;

+ (void)cardIsCollected:(NSString *)nid cardIsCollectedBlock:(cardIsCollectedBlock)cardIsCollectedBlock;

+ (NSMutableAttributedString *)titleHtmlString:(NSString *)title;

+ (NSMutableAttributedString *)titleHtmlString:(NSString *)title isRead:(NSNumber *)isRead;

+ (void)cancelConcernCard:(NSString *)sourceName;
@end
