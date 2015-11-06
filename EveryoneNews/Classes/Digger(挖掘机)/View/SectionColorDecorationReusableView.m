//
//  SectionColorDecorationReusableView.m
//  EveryoneNews
//
//  Created by apple on 15/10/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SectionColorDecorationReusableView.h"
#import "SectionColorLayoutAttributes.h"

@implementation SectionColorDecorationReusableView
- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    
    SectionColorLayoutAttributes *attributes = (SectionColorLayoutAttributes *)layoutAttributes;
    self.backgroundColor = attributes.color;
}
@end
