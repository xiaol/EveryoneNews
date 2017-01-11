//
//  Press+HTTPStatus.m
//  EveryoneNews
//
//  Created by dongdan on 16/1/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "Press+HTTPStatus.h"
#import <objc/runtime.h>

static char httpStatusKey;

@implementation Press (HTTPStatus)

- (void)setHttpStatus:(NSString *)httpStatus {
    objc_setAssociatedObject(self, &httpStatusKey, httpStatus, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)httpStatus {
    return  (NSString *)objc_getAssociatedObject(self, &httpStatusKey);
}

@end
