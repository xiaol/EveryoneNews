//
//  BigImgFrm.h
//  EveryoneNews
//
//  Created by 于咏畅 on 15/4/21.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BigImgDatasource.h"
#import <UIKit/UIKit.h>

@interface BigImgFrm : NSObject

@property (nonatomic, strong)BigImgDatasource *bigImgDatasource;

@property (nonatomic, assign, readonly) CGRect backFrm;
@property (nonatomic, assign, readonly) CGRect imgFrm;
@property (nonatomic, assign, readonly) CGRect titleFrm;
@property (nonatomic, assign, readonly) CGRect categoryFrm;
@property (nonatomic, assign, readonly) CGRect cutlineFrm;
@property (nonatomic, assign, readonly) CGRect toumuFrm;

@property (nonatomic, assign) CGFloat CellH;

@end
