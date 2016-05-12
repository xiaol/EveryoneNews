//
//  LPDetailContent.h
//  EveryoneNews
//
//  Created by dongdan on 15/12/31.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPDetailContent : NSObject

@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *txt;
- (NSMutableAttributedString *)bodyString;

@end
