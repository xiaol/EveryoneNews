//
//  DoubanDatasource.h
//  EveryoneNews
//
//  Created by 于咏畅 on 15/4/1.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DoubanDatasource : NSObject

@property (nonatomic, strong) NSArray *tagArr;

+ (id)doubanDatasourceWithArr:(NSArray *)array;

@end
