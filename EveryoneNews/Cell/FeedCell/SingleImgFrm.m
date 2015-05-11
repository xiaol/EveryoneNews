//
//  SingleImgFrm.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/5/6.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "SingleImgFrm.h"

@implementation SingleImgFrm

- (void)setHeadViewDatasource:(HeadViewDatasource *)headViewDatasource
{
    _headViewDatasource = headViewDatasource;
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    _imgFrm = CGRectMake(7, 12, 96, 80);
    
    CGFloat categoryX = screenW - 36;
    CGFloat categoryY = 15;
    _categoryFrm = CGRectMake(categoryX, categoryY, 38, 16);
    
    CGFloat titleX = CGRectGetMaxX(_imgFrm) + 6;
    CGFloat titleW = categoryX - titleX - 8;
    _titleFrm = CGRectMake(titleX, categoryY, titleW, 48);
    
    CGFloat aspectH = 16;
    CGFloat aspectY = CGRectGetMaxY(_imgFrm) - 2 - aspectH;
    CGFloat aspectW = 74;
    CGFloat aspectX = screenW - 12 - aspectW;
    _aspectFrm = CGRectMake(aspectX, aspectY, aspectW, aspectH);
    
    CGFloat pointY = CGRectGetMaxY(_imgFrm) + 6;
    CGFloat pointH = 26;
    _pointFrm_1 = CGRectMake(0, pointY, screenW, pointH);
    
    CGFloat maxPointY = CGRectGetMaxY(_pointFrm_1);
    
    if (_headViewDatasource.subArr.count == 2) {
        _pointFrm_2 = CGRectMake(0, pointY + pointH, screenW, pointH);
        _pointFrm_3 = CGRectMake(0, 0, 0, 0);
        maxPointY = CGRectGetMaxY(_pointFrm_2);
    } else if (_headViewDatasource.subArr.count >= 3){
        _pointFrm_2 = CGRectMake(0, pointY + pointH, screenW, pointH);
        _pointFrm_3 = CGRectMake(0, pointY + pointH * 2, screenW, pointH);
        maxPointY = CGRectGetMaxY(_pointFrm_3);
    }
    maxPointY += 6;
    _backgroundFrm = CGRectMake(0, 0, screenW, maxPointY);
    _cutlineFrm = CGRectMake(0, maxPointY, screenW, 18);
    maxPointY = CGRectGetMaxY(_cutlineFrm);
    _baseFrm = CGRectMake(0, 0, screenW, maxPointY);
    _cellH = maxPointY;
    
    /**** point内部 ****/
    _circleFrm = CGRectMake(17, 0, 15, 15);
    
    CGFloat barH = (pointH - 15) / 2;
    CGFloat offset = 2;
    _topBlueBarFrm = CGRectMake(0, offset, 3, barH);
    CGFloat bottonBarY = pointH - barH;
    _bottonBlueBarFrm  = CGRectMake(0, bottonBarY + offset, 3, barH);
    
    CGFloat sourceX = CGRectGetMaxX(_circleFrm) + 9;
    _sourceFrm = CGRectMake(sourceX, pointH - 10 - 10, 80, pointH);
    CGFloat sourceTitleX = CGRectGetMaxX(_sourceFrm);
    _sourceTitleFrm = CGRectMake(sourceTitleX, pointH - 13 - 10, 100, pointH);
    
}

@end
