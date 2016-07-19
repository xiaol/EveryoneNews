//
//  LPQiDianHaoFrame.m
//  EveryoneNews
//
//  Created by dongdan on 16/7/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPQiDianHaoFrame.h"
#import "LPQiDianHao.h"

@implementation LPQiDianHaoFrame

- (void)setQiDianHao:(LPQiDianHao *)qiDianHao {
    _qiDianHao = qiDianHao;
    
    CGFloat concernImageViewX = 12.0f;
    CGFloat concernImageViewY = 12.0f;
    CGFloat concernImageViewW = 47.0f;
    CGFloat concernImageViewH = 47.0f;
    _concernImageViewF = CGRectMake(concernImageViewX, concernImageViewY, concernImageViewW, concernImageViewH);
    
    NSString *title = qiDianHao.title;
    NSString *concernCount = qiDianHao.concernCount;
    CGFloat titleFontSize = LPFont2;
    CGFloat concernCountFontSize = LPFont5;
    
    CGFloat titleLabelX = CGRectGetMaxX(_concernImageViewF) + 12;
    CGFloat titleLabelY = 12.0;
    CGFloat titleLabelW = [title sizeWithFont:[UIFont systemFontOfSize:titleFontSize] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
    CGFloat titleLabelH = [title sizeWithFont:[UIFont systemFontOfSize:titleFontSize] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
    _titleLabelF = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    
    CGFloat concernCountX = CGRectGetMaxX(_concernImageViewF) + 12;
    CGFloat concernCountY = CGRectGetMaxY(_titleLabelF) + 2;
    CGFloat concernCountW = [concernCount sizeWithFont:[UIFont systemFontOfSize:concernCountFontSize] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
    CGFloat concernCountH = [concernCount sizeWithFont:[UIFont systemFontOfSize:concernCountFontSize] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
    _concernCountLabelF = CGRectMake(concernCountX, concernCountY, concernCountW, concernCountH);
    
    CGFloat concernButtonW = 60;
    CGFloat concernButtonH = 24;
    CGFloat concernButtonX = ScreenWidth - concernButtonW - 17;
    CGFloat concernButtonY = titleLabelY;
    _concernButtonF = CGRectMake(concernButtonX, concernButtonY, concernButtonW, concernButtonH);
    
    CGFloat seperatorLineX = 18;
    CGFloat seperatorLineY = CGRectGetMaxY(_concernImageViewF) + 12.0;
    CGFloat seperatorLineW = ScreenWidth - seperatorLineX;
    _seperatorLineF = CGRectMake(seperatorLineX, seperatorLineY, seperatorLineW, 0.5);
    
    _cellHeight =  CGRectGetMaxY(_seperatorLineF);
    
}

@end
