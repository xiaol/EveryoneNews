//
//  DigButton.m
//  EveryoneNews
//
//  Created by apple on 15/8/31.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "DigButton.h"

const CGFloat DigButtonWidth = 40;
const CGFloat DigButtonHeight = 40;
const CGFloat DigButtonPadding = 15;

@implementation DigButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorFromHexString:@"#000000" alpha:0.75];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitle:@"订" forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.layer.shadowRadius = 1;
        self.layer.shadowColor = [UIColor whiteColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 1.0;
    }
    return self;
}

@end
