//
//  LPPlayerModel.m
//  AVPlayerDemo
//
//  Created by dongdan on 2016/12/7.
//  Copyright © 2016年 dongdan. All rights reserved.
//

#import "LPPlayerModel.h"

@implementation LPPlayerModel

- (UIImage *)placeholderImage
{
    if (!_placeholderImage) {
        _placeholderImage = [UIImage sharePlaceholderImage:[UIColor colorFromHexString:@"#f8f8f8"] sizes:CGSizeMake(80, 80)];
    }
    return _placeholderImage;
}

@end
