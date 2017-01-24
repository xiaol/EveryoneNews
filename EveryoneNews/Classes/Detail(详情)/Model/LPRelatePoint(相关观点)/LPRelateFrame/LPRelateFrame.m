//
//  LPRelateFrame.m
//  EveryoneNews
//
//  Created by dongdan on 16/3/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPRelateFrame.h"
#import "LPRelatePoint.h"
#import "NSString+LP.h"


@implementation LPRelateFrame

- (void)setRelatePoint:(LPRelatePoint *)relatePoint {
    CGFloat paddingLeft = 18;
    CGFloat imagePadding = 20;
    CGFloat sourcePadding = 5;
    CGFloat paddingTop = 16;
   _relatePoint = relatePoint;
    
    CGFloat titleX = 13;
    CGFloat imageW = 90;
    CGFloat imageH = 60;
    
    if (iPhone6Plus) {
        imageW = 100;
        imageH = 73;
    } else if (iPhone6) {
        imageW = 92;
        imageH = 67;
    }
    
    CGFloat titleW = 0.0f;
    CGFloat titleH = 0.0f;
    CGFloat sourceX = paddingLeft;
    CGFloat sourceH = 0.0f;
    CGFloat sourceW = 0.0f;

    // 有图样式
    if (_relatePoint.img.length > 0 && [_relatePoint.img rangeOfString:@","].location == NSNotFound) {
        
        titleW = ScreenWidth - imageW - paddingLeft * 2 - imagePadding ;
        NSMutableAttributedString *titleHtmlString = _relatePoint.titleHtmlString;
        titleH =  [titleHtmlString textViewHeightWithConstraintWidth:titleW];
        CGFloat singleTitleH =  [_relatePoint.singleHtmlString textViewHeightWithConstraintWidth:titleW];
        
        if (titleH > 2 * singleTitleH) {
            titleH = 2 * singleTitleH - 2;
        }
        
        self.titleHtmlString = titleHtmlString;
        
        sourceW = titleW;
        sourceH = [_relatePoint.sourceString heightWithConstraintWidth:sourceW];
        
        CGFloat titleY = 0.0f;
        if (titleH + sourceH + sourcePadding > imageH) {
            titleH = imageH - sourceH - sourcePadding;
        }
        titleY = paddingTop + (imageH - titleH - sourceH - sourcePadding) / 2.0f;
        
        _titleF = CGRectMake(titleX, titleY, titleW , titleH);
     
        CGFloat imageViewX = ScreenWidth - paddingLeft - imageW;
        CGFloat imageViewY = paddingTop;
        _imageViewF = CGRectMake(imageViewX,imageViewY , imageW, imageH);
        
        _sourceSiteF = CGRectMake(sourceX, CGRectGetMaxY(_titleF) + sourcePadding , sourceW, sourceH);
  
        _seperatorViewF = CGRectMake(titleX, CGRectGetMaxY(_imageViewF) + 10, ScreenWidth - paddingLeft * 2, 0.5);
        
    } else {
        // 无图
        titleW =  ScreenWidth - paddingLeft * 2 ;
        NSMutableAttributedString *titleHtmlString = _relatePoint.titleHtmlString;
        titleH =  [titleHtmlString textViewHeightWithConstraintWidth:titleW];
        self.titleHtmlString = titleHtmlString;
        sourceW = titleW;
        sourceH = [_relatePoint.sourceString heightWithConstraintWidth:sourceW];
        
        _titleF = CGRectMake(titleX, paddingTop, titleW, titleH);
        _sourceSiteF = CGRectMake(sourceX, CGRectGetMaxY(_titleF) + sourcePadding , sourceW, sourceH);
        _seperatorViewF = CGRectMake(paddingLeft, CGRectGetMaxY(_sourceSiteF) + 10, ScreenWidth - paddingLeft * 2 , 0.5);
        
    }
    _cellHeight = CGRectGetMaxY(_seperatorViewF); 
}

@end
