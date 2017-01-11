//
//  Card+Fetch.h
//  EveryoneNews
//
//  Created by apple on 15/12/14.
//  Copyright © 2015年 apple. All rights reserved.
//  该分类负责: 依据参数模型读取数据库记录

#import "Card.h"
@class CardParam;

typedef void (^cardsArrayBlock)(NSArray *cardsArray);

@interface Card (Fetch)
/**
 *  从数据库获取模型数组cards
 *
 *  @param param 参数模型
 *
 */
//+ (NSArray *)fetchCardsWithCardParam:(CardParam *)param;
//
//+ (NSArray *)fetchCardsWithSourceSiteURL:(NSString *)sourceSiteURL;

+ (void)fetchCardsWithCardParam:(CardParam *)param cardsArrayBlock:(cardsArrayBlock)cardsArrayBlock;

@end
