//
//  NSObject+Swizzle.m
//  iVideo
//
//  Created by apple on 16/3/16.
//  Copyright © 2016年 lvpin. All rights reserved.
//

#import "NSObject+Swizzle.h"
#import <objc/runtime.h>

@implementation NSObject (Swizzle)

+ (IMP)swizzleInstanceSelector:(SEL)selector
                       withIMP:(IMP)imp {
    Method originalMethod = class_getInstanceMethod([self class], selector);
    IMP originalIMP = method_getImplementation(originalMethod);
    if (!class_addMethod(self, selector, imp, method_getTypeEncoding(originalMethod))) { // 已有该方法实现
        method_setImplementation(originalMethod, imp);
    }
    return originalIMP;
}

@end
