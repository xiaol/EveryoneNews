//
//  ImageExtension.h
//  upNews
//
//  Created by 于咏畅 on 15/3/9.
//  Copyright (c) 2015年 yyc. All rights reserved.
//
//***
//  * 获取网络图片Size
//***

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageExtension : NSObject

+(CGSize)downloadImageSizeWithURL:(id)imageURL;

@end
