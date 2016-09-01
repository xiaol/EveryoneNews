//
//  LPSubscriber.h
//  Test
//
//  Created by dongdan on 16/9/1.
//  Copyright © 2016年 dongdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPSubscriber : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageURL;

- (instancetype)initWithTitle:(NSString *)title imageURL:(NSString *)imageURL;

@end
