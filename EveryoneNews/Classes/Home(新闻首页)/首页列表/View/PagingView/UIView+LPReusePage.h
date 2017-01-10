//
//  UIView+LPReusePage.h
//  PagingViewDemo
//
//  Created by apple on 15/12/2.
//  Copyright © 2015年 lvpin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LPReusablePage)

@property (copy, nonatomic) NSString *pageReuseIdentifier;
- (void)prepareForReuse;

@end