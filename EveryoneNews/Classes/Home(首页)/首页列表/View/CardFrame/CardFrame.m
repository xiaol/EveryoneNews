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
#import "NSString+LP.h"
#import "Card+Create.h"

@implementation CardFrame

- (instancetype)init {
    if (self = [super init]) {
        self.tipButtonHidden = YES;
    }
    return self;
}

- (void)setCard:(Card *)card tipButtonHidden:(BOOL)tipButtonHidden {
    _tipButtonHidden = tipButtonHidden;
    [self setCard:card];
}

- (void)setCard:(Card *)card {
    
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
    CGFloat lineSpacing = 4.0;
 
    // 删除按钮宽度和高度
    CGFloat deleteButtonW = 22;
    CGFloat deleteButtonH = 13;
    CGFloat commentLabelW = 50;
    CGFloat commentLabelPaddingRight = 10;
    
    CGFloat tipButtonX = 0;
    CGFloat tipButtonH = 30;
    CGFloat tipButtonY = 0;
    CGFloat tipButtonW = ScreenWidth;
    
    NSMutableAttributedString *htmlTitle = [Card titleHtmlString:card.title];
    NSString *sourceSiteName = card.sourceSiteName;
    _card = card;
    _cellHeight = 0.0f;
    
    CGFloat newsTypeAdditionWidth = 4;
    
    
    if (self.isTipButtonHidden) {
        tipButtonH = 0;
    } else {
        tipButtonH = 30;
    }
    // 无图
    if([card.type integerValue] == imageStyleZero) {
        CGFloat titlePaddingTop = 11;
        if (iPhone5) {
             titlePaddingTop = 11;
        } else if (iPhone6Plus) {
            titlePaddingTop = 10;
        } else if (iPhone6) {
            titlePaddingTop = 12;
        }
        
        _noImageTipButtonFrame = CGRectMake(tipButtonX, tipButtonY, tipButtonW, tipButtonH);
        
        
        CGFloat titleW = ScreenWidth - PaddingHorizontal * 2;
        CGFloat titleH = [htmlTitle tttAttributeLabel:titleW];
        
        _noImageLabelFrame = CGRectMake(PaddingHorizontal, CGRectGetMaxY(_noImageTipButtonFrame) + titlePaddingTop, titleW, titleH);
        
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
        
        if (!card.rtype || [card.rtype integerValue] == normalNewsType) {
            _noImageSourceLabelFrame = CGRectMake(PaddingHorizontal, sourceSiteNameY, titleW, sourceSiteNameH);
            
        } else {
            NSString *newsType = @"要闻";
            CGFloat newsTypeW = [newsType sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + newsTypeAdditionWidth;
            _noImageNewsTypeLabelFrame = CGRectMake(PaddingHorizontal, sourceSiteNameY, newsTypeW, sourceSiteNameH);
            CGFloat noImageSourceLabelFrameX = CGRectGetMaxX(_noImageNewsTypeLabelFrame) + 8;
            CGFloat noImageSourceLabelFrameW = titleW - noImageSourceLabelFrameX;
            _noImageSourceLabelFrame = CGRectMake(noImageSourceLabelFrameX, sourceSiteNameY, noImageSourceLabelFrameW, sourceSiteNameH);
        }
        if (iPhone6) {
            paddingBottom = 15.5f;
        }
        
        CGFloat noImageSeperatorLineY = CGRectGetMaxY(_noImageSourceLabelFrame) + paddingBottom;

        _noImageSeperatorLineFrame = CGRectMake(0, noImageSeperatorLineY, ScreenWidth, 0.5);
        
        CGFloat deleteButtonX = ScreenWidth - PaddingHorizontal - deleteButtonW;
        
        CGFloat deleteButtonPaddingTop = 0;
        
        if (iPhone6Plus) {
            deleteButtonPaddingTop = 0;
        } else if (iPhone5) {
            deleteButtonPaddingTop = 0;
        }
        
        CGFloat deleteButtonY = sourceSiteNameY + deleteButtonPaddingTop;
        _noImageDeleteButtonFrame = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
        
        _noImageCommentLabelFrame = CGRectMake(CGRectGetMinX(_noImageDeleteButtonFrame) - commentLabelW - commentLabelPaddingRight, sourceSiteNameY, commentLabelW, sourceSiteNameH);
    
        _cellHeight = CGRectGetMaxY(_noImageSeperatorLineFrame);
        
    } else if (([card.type integerValue]  == imageStyleOne) || ([card.type integerValue]  == imageStyleTwo)) {
    
        if (iPhone6Plus) {
             paddingVertical = 13;
        } else if (iPhone5) {
            paddingVertical = 13;
        } else if (iPhone6) {
            paddingVertical = 15;
        }

        
        _singleTipButtonFrame = CGRectMake(tipButtonX, tipButtonY, tipButtonW, tipButtonH);
        
        // 定义单张图片的宽度
        CGFloat imageW = (ScreenWidth - PaddingHorizontal * 2 - 6) / 3 ;

        // 单图标题
        CGFloat titleX = PaddingHorizontal;
        CGFloat titleW = ScreenWidth - imageW - PaddingHorizontal * 2 - 20;
        // 标题高度
        CGFloat titleH = [htmlTitle tttAttributeLabel:titleW];
        
        // 图片
        CGFloat imageX = ScreenWidth - PaddingHorizontal - imageW;
        CGFloat imageY =   CGRectGetMaxY(_singleTipButtonFrame) + paddingVertical;
        
        
        
        CGFloat imageH = 76 * imageW / 114;
        
        // 图片高度
        _singleImageImageViewFrame = CGRectMake(imageX, imageY, imageW, imageH);
        // 新闻来源高度
        CGFloat sourceSiteNameH = [sourceSiteName sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(titleW, MAXFLOAT)].height;
  

        CGFloat sourcePaddingTop1 = 10.0f;

        if (iPhone6Plus) {
            sourcePaddingTop1 = 20.0f;
        } else if (iPhone5) {
            sourcePaddingTop1 = 5.0f;
        } else if (iPhone6) {
            sourcePaddingTop1 = 16;
        }
        
        CGFloat titleY = 0.0f;
        // 判断图片和标题+来源高度
        if ((titleH - lineSpacing * 2 + sourceSiteNameH + sourcePaddingTop1 )> imageH) {
            titleY =  CGRectGetMaxY(_singleTipButtonFrame) + paddingVertical - lineSpacing;
            
        } else {
            titleY =  CGRectGetMaxY(_singleTipButtonFrame) + paddingVertical + (imageH - (titleH + lineSpacing  + sourceSiteNameH + sourcePaddingTop1)) / 2 ;

        }
        
        _singleImageTitleLabelFrame = CGRectMake(PaddingHorizontal, titleY, titleW, titleH);
         CGFloat sourceSiteNameY = CGRectGetMaxY(_singleImageTitleLabelFrame) + sourcePaddingTop1;

        NSString *newsType = @"要闻";
        CGFloat newsTypeW = [newsType sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + newsTypeAdditionWidth;
        
          if (!card.rtype || [card.rtype integerValue] == normalNewsType) {
             _singleImageSourceLabelFrame = CGRectMake(titleX, sourceSiteNameY, titleW, sourceSiteNameH);
          } else {
              _singleNewsTypeLabelFrame = CGRectMake(titleX, sourceSiteNameY, newsTypeW, sourceSiteNameH);
              CGFloat singleImageSourceLabelFrameX = CGRectGetMaxX(_singleNewsTypeLabelFrame) + 8;
              CGFloat singleImageSourceLabelFrameW = titleW - singleImageSourceLabelFrameX;
              _singleImageSourceLabelFrame = CGRectMake(singleImageSourceLabelFrameX, sourceSiteNameY, singleImageSourceLabelFrameW, sourceSiteNameH);
          }
        
        CGFloat singleImageSeperatorLineY = 0.f;
        CGFloat deleteButtonY = sourceSiteNameY ;
        
        if ( (titleH - lineSpacing * 2) + sourceSiteNameH + sourcePaddingTop1 > imageH) {
            CGFloat deleteButtonX = ScreenWidth - PaddingHorizontal - deleteButtonW;
            _singleImageDeleteButtonFrame = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
            singleImageSeperatorLineY = CGRectGetMaxY(_singleImageSourceLabelFrame) + paddingBottom;
            
        } else {
            CGFloat deleteButtonX = ScreenWidth - PaddingHorizontal - deleteButtonW - PaddingHorizontal - imageW;
            
            _singleImageDeleteButtonFrame = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
      
            singleImageSeperatorLineY = CGRectGetMaxY(_singleImageImageViewFrame)+ paddingBottom;
        
        }
        _singleImageSeperatorLineFrame = CGRectMake(0, singleImageSeperatorLineY, ScreenWidth, 0.5);
        
        
        _singelImageCommentLabelFrame = CGRectMake(CGRectGetMinX(_singleImageDeleteButtonFrame) - commentLabelW - commentLabelPaddingRight, sourceSiteNameY, commentLabelW, sourceSiteNameH);
        
        _cellHeight =  CGRectGetMaxY(_singleImageSeperatorLineFrame);
        
    } else if ([card.type integerValue] == imageStyleEleven || [card.type integerValue] == imageStyleTwelve || [card.type integerValue] == imageStyleThirteen) {
        if (iPhone5) {
            paddingVertical = 11;
        }
        
 
        _singleBigTipButtonFrame = CGRectMake(tipButtonX, tipButtonY, tipButtonW, tipButtonH);
        
        CGFloat titleW = ScreenWidth - PaddingHorizontal * 2;
        CGFloat titleH = [htmlTitle tttAttributeLabel:titleW];
        _singleBigImageTitleLabelFrame = CGRectMake(PaddingHorizontal,   CGRectGetMaxY(_singleBigTipButtonFrame) + paddingVertical, titleW, titleH);
        
        CGFloat imageY =   CGRectGetMaxY(_singleBigTipButtonFrame) + titleH + 8 + paddingVertical;
        
        // 定义单张图片的宽度
        CGFloat imageW = (ScreenWidth - PaddingHorizontal * 2) ;
        
        CGFloat imageH = 183 * imageW / 350;
        
        _singleBigImageImageViewFrame = CGRectMake(PaddingHorizontal, imageY, ScreenWidth - PaddingHorizontal * 2, imageH);
        
        CGFloat sourcePaddingTop = 4;
        
        if (iPhone5) {
            sourcePaddingTop = 4;
        } else if(iPhone6Plus){
            sourcePaddingTop = 5;
        } else if (iPhone6) {
            sourcePaddingTop = 6;
        }
        
        CGFloat sourceSiteNameY = CGRectGetMaxY(_singleBigImageImageViewFrame) + sourcePaddingTop;
        CGFloat sourceSiteNameH = [sourceSiteName sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(titleW, MAXFLOAT)].height;
        NSString *newsType = @"要闻";
        CGFloat newsTypeW = [newsType sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + newsTypeAdditionWidth;
          if (!card.rtype || [card.rtype integerValue] == normalNewsType) {
            _singleBigImageSourceLabelFrame = CGRectMake(PaddingHorizontal, sourceSiteNameY, titleW, sourceSiteNameH);
          } else {
            _singleBigImageNewsTyeLabelFrame = CGRectMake(PaddingHorizontal, sourceSiteNameY, newsTypeW, sourceSiteNameH);
              CGFloat singleImageSourceLabelFrameX = CGRectGetMaxX(_singleBigImageNewsTyeLabelFrame) + 8;
              CGFloat singleImageSourceLabelFrameW = titleW - singleImageSourceLabelFrameX;
            _singleBigImageSourceLabelFrame = CGRectMake(singleImageSourceLabelFrameX, sourceSiteNameY, singleImageSourceLabelFrameW, sourceSiteNameH);
          }
        
      
    
        CGFloat deleteButtonX = ScreenWidth - PaddingHorizontal - deleteButtonW;
        
        
        
        CGFloat deleteButtonY = sourceSiteNameY ;
        _singleBigImageDeleteButtonFrame = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
        _singelBigImageCommentLabelFrame = CGRectMake(CGRectGetMinX(_singleBigImageDeleteButtonFrame) - commentLabelW - commentLabelPaddingRight, sourceSiteNameY, commentLabelW, sourceSiteNameH);
        
        if (iPhone6) {
            paddingBottom = 15;
        }
        // 分割线
        CGFloat singleBigImageSeperatorLineY = CGRectGetMaxY(_singleBigImageSourceLabelFrame)+ paddingBottom;
        
        
        _singleBigImageSeperatorLineFrame = CGRectMake(0, singleBigImageSeperatorLineY, ScreenWidth, 0.5);
        
        _cellHeight = CGRectGetMaxY(_singleBigImageSeperatorLineFrame);
    }

    else if ([card.type integerValue] == imageStyleThree) {
        
        if (iPhone5) {
            paddingVertical = 11;
        }
        
        _mutipleTipButtonFrame = CGRectMake(tipButtonX, tipButtonY, tipButtonW, tipButtonH);
        
        CGFloat titleW = ScreenWidth - PaddingHorizontal * 2;
        CGFloat titleH = [htmlTitle tttAttributeLabel:titleW];
        _multipleImageTitleLabelFrame = CGRectMake(PaddingHorizontal,   CGRectGetMaxY(_mutipleTipButtonFrame) + paddingVertical, titleW, titleH);
        
        CGFloat imageY =   CGRectGetMaxY(_mutipleTipButtonFrame) + titleH + 8 + paddingVertical;
        
        // 定义单张图片的宽度
        CGFloat imageW = (ScreenWidth - PaddingHorizontal * 2 - 6) / 3 ;
        
        CGFloat imageH = 76 * imageW / 114;
        
        _multipleImageViewFrame = CGRectMake(PaddingHorizontal, imageY, ScreenWidth - PaddingHorizontal * 2, imageH);
        
        CGFloat sourcePaddingTop = 4;
        
        if (iPhone5) {
            sourcePaddingTop = 4;
        } else if(iPhone6Plus){
            sourcePaddingTop = 5;
        } else if (iPhone6) {
            sourcePaddingTop = 6;
        }
        
        CGFloat sourceSiteNameY = CGRectGetMaxY(_multipleImageViewFrame) + sourcePaddingTop;
        CGFloat sourceSiteNameH = [sourceSiteName sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(titleW, MAXFLOAT)].height;
      
     
        
        NSString *newsType = @"要闻";
        CGFloat newsTypeW = [newsType sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + newsTypeAdditionWidth;
        if (!card.rtype || [card.rtype integerValue] == normalNewsType) {
              _multipleImageSourceLabelFrame = CGRectMake(PaddingHorizontal, sourceSiteNameY, titleW, sourceSiteNameH);
        } else {
            _multipleImageNewsTypeLabelFrame = CGRectMake(PaddingHorizontal, sourceSiteNameY, newsTypeW, sourceSiteNameH);
            CGFloat multipleImageSourceLabelFrameX = CGRectGetMaxX(_multipleImageNewsTypeLabelFrame) + 8;
            CGFloat multipleImageSourceLabelFrameW = titleW - multipleImageSourceLabelFrameX;
            _multipleImageSourceLabelFrame = CGRectMake(multipleImageSourceLabelFrameX, sourceSiteNameY, multipleImageSourceLabelFrameW, sourceSiteNameH);
        }
    
        CGFloat deleteButtonX = ScreenWidth - PaddingHorizontal - deleteButtonW;
        CGFloat deleteButtonY = sourceSiteNameY ;
        _mutipleImageDeleteButtonFrame = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
        _mutipleImageCommentLabelFrame = CGRectMake(CGRectGetMinX(_mutipleImageDeleteButtonFrame) - commentLabelW - commentLabelPaddingRight, sourceSiteNameY, commentLabelW, sourceSiteNameH);
        
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
