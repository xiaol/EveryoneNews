//
//  LPDetailVideoFrame.m
//  EveryoneNews
//
//  Created by dongdan on 2017/1/5.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "LPDetailVideoFrame.h"
#import "LPVideoModel.h"

@implementation LPDetailVideoFrame

- (void)setVideoModel:(LPVideoModel *)videoModel {
    _videoModel = videoModel;
    CGFloat paddingLeft = 18;
    CGFloat imagePadding = 20;
    CGFloat sourcePadding = 5;
    CGFloat paddingTop = 16;
    CGFloat titleX = 13;
    CGFloat imageW = 90;
    CGFloat imageH = 60;
    
    if (iPhone6Plus) {
        imageW = 100;
        imageH = 73;
    } else if (iPhone6) {
        imageW = 92;
        imageH = 67;
    }
    CGFloat titleW = 0.0f;
    CGFloat titleH = 0.0f;
    CGFloat sourceX = paddingLeft;
    CGFloat sourceH = 0.0f;
    CGFloat sourceW = 0.0f;
    
    titleW = ScreenWidth - imageW - paddingLeft * 2 - imagePadding ;
    NSMutableAttributedString *titleHtmlString = _videoModel.titleHtmlString;
    titleH =  [titleHtmlString textViewHeightWithConstraintWidth:titleW];
    
    CGFloat singleTitleH =  [_videoModel.singleHtmlString textViewHeightWithConstraintWidth:titleW];
    
    if (titleH > 2 * singleTitleH) {
        titleH = 2 * singleTitleH - 2;
    }
 
    sourceW = titleW;
    sourceH = [_videoModel.sourceString heightWithConstraintWidth:sourceW];
    
    CGFloat titleY = 0.0f;
    
    
    
    if (titleH + sourceH + sourcePadding > imageH) {
        titleH = imageH - sourceH - sourcePadding;
    }
    titleY = paddingTop + (imageH - titleH - sourceH - sourcePadding) / 2.0f;
    
    _titleF = CGRectMake(titleX, titleY, titleW , titleH);
    
    CGFloat imageViewX = ScreenWidth - paddingLeft - imageW;
    CGFloat imageViewY = paddingTop;
    _thumbnailImageViewF = CGRectMake(imageViewX,imageViewY , imageW, imageH);
    
    // 播放按钮 播放时长
    NSString *duration = @"000000";
    CGFloat durationFontSize = 10;
    CGFloat durationLabelW = [duration sizeWithFont:[UIFont systemFontOfSize:durationFontSize] maxSize:CGSizeMake(ScreenWidth, ScreenHeight)].width;
    CGFloat durationLabelH = [duration sizeWithFont:[UIFont systemFontOfSize:durationFontSize] maxSize:CGSizeMake(ScreenWidth, ScreenHeight)].height;
    
    CGFloat playImageViewW  = 10;
    CGFloat playImageViewH  = 10;
    CGFloat playImageViewX = (imageW - playImageViewW) / 2 + 5 ;
    
    if (iPhone6Plus) {
        playImageViewX = (imageW - playImageViewW) / 2 + 8 ;
    }
    
    CGFloat playImageViewY = (imageH - playImageViewH - 5);
    _playImageViewF = CGRectMake(playImageViewX, playImageViewY, playImageViewW, playImageViewH);
    CGFloat durationLabelX = CGRectGetMaxX(_playImageViewF) + 5;
    CGFloat durationLabelY = 0;
    _durationF = CGRectMake(durationLabelX, durationLabelY, durationLabelW, durationLabelH);
    
    _sourceSiteF = CGRectMake(sourceX, CGRectGetMaxY(_titleF) + sourcePadding , sourceW, sourceH);
    _seperatorViewF = CGRectMake(titleX, CGRectGetMaxY(_thumbnailImageViewF) + 10, ScreenWidth - paddingLeft * 2, 0.5);
    _cellHeight = CGRectGetMaxY(_seperatorViewF);
}

@end
