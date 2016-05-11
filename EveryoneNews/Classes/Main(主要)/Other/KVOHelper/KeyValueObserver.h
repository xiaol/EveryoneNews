//
//  KeyValueObserver.h
//  EveryoneNews
//
//  Created by apple on 15/10/26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyValueObserver : NSObject
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;

+ (NSObject *)observeObject:(id)object keyPath:(NSString *)keyPath target:(id)target selector:(SEL)selector;
+ (NSObject *)observeObject:(id)object keyPath:(NSString *)keyPath target:(id)target selector:(SEL)selector options:(NSKeyValueObservingOptions)options;
@end
