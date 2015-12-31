//
//  LPDetail.h
//  EveryoneNews
//
//  Created by dongdan on 15/12/31.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPDetailContent;
@interface LPDetail : NSObject

@property (nonatomic, strong) LPDetailContent *content;

@property (nonatomic ,copy) NSString *title;

@end
