//
//  HeadViewFrame.h
//  EveryoneNews
//
//  Created by 于咏畅 on 15/3/23.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HeadViewDatasource.h"

@interface HeadViewFrame : NSObject

@property (nonatomic, assign, readonly) CGRect backgroundViewFrm;
@property (nonatomic, assign, readonly) CGRect titleLabFrm;
@property (nonatomic, assign, readonly) CGRect imgFrm;

@property (nonatomic, assign, readonly) CGRect titleFrm_1;
@property (nonatomic, assign, readonly) CGRect titleFrm_2;
@property (nonatomic, assign, readonly) CGRect titleFrm_3;

@property (nonatomic, assign, readonly) CGRect aspectFrm;

@property (nonatomic, assign, readonly) CGRect cutBlockFrm;

@property (nonatomic, assign)CGFloat cellH;

@property (nonatomic, strong)HeadViewDatasource *headViewDatasource;

@end
