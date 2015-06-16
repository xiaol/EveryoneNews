//
//  LPCategory.m
//  EveryoneNews
//
//  Created by apple on 15/6/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPCategory.h"

@implementation LPCategory

+ (instancetype)categoryWithURL:(NSString *)url
{
    LPCategory *category = [[LPCategory alloc] init];
    category.url = url;
    return category;
}


@end
