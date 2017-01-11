//
//  LPPersonalSetting.m
//  EveryoneNews
//
//  Created by dongdan on 16/9/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPPersonalSetting.h"

@implementation LPPersonalSetting

- (instancetype)initWithIdentifier:(NSString *)identifier title:(NSString *)title imageName:(NSString *)imageName {
    if (self = [super init]) {
        _identifier = identifier;
        _title = title;
        _imageName = imageName;
    }
    return self;
}

@end
