//
//  ScaleImage.m
//  upNews
//
//  Created by 于咏畅 on 15/3/9.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "ScaleImage.h"

@implementation ScaleImage

#pragma mark 缩放图片并截取中间部分显示;
+ (UIImage*)scaleImage:(UIImage *)image size:(CGSize )size{
    CGSize imgSize = image.size; //原图大小
    CGSize viewSize = size;          //视图大小
    CGFloat imgwidth = 0;            //缩放后的图片宽度
    CGFloat imgheight = 0;          //缩放后的图片高度
    
    //视图横长方形及正方形
    if (viewSize.width >= viewSize.height) {
        //缩小
        //        if (imgSize.width > viewSize.width && imgSize.height > viewSize.height) {
        if (imgSize.width > viewSize.width) {
            imgwidth = viewSize.width;
            imgheight = imgSize.height/(imgSize.width/imgwidth);
        }
        //放大
        if(imgSize.width < viewSize.width){
            imgwidth = viewSize.width;
            imgheight = (viewSize.width/imgSize.width)*imgSize.height;
        }
        //判断缩放后的高度是否小于视图高度
        imgheight = imgheight < viewSize.height?viewSize.height:imgheight;
    }
    
    //视图竖长方形
    if (viewSize.width < viewSize.height) {
        //缩小
        if (imgSize.width > viewSize.width && imgSize.height > viewSize.height) {
            imgheight = viewSize.height;
            imgwidth = imgSize.width/(imgSize.height/imgheight);
        }
        
        //放大
        if(imgSize.height < viewSize.height){
            imgheight = viewSize.width;
            imgwidth = (viewSize.height/imgSize.height)*imgSize.width;
        }
        //判断缩放后的高度是否小于视图高度
        imgwidth = imgwidth < viewSize.width?viewSize.width:imgwidth;
    }
    
    //重新绘制图片大小
    UIImage *i;
    UIGraphicsBeginImageContext(CGSizeMake(imgwidth, imgheight));
    [image drawInRect:CGRectMake(0, 0, imgwidth, imgheight)];
    i=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //截取中间部分图片显示
    if (imgwidth > 0) {
        CGImageRef newImageRef = CGImageCreateWithImageInRect(i.CGImage, CGRectMake((imgwidth-viewSize.width)/2, (imgheight-viewSize.height)/2, viewSize.width, viewSize.height));
        return [UIImage imageWithCGImage:newImageRef];
    }else{
        CGImageRef newImageRef = CGImageCreateWithImageInRect(image.CGImage, CGRectMake((imgwidth-viewSize.width)/2, (imgheight-viewSize.height)/2, viewSize.width, viewSize.height));
        return [UIImage imageWithCGImage:newImageRef];
    }
}

+ (UIImage*)scaleImageForHeaderImg:(UIImage *)image size:(CGSize )size{
//    CGSize imgSize = image.size; //原图大小
    CGSize viewSize = size;          //视图大小
    CGFloat imgwidth = viewSize.width;            //缩放后的图片宽度
    CGFloat imgheight = viewSize.height;          //缩放后的图片高度
    
    //视图横长方形
//    if (imgSize.width / imgSize.height >= 16 / 9) {
//        imgheight = viewSize.height;
//        
//        
//    } else {
//        
//    }
    //重新绘制图片大小
    UIImage *i;
    UIGraphicsBeginImageContext(CGSizeMake(imgwidth, imgheight));
    [image drawInRect:CGRectMake(0, 0, imgwidth, imgheight)];
    i=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //截取中间部分图片显示
    if (imgwidth > 0) {
        CGImageRef newImageRef = CGImageCreateWithImageInRect(i.CGImage, CGRectMake((imgwidth-viewSize.width)/2, (imgheight-viewSize.height)/2, viewSize.width, viewSize.height));
        return [UIImage imageWithCGImage:newImageRef];
    }else{
        CGImageRef newImageRef = CGImageCreateWithImageInRect(image.CGImage, CGRectMake((imgwidth-viewSize.width)/2, (imgheight-viewSize.height)/2, viewSize.width, viewSize.height));
        return [UIImage imageWithCGImage:newImageRef];
    }
}


@end
