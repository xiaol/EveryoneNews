//
//  ContentDatasource.m
//  upNews
//
//  Created by 于咏畅 on 15/1/20.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "ContentDatasource.h"
#import "ImageExtension.h"

@implementation ContentDatasource

+ (id)contentDatasourceWithImgStr:(NSString *)imgUrl
{
    return [[ContentDatasource alloc] initWithImgStr:imgUrl];
}

- (id)initWithImgStr:(NSString *)imgUrl
{
    if (self = [super init]) {
        self.imgUrl = imgUrl;
        CGSize size = [ImageExtension downloadImageSizeWithURL:imgUrl];
        NSLog(@"size:%f,  %f", size.width, size.height);
        if (size.width == 0) {
            CGFloat X = 15;
            self.imgW = [UIScreen mainScreen].bounds.size.width - 2 * X;
            self.imgH = self.imgW * 9 / 16;
        } else {
            self.imgW = size.width;
            self.imgH = size.height;
        }
        
    }
    return self;
}

@end
