//
//  LPMenuButton.m
//  EveryoneNews
//
//  Created by dongdan on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPMenuButton.h"

const static CGFloat DefaultRate = 1.15;

@interface LPMenuButton () {
    CGFloat rgba[4];
    CGFloat rgbaGap[4];
}

@end

@implementation LPMenuButton

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (self.selected == selected) {
        return;
    }
    if (selected) {
        [self setTitleColor:self.selectedColor forState:UIControlStateSelected];
    } else {
        [self setTitleColor:self.normalColor forState:UIControlStateNormal];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.normalColor = LPNormalColor;
        self.selectedColor = LPSelectedColor;
        self.rate = DefaultRate;
        self.fontName =  @"Arial";
        self.fontSize = 14;
        [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self setTitleColor:self.normalColor forState:UIControlStateNormal];
    }
    return self;
}

- (void)buttonDidSelectedWithAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(self.rate, self.rate);
    }];
     
}

- (void)buttonDidDeSelectedWithAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
}

- (instancetype)initWithTitle:(NSString *)title {
    if(self = [super init]) {
        [self setTitle:title forState:UIControlStateNormal];
    }
    return self;
}

- (void)titleSizeAndColorDidChangedWithRate:(CGFloat)rate {
    int numNormal = (int)CGColorGetNumberOfComponents(self.normalColor.CGColor);
    int numSelected = (int)CGColorGetNumberOfComponents(self.selectedColor.CGColor);
    if(numNormal == 4 && numSelected == 4) {
        const CGFloat *norComponents = CGColorGetComponents(self.normalColor.CGColor);
        const CGFloat *selComponents = CGColorGetComponents(self.selectedColor.CGColor);
        for (int i = 0; i < 4; i++) {
            rgba[i] = norComponents[i];
            rgbaGap[i] = selComponents[i] - norComponents[i];
        }
    } else {
        if (numNormal == 2) {
            const CGFloat *norComponents = CGColorGetComponents(self.normalColor.CGColor);
            self.normalColor = [UIColor colorWithRed:norComponents[0] green:norComponents[0] blue:norComponents[0] alpha:norComponents[1]];
        }
        if (numSelected == 2) {
            const CGFloat *selComponents = CGColorGetComponents(self.selectedColor.CGColor);
            self.selectedColor = [UIColor colorWithRed:selComponents[0] green:selComponents[0] blue:selComponents[0] alpha:selComponents[1]];
        }
    }
    CGFloat r = rgba[0] + rgbaGap[0]*(1-rate);
    CGFloat g = rgba[1] + rgbaGap[1]*(1-rate);
    CGFloat b = rgba[2] + rgbaGap[2]*(1-rate);
    CGFloat a = rgba[3] + rgbaGap[3]*(1-rate);
    self.titleColor = [UIColor colorWithRed:r green:g blue:b alpha:a];
    [self setTitleColor:self.titleColor forState:UIControlStateNormal];
    CGFloat scaleRate = self.rate - rate * (self.rate - 1);
    self.transform = CGAffineTransformMakeScale(scaleRate, scaleRate);
}


@end
