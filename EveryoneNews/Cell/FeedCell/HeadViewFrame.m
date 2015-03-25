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
    
    CGFloat factor = [UIScreen mainScreen].bounds.size.width / 320;
    
    CGFloat startY = 8;
    CGFloat titleW = 222 * factor;
    CGFloat titleH = 53;
    _titleLabFrm = CGRectMake(0, startY, titleW, titleH);
    
    CGFloat imgH = 133 * factor;
    _imgFrm = CGRectMake(0, startY, backViewW, imgH);
    
//    CGFloat sourceTitleH = 30;
//    CGFloat sourceTitleY = CGRectGetMaxY(_imgFrm);
//    _titleFrm_1 = CGRectMake(0, sourceTitleY, backViewW, sourceTitleH);
//    _titleFrm_2 = CGRectMake(0, sourceTitleY + sourceTitleH, backViewW, sourceTitleH);
//    _titleFrm_3 = CGRectMake(0, sourceTitleY + 2 * sourceTitleH, backViewW, sourceTitleH);
    
    ////////////////////////
    CGFloat sourceViewH = 30;
    CGFloat sourceViewY = CGRectGetMaxY(_imgFrm);
    _sourceView_1 = CGRectMake(0, sourceViewY, backViewW, sourceViewH);
    _sourceView_2 = CGRectMake(0, sourceViewY + sourceViewH, backViewW, sourceViewH);
    _sourceView_3 = CGRectMake(0, sourceViewY + 2 * sourceViewH, backViewW, sourceViewH);
    
    _sourceIcon = CGRectMake(16, 8, 16, 13.5);
    
    CGFloat sourceNameX = CGRectGetMaxX(_sourceIcon);
    CGFloat sourceNameH = 16;
    CGFloat sourceNameY = CGRectGetMaxY(_sourceIcon) - sourceNameH;
    _sourceName = CGRectMake(sourceNameX, sourceNameY, 55, sourceNameH);
    
    CGFloat sourceTitleX = CGRectGetMaxX(_sourceName) + 3.5;
    CGFloat sourceTitleW = backViewW - 16;
    CGFloat sourceTitleH = 18;
    CGFloat sourceTitleY = CGRectGetMaxY(_sourceIcon) - sourceTitleH;
    _sourceTitle = CGRectMake(sourceTitleX, sourceTitleY, sourceTitleW, sourceTitleH);
    
    
    CGFloat aspectW = 120;
    CGFloat aspectX = backViewW - aspectW;
    CGFloat aspectY = CGRectGetMaxY(_sourceView_3);
    _aspectFrm = CGRectMake(aspectX, aspectY, aspectW, 30);
    
    CGFloat cutY = CGRectGetMaxY(_aspectFrm);
    _cutBlockFrm = CGRectMake(0, cutY, backViewW, 8);
    
    
    CGFloat backViewH = CGRectGetMaxY(_cutBlockFrm);
    _backgroundViewFrm = CGRectMake(0, 0, backViewW, backViewH);
    _cellH = backViewH;
}

@end
