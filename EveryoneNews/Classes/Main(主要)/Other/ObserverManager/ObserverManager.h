//
//  ObserverManager.h
//  EveryoneNews
//
//  Created by apple on 15/12/17.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObserverManager : NSObject

- (id)initWithProtocol:(Protocol *)protocol
             observers:(NSSet *)observers;
- (void)addObserver:(id)observer;
- (void)removeObserver:(id)observer;

@end
