//
//  ContentFrame.h
//  EveryoneNews
//
//  Created by apple on 15/10/27.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Content;
@interface ContentFrame : NSObject
@property (nonatomic, strong) Content *content;

@property (nonatomic, assign, readonly) CGRect textF;
@property (nonatomic, assign, readonly) CGRect photoF;
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign, getter=isUpdated) BOOL updated;
@end
