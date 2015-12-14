//
//  Content+AttributedText.m
//  EveryoneNews
//
//  Created by apple on 15/10/27.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "Content+AttributedText.h"

@implementation Content (AttributedText)
- (NSMutableAttributedString *)attributedBodyText {
    return [self.body attributedStringWithFont:[UIFont systemFontOfSize:16] color:[UIColor blackColor] lineSpacing:BodyLineSpacing];
}
@end
