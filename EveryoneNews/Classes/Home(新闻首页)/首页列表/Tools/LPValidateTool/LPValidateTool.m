//
//  LPValidateTool.m
//  EveryoneNews
//
//  Created by dongdan on 16/9/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPValidateTool.h"

@implementation LPValidateTool


+ (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPrediate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailPrediate evaluateWithObject:emailStr];
}
@end
