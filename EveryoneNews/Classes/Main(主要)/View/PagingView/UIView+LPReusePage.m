//
//  UIView+LPReusePage.m
//  PagingViewDemo
//
//  Created by apple on 15/12/2.
//  Copyright © 2015年 lvpin. All rights reserved.
//

#import "UIView+LPReusePage.h"
#import <objc/runtime.h>

@implementation UIView (LPReusablePage)

static NSString *PageReuseIdentifierKey = @"pageReuseIdentifier";

- (NSString *)pageReuseIdentifier {
    return objc_getAssociatedObject(self, &PageReuseIdentifierKey);
}

- (void)setPageReuseIdentifier:(NSString *)pageReuseIdentifier {
    objc_setAssociatedObject(self, &PageReuseIdentifierKey, pageReuseIdentifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)prepareForReuse {
    
}

@end;
