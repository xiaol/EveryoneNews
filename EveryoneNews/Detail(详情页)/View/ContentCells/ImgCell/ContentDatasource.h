//
//  ContentDatasource.h
//  upNews
//
//  Created by 于咏畅 on 15/1/20.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ContentDatasource : NSObject

@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, assign) CGFloat imgW;
@property (nonatomic, assign) CGFloat imgH;

- (id)initWithImgStr:(NSString *)imgUrl;
+ (id)contentDatasourceWithImgStr:(NSString *)imgUrl;

@end
