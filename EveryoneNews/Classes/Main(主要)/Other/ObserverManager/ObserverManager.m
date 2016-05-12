//
//  ObserverManager.m
//  EveryoneNews
//
//  Created by apple on 15/12/17.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ObserverManager.h"
#import <objc/runtime.h>

@interface ObserverManager ()
@property (nonatomic, strong, readonly) NSMutableSet *observers;
@property (nonatomic, strong, readonly) Protocol *protocol;
@end

@implementation ObserverManager

- (id)initWithProtocol:(Protocol *)protocol observers:(NSSet *)observers {
    if (self = [super init]) {
        _observers = [NSMutableSet setWithSet:observers];
        _protocol = protocol;
    }
    return self;
}

- (void)addObserver:(id)observer {
    NSAssert([observer conformsToProtocol:self.protocol], @"This observer must conform to protocol !");
    [self.observers addObject:observer];
}

- (void)removeObserver:(id)observer {
    [self.observers removeObject:observer];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *sig= [super methodSignatureForSelector:aSelector];
    if (sig) {
        return sig;
    }
    
    struct objc_method_description desc = protocol_getMethodDescription(self.protocol, aSelector, YES, YES);
    if (desc.name == NULL) { // 没有必选, 检查可选
        desc = protocol_getMethodDescription(self.protocol, aSelector, NO, YES);
    }
    
    if (desc.name == NULL) {
        [self doesNotRecognizeSelector:aSelector];
        return nil;
    }
    
    return [NSMethodSignature signatureWithObjCTypes:desc.types];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    for (id observer in self.observers) {
        if ([observer respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:observer];
        }
    }
}
@end
