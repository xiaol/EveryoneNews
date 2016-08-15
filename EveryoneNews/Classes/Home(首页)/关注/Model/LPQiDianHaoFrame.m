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
    
    NSString *title = qiDianHao.name;
    
    NSString *concernStr = @"";
    if (qiDianHao.concernCount > 10000) {
        concernStr = [NSString stringWithFormat:@"%.1f万", (qiDianHao.concernCount / 10000.00f)];
    } else {
        concernStr = [NSString stringWithFormat:@"%d", qiDianHao.concernCount];
    }
    
    NSString *concernCount = [NSString stringWithFormat:@"%@人关注",concernStr] ;
    CGFloat titleFontSize = LPFont2;
    CGFloat concernCountFontSize = LPFont5;
    
    CGFloat titleLabelX = CGRectGetMaxX(_concernImageViewF) + 12;
    CGFloat titleLabelY = 12.0;
    CGFloat titleLabelW = [title sizeWithFont:[UIFont systemFontOfSize:titleFontSize] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
    CGFloat titleLabelH = [title sizeWithFont:[UIFont systemFontOfSize:titleFontSize] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
    
    if (qiDianHao.concernCount  == 0) {
        titleLabelY = (concernImageViewH + concernImageViewY * 2 - titleLabelH) / 2.0f;
    }
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
