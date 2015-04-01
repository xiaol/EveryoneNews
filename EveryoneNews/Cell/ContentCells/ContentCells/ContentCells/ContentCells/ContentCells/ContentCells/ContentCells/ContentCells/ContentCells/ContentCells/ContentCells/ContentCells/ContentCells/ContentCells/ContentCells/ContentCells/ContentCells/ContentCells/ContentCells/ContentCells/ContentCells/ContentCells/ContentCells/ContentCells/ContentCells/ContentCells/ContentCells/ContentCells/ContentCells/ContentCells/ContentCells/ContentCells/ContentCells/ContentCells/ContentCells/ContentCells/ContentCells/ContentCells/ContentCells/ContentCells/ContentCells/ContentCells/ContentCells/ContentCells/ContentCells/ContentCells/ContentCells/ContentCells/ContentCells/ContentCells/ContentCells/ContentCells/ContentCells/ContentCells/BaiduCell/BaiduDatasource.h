//
//  BaiduDatasource.h
//  EveryoneNews
//
//  Created by 于咏畅 on 15/3/31.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaiduDatasource : NSObject

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *abstract;
@property (nonatomic, copy) NSString *title;

- (id)initWithDict:(NSDictionary *)dict;
+ (id)baiduDatasourceWithDict:(NSDictionary *)dict;

@end
