//
//  LPRelatePoint.h
//  EveryoneNews
//
//  Created by apple on 15/6/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPRelatePoint : NSObject

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy)  NSString *ptime;
@property (nonatomic, copy) NSString *pname;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, assign) NSInteger rank;

- (NSMutableAttributedString *)titleString;
- (NSMutableAttributedString *)sourceString;
- (NSMutableAttributedString *)titleHtmlString;
- (NSMutableAttributedString *)singleHtmlString;


@end
