//
//  LPContent.h
//  EveryoneNews
//
//  Created by apple on 15/6/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LPComment.h"

@interface LPContent : NSObject
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, assign) BOOL hasComment;
@property (nonatomic, assign) BOOL isAbstract;
@property (nonatomic, assign) int paragraphIndex;

- (LPComment *)displayingComment;
- (NSMutableAttributedString *)bodyString;
@end
