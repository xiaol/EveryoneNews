//
//  LPPersonal.m
//  EveryoneNews
//
//  Created by dongdan on 16/9/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPPersonal.h"

@implementation LPPersonal

-(instancetype)initWithImageName:(NSString *)imageName title:(NSString *)title {
    if (self = [super init]) {
        _imageName = imageName;
        _title = title;
    }
    return self;
}

@end
