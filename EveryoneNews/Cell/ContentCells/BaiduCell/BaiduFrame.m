//
//  BaiduFrame.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/3/31.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "BaiduFrame.h"
//#import "AutoLabelSize.h"

@implementation BaiduFrame

- (void)setBaiduDatasource:(BaiduDatasource *)baiduDatasource
{
    _baiduDatasource = baiduDatasource;
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat titleX = 20;
    CGFloat titleY = 10;
    
    //    CGSize nameSize = [AutoLabelSize autoLabSizeWithStr:_baiduDatasource.title Fontsize:16 SizeW:0 SizeH:16];
    CGFloat titleW = screenW - titleX * 2;
    
    _titleFrm = CGRectMake(titleX, titleY, titleW, 16);
    
    CGFloat abstractY = CGRectGetMaxY(_titleFrm) + 10;
    _abstractFrm = CGRectMake(titleX, abstractY, screenW - 2 * titleX, 82);
    
    CGFloat iconY = CGRectGetMaxY(_abstractFrm) + 10;
    CGFloat iconW = 42;
    CGFloat iconX = screenW - titleX - iconW;
    _baiduIconFrm = CGRectMake(iconX, iconY, iconW, 14);
    
    CGFloat backViewH = CGRectGetMaxY(_baiduIconFrm) + 10;
    _backViewFrm = CGRectMake(0, 14, screenW, backViewH);
    
    CGFloat baseViewH = CGRectGetMaxY(_backViewFrm) + 14;
    _baseViewFrm = CGRectMake(0, 0, screenW, baseViewH);
    
    _cellH = CGRectGetMaxY(_backViewFrm);
    
}

@end