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
    
    CGFloat imgX = (backViewW - 320) / 2;
    
    CGFloat startY = 0;
    if (backViewW > 320) {
        startY = 8;
    }
    
    CGFloat titleW = 222 * factor;
    CGFloat titleH = 53;
    _titleLabFrm = CGRectMake(imgX + 12, startY + 30, titleW, titleH);
    
//    CGFloat imgH = 180 * factor;
//    CGFloat imgX = (backViewW - 320) / 2;
    _imgFrm = CGRectMake(imgX, startY, 320, 180);
   
    ////////////////////////
    CGFloat sourceViewH = 24;
    CGFloat sourceViewY = CGRectGetMaxY(_imgFrm);
    _sourceView_1 = CGRectMake(0, sourceViewY, backViewW, sourceViewH);
    _sourceView_2 = CGRectMake(0, sourceViewY + sourceViewH, backViewW, sourceViewH);
    _sourceView_3 = CGRectMake(0, sourceViewY + 2 * sourceViewH, backViewW, sourceViewH);
    
    _sourceIcon = CGRectMake(16, 6, 16, 13.5);
    
    CGFloat sourceNameX = CGRectGetMaxX(_sourceIcon) + 4;
    CGFloat sourceNameH = 14;
    CGFloat sourceNameY = CGRectGetMaxY(_sourceIcon) - sourceNameH;
    _sourceName = CGRectMake(sourceNameX, sourceNameY, 55, sourceNameH);
    
    CGFloat sourceTitleX = CGRectGetMaxX(_sourceName) + 3.5;
    CGFloat sourceTitleW = backViewW - 16 - sourceTitleX;
    CGFloat sourceTitleH = 15;
    CGFloat sourceTitleY = CGRectGetMaxY(_sourceIcon) - sourceTitleH;
    _sourceTitle = CGRectMake(sourceTitleX, sourceTitleY, sourceTitleW, sourceTitleH);
    
    CGFloat cutY;
    
    if (![_headViewDatasource.aspectStr isEqualToString:@"0家观点"]) {
        CGFloat aspectW = 100;
        CGFloat aspectX = backViewW - aspectW - 16;
        CGFloat aspectY = CGRectGetMaxY(_sourceView_3) + 5;
        _aspectFrm = CGRectMake(aspectX, aspectY, aspectW, 30);
        _bottonView = CGRectMake(0, aspectY, backViewW, 40);
        cutY = CGRectGetMaxY(_bottonView);
    } else {
//        _bottonView = CGRectMake(0, CGRectGetMaxY(_sourceView_3), backViewW, 40);
        cutY = CGRectGetMaxY(_sourceView_3);
    }

//    CGFloat aspectW = 100;
//    CGFloat aspectX = backViewW - aspectW - 16;
//    CGFloat aspectY = CGRectGetMaxY(_sourceView_3);
//    _aspectFrm = CGRectMake(aspectX, aspectY, aspectW, 30);
//    _bottonView = CGRectMake(0, aspectY, backViewW, 40);

    
    if (backViewW > 320) {
        _cutBlockFrm = CGRectMake(0, cutY, backViewW, 16);
    } else {
        _cutBlockFrm = CGRectMake(0, cutY, backViewW, 8);
    }
    
    
    
    CGFloat backViewH = CGRectGetMaxY(_cutBlockFrm);
    _backgroundViewFrm = CGRectMake(0, 0, backViewW, backViewH);
    
    _cellH = backViewH;
}

@end
