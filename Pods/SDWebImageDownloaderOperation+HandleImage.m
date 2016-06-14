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
    
//    NSString *imageContentType = [NSData sd_contentTypeForImageData:data];
//    
//    // gif处理
//    if ([imageContentType isEqualToString:@"image/gif"]) {
//        
//        NSMutableData *mutableData = [NSMutableData data];
//        CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
//        
//        size_t count = CGImageSourceGetCount(source);
//        UIImage *animatedImage;
//        if(count <= 1) {
//            animatedImage = [[UIImage alloc] initWithData:data];
//            
//        } else {
//            size_t count = CGImageSourceGetCount(source);
//            // 设置图片最大数量为10个
//            count = count > 10 ? 10 :count;
//            NSTimeInterval frameDuration = 0.1;
//            NSDictionary *frameProperties = @{
//                                              (__bridge NSString *)kCGImagePropertyGIFDictionary: @{
//                                                      (__bridge NSString *)kCGImagePropertyGIFDelayTime: @(frameDuration)
//                                                      }
//                                              };
//            
//            
//            CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)mutableData, kUTTypeGIF, count, NULL);
//            
//            NSDictionary *imageProperties = @{ (__bridge NSString *)kCGImagePropertyGIFDictionary: @{
//                                                       (__bridge NSString *)kCGImagePropertyGIFLoopCount: @(1)
//                                                       }
//                                               };
//            CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)imageProperties);
//            
//            for (size_t i = 0; i < count; i++) {
//                CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
//                if (!imageRef) {
//                    continue;
//                }
//                
//                size_t imageW = CGImageGetWidth(imageRef);
//                size_t imageH = CGImageGetHeight(imageRef);
//                CGFloat w = [UIScreen mainScreen].bounds.size.width;
//                CGFloat h = imageH * w / imageW ;
//                
//                // 图片宽度大于屏幕宽度
//                if (imageW > w) {
//                    imageRef = [self resizeCGImage:imageRef width:w height:h];
//                    CGImageDestinationAddImage(destination, imageRef, (__bridge CFDictionaryRef)frameProperties);
//                    
////                    NSLog(@"%zu", CGImageGetWidth(imageRef));
//                    
//                } else {
//                    CGImageDestinationAddImage(destination, imageRef, (__bridge CFDictionaryRef)frameProperties);
//                }
//                
//            }
//            
//            CGImageDestinationFinalize(destination);
//            CFRelease(destination);
//        }
//        CFRelease(source);
//        data = [NSData dataWithData:mutableData];
//        
//    } else {
//        
//        UIImage *image = [UIImage imageWithData:data];
//        CGFloat w = [UIScreen mainScreen].bounds.size.width;
//        CGFloat h = image.size.height / image.size.width * w;
//        UIImage *resizeImage = [[UIImage alloc] init];
//        // 图片宽度大于屏幕宽度
//        if (image.size.width > w) {
//            resizeImage = [self imageWithImage:image scaledToSize:CGSizeMake(w, h)];
//            data = UIImageJPEGRepresentation(resizeImage, (CGFloat)0.5);
//            image = nil;
//        }
//    }
    
    NSString *imageContentType = [NSData sd_contentTypeForImageData:data];

    UIImage *image = [UIImage imageWithData:data];
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = (image.size.height * 1.0f / image.size.width) * w;
    UIImage *resizeImage = [[UIImage alloc] init];
    
    // gif处理
    if ([imageContentType isEqualToString:@"image/gif"]) {
        if (image.size.width > w) {
            resizeImage = [self imageWithImage:image scaledToSize:CGSizeMake(w, h)];
            data = UIImageJPEGRepresentation(resizeImage, (CGFloat)0.5);
        } else {
            data = UIImageJPEGRepresentation(image, (CGFloat)0.5);
        }
        
        image = nil;
    } else {
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
