//
//  HeadViewFrame.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/3/23.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "HeadViewFrame.h"

@implementation HeadViewFrame

- (void)setHeadViewDatasource:(HeadViewDatasource *)headViewDatasource
{
    _headViewDatasource = headViewDatasource;
    
    CGFloat backViewW = [UIScreen mainScreen].bounds.size.width;
    
    
    
    CGFloat titleW = backViewW * 3 / 4;
    CGFloat titleH = 60;
    _titleLabFrm = CGRectMake(0, 0, titleW, titleH);
    
    CGFloat imgH = backViewW * 512 / 640;
    _imgFrm = CGRectMake(0, 0, backViewW, imgH);
    
    CGFloat sourceTitleH = 30;
    _titleFrm_1 = CGRectMake(0, imgH - 4 * sourceTitleH, backViewW, sourceTitleH);
    _titleFrm_2 = CGRectMake(0, imgH - 3 * sourceTitleH, backViewW, sourceTitleH);
    _titleFrm_3 = CGRectMake(0, imgH - 2 * sourceTitleH, backViewW, sourceTitleH);
    
    CGFloat aspectW = 120;
    CGFloat aspectX = backViewW - aspectW;
    CGFloat aspectY = CGRectGetMaxY(_titleFrm_3);
    _aspectFrm = CGRectMake(aspectX, aspectY, aspectW, 30);
    
    CGFloat cutY = CGRectGetMaxY(_aspectFrm);
    _cutBlockFrm = CGRectMake(0, cutY, backViewW, 10);
    
    
    CGFloat backViewH = CGRectGetMaxY(_cutBlockFrm);
    _backgroundViewFrm = CGRectMake(0, 0, backViewW, backViewH);
    _cellH = backViewH;
}

@end
