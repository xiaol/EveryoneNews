//
//  LPSearchCardFrame.m
//  EveryoneNews
//
//  Created by dongdan on 16/6/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPSearchCardFrame.h"
#import "LPSearchCard.h"
#import "NSString+LP.h"
#import "Card+Create.h"
#import "LPFontSizeManager.h"

@implementation LPSearchCardFrame


- (void)setCard:(LPSearchCard *)card {
    
    CGFloat PaddingHorizontal = 10;
    CGFloat sourceFontSize = 10;
    CGFloat paddingVertical = 11;
    
    if (iPhone6Plus) {
        
        PaddingHorizontal = 15;
        sourceFontSize = 10;
        paddingVertical = 10;
        
    } else if (iPhone5) {
        
        PaddingHorizontal = 10;
        
    } else if (iPhone6) {
        
        PaddingHorizontal = 12;
        sourceFontSize = 11;
        
    }
    
    CGFloat paddingBottom = 12;
    
    CGFloat commentLabelW = 50;
    CGFloat commentLabelPaddingRight = 10;

    NSString *sourceSiteName = card.sourceSiteName;
    _card = card;
    _cellHeight = 0.0f;

    NSMutableAttributedString *htmlTitle = [Card titleHtmlString:card.title];
    // 无图
    if(card.cardImages.count == 0) {
        
        CGFloat titlePaddingTop = 11;
        if (iPhone5) {
            titlePaddingTop = 11;
        } else if (iPhone6Plus) {
            titlePaddingTop = 10;
        } else if (iPhone6) {
            titlePaddingTop = 12;
        }
        
        CGFloat titleW = ScreenWidth - PaddingHorizontal * 2;
 
        CGFloat titleH = [htmlTitle tttAttributeLabel:titleW];

        
        _noImageLabelFrame = CGRectMake(PaddingHorizontal , titlePaddingTop, titleW, titleH);
        
        CGFloat sourceSiteNameH = [sourceSiteName sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(titleW, MAXFLOAT)].height;
        
        CGFloat sourcePaddingTop = 10;
        
        if (iPhone6Plus) {
            sourcePaddingTop = 11;
        } else if (iPhone5) {
            sourcePaddingTop = 10;
        } else if (iPhone6) {
            sourcePaddingTop = 11;
        }
        
        CGFloat sourceSiteNameY = CGRectGetMaxY(_noImageLabelFrame) + sourcePaddingTop;
        
        _noImageSourceLabelFrame = CGRectMake(PaddingHorizontal, sourceSiteNameY, titleW, sourceSiteNameH);
        
        if (iPhone6) {
            paddingBottom = 15.5f;
        }
        
        CGFloat noImageSeperatorLineY = CGRectGetMaxY(_noImageSourceLabelFrame) + paddingBottom;
        
        _noImageSeperatorLineFrame = CGRectMake(0, noImageSeperatorLineY, ScreenWidth, 0.5);
        
        _noImageCommentLabelFrame = CGRectMake(ScreenWidth - commentLabelW - commentLabelPaddingRight, sourceSiteNameY, commentLabelW, sourceSiteNameH);
        
        _cellHeight = CGRectGetMaxY(_noImageSeperatorLineFrame);

    }   else if (card.cardImages.count == 1 || card.cardImages.count == 2) {
        
        // 定义单张图片的宽度
        CGFloat imageW = (ScreenWidth - PaddingHorizontal * 2 - 6) / 3 ;
        
        // 单图标题
        CGFloat titleX = PaddingHorizontal;
        CGFloat titleW = ScreenWidth - imageW - PaddingHorizontal * 2 - 20;
        CGFloat titleH = [htmlTitle tttAttributeLabel:titleW];

        // 图片
        CGFloat imageX = ScreenWidth - PaddingHorizontal - imageW;
        CGFloat imageY = paddingVertical;
        
        CGFloat imageH = 76 * imageW / 114;
        
        // 图片高度
        _singleImageImageViewFrame = CGRectMake(imageX, imageY, imageW, imageH);
        // 新闻来源高度
        CGFloat sourceSiteNameH = [sourceSiteName sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(titleW, MAXFLOAT)].height;
        
        CGFloat sourcePaddingTop1 = 10.0f;
 
        
        CGFloat titleY =  0.0f;
        // 判断图片和标题+来源高度
        if ((titleH + sourceSiteNameH + sourcePaddingTop1 ) > imageH) {
            titleY =    paddingVertical;
            
        } else {
            titleY = (imageH - (titleH + sourceSiteNameH + paddingVertical)) / 2 ;
        }
        
        _singleImageTitleLabelFrame = CGRectMake(titleX, titleY, titleW, titleH);
        CGFloat sourceSiteNameY = CGRectGetMaxY(_singleImageTitleLabelFrame) + sourcePaddingTop1;
        _singleImageSourceLabelFrame = CGRectMake(PaddingHorizontal, sourceSiteNameY, titleW, sourceSiteNameH);
        CGFloat singleImageSeperatorLineY = 0.f;
        
        if ( (titleH ) + sourceSiteNameH + sourcePaddingTop1 > imageH) {
            singleImageSeperatorLineY = CGRectGetMaxY(_singleImageSourceLabelFrame) + paddingBottom;
            _singelImageCommentLabelFrame = CGRectMake(ScreenWidth - commentLabelW - commentLabelPaddingRight, sourceSiteNameY, commentLabelW, sourceSiteNameH);
            
        } else {
            singleImageSeperatorLineY = CGRectGetMaxY(_singleImageImageViewFrame)+ paddingBottom;
            _singelImageCommentLabelFrame = CGRectMake(ScreenWidth - commentLabelW - commentLabelPaddingRight - imageW - PaddingHorizontal, sourceSiteNameY, commentLabelW, sourceSiteNameH);
        }
        _singleImageSeperatorLineFrame = CGRectMake(0, singleImageSeperatorLineY, ScreenWidth, 0.5);
        _cellHeight =  CGRectGetMaxY(_singleImageSeperatorLineFrame);
        
    } else if (card.cardImages.count >= 3) {

        CGFloat titleW = ScreenWidth - PaddingHorizontal * 2;
        CGFloat titleH = [htmlTitle tttAttributeLabel:titleW];

        _multipleImageTitleLabelFrame = CGRectMake(PaddingHorizontal, paddingVertical, titleW, titleH);
        
        CGFloat imageY = titleH + 8 + paddingVertical;
        
        // 定义单张图片的宽度
        CGFloat imageW = (ScreenWidth - PaddingHorizontal * 2 - 6) / 3 ;
        
        CGFloat imageH = 76 * imageW / 114;
        
        _multipleImageViewFrame = CGRectMake(PaddingHorizontal, imageY, (ScreenWidth - PaddingHorizontal * 2), imageH);
        
        CGFloat sourcePaddingTop = 4;
        
        CGFloat sourceSiteNameY = CGRectGetMaxY(_multipleImageViewFrame) + sourcePaddingTop;
        CGFloat sourceSiteNameH = [sourceSiteName sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(titleW, MAXFLOAT)].height;
        _multipleImageSourceLabelFrame = CGRectMake(PaddingHorizontal, sourceSiteNameY, titleW, sourceSiteNameH);
        
        _mutipleImageCommentLabelFrame = CGRectMake(ScreenWidth - commentLabelW - commentLabelPaddingRight, sourceSiteNameY, commentLabelW, sourceSiteNameH);
        
        if (iPhone6) {
            paddingBottom = 15;
        }
        // 分割线
        CGFloat mutipleImageSeperatorLineY = CGRectGetMaxY(_multipleImageSourceLabelFrame)+ paddingBottom;
        _mutipleImageSeperatorLineFrame = CGRectMake(0, mutipleImageSeperatorLineY, ScreenWidth, 0.5);
        _cellHeight = CGRectGetMaxY(_mutipleImageSeperatorLineFrame);
    }
}

@end
