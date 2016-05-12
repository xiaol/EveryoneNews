//
//  LPCategory.h
//  EveryoneNews
//
//  Created by apple on 15/6/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPCategory : NSObject

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSUInteger ID;

+ (instancetype)categoryWithURL:(NSString *)url;

@end
