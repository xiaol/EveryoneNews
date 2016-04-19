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

static const CGFloat PaddingHorizontal = 12;
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
    self.homeViewFontSize = [LPFontSizeManager sharedManager].currentHomeViewFontSize;
    CGFloat titleFontSize =  self.homeViewFontSize;
    CGFloat sourceFontSize = 10;
    CGFloat paddingVertical = 15;
//    CGFloat imageH = 75;
    
    CGFloat lineSpacing = 4.0;
    
    
    if (iPhone6) {
        sourceFontSize = 12;
    } else if (iPhone6Plus) {
        sourceFontSize = 13;
//        imageH = 90;
    }
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
   
        _noImageTipButtonFrame = CGRectMake(tipButtonX, tipButtonY, tipButtonW, tipButtonH);
        
        
        CGFloat titleW = ScreenWidth - PaddingHorizontal * 2;
//        CGFloat titleH = [title sizeWithFont:[UIFont systemFontOfSize:titleFontSize] maxSize:CGSizeMake(titleW, MAXFLOAT)].height;

        NSMutableAttributedString *attrStr =  [title attributedStringWithFont:[UIFont systemFontOfSize:titleFontSize] lineSpacing:lineSpacing];
        CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        CGFloat titleH = rect.size.height;
        
        _noImageLabelFrame = CGRectMake(PaddingHorizontal, CGRectGetMaxY(_noImageTipButtonFrame) + paddingVertical, titleW, titleH);
        
        CGFloat sourceSiteNameH = [sourceSiteName sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(titleW, MAXFLOAT)].height;
        CGFloat sourceSiteNameY = CGRectGetMaxY(_noImageLabelFrame) + 14;
        
        _noImageSourceLabelFrame = CGRectMake(PaddingHorizontal, sourceSiteNameY, titleW, sourceSiteNameH);
        
        CGFloat noImageSeperatorLineY = CGRectGetMaxY(_noImageSourceLabelFrame) + paddingVertical;
        
        _noImageSeperatorLineFrame = CGRectMake(0, noImageSeperatorLineY, ScreenWidth, 0.5);
        
        CGFloat deleteButtonX = ScreenWidth - PaddingHorizontal - deleteButtonW;
        CGFloat deleteButtonY = sourceSiteNameY;
        _noImageDeleteButtonFrame = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
        
        _noImageCommentLabelFrame = CGRectMake(CGRectGetMinX(_noImageDeleteButtonFrame) - commentLabelW - commentLabelPaddingRight, deleteButtonY, commentLabelW, sourceSiteNameH);
    
        _cellHeight = CGRectGetMaxY(_noImageSeperatorLineFrame);
        
    } else if (card.cardImages.count == 1 || card.cardImages.count == 2) {
        _singleTipButtonFrame = CGRectMake(tipButtonX, tipButtonY, tipButtonW, tipButtonH);
        
        // 定义单张图片的宽度
        CGFloat imageW = (ScreenWidth - PaddingHorizontal * 2 - 6) / 3 ;

        // 单图标题
        CGFloat titleX = PaddingHorizontal;
        CGFloat titleY =   CGRectGetMaxY(_singleTipButtonFrame) + paddingVertical;
        CGFloat titleW = ScreenWidth - imageW - PaddingHorizontal * 2 - 20;
        // 标题高度
//        CGFloat titleH = [title sizeWithFont:[UIFont systemFontOfSize:titleFontSize] maxSize:CGSizeMake(titleW, MAXFLOAT)].height;
        
        NSMutableAttributedString *attrStr =  [title attributedStringWithFont:[UIFont systemFontOfSize:titleFontSize] lineSpacing:lineSpacing];
        CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        CGFloat titleH = rect.size.height;
        
        _singleImageTitleLabelFrame = CGRectMake(titleX, titleY, titleW, titleH);
        
        
        // 图片
        CGFloat imageX = ScreenWidth - PaddingHorizontal - imageW;
        CGFloat imageY =   CGRectGetMaxY(_singleTipButtonFrame) + paddingVertical;
        CGFloat imageH = 77 * imageW / 114;
        
        
        // 图片高度
        _singleImageImageViewFrame = CGRectMake(imageX, imageY, imageW, imageH);
        // 新闻来源高度
        CGFloat sourceSiteNameH = [sourceSiteName sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(titleW, MAXFLOAT)].height;
    
        
        CGFloat sourceSiteNameY = 0.0;
        
    
        if (titleH + sourceSiteNameH  > imageH) {
            sourceSiteNameY = CGRectGetMaxY(_singleImageTitleLabelFrame) + 10;
        } else {
            sourceSiteNameY = CGRectGetMaxY(_singleImageImageViewFrame) - sourceSiteNameH;
        }
        
        _singleImageSourceLabelFrame = CGRectMake(titleX, sourceSiteNameY, titleW, sourceSiteNameH);
        
        CGFloat singleImageSeperatorLineY = 0.f;
        CGFloat deleteButtonY = sourceSiteNameY;
        if ( titleH + sourceSiteNameH  > imageH) {
            CGFloat deleteButtonX = ScreenWidth - PaddingHorizontal - deleteButtonW;
            _singleImageDeleteButtonFrame = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
            
            singleImageSeperatorLineY = CGRectGetMaxY(_singleImageSourceLabelFrame) + paddingVertical;
        } else {
            CGFloat deleteButtonX = ScreenWidth - PaddingHorizontal - deleteButtonW - 13 - imageW;
            
            _singleImageDeleteButtonFrame = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
            singleImageSeperatorLineY = CGRectGetMaxY(_singleImageImageViewFrame)+ paddingVertical;
          
        }
        _singleImageSeperatorLineFrame = CGRectMake(0, singleImageSeperatorLineY, ScreenWidth, 0.5);
        
        
        _singelImageCommentLabelFrame = CGRectMake(CGRectGetMinX(_singleImageDeleteButtonFrame) - commentLabelW - commentLabelPaddingRight, deleteButtonY, commentLabelW, sourceSiteNameH);
        
        _cellHeight =  CGRectGetMaxY(_singleImageSeperatorLineFrame);
        
    } else if (card.cardImages.count >= 3) {
        _mutipleTipButtonFrame = CGRectMake(tipButtonX, tipButtonY, tipButtonW, tipButtonH);
        
        
        CGFloat titleW = ScreenWidth - PaddingHorizontal * 2;
//        CGFloat titleH = [title sizeWithFont:[UIFont systemFontOfSize:titleFontSize] maxSize:CGSizeMake(titleW, MAXFLOAT)].height;
        
        
        NSMutableAttributedString *attrStr =  [title attributedStringWithFont:[UIFont systemFontOfSize:titleFontSize] lineSpacing:lineSpacing];
        CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        CGFloat titleH = rect.size.height;
        _multipleImageTitleLabelFrame = CGRectMake(PaddingHorizontal,   CGRectGetMaxY(_mutipleTipButtonFrame) + paddingVertical, titleW, titleH);
        
        CGFloat imageY =   CGRectGetMaxY(_mutipleTipButtonFrame) + titleH + 8 + paddingVertical;
        
        // 定义单张图片的宽度
        CGFloat imageW = (ScreenWidth - PaddingHorizontal * 2 - 6) / 3 ;
        
        CGFloat imageH = 77 * imageW / 114;
        
        _multipleImageViewFrame = CGRectMake(PaddingHorizontal, imageY, titleW, imageH);
        
        CGFloat sourceSiteNameY = CGRectGetMaxY(_multipleImageViewFrame) + 6;
        CGFloat sourceSiteNameH = [sourceSiteName sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(titleW, MAXFLOAT)].height;
        _multipleImageSourceLabelFrame = CGRectMake(PaddingHorizontal, sourceSiteNameY, titleW, sourceSiteNameH);
     
        
        CGFloat deleteButtonX = ScreenWidth - PaddingHorizontal - deleteButtonW;
        CGFloat deleteButtonY = sourceSiteNameY;
        _mutipleImageDeleteButtonFrame = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
        
        
        _mutipleImageCommentLabelFrame = CGRectMake(CGRectGetMinX(_mutipleImageDeleteButtonFrame) - commentLabelW - commentLabelPaddingRight, deleteButtonY, commentLabelW, sourceSiteNameH);
        // 分割线
         CGFloat mutipleImageSeperatorLineY = CGRectGetMaxY(_multipleImageSourceLabelFrame)+ paddingVertical;
        _mutipleImageSeperatorLineFrame = CGRectMake(0, mutipleImageSeperatorLineY, ScreenWidth, 0.5);
        
        _cellHeight = CGRectGetMaxY(_mutipleImageSeperatorLineFrame);
    }
}



@end
