//
//  BaseCell.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/4/1.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "BaseCell.h"

@implementation BaseCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showWebViewWithUrl:(NSString *)URL
{
    if ([self.delegate respondsToSelector:@selector(loadWebViewWithURL:)]) {
        [self.delegate loadWebViewWithURL:URL];
    }
}

@end
