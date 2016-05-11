//
//  LPPointview.h
//  EveryoneNews
//
//  Created by apple on 15/6/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPPointview : NSObject

@property (nonatomic, copy) NSString *sourceSitename;

@property (nonatomic, copy) NSString *user;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *title;

- (NSMutableAttributedString *)pointItem;

@end
