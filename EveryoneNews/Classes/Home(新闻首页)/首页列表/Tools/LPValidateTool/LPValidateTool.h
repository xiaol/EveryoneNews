//
//  LPValidateTool.h
//  EveryoneNews
//
//  Created by dongdan on 16/9/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPValidateTool : NSObject

// 邮箱验证
+ (BOOL)validateEmail:(NSString *)emailStr;

@end
