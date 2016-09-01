//
//  LPSubscriber.m
//  Test
//
//  Created by dongdan on 16/9/1.
//  Copyright © 2016年 dongdan. All rights reserved.
//

#import "LPSubscriber.h"

@implementation LPSubscriber

- (instancetype)initWithTitle:(NSString *)title imageURL:(NSString *)imageURL {
    if (self = [super init]) {
        _title = title;
        _imageURL = imageURL;
    }
    return self;
}

@end
