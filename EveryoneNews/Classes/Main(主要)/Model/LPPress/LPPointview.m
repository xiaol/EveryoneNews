//
//  LPPointview.m
//  EveryoneNews
//
//  Created by apple on 15/6/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPPointview.h"

@implementation LPPointview

- (NSString *)author
{
    if (self.user && self.user.length) {
        return [NSString stringWithFormat:@"%@: ", self.user];
    } else if (self.sourceSitename && self.sourceSitename.length) {
        return [NSString stringWithFormat:@"%@: ", self.sourceSitename];
    } else  {
        return @"匿名报道: ";
    } 
}

- (NSMutableAttributedString *)pointItem
{
    NSString *author = [self author];
    NSString *pointString = [NSString stringWithFormat:@"%@%@", author, [self.title stringByTrimmingNewline]];
    NSMutableAttributedString *point = [pointString attributedStringWithFont:[UIFont systemFontOfSize:14]];
    [point addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"b5b5b5"] range:NSMakeRange(0, author.length)];
    return point;
}



@end
