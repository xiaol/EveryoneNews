//
//  SingleImgFrm.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/5/6.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "SingleImgFrm.h"
#import "AutoLabelSize.h"
#import "NSString+YU.h"

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

    CGFloat maxPointY = CGRectGetMaxY(_aspectFrm) + 10 ;
    
//    _backgroundFrm = CGRectMake(0, 0, screenW, maxPointY);
    _cellH = maxPointY;
   
    NSArray *subArr = _headViewDatasource.subArr;

    if (subArr != nil && ![subArr isKindOfClass:[NSNull class]] && subArr.count != 0) {

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

    CGFloat filler = 5.0;
    _cellH += filler;
    _cutlineFrm = CGRectMake(0, _cellH, screenW, 18);
    _cellH += _cutlineFrm.size.height;
    _backgroundFrm = CGRectMake(0, 0, screenW, _cellH);
    
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
    
    NSLog(@"sourceSize.H:%F", sourceSize.height);
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
