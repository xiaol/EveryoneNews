//
//  UIImage+Additions.m
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UIImage+Additions.h"

NS_ASSUME_NONNULL_BEGIN
@implementation UIImage (Additions)

+ (nullable UIImage *)commonColorSquarenessImage:(nullable UIColor *)color size:(CGSize)size{
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    [color set];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (nullable UIImage *)stretchImage:(nullable UIImage *)image imageSize:(CGSize)size
{
    if ([image respondsToSelector:@selector(stretchableImageWithLeftCapWidth:topCapHeight:)]) {
        return [image stretchableImageWithLeftCapWidth:size.width topCapHeight:size.height];
    }
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(size.height, size.width, size.height, size.width+1)];
}

- (UIImage *)scaleFromImageToSize:(CGSize) size{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (nullable UIImage *)stretchImageSize:(CGSize)size
{
    return [UIImage stretchImage:self imageSize:size];
}

@end
NS_ASSUME_NONNULL_END