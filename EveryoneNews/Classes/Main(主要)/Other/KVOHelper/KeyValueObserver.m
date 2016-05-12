//
//  KeyValueObserver.m
//  EveryoneNews
//
//  Created by apple on 15/10/26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "KeyValueObserver.h"

@interface KeyValueObserver ()
@property (nonatomic, weak) id observedObject;
@property (nonatomic, copy) NSString *keyPath;
@end

@implementation KeyValueObserver
- (instancetype)initWithObject:(id)object keyPath:(NSString *)keyPath target:(id)target selector:(SEL)selector options:(NSKeyValueObservingOptions)options { // 注册为观察者
    if (object == nil) {
        return nil;
    }
    NSParameterAssert(target != nil);
    NSParameterAssert([target respondsToSelector:selector]);
    self = [super init];
    if (self) {
        self.target = target;
        self.selector = selector;
        self.observedObject = object;
        self.keyPath = keyPath;
        [object addObserver:self forKeyPath:keyPath options:options context:(__bridge void *)(self)];
    }
    return self;
}

+ (NSObject *)observeObject:(id)object keyPath:(NSString *)keyPath target:(id)target selector:(SEL)selector options:(NSKeyValueObservingOptions)options {
    return [[self alloc] initWithObject:object keyPath:keyPath target:target selector:selector options:options];
}

+ (NSObject *)observeObject:(id)object keyPath:(NSString *)keyPath target:(id)target selector:(SEL)selector {
    return [self observeObject:object keyPath:keyPath target:target selector:selector options:0];
}

// 观测属性变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == (__bridge void *)(self)) {
        [self didChange:change];
    }
}
// target执行selector
- (void)didChange:(NSDictionary *)change {
    id target = self.target;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [target performSelector:self.selector withObject:change];
#pragma clang diagnostic pop
}

// 注销监听
- (void)dealloc {
    [self.observedObject removeObserver:self forKeyPath:self.keyPath];
}
@end
