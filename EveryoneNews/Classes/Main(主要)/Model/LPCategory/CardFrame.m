//
//  LPHomeViewFrame.m
//  EveryoneNews
//
//  Created by dongdan on 15/12/16.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "CardFrame.h"
#import "Card.h"

static const CGFloat PaddingHorizontal = 15;
static const CGFloat PaddingVertical = 15;

@implementation CardFrame

- (void)setCard:(Card *)card {
    CGFloat titleFontSize = ConcernPressTitleFontSize;
    CGFloat sourceFontSize = 10;
    CGFloat imageH = 75;
    if (iPhone6Plus) {
        titleFontSize = 18;
        sourceFontSize = 12;
        imageH = 90;
    }
    NSString *title = card.title;
    NSString *sourceSiteName = card.sourceSiteName;
    _card = card;
    _cellHeight = 0.0f;
    
    if(card.cardImages.count == 0) {
        // 无图
        CGFloat titleW = ScreenWidth - PaddingHorizontal * 2;
        CGFloat titleH = [title sizeWithFont:[UIFont systemFontOfSize:titleFontSize] maxSize:CGSizeMake(titleW, MAXFLOAT)].height;
        _noImageLabelFrame = CGRectMake(PaddingHorizontal, PaddingVertical, titleW, titleH);
        
        CGFloat sourceSiteNameH = [sourceSiteName sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(titleW, MAXFLOAT)].height;
        CGFloat sourceSiteNameY = CGRectGetMaxY(_noImageLabelFrame) + 5;
        
        _noImageSourceLabelFrame = CGRectMake(PaddingHorizontal, sourceSiteNameY, titleW, sourceSiteNameH);
        
        CGFloat noImageSeperatorLineY = CGRectGetMaxY(_noImageSourceLabelFrame) + PaddingVertical;
        
        _noImageSeperatorLineFrame = CGRectMake(0, noImageSeperatorLineY, ScreenWidth, 0.5);
        
        _cellHeight = CGRectGetMaxY(_noImageSeperatorLineFrame);
        
    } else if (card.cardImages.count == 1 || card.cardImages.count == 2) {
        CGFloat imageX = PaddingHorizontal;
        CGFloat imageY = PaddingVertical;
        // 图片高度
        CGFloat imageW = (ScreenWidth - PaddingHorizontal * 2 - 6) / 3 ;
        
        
        // 标题宽度
        CGFloat titleW = ScreenWidth - imageW - 3 * PaddingHorizontal;
        // 标题高度
        CGFloat titleH = [title sizeWithFont:[UIFont systemFontOfSize:titleFontSize] maxSize:CGSizeMake(titleW, MAXFLOAT)].height;
        CGFloat titleX = imageW + PaddingHorizontal * 2;
        CGFloat titleY = PaddingVertical;
        CGFloat singleImageSeperatorLineY = 0.f;
        // 分割线
        
        // 新闻来源高度
        CGFloat sourceSiteNameH = [sourceSiteName sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(titleW, MAXFLOAT)].height;
        CGFloat sourceSiteNameY = 0.f;
        // 如果图片比文字高则以图片作为参考对象
        if (imageH > titleH + sourceSiteNameH + 10) {
            titleY = PaddingVertical + (imageH - titleH - sourceSiteNameH - 10) / 2;
           
        } else {
            imageY = PaddingVertical + (titleH + sourceSiteNameH + 10 - imageH) / 2;
        }
        sourceSiteNameY = titleY + titleH + 10;
        _singleImageImageViewFrame = CGRectMake(imageX, imageY, imageW, imageH);
        _singleImageTitleLabelFrame = CGRectMake(titleX, titleY, titleW, titleH);
        _singleImageSourceLabelFrame = CGRectMake(titleX, sourceSiteNameY, titleW, sourceSiteNameH);
        
        if (imageH > titleH + sourceSiteNameH + 10) {
            singleImageSeperatorLineY = CGRectGetMaxY(_singleImageImageViewFrame) + PaddingVertical;
        } else {
            
            singleImageSeperatorLineY = CGRectGetMaxY(_singleImageSourceLabelFrame) + PaddingVertical;
          
        }
        _singleImageSeperatorLineFrame = CGRectMake(0, singleImageSeperatorLineY, ScreenWidth, 0.5);
        _cellHeight =  CGRectGetMaxY(_singleImageSeperatorLineFrame);
        
    } else if (card.cardImages.count >= 3) {
        CGFloat titleW = ScreenWidth - PaddingHorizontal * 2;
        CGFloat titleH = [title sizeWithFont:[UIFont systemFontOfSize:titleFontSize] maxSize:CGSizeMake(titleW, MAXFLOAT)].height;
        _multipleImageTitleLabelFrame = CGRectMake(PaddingHorizontal, PaddingVertical, titleW, titleH);
        
        CGFloat imageY = PaddingVertical + titleH + 8;
        _multipleImageViewFrame = CGRectMake(PaddingHorizontal, imageY, titleW, imageH);
        
        CGFloat sourceSiteNameY = CGRectGetMaxY(_multipleImageViewFrame) + 6;
        CGFloat sourceSiteNameH = [sourceSiteName sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(titleW, MAXFLOAT)].height;
        _multipleImageSourceLabelFrame = CGRectMake(PaddingHorizontal, sourceSiteNameY, titleW, sourceSiteNameH);
     
        // 分割线
         CGFloat mutipleImageSeperatorLineY = CGRectGetMaxY(_multipleImageSourceLabelFrame) + PaddingVertical;
        _mutipleImageSeperatorLineFrame = CGRectMake(0, mutipleImageSeperatorLineY, ScreenWidth, 0.5);
        
        _cellHeight = CGRectGetMaxY(_mutipleImageSeperatorLineFrame);
    }
}

@end
