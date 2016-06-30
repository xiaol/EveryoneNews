//
//  SDWebImageDownloaderOperation+HandleImage.m
//  ImageViewDemo
//
//  Created by dongdan on 16/6/2.
//  Copyright © 2016年 dongdan. All rights reserved.
//

#import "SDWebImageDownloaderOperation+HandleImage.h"
#import "UIImage+MultiFormat.h"
#import "NSData+ImageContentType.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation SDWebImageDownloaderOperation (HandleImage)

- (NSData *)handleNSData:(NSData *)data {
    
    NSString *imageContentType = [NSData sd_contentTypeForImageData:data];
    // gif处理
    if ([imageContentType isEqualToString:@"image/gif"]) {
        
        NSMutableData *mutableData = [NSMutableData data];
        CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
        
        size_t count = CGImageSourceGetCount(source);
        UIImage *animatedImage;
        if(count <= 1) {
            animatedImage = [[UIImage alloc] initWithData:data];
            
        } else {
            size_t count = CGImageSourceGetCount(source);
            // gif图片数量太多采用随机抽样方式解决
            NSTimeInterval frameDuration = 0.2;
            NSDictionary *frameProperties = @{
                                              (__bridge NSString *)kCGImagePropertyGIFDictionary: @{
                                                      (__bridge NSString *)kCGImagePropertyGIFDelayTime: @(frameDuration)
                                                      }
                                              };
            
            // 设置目标图片总数量
            size_t maxNormalImageCount = 30;
            size_t destionImageCount = count;
            size_t durationImageCount = 4;
            if (count > maxNormalImageCount) {
                destionImageCount = ceilf(count * 1.0 / durationImageCount);
                
                
            }
            CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)mutableData, kUTTypeGIF, destionImageCount, NULL);
            
            NSDictionary *imageProperties = @{ (__bridge NSString *)kCGImagePropertyGIFDictionary: @{
                                                       (__bridge NSString *)kCGImagePropertyGIFLoopCount: @(1)
                                                       }
                                               };
            CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)imageProperties);
            // 图片数量不超过15张直接显示
            for (size_t i = 0; i < count; i++) {
                CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
                if (!imageRef) {
                    continue;
                }
                size_t imageW = CGImageGetWidth(imageRef);
                size_t imageH = CGImageGetHeight(imageRef);
                CGFloat w = [UIScreen mainScreen].bounds.size.width;
                CGFloat h = imageH * w / imageW ;
                if (count > maxNormalImageCount) {
                    if(i % durationImageCount == 0) {
                        // 图片宽度大于屏幕宽度
                        if (imageW > w) {
                            imageRef = [self resizeCGImage:imageRef width:w height:h];
                            CGImageDestinationAddImage(destination, imageRef, (__bridge CFDictionaryRef)frameProperties);
                        } else {
                            CGImageDestinationAddImage(destination, imageRef, (__bridge CFDictionaryRef)frameProperties);
                        }
                    }
                    
                } else {
                    // 图片宽度大于屏幕宽度
                    if (imageW > w) {
                        imageRef = [self resizeCGImage:imageRef width:w height:h];
                        CGImageDestinationAddImage(destination, imageRef, (__bridge CFDictionaryRef)frameProperties);
                    } else {
                        CGImageDestinationAddImage(destination, imageRef, (__bridge CFDictionaryRef)frameProperties);
                    }
                }
            }
            
            CGImageDestinationFinalize(destination);
            CFRelease(destination);
            
        }
        CFRelease(source);
        data = [NSData dataWithData:mutableData];
        
    } else {
        
        UIImage *image = [UIImage imageWithData:data];
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        CGFloat h = image.size.height / image.size.width * w;
        UIImage *resizeImage = [[UIImage alloc] init];
        // 图片宽度大于屏幕宽度
        if (image.size.width > w) {
            resizeImage = [self imageWithImage:image scaledToSize:CGSizeMake(w, h)];
            data = UIImageJPEGRepresentation(resizeImage, (CGFloat)0.5);
            image = nil;
        }
    }
    return data;
}

#pragma mark - Resize Image
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - Resize CGImage
- (CGImageRef)resizeCGImage:(CGImageRef)image width:(int)width height:(int)height {
    
    CGColorSpaceRef colorspace = CGImageGetColorSpace(image);
    CGContextRef bitmap = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(image), CGImageGetBytesPerRow(image), colorspace, kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorspace);
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), image);
    CGImageRef imageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *result = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(bitmap);
    CGImageRelease(imageRef);
    return result.CGImage;
}
@end
