//
//  UIImage+Additions.h
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Additions)

+ (nullable UIImage *)commonColorSquarenessImage:(nullable UIColor *)color size:(CGSize)size;

+ (UIImage *)imageWithColor:(UIColor *)color;

- (nullable UIImage *)stretchImageSize:(CGSize)size;

+ (nullable UIImage *)stretchImage:(nullable UIImage *)image imageSize:(CGSize)size;

- (UIImage *)scaleFromImageToSize:(CGSize) size;

@end
NS_ASSUME_NONNULL_END