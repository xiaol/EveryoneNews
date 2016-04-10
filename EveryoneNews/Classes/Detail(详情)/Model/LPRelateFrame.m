//
//  LPRelateFrame.m
//  EveryoneNews
//
//  Created by dongdan on 16/3/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPRelateFrame.h"
#import "LPRelatePoint.h"


const static CGFloat cellHeight = 79;
const static CGFloat padding = 10;

@implementation LPRelateFrame

- (void)setRelatePoint:(LPRelatePoint *)relatePoint {
    _relatePoint = relatePoint;
    
    CGFloat dateLayerX = padding;
    CGFloat dateLayerW = 32;
    CGFloat dateLayerH = 12;
    CGFloat dateLayerY = (cellHeight - dateLayerH - padding) / 2 + padding;
    
    CGFloat contentPaddingH = 10;
    CGFloat contentPaddingV = 5;
    
    _datelayerF = CGRectMake(dateLayerX, dateLayerY, dateLayerW, dateLayerH);
    
    _dateF = _datelayerF;
    
    CGFloat circleRadius = 3.0f;
    CGFloat circlePathX = CGRectGetMaxX(_datelayerF) + circleRadius * 2;
    CGFloat circlePathY = (cellHeight + padding)/ 2;
    
    _circlePoint = CGPointMake(circlePathX, circlePathY);
    _circleRadius = circleRadius;
    
    // 内容
    CGFloat contentPathX = circlePathX + circleRadius * 2;
    
    CGFloat contentPathH = cellHeight - padding;
    CGFloat contentPathW = ScreenWidth - contentPathX - padding - BodyPadding * 2;
    
    _contentLayerF = CGRectMake(contentPathX, padding, contentPathW, contentPathH);
    
    _contentImageViewF =  CGRectMake(contentPathX, padding + contentPaddingV, contentPathW, contentPathH - contentPaddingV * 2);
    

    _contentF = CGRectMake(contentPaddingH , contentPaddingV, contentPathW - 2 * contentPaddingH, contentPathH - contentPaddingV * 2);
    
    // 有图片时，重新设置文字宽度
    if (_relatePoint.imgUrl.length > 0 && [_relatePoint.imgUrl rangeOfString:@","].location == NSNotFound) {
        
        CGFloat imageW = 50;
        CGFloat imageY = 10;
        CGFloat imageH = contentPathH - 2 * imageY;
        _contentF = CGRectMake(contentPaddingH , contentPaddingV, contentPathW - 2 * contentPaddingH - imageW - 10, contentPathH - contentPaddingV * 2);
        _imageViewF = CGRectMake( CGRectGetMaxX(_contentF) + 10, imageY, imageW, imageH);
    }
}

@end
