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

const static CGFloat circleHeight = 6.5f;
const static CGFloat circleWidth = 6.5f;
const static CGFloat padding1 = 5.0f;
const static CGFloat padding2 = 7.0f;
const static CGFloat padding3 = 15;
const static CGFloat padding4 = 8.0f;
const static CGFloat padding5 = 10.0f;

@implementation LPRelateFrame

- (void)setRelatePoint:(LPRelatePoint *)relatePoint {
    
    CGFloat padding = 18;
   _relatePoint = relatePoint;
    
    CGSize yearSize = [@"8888" sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGSize monthSize = [@"88/88" sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    CGFloat circleRadius = 2.75f;
    
    _circleRadius = circleRadius;
    
    CGFloat titleX = 0;
    CGFloat imageW = 90;
    CGFloat imageH = 60;
    
    if (iPhone6Plus) {
        imageW = 100;
        imageH = 73;
    }
    
    CGFloat titleW = 0.0f;
    CGFloat titleH = 0.0f;
    CGFloat sourceX = titleX;
    CGFloat sourceH = 0.0f;
    CGFloat sourceW = 0.0f;
    // 日期包含年份
    if (_relatePoint.updateTime.length > 5) {
        
        _yearPoint = CGPointMake(padding + circleHeight / 2, padding5 + yearSize.height / 2);
        _monthDayPoint = CGPointMake(padding + circleHeight / 2 , yearSize.height + padding5 * 2 + monthSize.height / 2);
        
        _yearF = CGRectMake(titleX, padding5, yearSize.width + 2, yearSize.height);
        _monthDayF = CGRectMake(titleX, yearSize.height + padding5 * 2, monthSize.width , monthSize.height);
        
  
        
    } else {
        _monthDayPoint = CGPointMake(padding + circleHeight / 2,  padding5 + monthSize.height / 2);
        _monthDayF = CGRectMake(titleX,  padding5, monthSize.width, monthSize.height);
    }
    // 有图样式
    if (_relatePoint.imgUrl.length > 0 && [_relatePoint.imgUrl rangeOfString:@","].location == NSNotFound) {
        
        titleW = ScreenWidth - imageW - circleWidth - padding2 - padding3 - padding * 2 ;
        titleH = [_relatePoint.titleString heightWithConstraintWidth:titleW];
        
        sourceW = titleW;
        sourceH = [_relatePoint.sourceString heightWithConstraintWidth:sourceW];
        
        CGFloat titleY = 0.0f;
        if (titleH + padding4 + sourceH > imageH) {
            
            titleH = imageH - sourceH - padding4;
            titleY = CGRectGetMaxY(_monthDayF) + (imageH - (titleH + padding4 + sourceH)) / 2;
        }
        _titleF = CGRectMake(titleX, titleY, titleW, titleH);
        
        _imageViewF = CGRectMake(CGRectGetMaxX(_titleF) + 15, CGRectGetMaxY(_monthDayF) + padding2, imageW, imageH);
        
        _sourceSiteF = CGRectMake(sourceX, CGRectGetMaxY(_titleF) + padding4, sourceW, sourceH);
        
        _seperatorViewF = CGRectMake(titleX, CGRectGetMaxY(_imageViewF) + 10, ScreenWidth - titleX - padding * 2 - padding2 - circleWidth, 0.5);
        
        
        
    } else {
        // 无图
        titleW =  ScreenWidth - circleWidth - padding2 - padding * 2 ;
        titleH = [_relatePoint.titleString heightWithConstraintWidth:titleW];
        
        sourceW = titleW;
        sourceH = [_relatePoint.sourceString heightWithConstraintWidth:sourceW];
        
        _titleF = CGRectMake(titleX, CGRectGetMaxY(_monthDayF) + 8, titleW, titleH);
        
        _sourceSiteF = CGRectMake(sourceX, CGRectGetMaxY(_titleF) + padding1, sourceW, sourceH);
        
        _seperatorViewF = CGRectMake(titleX, CGRectGetMaxY(_sourceSiteF) + 10, ScreenWidth - padding * 2 - titleX - padding2 - circleWidth, 0.5);
        
    }
    _cellHeight = CGRectGetMaxY(_seperatorViewF);
    _cellViewF = CGRectMake(padding + circleWidth + padding2, 0,ScreenWidth - padding * 2 - titleX, _cellHeight);
}

@end
