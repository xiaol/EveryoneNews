//
//  LPPress.m
//  EveryoneNews
//
//  Created by apple on 15/5/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPPress.h"
#import "MJExtension.h"



@implementation LPPress

- (NSMutableAttributedString *)titleString
{
    return [self.title attributedStringWithFont:[UIFont fontWithName:FontName size:16] color:[UIColor colorFromHexString:TitleColor] lineSpacing:3];
}

+ (void)load
{
    [self setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"sublist": @"LPPointview"
                 };
    }];
}

//if ([text isEqualToString:@"科技"]) {
//    return [UIColor colorFromHexString:@"#35a6fb" alpha:alpha];
//} else if ([text isEqualToString:@"港台"]){
//    return [UIColor colorFromHexString:@"#b56f40" alpha:alpha];
//} else if ([text isEqualToString:@"财经"]){
//    return [UIColor colorFromHexString:@"#f6aa32" alpha:alpha];
//} else if ([text isEqualToString:@"社会"]){
//    return [UIColor colorFromHexString:@"#45aecd" alpha:alpha];
//} else if ([text isEqualToString:@"体育"]){
//    return [UIColor colorFromHexString:@"#70c011" alpha:alpha];
//} else if ([text isEqualToString:@"国际"]){
//    return [UIColor colorFromHexString:@"#ee6270" alpha:alpha];
//} else if ([text isEqualToString:@"娱乐"]){
//    return [UIColor colorFromHexString:@"#9153c6" alpha:alpha];
//} else if ([text isEqualToString:@"时事"]){
//    return [UIColor colorFromHexString:@"#ef6430" alpha:alpha];
//} else if ([text isEqualToString:@"焦点"]){
//    return [UIColor colorFromHexString:@"#ff1652" alpha:alpha];
//} else if ([text isEqualToString:@"内地"]){
//    return [UIColor colorFromHexString:@"#72d29b" alpha:alpha];
//} else if ([text isEqualToString:@"国内"]){
//    return [UIColor colorFromHexString:@"#8bace9" alpha:alpha];
//} else {
//    return [UIColor colorFromHexString:@"#ee6270" alpha:alpha];
//}


- (NSString *)redefineCategory {
    if(_category == nil) return nil;
    if ([_category isEqualToString:@"科技"] || [_category isEqualToString:@"港台"] || [_category isEqualToString:@"财经"] ||[_category isEqualToString:@"社会"] || [_category isEqualToString:@"体育"] || [_category isEqualToString:@"国际"] || [_category isEqualToString:@"娱乐"] || [_category isEqualToString:@"时事"] || [_category isEqualToString:@"焦点"] || [_category isEqualToString:@"内地"] || [_category isEqualToString:@"国内"]) {
        return _category;
    } else {
        return @"国际";
    }
}

@end
