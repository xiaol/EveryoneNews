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

//static const CGFloat PaddingHorizontal = 12;
//static const CGFloat PaddingVertical = 15;

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
    if (iPhone6Plus) {
        PaddingHorizontal = 15;
    } else if (iPhone5) {
        PaddingHorizontal = 10;
    }
    
    CGFloat sourceFontSize = 10;
    if (iPhone6) {
        sourceFontSize = 9;
    } else if (iPhone6Plus) {
        sourceFontSize = 10;
    }
    
    CGFloat paddingVertical = 11;
    if (iPhone6Plus) {
        paddingVertical = 10;
    }
    
    self.homeViewFontSize = [LPFontSizeManager sharedManager].currentHomeViewFontSize;
    CGFloat titleFontSize =  self.homeViewFontSize;

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
    
    NSString *title = card.title;
    NSString *sourceSiteName = card.sourceSiteName;
    _card = card;
    _cellHeight = 0.0f;
    
    if (self.isTipButtonHidden) {
        tipButtonH = 0;
    } else {
        tipButtonH = 30;
    }
    // 无图
    if(card.cardImages.count == 0) {
        CGFloat titlePaddingTop = 11;
        if (iPhone5) {
             titlePaddingTop = 11;
        } else if (iPhone6Plus) {
            titlePaddingTop = 10;
        }
        
        
        
        
//        if (iPhone5) {
//            paddingVertical = 11;
//        }
//   
        _noImageTipButtonFrame = CGRectMake(tipButtonX, tipButtonY, tipButtonW, tipButtonH);
        
        
        CGFloat titleW = ScreenWidth - PaddingHorizontal * 2;

        NSMutableAttributedString *attrStr =  [title attributedStringWithFont:[UIFont systemFontOfSize:titleFontSize] lineSpacing:lineSpacing];
        CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        CGFloat titleH = rect.size.height;
        
        _noImageLabelFrame = CGRectMake(PaddingHorizontal, CGRectGetMaxY(_noImageTipButtonFrame) + titlePaddingTop, titleW, titleH);
        
        CGFloat sourceSiteNameH = [sourceSiteName sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(titleW, MAXFLOAT)].height;
        
        CGFloat sourcePaddingTop = 10;
        
        if (iPhone6Plus) {
            sourcePaddingTop = 11;
        } else if (iPhone5) {
            sourcePaddingTop = 10;
        }
        
        CGFloat sourceSiteNameY = CGRectGetMaxY(_noImageLabelFrame) + sourcePaddingTop;
        
        _noImageSourceLabelFrame = CGRectMake(PaddingHorizontal, sourceSiteNameY, titleW, sourceSiteNameH);
        
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
        
    } else if (card.cardImages.count == 1 || card.cardImages.count == 2) {
    
        if (iPhone6Plus) {
             paddingVertical = 13;
        } else if (iPhone5) {
            paddingVertical = 13;
        }
        
//        CGFloat titlePaddingTop = 11;
//        if (iPhone5) {
//            titlePaddingTop = 9.5f;
//        } else if (iPhone6Plus) {
//            titlePaddingTop = 13;
//        }
        
        _singleTipButtonFrame = CGRectMake(tipButtonX, tipButtonY, tipButtonW, tipButtonH);
        
        // 定义单张图片的宽度
        CGFloat imageW = (ScreenWidth - PaddingHorizontal * 2 - 6) / 3 ;

        // 单图标题
        CGFloat titleX = PaddingHorizontal;
        CGFloat titleW = ScreenWidth - imageW - PaddingHorizontal * 2 - 20;
        // 标题高度
        
        NSMutableAttributedString *attrStr =  [title attributedStringWithFont:[UIFont systemFontOfSize:titleFontSize] lineSpacing:lineSpacing];
        CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        CGFloat titleH = rect.size.height;
        
        // 图片
        CGFloat imageX = ScreenWidth - PaddingHorizontal - imageW;
        CGFloat imageY =   CGRectGetMaxY(_singleTipButtonFrame) + paddingVertical;
        CGFloat imageH = 76 * imageW / 114;
        
        // 图片高度
        _singleImageImageViewFrame = CGRectMake(imageX, imageY, imageW, imageH);
        // 新闻来源高度
        CGFloat sourceSiteNameH = [sourceSiteName sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(titleW, MAXFLOAT)].height;
        
        // 判断图片和标题+来源高度
        CGFloat sourcePaddingTop1 = 10.0f;
        CGFloat titlePaddingTop = 6;
        
        if (iPhone5) {
            titlePaddingTop = 6;
        } else if (iPhone6Plus) {
            titlePaddingTop = 9;
        }
        
        if (iPhone6Plus) {
            sourcePaddingTop1 = 20.0f;
        } else if (iPhone5) {
            sourcePaddingTop1 = 10.0f;
        }
        
        CGFloat titleY = 0.0f;
        CGFloat sourceSiteNameY = 0.0f;
        if (titleH + sourceSiteNameH + sourcePaddingTop1 > imageH) {
            
            if (iPhone6Plus) {
                sourcePaddingTop1 = 18;
            } else if (iPhone5) {
                sourcePaddingTop1 = 10;
            }
            
            titleY =  CGRectGetMaxY(_singleTipButtonFrame) + titlePaddingTop;
            
            
        } else {
            titleY = (imageH - (titleH + sourceSiteNameH + sourcePaddingTop1) ) / 2 +  CGRectGetMaxY(_singleTipButtonFrame)  + paddingVertical;
        }
        
        _singleImageTitleLabelFrame = CGRectMake(titleX, titleY, titleW, titleH);
        
        sourceSiteNameY = CGRectGetMaxY(_singleImageTitleLabelFrame) + sourcePaddingTop1;
        
        _singleImageSourceLabelFrame = CGRectMake(titleX, sourceSiteNameY, titleW, sourceSiteNameH);
        
        CGFloat singleImageSeperatorLineY = 0.f;
        
        CGFloat deleteButtonPaddingTop = 0;
        
        if (iPhone6Plus) {
            deleteButtonPaddingTop = 0;
        } else if (iPhone5) {
            deleteButtonPaddingTop = 0;
        }
        
        CGFloat deleteButtonY = sourceSiteNameY + deleteButtonPaddingTop;
        if ( titleH + sourceSiteNameH  > imageH) {
            CGFloat deleteButtonX = ScreenWidth - PaddingHorizontal - deleteButtonW;
            _singleImageDeleteButtonFrame = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
            
            singleImageSeperatorLineY = CGRectGetMaxY(_singleImageSourceLabelFrame) + paddingBottom;
        } else {
            CGFloat deleteButtonX = ScreenWidth - PaddingHorizontal - deleteButtonW - 13 - imageW;
            
            _singleImageDeleteButtonFrame = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
            singleImageSeperatorLineY = CGRectGetMaxY(_singleImageImageViewFrame)+ paddingBottom;
          
        }
        _singleImageSeperatorLineFrame = CGRectMake(0, singleImageSeperatorLineY, ScreenWidth, 0.5);
        
        
        _singelImageCommentLabelFrame = CGRectMake(CGRectGetMinX(_singleImageDeleteButtonFrame) - commentLabelW - commentLabelPaddingRight, sourceSiteNameY, commentLabelW, sourceSiteNameH);
        
        _cellHeight =  CGRectGetMaxY(_singleImageSeperatorLineFrame);
        
    } else if (card.cardImages.count >= 3) {
        
        if (iPhone5) {
            paddingVertical = 11;
        }
        
        _mutipleTipButtonFrame = CGRectMake(tipButtonX, tipButtonY, tipButtonW, tipButtonH);
        
        CGFloat titleW = ScreenWidth - PaddingHorizontal * 2;
        NSMutableAttributedString *attrStr =  [title attributedStringWithFont:[UIFont systemFontOfSize:titleFontSize] lineSpacing:lineSpacing];
        CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        CGFloat titleH = rect.size.height;
        _multipleImageTitleLabelFrame = CGRectMake(PaddingHorizontal,   CGRectGetMaxY(_mutipleTipButtonFrame) + paddingVertical, titleW, titleH);
        
        CGFloat imageY =   CGRectGetMaxY(_mutipleTipButtonFrame) + titleH + 3 + paddingVertical;
        
        // 定义单张图片的宽度
        CGFloat imageW = (ScreenWidth - PaddingHorizontal * 2 - 6) / 3 ;
        
        CGFloat imageH = 76 * imageW / 114;
        
        _multipleImageViewFrame = CGRectMake(PaddingHorizontal, imageY, titleW, imageH);
        
        CGFloat sourcePaddingTop = 4;
        
        if (iPhone5) {
            sourcePaddingTop = 4;
        } else if(iPhone6Plus){
            sourcePaddingTop = 5;
        }
        
        CGFloat sourceSiteNameY = CGRectGetMaxY(_multipleImageViewFrame) + sourcePaddingTop;
        CGFloat sourceSiteNameH = [sourceSiteName sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(titleW, MAXFLOAT)].height;
        _multipleImageSourceLabelFrame = CGRectMake(PaddingHorizontal, sourceSiteNameY, titleW, sourceSiteNameH);
     
        
        CGFloat deleteButtonX = ScreenWidth - PaddingHorizontal - deleteButtonW;
        
        CGFloat deleteButtonPaddingTop = 0;
        
        if (iPhone6Plus) {
            deleteButtonPaddingTop = 0;
        } else if (iPhone5) {
            deleteButtonPaddingTop = 0;
        }
        
        CGFloat deleteButtonY = sourceSiteNameY + deleteButtonPaddingTop;
        _mutipleImageDeleteButtonFrame = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
        
        
        _mutipleImageCommentLabelFrame = CGRectMake(CGRectGetMinX(_mutipleImageDeleteButtonFrame) - commentLabelW - commentLabelPaddingRight, sourceSiteNameY, commentLabelW, sourceSiteNameH);
        // 分割线
         CGFloat mutipleImageSeperatorLineY = CGRectGetMaxY(_multipleImageSourceLabelFrame)+ paddingBottom;
        _mutipleImageSeperatorLineFrame = CGRectMake(0, mutipleImageSeperatorLineY, ScreenWidth, 0.5);
        
        _cellHeight = CGRectGetMaxY(_mutipleImageSeperatorLineFrame);
    }
}



@end
