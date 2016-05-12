//
//  ImageWallCell.m
//  EveryoneNews
//
//  Created by Feng on 15/7/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ImageWallCell.h"

@implementation ImageWallCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.contentView.layer.borderWidth = 1.0f;
        self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}
@end
