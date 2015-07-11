//
//  LPContent.m
//  EveryoneNews
//
//  Created by apple on 15/6/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPContent.h"

@implementation LPContent

- (LPComment *)displayingComment
{
    return [self.comments objectAtIndex:0];
}
//- (BOOL)hasComment
//{
//    return (self.comments && self.comments.count);
//}
- (NSMutableAttributedString *)bodyString
{
    if (self.isAbstract) {
        return [self.body attributedStringWithFont:[UIFont fontWithName:@"Arial-BoldMT" size:BodyFontSize] color:[UIColor blackColor] lineSpacing:BodyLineSpacing];
    } else {
        return [self.body attributedStringWithFont:[UIFont systemFontOfSize:BodyFontSize] color:[UIColor blackColor] lineSpacing:BodyLineSpacing];
    }
}
@end
