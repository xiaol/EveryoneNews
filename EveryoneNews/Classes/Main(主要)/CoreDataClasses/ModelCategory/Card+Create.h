//
//  Card+Create.h
//  EveryoneNews
//
//  Created by apple on 15/12/10.
//  Copyright © 2015年 apple. All rights reserved.
//  该分类负责: 创建Feed页卡片并存入数据库

#import "Card.h"

@interface Card (Create)

+ (Card *)createCardWithDict:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
/**
 *  依据字典数组(json)创建模型数组cards, 并存入数据库
 *
 *  @param dicts: json data
 *
 *  @return 模型数组
 */
+ (NSArray *)createCardsWithDictArray:(NSArray *)dicts;

@end
