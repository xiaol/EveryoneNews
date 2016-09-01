//
//  LPSubscriberFrame.h
//  Test
//
//  Created by dongdan on 16/9/1.
//  Copyright © 2016年 dongdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPSubscriber;
@interface LPSubscriberFrame : NSObject

@property (nonatomic, assign) CGRect titleFrame;
@property (nonatomic, assign) CGRect imageFrame;
@property (nonatomic, assign) CGRect subscriberButtonFrame;

@property (nonatomic, strong) LPSubscriber *subscriber;


@end
