//
//  LPMenuButton.m
//  EveryoneNews
//
//  Created by dongdan on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPMenuButton.h"

@interface LPMenuButton () {
}

@end

@implementation LPMenuButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGFloat menuFontSize = 16;
        if (iPhone6) {
            menuFontSize = 16;
        }
        else if (iPhone6Plus) {
            menuFontSize = 18;
        }
        self.textColor = LPNormalColor;
        self.textAlignment = NSTextAlignmentCenter;
        self.highlightedTextColor = LPSelectedColor;
        [self setFont:[UIFont fontWithName:@"Arial-BoldMT" size:menuFontSize]];
   
    }
    return self;
}



@end
