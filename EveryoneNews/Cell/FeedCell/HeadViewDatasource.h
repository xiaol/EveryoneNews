//
//  HeadViewDatasource.h
//  EveryoneNews
//
//  Created by 于咏畅 on 15/3/23.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeadViewDatasource : NSObject

@property (nonatomic, copy) NSString *imgStr;           //imgUrl
@property (nonatomic, copy) NSString *titleStr;         //title

@property (nonatomic, copy) NSString *sourceTitle;
@property (nonatomic, copy) NSString *sourceName;       //originsourceSiteName

@property (nonatomic, copy) NSString *aspectStr;

@property (nonatomic, copy) NSString *sourceUrl;        //sourceUrl

//@property (nonatomic, assign) int otherNum;             //otherNum

@property (nonatomic, strong) NSArray *subArr;          //sublist

+(id)headViewDatasourceWithDict:(NSDictionary *)dict;

@end
