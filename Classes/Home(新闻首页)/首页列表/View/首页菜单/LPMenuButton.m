//
//  LPMenuButton.m
//  EveryoneNews
//
//  Created by dongdan on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPMenuButton.h"

@interface LPMenuButton () {
    CGFloat rgba[4];
    CGFloat rgbaGap[4];
}

@end

@implementation LPMenuButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGFloat menuFontSize = 16;
        if (iPhone6 || iPhone6Plus) {
            menuFontSize = 18;
        }
        self.textColor = [UIColor colorFromHexString:LPColor30];
        self.textAlignment = NSTextAlignmentCenter;
        self.highlightedTextColor = [UIColor colorFromHexString:LPColor30];
        self.font = [UIFont systemFontOfSize:menuFontSize];        
        self.menuNormalColor = [UIColor colorFromHexString:LPColor30];
        self.menuSelectedColor = [UIColor colorFromHexString:LPColor30];
        self.rate = 1.15;
        
   
    }
    return self;
}

- (void)titleSizeColorDidChangedWithRate:(CGFloat)rate {
    int numNormal = (int)CGColorGetNumberOfComponents(self.menuNormalColor.CGColor);
    int numSelected = (int)CGColorGetNumberOfComponents(self.menuSelectedColor.CGColor);
    if(numNormal == 4 && numSelected == 4) {
        const CGFloat *norComponents = CGColorGetComponents(self.menuNormalColor.CGColor);
        const CGFloat *selComponents = CGColorGetComponents(self.menuSelectedColor.CGColor);
        for (int i = 0; i < 4; i++) {
            rgba[i] = norComponents[i];
            rgbaGap[i] = selComponents[i] - norComponents[i];
        }
    } else {
        if (numNormal == 2) {
            const CGFloat *norComponents = CGColorGetComponents(self.menuNormalColor.CGColor);
            self.menuNormalColor = [UIColor colorWithRed:norComponents[0] green:norComponents[0] blue:norComponents[0] alpha:norComponents[1]];
        }
        if (numSelected == 2) {
            const CGFloat *selComponents = CGColorGetComponents(self.menuSelectedColor.CGColor);
            self.menuSelectedColor = [UIColor colorWithRed:selComponents[0] green:selComponents[0] blue:selComponents[0] alpha:selComponents[1]];
        }
    }
    CGFloat r = rgba[0] + rgbaGap[0]*(1-rate);
    CGFloat g = rgba[1] + rgbaGap[1]*(1-rate);
    CGFloat b = rgba[2] + rgbaGap[2]*(1-rate);
    CGFloat a = rgba[3] + rgbaGap[3]*(1-rate);
    self.textColor = [UIColor colorWithRed:r green:g blue:b alpha:a];
    CGFloat scaleRate = self.rate - rate * (self.rate - 1);
    self.transform = CGAffineTransformMakeScale(scaleRate, scaleRate);
}



@end
