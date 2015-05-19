//
//  SingleImgFrm.h
//  EveryoneNews
//
//  Created by 于咏畅 on 15/5/6.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HeadViewDatasource.h"

@interface SingleImgFrm : NSObject

//@property (nonatomic, assign, readonly) CGRect baseFrm;
@property (nonatomic, assign, readonly) CGRect backgroundFrm;
@property (nonatomic, assign, readonly) CGRect imgFrm;
@property (nonatomic, assign, readonly) CGRect titleFrm;
@property (nonatomic, assign, readonly) CGRect categoryFrm;
@property (nonatomic, assign, readonly) CGRect aspectFrm;
@property (nonatomic, assign, readonly) CGRect pointFrm_1;
@property (nonatomic, assign, readonly) CGRect pointFrm_2;
@property (nonatomic, assign, readonly) CGRect pointFrm_3;
@property (nonatomic, assign, readonly) CGRect cutlineFrm;
//
@property (nonatomic, assign, readonly) CGRect topBlueBarFrm_1;
@property (nonatomic, assign, readonly) CGRect topBlueBarFrm_2;
@property (nonatomic, assign, readonly) CGRect topBlueBarFrm_3;
@property (nonatomic, assign, readonly) CGRect bottonBlueBarFrm_1;
@property (nonatomic, assign, readonly) CGRect bottonBlueBarFrm_2;
@property (nonatomic, assign, readonly) CGRect bottonBlueBarFrm_3;
@property (nonatomic, assign, readonly) CGRect circleFrm_1;
@property (nonatomic, assign, readonly) CGRect circleFrm_2;
@property (nonatomic, assign, readonly) CGRect circleFrm_3;
@property (nonatomic, assign, readonly) CGRect sourceTitleFrm_1;
@property (nonatomic, assign, readonly) CGRect sourceTitleFrm_2;
@property (nonatomic, assign, readonly) CGRect sourceTitleFrm_3;
@property (nonatomic, assign, readonly) CGRect whiteBlockFrm;

@property (nonatomic, assign)CGFloat cellH;

@property (nonatomic, strong)HeadViewDatasource *headViewDatasource;


@end
