//
//  Content+PhotoDownloadCompletion.m
//  EveryoneNews
//
//  Created by dongdan on 16/2/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "Content+PhotoDownloadCompletion.h"
#import <objc/runtime.h>
static char photoKey;

@implementation Content (PhotoDownloadCompletion)

- (void)setImage:(UIImage *)image {
    objc_setAssociatedObject(self, &photoKey, image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)image {
    return (UIImage *)objc_getAssociatedObject(self, &photoKey);
}

@end
