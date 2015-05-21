//
//  Relate.h
//  WaterFlow
//
//  Created by apple on 15/5/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Relate : NSObject

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *sourceSitename;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSNumber *height;

@property (nonatomic, strong) NSNumber *width;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)relateWithDict:(NSDictionary *)dict;

@end
