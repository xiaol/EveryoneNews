//
//  ContentCellFrame.m
//  upNews
//
//  Created by 于咏畅 on 15/1/20.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "ContentCellFrame.h"

@implementation ContentCellFrame

- (void)setContentDatasource:(ContentDatasource *)contentDatasource
{
    _contentDatasource = contentDatasource;
    CGFloat X = 15;
    CGFloat Y = 0;
    CGFloat blank = 22;
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 2 * X;
    CGFloat imgW = _contentDatasource.imgW;
    CGFloat imgH = _contentDatasource.imgH;
    
    if (imgW >= width) {
        imgH = imgH * width / imgW;
        imgW = width;
    }
    
    X = ([UIScreen mainScreen].bounds.size.width - imgW) / 2;
    _imgViewFrm = CGRectMake(X, Y, imgW, imgH + blank);
    _imgFrm = CGRectMake(0, blank, imgW, imgH);
    _cellHeight = CGRectGetMaxY(_imgViewFrm);
}

@end
