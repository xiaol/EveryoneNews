//
//  Card+Fetch.h
//  EveryoneNews
//
//  Created by apple on 15/12/14.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "Card.h"
@class CardParam;

@interface Card (Fetch)
/**
 *  从数据库获取cards
 *
 *  @param param 参数
 *
 */
+ (NSArray *)fetchCardsWithCardParam:(CardParam *)param;
@end
