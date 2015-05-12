//
//  BigImgFrm.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/4/21.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "BigImgFrm.h"

@implementation BigImgFrm

- (void)setBigImgDatasource:(BigImgDatasource *)bigImgDatasource
{
    _bigImgDatasource = bigImgDatasource;
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat backH;
    
    if (screenW == 320) {
        backH = 412 / 2;
        _backFrm = CGRectMake(0, 0, screenW, backH + 8);
        _imgFrm = CGRectMake(0, 0, screenW, backH);
        
    } else {
//        CGFloat backH = 195;
        backH = 412 / 2 + 20;
        
        _backFrm = CGRectMake(0, 0, screenW, backH);
        
//        CGFloat imgX = 78;
        CGFloat imgY = 20;
//        CGFloat imgW = 800 / 3;
        CGFloat imgW = 320;
        CGFloat imgX = (screenW - 320) / 2;
//        CGFloat imgH = 464 / 3;
        CGFloat imgH = 412 / 2;
        _imgFrm = CGRectMake(imgX, imgY, imgW, imgH);
        
    }
    
    CGFloat titleY = CGRectGetMaxY(_imgFrm) - 50;
    CGFloat titleX = _imgFrm.origin.x + 24;
    _titleFrm = CGRectMake(titleX, titleY + 5, screenW - 2 * titleX, 40);
    
    CGFloat toumuX = _imgFrm.origin.x;
    _toumuFrm = CGRectMake(toumuX, titleY, _imgFrm.size.width, 50);
    
    CGFloat categoryX = CGRectGetMaxX(_titleFrm);
    CGFloat categoryY = 142 / 3;
    _categoryFrm = CGRectMake(categoryX, categoryY, 18, 36);
    
    _cutlineFrm = CGRectMake(0, _backFrm.size.height - 1, screenW, 1);
    
    _CellH = _backFrm.size.height;
//    _CellH = 300;
}

@end
