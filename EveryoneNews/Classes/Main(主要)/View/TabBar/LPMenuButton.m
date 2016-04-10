//
//  LPMenuButton.m
//  EveryoneNews
//
//  Created by dongdan on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPMenuButton.h"

@interface LPMenuButton () {
//    CGFloat rgba[4];
//    CGFloat rgbaGap[4];
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



//- (instancetype)initWithFrame:(CGRect)frame {
//    CGFloat titleFontSize = 15;
//    if (iPhone6) {
//        titleFontSize = 16;
//    }
//    else if (iPhone6Plus) {
//        titleFontSize = 18;
//    }
//    
//    if(self = [super initWithFrame:frame]) {
//        self.textColor = LPNormalColor;
//        self.textAlignment = NSTextAlignmentCenter;
//        [self setFont:[UIFont fontWithName:@"Arial" size:titleFontSize]];
//        self.normalColor = LPNormalColor;
//        self.selectedColor = LPSelectedColor;
//        self.rate = 1.2f;
//        self.highlightedTextColor = LPSelectedColor;
//    }
//    return self;
//}
//
//- (void)titleSizeAndColorDidChangedWithRate:(CGFloat)rate {
//    int numNormal = (int)CGColorGetNumberOfComponents(self.normalColor.CGColor);
//    int numSelected = (int)CGColorGetNumberOfComponents(self.selectedColor.CGColor);
//    if(numNormal == 4 && numSelected == 4) {
//        const CGFloat *norComponents = CGColorGetComponents(self.normalColor.CGColor);
//        const CGFloat *selComponents = CGColorGetComponents(self.selectedColor.CGColor);
//        for (int i = 0; i < 4; i++) {
//            rgba[i] = norComponents[i];
//            rgbaGap[i] = selComponents[i] - norComponents[i];
//        }
//    } else {
//        if (numNormal == 2) {
//            const CGFloat *norComponents = CGColorGetComponents(self.normalColor.CGColor);
//            self.normalColor = [UIColor colorWithRed:norComponents[0] green:norComponents[0] blue:norComponents[0] alpha:norComponents[1]];
//        }
//        if (numSelected == 2) {
//            const CGFloat *selComponents = CGColorGetComponents(self.selectedColor.CGColor);
//            self.selectedColor = [UIColor colorWithRed:selComponents[0] green:selComponents[0] blue:selComponents[0] alpha:selComponents[1]];
//        }
//    }
//    CGFloat r = rgba[0] + rgbaGap[0] * (1 - rate);
//    CGFloat g = rgba[1] + rgbaGap[1] * (1 - rate);
//    CGFloat b = rgba[2] + rgbaGap[2] * (1 - rate);
//    CGFloat a = rgba[3] + rgbaGap[3] * (1 - rate);
//    self.textColor = [UIColor colorWithRed:r green:g blue:b alpha:a];
//    CGFloat scaleRate = self.rate - rate * (self.rate - 1);
//    self.transform = CGAffineTransformMakeScale(scaleRate, scaleRate);
//}


@end
