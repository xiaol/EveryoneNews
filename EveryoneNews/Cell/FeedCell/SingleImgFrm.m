//
//  SingleImgFrm.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/5/6.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "SingleImgFrm.h"
#import "AutoLabelSize.h"

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
    
//    CGFloat pointY = CGRectGetMaxY(_imgFrm) + 6;
//    CGFloat pointH = 26;
//    _pointFrm_1 = CGRectMake(0, pointY, screenW, pointH);
//    
//    CGFloat maxPointY = CGRectGetMaxY(_pointFrm_1);
//    
//    if (_headViewDatasource.subArr.count == 2) {
//        _pointFrm_2 = CGRectMake(0, pointY + pointH, screenW, pointH);
//        _pointFrm_3 = CGRectMake(0, 0, 0, 0);
//        maxPointY = CGRectGetMaxY(_pointFrm_2);
//    } else if (_headViewDatasource.subArr.count >= 3){
//        _pointFrm_2 = CGRectMake(0, pointY + pointH, screenW, pointH);
//        _pointFrm_3 = CGRectMake(0, pointY + pointH * 2, screenW, pointH);
//        maxPointY = CGRectGetMaxY(_pointFrm_3);
//    }
    CGFloat maxPointY = CGRectGetMaxY(_aspectFrm) + 6;
    _backgroundFrm = CGRectMake(0, 0, screenW, maxPointY);
//    _cutlineFrm = CGRectMake(0, maxPointY, screenW, 18);
//    maxPointY = CGRectGetMaxY(_cutlineFrm);
//    _baseFrm = CGRectMake(0, 0, screenW, maxPointY);
    _cellH = maxPointY;
    
    /**** point内部 ****/
//    _circleFrm = CGRectMake(17, 0, 15, 15);
//    
//    CGFloat barH = (pointH - 15) / 2;
//    CGFloat offset = 2;
//    _topBlueBarFrm = CGRectMake(0, offset, 3, barH);
//    CGFloat bottonBarY = pointH - barH;
//    _bottonBlueBarFrm  = CGRectMake(0, bottonBarY + offset, 3, barH);
//    
//    CGFloat sourceX = CGRectGetMaxX(_circleFrm) + 9;
////    _sourceFrm = CGRectMake(sourceX, pointH - 10 - 10, 80, pointH);
////    CGFloat sourceTitleX = CGRectGetMaxX(_sourceFrm);
////    _sourceTitleFrm = CGRectMake(sourceTitleX, pointH - 13 - 10, 100, pointH);
//    _sourceTitleFrm = CGRectMake(sourceX, 0, 180, pointH);
    
    NSArray *subArr = _headViewDatasource.subArr;

    if (subArr != nil && ![subArr isKindOfClass:[NSNull class]] && subArr.count != 0) {
//        [self setPointDetail:_pointFrm_1 WithDict:subArr[0] sourceTitleFrm:_sourceTitleFrm_1];
        [self setPointDetailWithDict:subArr[0] index:1];
        _pointFrm_3 = CGRectMake(0, 0, 0, 0);
        _pointFrm_2 = CGRectMake(0, 0, 0, 0);
    } else {
        _pointFrm_1 = CGRectMake(0, 0, 0, 0);
        _pointFrm_2 = CGRectMake(0, 0, 0, 0);
        _pointFrm_3 = CGRectMake(0, 0, 0, 0);
    }
    
    
    if (subArr.count == 2) {
//         [self setPointDetail:_pointFrm_2 WithDict:subArr[1] sourceTitleFrm:_sourceTitleFrm_2];
        [self setPointDetailWithDict:subArr[1] index:2];
        _pointFrm_3 = CGRectMake(0, 0, 0, 0);
    } else if (subArr.count >= 3) {
//        [self setPointDetail:_pointFrm_2 WithDict:subArr[1] sourceTitleFrm:_sourceTitleFrm_2];
//        [self setPointDetail:_pointFrm_3 WithDict:subArr[2] sourceTitleFrm:_sourceTitleFrm_3];
        [self setPointDetailWithDict:subArr[1] index:2];
        [self setPointDetailWithDict:subArr[2] index:3];
    }
    _cutlineFrm = CGRectMake(0, _cellH, screenW, 18);
    _cellH += _cutlineFrm.size.height;
}

- (void)setPointDetailWithDict:(NSDictionary *)dict index:(int)index
{
    
    NSString *sourceStr;
    if (![self isBlankString:dict[@"user"]]) {
        sourceStr = dict[@"user"];
    } else if (![self isBlankString:dict[@"sourceSitename"]]) {
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

    CGRect sourceTitleFrm = CGRectMake(50, 0, sourceTitleW, sourceTitleH);
    
    CGRect viewFrm = CGRectMake(0, _cellH, screenW, sourceTitleH);
    
    [self drawPointInIndex:index PointFrm:viewFrm SourceFrm:sourceTitleFrm];

    _cellH = _cellH + sourceTitleH;
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

#pragma mark 判断字符串是否为空
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
@end
