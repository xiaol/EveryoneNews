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
        _placeholderImage = [UIImage imageNamed:@"video_loading_bgView"];
    }
    return _placeholderImage;
}

@end
