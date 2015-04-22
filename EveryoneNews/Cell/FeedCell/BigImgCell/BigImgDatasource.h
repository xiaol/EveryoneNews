//
//  BigImgDatasource.h
//  EveryoneNews
//
//  Created by 于咏畅 on 15/4/21.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BigImgDatasource : NSObject

@property (nonatomic, copy) NSString *categoryStr;
@property (nonatomic, copy) NSString *titleStr;
//@property (nonatomic, copy) NSString *imgUrlStr;

////////
@property (nonatomic, copy) NSString *imgStr;           //imgUrl
//@property (nonatomic, copy) NSString *titleStr;         //title

@property (nonatomic, copy) NSString *aspectStr;

@property (nonatomic, copy) NSString *sourceUrl;        //sourceUrl

@property (nonatomic, copy) NSArray *responseUrls;

@property (nonatomic, copy) NSString *updateTime;

@property (nonatomic, strong) NSArray *subArr;          //sublist

@property (nonatomic, copy) NSString *sourceSiteName;

@property (nonatomic, copy) NSString *rootClass;

//@property (nonatomic, copy) NSString *categoryStr;

+(id)bigImgDatasourceWithDict:(NSDictionary *)dict;

@end
