//
//  LPPersonalSettingFrame.h
//  EveryoneNews
//
//  Created by dongdan on 16/9/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPPersonalSetting;
@interface LPPersonalSettingFrame : NSObject

@property (nonatomic, assign) CGRect imageNameF;
@property (nonatomic, assign) CGRect titleF;
@property (nonatomic, assign) CGRect arrowF;
@property (nonatomic, assign) CGRect seperatorLayerF;
@property (nonatomic, assign) CGRect signOutF;
@property (nonatomic, assign) CGRect segmentControlF;
@property (nonatomic, assign) CGRect switchF;

@property (nonatomic, strong) LPPersonalSetting *personalSetting;


@end
