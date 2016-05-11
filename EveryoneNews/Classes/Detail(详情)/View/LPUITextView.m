//
//  LPUITextView.m
//  EveryoneNews
//
//  Created by dongdan on 16/4/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPUITextView.h"
@implementation LPUITextView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.textContainerInset = UIEdgeInsetsZero;
        [self setDataDetectorTypes:UIDataDetectorTypeLink];
        self.scrollEnabled = NO;
        self.editable = NO;
        self.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6"];
    }
    return self;
}

- (BOOL)canBecomeFirstResponder {
    return NO;
}


 

@end
