//
//  CardTool.m
//  EveryoneNews
//
//  Created by apple on 15/12/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "CardTool.h"
#import "LPHttpTool.h"


@implementation CardTool

//  先从数据库获取, 如未命中, 转网络请求
+ (void)cardsWithParam:(NSDictionary *)param
               success:(CardsFetchedSuccessHandler)success
               failure:(CardsFetchedFailureHandler)failure {
    
}

@end
