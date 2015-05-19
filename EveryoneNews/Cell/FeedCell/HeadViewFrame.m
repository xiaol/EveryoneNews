//
//  HeadViewFrame.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/3/23.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "HeadViewFrame.h"
#import "AutoLabelSize.h"
#import "NSString+YU.h"
#import "NSArray+isEmpty.h"

@implementation HeadViewFrame
{
    CGFloat maxSourceViewY;
    CGFloat maxImgY;
    CGFloat sourceViewY;
}

- (void)setHeadViewDatasource:(HeadViewDatasource *)headViewDatasource
{
    _headViewDatasource = headViewDatasource;
    
    CGFloat backViewW = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat imgX = (backViewW - 320) / 2 + 7;
    CGFloat startY = 0;
    if (backViewW > 320) {
        startY = 20;
    }
    CGFloat titleW = 222;
    CGFloat titleH = 53;
    
    if (_headViewDatasource.imgArr.count == 2) {
        CGFloat offset = 9;
        CGFloat imgW = (320 - offset - 2 * 7) / 2;
        CGFloat imgH = 230 * imgW / 335;
        _imgFrm = CGRectMake(imgX, startY, imgW, imgH);
        _imgFrm_2 = CGRectMake(imgX + offset + imgW, startY, imgW, imgH);
        _imgFrm_3 = CGRectMake(0, 0, 0, 0);
        
    } else if (_headViewDatasource.imgArr.count > 2) {
        CGFloat offset = 9;
        CGFloat imgW = (320 - offset * 2 - 2 * 7) / 3;
        CGFloat imgH = 180 * imgW / 220;
        _imgFrm = CGRectMake(imgX, startY, imgW, imgH);
        _imgFrm_2 = CGRectMake(imgX + offset + imgW, startY, imgW, imgH);
        _imgFrm_3 = CGRectMake(imgX + 2 * offset + 2 * imgW, startY, imgW, imgH);
    }
    CGFloat titleY = CGRectGetMaxY(_imgFrm) + 18;
    titleW = backViewW - 36 - 9 - imgX;
    _titleLabFrm = CGRectMake(imgX + 12, titleY, titleW, titleH);
    
    CGFloat categoryX = backViewW - imgX - 36;
    CGFloat categoryY = CGRectGetMaxY(_titleLabFrm);
    _categoryFrm = CGRectMake(categoryX, categoryY, 36, 18);
    
//    sourceViewY = CGRectGetMaxY(_categoryFrm);
    
    /*** 更新多行评论 ***/
    
    _cellH = CGRectGetMaxY(_categoryFrm);
    
    NSArray *subArr = _headViewDatasource.subArr;
    
    if (![NSArray isEmpty:subArr]) {
        
        [self setPointDetailWithDict:subArr[0] index:1];
        _pointFrm_3 = CGRectMake(0, 0, 0, 0);
        _pointFrm_2 = CGRectMake(0, 0, 0, 0);
    } else {
        _pointFrm_1 = CGRectMake(0, 0, 0, 0);
        _pointFrm_2 = CGRectMake(0, 0, 0, 0);
        _pointFrm_3 = CGRectMake(0, 0, 0, 0);
    }
    
    if (subArr.count == 2) {
        
        [self setPointDetailWithDict:subArr[1] index:2];
        _pointFrm_3 = CGRectMake(0, 0, 0, 0);
    } else if (subArr.count >= 3) {
        [self setPointDetailWithDict:subArr[1] index:2];
        [self setPointDetailWithDict:subArr[2] index:3];
    }


//    CGFloat sourceViewH = 28;
    
//    _pointFrm_1 = CGRectMake(0, sourceViewY, backViewW, sourceViewH);
//    maxSourceViewY = CGRectGetMaxY(_pointFrm_1);
//    if (_headViewDatasource.subArr.count == 2) {
//        _pointFrm_2 = CGRectMake(0, sourceViewY + sourceViewH, backViewW, sourceViewH);
//        maxSourceViewY = CGRectGetMaxY(_pointFrm_2);
//        _pointFrm_3 = CGRectMake(0, 0, 0, 0);
//    }
//    if (_headViewDatasource.subArr.count >= 3) {
//        _pointFrm_2 = CGRectMake(0, sourceViewY + sourceViewH, backViewW, sourceViewH);
//        _pointFrm_3 = CGRectMake(0, sourceViewY + 2 * sourceViewH, backViewW, sourceViewH + 5);
//        maxSourceViewY = CGRectGetMaxY(_pointFrm_3);
//    }
    
    
    _sourceIcon = CGRectMake(16 + 12, 8, 16, 13.5);
    
    CGFloat sourceNameX = CGRectGetMaxX(_sourceIcon) + 4;
    CGFloat sourceNameH = 13;
    CGFloat sourceNameY = CGRectGetMaxY(_sourceIcon) - sourceNameH - 0.5;
    _sourceName = CGRectMake(sourceNameX, sourceNameY, 55, sourceNameH);
    
    CGFloat sourceTitleX = CGRectGetMaxX(_sourceName) + 3.5;
    CGFloat sourceTitleW = backViewW - 16 - sourceTitleX;
    CGFloat sourceTitleH = 14;
    CGFloat sourceTitleY = CGRectGetMaxY(_sourceIcon) - sourceTitleH;
    _sourceTitle = CGRectMake(sourceTitleX, sourceTitleY, sourceTitleW, sourceTitleH);
    
    CGFloat cutY;
    
    if (![_headViewDatasource.aspectStr isEqualToString:@"0家观点"]) {
        CGFloat aspectW = 100;
        CGFloat aspectX = backViewW - aspectW - 16;
        CGFloat aspectY = _cellH + 5;
        _aspectFrm = CGRectMake(aspectX, aspectY, aspectW, 30);
        _bottonView = CGRectMake(0, aspectY, backViewW, 40);
        cutY = CGRectGetMaxY(_bottonView);
    } else {
        _aspectFrm = CGRectMake(0, 0, 0, 0);
        cutY = _cellH;
    }
    
    cutY += 8;
    
    if (backViewW > 320) {
        _cutBlockFrm = CGRectMake(0, cutY, backViewW, 1);
    } else {
        _cutBlockFrm = CGRectMake(0, cutY, backViewW, 8);
    }
    
    CGFloat backViewH = CGRectGetMaxY(_cutBlockFrm);
    _backgroundViewFrm = CGRectMake(0, 0, backViewW, backViewH);
    
    _cellH = backViewH;
}

