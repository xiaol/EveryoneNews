//
//  BaiduFrame.h
//  EveryoneNews
//
//  Created by 于咏畅 on 15/3/31.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaiduDatasource.h"
@interface BaiduFrame : NSObject

@property (nonatomic, assign, readonly) CGRect baseViewFrm;
@property (nonatomic, assign, readonly) CGRect backViewFrm;
@property (nonatomic, assign, readonly) CGRect titleFrm;
@property (nonatomic, assign, readonly) CGRect abstractFrm;
@property (nonatomic, assign, readonly) CGRect baiduIconFrm;

@property (nonatomic, assign) CGFloat cellH;

@property (nonatomic, strong) BaiduDatasource *baiduDatasource;

@end
