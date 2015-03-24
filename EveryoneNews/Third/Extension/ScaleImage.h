//
//  ScaleImage.h
//  upNews
//
//  Created by 于咏畅 on 15/3/9.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ScaleImage : NSObject
+ (UIImage*)scaleImage:(UIImage *)image size:(CGSize )size;
+ (UIImage*)scaleImageForHeaderImg:(UIImage *)image size:(CGSize )size;
@end
