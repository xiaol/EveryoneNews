//
//  BaiduFrame.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/3/31.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "BaiduFrame.h"

@implementation BaiduFrame

- (void)setBaiduDatasource:(BaiduDatasource *)baiduDatasource
{
    _baiduDatasource = baiduDatasource;
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat titleX = 14;
    CGFloat titleY = 10;
    
    NSDictionary * attribute = @{NSFontAttributeName: [UIFont fontWithName:kFont size:16]};
    CGSize nameSize = [_baiduDatasource.title boundingRectWithSize:CGSizeMake(0, 16) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
//
    _titleFrm = CGRectMake(titleX, titleY, nameSize.width, 16);
    
    CGFloat abstractY = CGRectGetMaxY(_titleFrm) + 10;
    _abstractFrm = CGRectMake(titleX, abstractY, screenW - 2 * titleX, 82);
    
    CGFloat iconY = CGRectGetMaxY(_abstractFrm) + 10;
    CGFloat iconW = 42;
    CGFloat iconX = screenW - titleX - iconW;
    _baiduIconFrm = CGRectMake(iconX, iconY, iconW, 14);
    
    CGFloat backViewH = CGRectGetMaxY(_baiduIconFrm) + 10;
    _backViewFrm = CGRectMake(0, 28, screenW, backViewH);
    
    CGFloat baseViewH = CGRectGetMaxY(_backViewFrm) + 28;
    _baseViewFrm = CGRectMake(0, 0, screenW, baseViewH);
    
    _cellH = CGRectGetMaxY(_backViewFrm);
    
}

@end
