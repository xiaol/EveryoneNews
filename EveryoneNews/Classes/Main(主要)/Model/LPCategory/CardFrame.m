//
//  LPHomeViewFrame.m
//  EveryoneNews
//
//  Created by dongdan on 15/12/16.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "CardFrame.h"
#import "Card.h"
#import "LPFontSizeManager.h"

static const CGFloat PaddingHorizontal = 12;
static const CGFloat PaddingVertical = 15;

@implementation CardFrame

- (void)setCard:(Card *)card {
    self.homeViewFontSize = [LPFontSizeManager sharedManager].currentHomeViewFontSize;
    CGFloat titleFontSize =  self.homeViewFontSize;
    CGFloat sourceFontSize = 10;
    CGFloat imageH = 75;
    
    if (iPhone6) {
        sourceFontSize = 12;
    } else if (iPhone6Plus) {
        sourceFontSize = 13;
        imageH = 90;
    }
    // 删除按钮宽度和高度
    CGFloat deleteButtonW = 22;
    CGFloat deleteButtonH = 13;
    
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
        
        CGFloat deleteButtonX = ScreenWidth - PaddingHorizontal - deleteButtonW;
        CGFloat deleteButtonY = sourceSiteNameY;
        _noImageDeleteButtonFrame = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
    
        _cellHeight = CGRectGetMaxY(_noImageSeperatorLineFrame);
        
    } else if (card.cardImages.count == 1 || card.cardImages.count == 2) {
        
        
        // 定义单张图片的宽度
        CGFloat imageW = (ScreenWidth - PaddingHorizontal * 2 - 6) / 3 ;

        // 单图标题
        CGFloat titleX = PaddingHorizontal;
        CGFloat titleY = PaddingVertical;
        CGFloat titleW = ScreenWidth - imageW - PaddingHorizontal * 2 - 20;
        // 标题高度
        CGFloat titleH = [title sizeWithFont:[UIFont systemFontOfSize:titleFontSize] maxSize:CGSizeMake(titleW, MAXFLOAT)].height;
        _singleImageTitleLabelFrame = CGRectMake(titleX, titleY, titleW, titleH);
        
        
        // 图片
        CGFloat imageX = ScreenWidth - PaddingHorizontal - imageW;
        CGFloat imageY = PaddingVertical;
        
        // 图片高度
        _singleImageImageViewFrame = CGRectMake(imageX, imageY, imageW, imageH);
        // 新闻来源高度
        CGFloat sourceSiteNameH = [sourceSiteName sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(titleW, MAXFLOAT)].height;
    
        CGFloat sourceSiteNameY = CGRectGetMaxY(_singleImageTitleLabelFrame) + 10;
        if (titleH + sourceSiteNameH + 10 > imageH) {
            sourceSiteNameY = CGRectGetMaxY(_singleImageImageViewFrame) + 10;
        }
        
        _singleImageSourceLabelFrame = CGRectMake(titleX, sourceSiteNameY, titleW, sourceSiteNameH);
        
        CGFloat singleImageSeperatorLineY = 0.f;
        CGFloat deleteButtonY = sourceSiteNameY;
        if (imageH > titleH + sourceSiteNameH + 10) {
            CGFloat deleteButtonX = ScreenWidth - PaddingHorizontal - deleteButtonW - 13 - imageW;
            
            _singleImageDeleteButtonFrame = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
            singleImageSeperatorLineY = CGRectGetMaxY(_singleImageImageViewFrame) + PaddingVertical;
        } else {
            CGFloat deleteButtonX = ScreenWidth - PaddingHorizontal - deleteButtonW;
            _singleImageDeleteButtonFrame = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
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
     
        
        CGFloat deleteButtonX = ScreenWidth - PaddingHorizontal - deleteButtonW;
        CGFloat deleteButtonY = sourceSiteNameY;
        _mutipleImageDeleteButtonFrame = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
        
        
        // 分割线
         CGFloat mutipleImageSeperatorLineY = CGRectGetMaxY(_multipleImageSourceLabelFrame) + PaddingVertical;
        _mutipleImageSeperatorLineFrame = CGRectMake(0, mutipleImageSeperatorLineY, ScreenWidth, 0.5);
        
        _cellHeight = CGRectGetMaxY(_mutipleImageSeperatorLineFrame);
    }
}

@end
