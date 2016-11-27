//
//  LPCardConcernFrame.m
//  EveryoneNews
//
//  Created by dongdan on 16/7/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPCardConcernFrame.h"
#import "NSString+LP.h"
#import "Card+Create.h"
#import "CardConcern.h"
#import "LPFontSizeManager.h"
#import "LPFontSize.h"

const static CGFloat paddingLeft = 13;
const static CGFloat paddingTop = 15;

@implementation LPCardConcernFrame

- (void)setCard:(Card *)card {
    
    _card = card;
    NSString *sourceSiteName = card.sourceSiteName;
    NSString *keyword = card.keyword;
    
    CGFloat sourceFontSize = LPFont7;
    CGFloat keywordFontSize = LPFont6;
    CGFloat keywordPaddingHorizontal = 10;
    
    self.homeViewFontSize = [LPFontSizeManager sharedManager].lpFontSize.currentHomeViewFontSize;
    CGFloat titleFontSize =  self.homeViewFontSize;
    CGFloat keywordPadddingVertical = 4;
    
    NSString *title = card.title;
    CGFloat lineSpacing = 4.0;
    CGFloat seperatorH = 4.0f;
    
    // 无图
    if(card.cardImages.count == 0) {
        
        // 关键字
        CGFloat keywordX = paddingLeft;
        CGFloat keywordY = paddingTop;
        CGFloat keywordW = [keyword sizeWithFont:[UIFont systemFontOfSize:keywordFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + keywordPaddingHorizontal;
        CGFloat keywordH = [keyword sizeWithFont:[UIFont systemFontOfSize:keywordFontSize] maxSize:CGSizeMake(keywordW, MAXFLOAT)].height + keywordPadddingVertical;
        _noImageKeywordLabelFrame = CGRectMake(keywordX, keywordY, keywordW, keywordH);
        
        CGFloat sourceListViewX = 0;
        CGFloat sourceListViewY = 0;
        CGFloat sourceListViewW = paddingLeft + keywordW;
        CGFloat sourceListViewH = paddingTop + keywordH;
        _noImageSourceListViewFrame = CGRectMake(sourceListViewX, sourceListViewY, sourceListViewW, sourceListViewH);
        
        // 标题
        CGFloat titleX = paddingLeft;
        CGFloat titleY =  CGRectGetMaxY(_noImageKeywordLabelFrame) + 15;
        CGFloat titleW = ScreenWidth - titleX * 2;
        
        NSMutableAttributedString *attrStr =  [title attributedStringWithFont:[UIFont systemFontOfSize:titleFontSize] lineSpacing:lineSpacing];
        CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        CGFloat titleH = rect.size.height;
        
        _noImageTitleLabelFrame = CGRectMake(titleX, titleY, titleW, titleH);
    
        // 来源
        CGFloat sourceSiteNameX = CGRectGetMaxX(_noImageKeywordLabelFrame) + 7;
        CGFloat sourceSiteNameY = 0;
        CGFloat sourceSiteNameW = [sourceSiteName sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
        CGFloat sourceSiteNameH = [sourceSiteName sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(sourceSiteNameW, MAXFLOAT)].height ;
        _noImageSourceLabelFrame = CGRectMake(sourceSiteNameX, sourceSiteNameY, sourceSiteNameW, sourceSiteNameH);
        
        // 分割线
        CGFloat noImageSeperatorLineY = CGRectGetMaxY(_noImageTitleLabelFrame) + 15;
        _noImageSeperatorLineFrame = CGRectMake(0, noImageSeperatorLineY, ScreenWidth, seperatorH);
        
         _cellHeight = CGRectGetMaxY(_noImageSeperatorLineFrame);
        
    }  else if (card.cardImages.count == 1 || card.cardImages.count == 2) {
        // 定义单张图片的宽度
        CGFloat imageW = (ScreenWidth - paddingLeft * 2 - 6) / 3 ;
        // 单图标题
        CGFloat titleX = paddingLeft;
        CGFloat titleW = ScreenWidth - imageW - paddingLeft * 2 - 20;
        
        NSMutableAttributedString *attrStr =  [title attributedStringWithFont:[UIFont systemFontOfSize:titleFontSize] lineSpacing:lineSpacing];
        CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        CGFloat titleH = rect.size.height;
        CGFloat titleY = 0.0f;
        // 图片
        CGFloat imageX = ScreenWidth - paddingLeft - imageW;
      
        CGFloat imageH = 76 * imageW / 114;

        // 关键字
        CGFloat keywordX = paddingLeft;
        CGFloat keywordW = [keyword sizeWithFont:[UIFont systemFontOfSize:keywordFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + keywordPaddingHorizontal;
        CGFloat keywordH = [keyword sizeWithFont:[UIFont systemFontOfSize:keywordFontSize] maxSize:CGSizeMake(keywordW, MAXFLOAT)].height + keywordPadddingVertical;
        
        CGFloat keywordPaddingTop = 15;
        CGFloat keywordY = paddingTop;

        _singleImageKeywordFrame = CGRectMake(keywordX, keywordY, keywordW, keywordH);
  
        CGFloat imageY = CGRectGetMaxY(_singleImageKeywordFrame) + paddingTop;
        
        CGFloat sourceListViewX = 0;
        CGFloat sourceListViewY = 0;
        CGFloat sourceListViewW = paddingLeft + keywordW;
        CGFloat sourceListViewH = paddingTop + keywordH;
        _singleImageSourceListViewFrame = CGRectMake(sourceListViewX, sourceListViewY, sourceListViewW, sourceListViewH);
        
        // 比较图片和标题
        if (titleH > imageH) {
            titleY = imageY;
            
        } else {
            titleY = (imageH - titleH) / 2  + imageY;
            
        }
        _singleImageTitleLabelFrame = CGRectMake(titleX, titleY, titleW, titleH);
        
        // 图片高度
        _singleImageImageViewFrame = CGRectMake(imageX, imageY, imageW, imageH);
        
        // 来源
        CGFloat sourceSiteNameX = CGRectGetMaxX(_singleImageKeywordFrame) + 7;
        CGFloat sourceSiteNameY = 0;
        CGFloat sourceSiteNameW = [sourceSiteName sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
        CGFloat sourceSiteNameH = [sourceSiteName sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(sourceSiteNameW, MAXFLOAT)].height;
        _singleImageSourceLabelFrame = CGRectMake(sourceSiteNameX, sourceSiteNameY, sourceSiteNameW, sourceSiteNameH);
        
        // 分割线
        CGFloat singleImageSeperatorLineY = 0.0f;
        
        if (titleH > imageH) {
            singleImageSeperatorLineY = CGRectGetMaxY(_singleImageTitleLabelFrame) + keywordPaddingTop;
        } else {
            singleImageSeperatorLineY = CGRectGetMaxY(_singleImageImageViewFrame) + keywordPaddingTop;
        }
        
        _singleImageSeperatorLineFrame = CGRectMake(0, singleImageSeperatorLineY, ScreenWidth, seperatorH);
        _cellHeight = CGRectGetMaxY(_singleImageSeperatorLineFrame);
        
    } else if (card.cardImages.count >= 3) {
        
        // 关键字
        CGFloat keywordX = paddingLeft;
        CGFloat keywordY = paddingTop;
        CGFloat keywordW = [keyword sizeWithFont:[UIFont systemFontOfSize:keywordFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + keywordPaddingHorizontal;
        CGFloat keywordH = [keyword sizeWithFont:[UIFont systemFontOfSize:keywordFontSize] maxSize:CGSizeMake(keywordW, MAXFLOAT)].height + keywordPadddingVertical;
        _multipleImageKeywordFrame = CGRectMake(keywordX, keywordY, keywordW, keywordH);
        
        CGFloat sourceListViewX = 0;
        CGFloat sourceListViewY = 0;
        CGFloat sourceListViewW = paddingLeft + keywordW;
        CGFloat sourceListViewH = paddingTop + keywordH;
        _multipleImageSourceListFrame = CGRectMake(sourceListViewX, sourceListViewY, sourceListViewW, sourceListViewH);
        
        CGFloat titleX = paddingLeft;
        CGFloat titleW = ScreenWidth - paddingLeft * 2;
        CGFloat titleY = CGRectGetMaxY(_multipleImageKeywordFrame) + 15;
        
        NSMutableAttributedString *attrStr =  [title attributedStringWithFont:[UIFont systemFontOfSize:titleFontSize] lineSpacing:lineSpacing];
        CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        CGFloat titleH = rect.size.height;
        
        _multipleImageTitleLabelFrame = CGRectMake(titleX, titleY , titleW, titleH);
        
        CGFloat imageY =   CGRectGetMaxY(_multipleImageTitleLabelFrame) + 8;
        CGFloat imageW = (ScreenWidth - paddingLeft * 2 - 6) / 3 ;
        CGFloat imageH = 76 * imageW / 114;
        _multipleImageViewFrame = CGRectMake(paddingLeft, imageY, ScreenWidth - paddingLeft * 2, imageH);
        
        // 来源
        CGFloat sourceSiteNameX = CGRectGetMaxX(_multipleImageKeywordFrame) + 7;
        CGFloat sourceSiteNameY = 0;
        CGFloat sourceSiteNameW = [sourceSiteName sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
        CGFloat sourceSiteNameH = [sourceSiteName sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(sourceSiteNameW, MAXFLOAT)].height;
        _multipleImageSourceLabelFrame = CGRectMake(sourceSiteNameX, sourceSiteNameY, sourceSiteNameW, sourceSiteNameH);
        
        // 分割线
        CGFloat multipleImageSeperatorLineY = CGRectGetMaxY(_multipleImageViewFrame) + 15;
        _multipleImageSeperatorLineFrame = CGRectMake(0, multipleImageSeperatorLineY, ScreenWidth, seperatorH);
        
        _cellHeight = CGRectGetMaxY(_multipleImageSeperatorLineFrame);
    }
    
}

@end
