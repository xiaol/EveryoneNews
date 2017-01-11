//
//  LPPersonalFrame.h
//  EveryoneNews
//
//  Created by dongdan on 16/9/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPPersonal;
@interface LPPersonalFrame : NSObject

@property (nonatomic, assign) CGRect imageNameF;
@property (nonatomic, assign) CGRect titleF;
@property (nonatomic, assign) CGRect arrowF;
@property (nonatomic, assign) CGRect seperatorLayerF;

@property (nonatomic, strong) LPPersonal *personal;

@end