- (void)setPointDetailWithDict:(NSDictionary *)dict index:(int)index
{
    
    NSString *sourceStr;
    if (![NSString isBlankString:dict[@"user"]]) {
        sourceStr = dict[@"user"];
    } else if (![NSString isBlankString:dict[@"sourceSitename"]]) {
        sourceStr = dict[@"sourceSitename"];
    } else {
        sourceStr = @"null";
    }
    sourceStr = [NSString stringWithFormat:@"%@:%@", sourceStr, dict[@"title"]];
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat sourceTitleW = screenW - 50 - 10;
    CGSize sourceSize = [AutoLabelSize autoLabSizeWithStr:sourceStr Fontsize:12 SizeW:sourceTitleW SizeH:0];
    
    CGFloat sourceTitleH = sourceSize.height;
    if (sourceTitleH > 30) {
        sourceTitleH = 30;
    }
    
    CGRect sourceTitleFrm = CGRectMake(50, 5, sourceTitleW, sourceTitleH);
    
    CGRect viewFrm = CGRectMake(0, _cellH, screenW, (sourceTitleH + 10));
    
    [self drawPointInIndex:index PointFrm:viewFrm SourceFrm:sourceTitleFrm];
    
    _cellH = _cellH + viewFrm.size.height;
}

- (void)drawPointInIndex:(int)index PointFrm:(CGRect)pointFrm SourceFrm:(CGRect)sourceFrm
{
    if (index == 1) {
        _pointFrm_1 = pointFrm;
        _sourceTitleFrm_1 = sourceFrm;
    } else if (index == 2) {
        _pointFrm_2 = pointFrm;
        _sourceTitleFrm_2 = sourceFrm;
    } else if (index == 3) {
        _pointFrm_3 = pointFrm;
        _sourceTitleFrm_3 = sourceFrm;
    }
}

@end
