//
//  HeadViewDatasource.h
//  EveryoneNews
//
//  Created by 于咏畅 on 15/3/23.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeadViewDatasource : NSObject

@property (nonatomic, copy) NSString *imgStr;
@property (nonatomic, copy) NSString *titleStr;

@property (nonatomic, copy) NSString *sourceTitle;
@property (nonatomic, copy) NSString *sourceName;

@property (nonatomic, copy) NSString *aspectStr;

+(id)headViewDatasourceWithDict:(NSDictionary *)dict;

@end
