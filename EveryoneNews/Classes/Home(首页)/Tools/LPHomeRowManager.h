//
//  LPHomeRowManager.h
//  EveryoneNews
//
//  Created by dongdan on 16/6/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPHomeRowManager : NSObject

@property (nonatomic, assign) NSInteger currentRowIndex;

+ (instancetype)sharedManager;


@end
