//
//  LPCategoryButton.m
//  EveryoneNews
//
//  Created by apple on 15/6/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPCategoryButton.h"
#import "LPCategory.h"

@implementation LPCategoryButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, contentRect.size.width, contentRect.size.height);
}

- (void)setHighlighted:(BOOL)highlighted
{
    
}

- (void)setCategory:(LPCategory *)category
{
    _category = category;
    self.category.url = category.url;
    self.category.ID = category.ID;
    self.category.title = category.title;
}

@end
