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

const static CGFloat paddingLeft = 17;
const static CGFloat circleHeight = 6.5f;
const static CGFloat circleWidth = 6.5f;
const static CGFloat padding1 = 10.0f;
const static CGFloat padding2 = 7.0f;
const static CGFloat padding3 = 15;
const static CGFloat padding4 = 8.0f;

@implementation LPRelateFrame

- (void)setRelatePoint:(LPRelatePoint *)relatePoint {

   _relatePoint = relatePoint;
    
    CGSize yearSize = [@"2016" sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGSize monthSize = [@"08/12" sizeWithFont:[UIFont systemFontOfSize:LPFont6] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    CGFloat circleRadius = 2.75f;
    
    _circleRadius = circleRadius;
    // 日期包含年份
    if (_relatePoint.updateTime.length > 5) {
        
        _yearPoint = CGPointMake(paddingLeft +  circleHeight / 2 - BodyPadding, padding1 + yearSize.height / 2);
        _monthDayPoint = CGPointMake(paddingLeft +  circleHeight / 2 - BodyPadding, yearSize.height + padding1 * 2 + monthSize.height / 2);
        
        
        _yearF = CGRectMake(0, padding1, yearSize.width + 2, yearSize.height);
        
        _monthDayF = CGRectMake(0, yearSize.height + padding1 * 2, monthSize.width, monthSize.height);
        
        CGFloat titleX = 0.0f;
        CGFloat titleW = 0.0f;
        CGFloat titleH = 0.0f;
        
        CGFloat sourceX = titleX;
        CGFloat sourceH = 0.0f;
        CGFloat sourceW = 0.0f;
  
        
        
        CGFloat imageW = 81;
        CGFloat imageH = 60;
        
        CGFloat maxHeightWithImage = imageH + padding1 + padding2;
        
        // 有图样式
        if (_relatePoint.imgUrl.length > 0 && [_relatePoint.imgUrl rangeOfString:@","].location == NSNotFound) {
            
            titleW = ScreenWidth - imageW - paddingLeft * 2 - padding3 ;
            titleH = [_relatePoint.titleString heightWithConstraintWidth:titleW];
            
            sourceW = titleW;
            sourceH = [_relatePoint.sourceString heightWithConstraintWidth:sourceW];
            
            if (titleH + padding4 + sourceH > maxHeightWithImage) {
                
                titleH = maxHeightWithImage - sourceH - padding4;
            }
            
            _imageViewF = CGRectMake(titleW + 15, CGRectGetMaxY(_monthDayF) + padding2, imageW, imageH);
            
            _titleF = CGRectMake(titleX, CGRectGetMaxY(_monthDayF) + padding1, titleW, titleH);
            
            _sourceSiteF = CGRectMake(sourceX, CGRectGetMaxY(_titleF) + padding1, sourceW, sourceH);
            
            _seperatorViewF = CGRectMake(titleX, CGRectGetMaxY(_imageViewF) + padding1, ScreenWidth - paddingLeft - titleX, 0.5);
            
            
            
        } else {
            // 无图
            titleW = ScreenWidth - (paddingLeft * 2 + circleWidth + padding2) - 4;
            titleH = [_relatePoint.titleString heightWithConstraintWidth:titleW];
            
            sourceW = titleW;
            sourceH = [_relatePoint.sourceString heightWithConstraintWidth:sourceW];
            
            _titleF = CGRectMake(titleX, CGRectGetMaxY(_monthDayF) + padding1, titleW, titleH);
            
            _sourceSiteF = CGRectMake(sourceX, CGRectGetMaxY(_titleF) + padding1, sourceW, sourceH);
            
            _seperatorViewF = CGRectMake(titleX, CGRectGetMaxY(_sourceSiteF) + padding1, ScreenWidth - paddingLeft - titleX, 0.5);
            
        }
        _cellHeight = CGRectGetMaxY(_seperatorViewF);
        _cellViewF = CGRectMake(paddingLeft + circleWidth + padding2, 0, ScreenWidth - (paddingLeft + circleWidth + padding2), _cellHeight);
        
    } else {
        
      
        _monthDayPoint = CGPointMake(paddingLeft +  circleHeight / 2 - BodyPadding,  padding1 + monthSize.height / 2);
        
        _monthDayF = CGRectMake(0,  padding1, monthSize.width, monthSize.height);
        
        CGFloat titleX = 0.0f;
        CGFloat titleW = 0.0f;
        CGFloat titleH = 0.0f;
        
        CGFloat sourceX = titleX;
        CGFloat sourceH = 0.0f;
        CGFloat sourceW = 0.0f;
        
        
        
        CGFloat imageW = 81;
        CGFloat imageH = 60;
        
        CGFloat maxHeightWithImage = imageH + padding1 + padding2;
        
        // 有图样式
        if (_relatePoint.imgUrl.length > 0 && [_relatePoint.imgUrl rangeOfString:@","].location == NSNotFound) {
            
            titleW = ScreenWidth - imageW - paddingLeft * 2 - padding3 ;
            titleH = [_relatePoint.titleString heightWithConstraintWidth:titleW];
            
            sourceW = titleW;
            sourceH = [_relatePoint.sourceString heightWithConstraintWidth:sourceW];
            
            if (titleH + padding4 + sourceH > maxHeightWithImage) {
                
                titleH = maxHeightWithImage - sourceH - padding4;
            }
            
            _imageViewF = CGRectMake(titleW + 15, CGRectGetMaxY(_monthDayF) + padding2, imageW, imageH);
            
            _titleF = CGRectMake(titleX, CGRectGetMaxY(_monthDayF) + padding1, titleW, titleH);
            
            _sourceSiteF = CGRectMake(sourceX, CGRectGetMaxY(_titleF) + padding1, sourceW, sourceH);
            
            _seperatorViewF = CGRectMake(titleX, CGRectGetMaxY(_imageViewF) + padding1, ScreenWidth - paddingLeft - titleX, 0.5);
            
            
            
        } else {
            
            titleW = ScreenWidth - (paddingLeft * 2 + circleWidth + padding2) - 4;
            titleH = [_relatePoint.titleString heightWithConstraintWidth:titleW];
            
            sourceW = titleW;
            sourceH = [_relatePoint.sourceString heightWithConstraintWidth:sourceW];
            
            _titleF = CGRectMake(titleX, CGRectGetMaxY(_monthDayF) + padding1, titleW, titleH);
            
            _sourceSiteF = CGRectMake(sourceX, CGRectGetMaxY(_titleF) + padding1, sourceW, sourceH);
            
            _seperatorViewF = CGRectMake(titleX, CGRectGetMaxY(_sourceSiteF) + padding1, ScreenWidth - paddingLeft - titleX, 0.5);
            
        }
        _cellHeight = CGRectGetMaxY(_seperatorViewF);
        _cellViewF = CGRectMake(paddingLeft + circleWidth + padding2, 0, ScreenWidth - (paddingLeft + circleWidth + padding2), _cellHeight);
        
    }
}


//- (void)setRelatePoint:(LPRelatePoint *)relatePoint {
//    _relatePoint = relatePoint;
//    
//    CGFloat dateLayerX = padding;
//    CGFloat dateLayerW = 32;
//    CGFloat dateLayerH = 12;
//    CGFloat dateLayerY = (cellHeight - dateLayerH - padding) / 2 + padding;
//    
//    CGFloat contentPaddingH = 10;
//    CGFloat contentPaddingV = 5;
//    
//    _datelayerF = CGRectMake(dateLayerX, dateLayerY, dateLayerW, dateLayerH);
//    
//    _dateF = _datelayerF;
//    
//    CGFloat circleRadius = 3.0f;
//    CGFloat circlePathX = CGRectGetMaxX(_datelayerF) + circleRadius * 2;
//    CGFloat circlePathY = (cellHeight + padding)/ 2;
//    
//    _circlePoint = CGPointMake(circlePathX, circlePathY);
//    _circleRadius = circleRadius;
//    
//    // 内容
//    CGFloat contentPathX = circlePathX + circleRadius * 2;
//    
//    CGFloat contentPathH = cellHeight - padding;
//    CGFloat contentPathW = ScreenWidth - contentPathX - padding - BodyPadding * 2;
//    
//    _contentLayerF = CGRectMake(contentPathX, padding, contentPathW, contentPathH);
//    
//    _contentImageViewF =  CGRectMake(contentPathX, padding + contentPaddingV, contentPathW, contentPathH - contentPaddingV * 2);
//    
//
//    _contentF = CGRectMake(contentPaddingH , contentPaddingV, contentPathW - 2 * contentPaddingH, contentPathH - contentPaddingV * 2);
//    
//    // 有图片时，重新设置文字宽度
//    if (_relatePoint.imgUrl.length > 0 && [_relatePoint.imgUrl rangeOfString:@","].location == NSNotFound) {
//        
//        CGFloat imageW = 50;
//        CGFloat imageY = 10;
//        CGFloat imageH = contentPathH - 2 * imageY;
//        _contentF = CGRectMake(contentPaddingH , contentPaddingV, contentPathW - 2 * contentPaddingH - imageW - 10, contentPathH - contentPaddingV * 2);
//        _imageViewF = CGRectMake( CGRectGetMaxX(_contentF) + 10, imageY, imageW, imageH);
//    }
//}

@end
