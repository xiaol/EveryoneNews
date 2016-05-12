//
//  Press+HTTP.m
//  EveryoneNews
//
//  Created by apple on 15/11/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "Press+HTTP.h"
#import "LPHttpTool.h"
#import <objc/runtime.h>

@implementation Press (HTTP)
static char httpRequestKey;

- (void)setHttp:(LPHttpTool *)http {
    objc_setAssociatedObject(self, &httpRequestKey, http, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LPHttpTool *)http {
    return objc_getAssociatedObject(self, &httpRequestKey);
}

- (void)cancelRequest {
    if (self.http) {
        [self.http cancelRequest];
        self.http = nil;
    }
}


@end
