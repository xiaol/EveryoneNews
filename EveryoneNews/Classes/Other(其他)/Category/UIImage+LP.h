//
//  UIImage+LP.h
//  EveryoneNews
//
//  Created by apple on 15/6/8.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LP)
+ (UIImage *)resizableImage:(NSString *)name;
+ (UIImage *)resizedImageWithName:(NSString *)name top:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;
+ (UIImage *)resizedImageWithName:(NSString *)name;
+ (UIImage *)resizableImage:(NSString *)name left:(CGFloat)left top:(CGFloat)top;
+ (instancetype)captureWithView:(UIView *)view;
- (UIColor *)averageColor;
+ (UIImage *)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
+ (UIImage *)circleImageWithImage:(UIImage *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
- (instancetype)circleImage;
+ (instancetype)circleImageWithImage:(UIImage *)image;
- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;
+ (UIImage*) blur:(UIImage*)theImage;
@end
