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
#import "LPFontSize.h"
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
    
    _card = card;
    self.homeViewFontSize = [LPFontSizeManager sharedManager].lpFontSize.currentHomeViewFontSize;
    self.fontSizeType =  [LPFontSizeManager sharedManager].lpFontSize.fontSizeType;
    NSString *sourceSiteName = card.sourceSiteName;
    NSString *title = card.title;
    NSInteger rtype = [card.rtype intValue];
    // 评论数量
    NSInteger commentsCount = [card.commentsCount intValue];
    NSString *commentStr = @"";
    // 标题字体大小
    CGFloat titleFontSize =  self.homeViewFontSize;
    // 来源字体大小
    CGFloat sourceFontSize = 13;

    // 评论字体大小
    CGFloat commentsFontSize = 13;
    
    CGFloat paddingLeft = 12;
    CGFloat paddingTop = 14;
    CGFloat paddingBottom = 10;
    CGFloat deleteButtonPaddingTop = 10;
    CGFloat seperatorH = 4;
    CGFloat lineSpacing = 2.0;
    
    // 上次刷新位置
    CGFloat tipButtonX = 0;
    CGFloat tipButtonH = 0;
    CGFloat tipButtonY = 0;
    CGFloat tipButtonW = ScreenWidth;
    if (self.isTipButtonHidden) {
        tipButtonH = 0;
    } else {
        tipButtonH = 30;
    }
    CGFloat sourcePaddingLeft = 10;
    switch (rtype) {
        case hotNewsType:case pushNewsType:case adNewsType:
            title = [NSString stringWithFormat:@"占位%@", title];
            break;
        default:
            break;
    }
    CGFloat commentsX = paddingLeft;
    CGFloat commentsY = 0.0f;
    CGFloat commentsW = 0.0f;
    CGFloat commentsH = 0.0f;
    if (commentsCount > 0) {
        commentStr = [NSString stringWithFormat:@"%d评", commentsCount];
        commentsH = [commentStr sizeWithFont:[UIFont systemFontOfSize:commentsFontSize] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
        commentsW = [commentStr sizeWithFont:[UIFont systemFontOfSize:commentsFontSize] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
    }

    CGFloat sourceImageViewW = 32;
    CGFloat sourceImageViewH = 32;
    CGFloat sourceImageViewY = paddingTop + tipButtonH;
    
    CGFloat sourceImageListViewX = 0;
    CGFloat sourceImageListViewY = tipButtonH;
    CGFloat sourceImageListViewH = sourceImageViewH + paddingTop;
    
    CGFloat sourceH = [sourceSiteName sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
    CGFloat sourceW = [sourceSiteName sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
    
    if (sourceW > 100) {
        sourceW = 100;
    }
    CGFloat sourceY = sourceImageViewY + (sourceImageViewH - sourceH) / 2.0f;
    
    // 删除按钮宽度和高度
    CGFloat deleteButtonW = 12;
    CGFloat deleteButtonH = 12;
    CGFloat deleteButtonX = ScreenWidth - deleteButtonW - paddingLeft;
    CGFloat deleteButtonY = 0.0f;
    
    NSMutableAttributedString *rtypeAttrStr =  [@"占位" attributedStringWithFont:[UIFont systemFontOfSize:titleFontSize] lineSpacing:lineSpacing];
    CGRect rtypeRect = [rtypeAttrStr boundingRectWithSize:CGSizeMake(ScreenWidth, ScreenHeight) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    CGFloat rtypeH = rtypeRect.size.height - 6;
    CGFloat rtypeW = rtypeRect.size.width;
    CGFloat rtypeGap = 2.0f;
    
    _cellHeight = 0.0f;
    
    // 专题
    if (rtype == 4) {
        _specialTopicTipButtonFrame = CGRectMake(tipButtonX, tipButtonY, tipButtonW, tipButtonH);
        CGFloat specialTopicInsideViewY = 16 - seperatorH;
        CGFloat specialTopicLogoY = paddingTop;
        CGFloat specialTopicLogoX = 0;
        CGFloat specialTopicLogoW = 83;
        CGFloat specialTopicLogoH = 26;
        
        _specialTopicLogoFrame = CGRectMake(specialTopicLogoX, specialTopicLogoY, specialTopicLogoW, specialTopicLogoH);
        CGFloat titleW = ScreenWidth - paddingLeft * 4;
        NSMutableAttributedString *attrStr =  [title attributedStringWithFont:[UIFont systemFontOfSize:titleFontSize] lineSpacing:lineSpacing];
        CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        CGFloat titleH = rect.size.height;
        CGFloat titleX = paddingLeft;
        CGFloat titleY = paddingTop + CGRectGetMaxY(_specialTopicLogoFrame);
        _specialTopicTitleLabelFrame = CGRectMake(titleX, titleY, titleW, titleH);
        
        CGFloat specialTopicImageX = paddingLeft;
        CGFloat specialTopicImageW = ScreenWidth - paddingLeft * 4;
        CGFloat specialTopicImageH = 80 * specialTopicImageW / 327;
        CGFloat specialTopicImageY = CGRectGetMaxY(_specialTopicTitleLabelFrame) + paddingTop;
        _specialTopicImageViewFrame = CGRectMake(specialTopicImageX, specialTopicImageY, specialTopicImageW, specialTopicImageH);
        
        CGFloat specailTopicNewsTypeX = paddingLeft;
        CGFloat specialTopicNewsTypeY = CGRectGetMaxY(_specialTopicTitleLabelFrame) + paddingTop;
        _specialTopicNewsTypeLabelFrame = CGRectMake(specailTopicNewsTypeX, specialTopicNewsTypeY, rtypeW, rtypeH);
        
        deleteButtonX = ScreenWidth - deleteButtonW - paddingLeft * 3;
        deleteButtonY = CGRectGetMaxY(_specialTopicImageViewFrame) + deleteButtonPaddingTop;
        
        commentsX = CGRectGetMaxX(_specialTopicNewsTypeLabelFrame) + paddingLeft;
        commentsY = deleteButtonY;
        _specialTopicCommentsCountLabelFrame = CGRectMake(commentsX, commentsY, commentsW, commentsH);
        _specialTopicDeleteButtonFrame = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
        
        CGFloat specialTopicInsideViewH = CGRectGetMaxY(_specialTopicDeleteButtonFrame) + paddingBottom;
        CGFloat specialTopicInsideViewX = paddingLeft;
        CGFloat specialTopicInsideViewW = ScreenWidth - paddingLeft * 2;
        _specialTopicInsideViewFrame = CGRectMake(specialTopicInsideViewX, specialTopicInsideViewY, specialTopicInsideViewW, specialTopicInsideViewH);
        
        CGFloat specialTopicOutsideViewH = CGRectGetMaxY(_specialTopicInsideViewFrame) + 16;
        CGFloat specialTopicOutsideViewY = CGRectGetMaxY(_specialTopicTipButtonFrame);
        _specialTopicOutsideViewFrame = CGRectMake(0, specialTopicOutsideViewY, ScreenWidth, specialTopicOutsideViewH);
        
        _cellHeight = CGRectGetMaxY(_specialTopicOutsideViewFrame);
        
    } else {
        // 无图
        if([card.type integerValue] == imageStyleZero) {
            
            _noImageTipButtonFrame = CGRectMake(tipButtonX, tipButtonY, tipButtonW, tipButtonH);
            
            _noImageSourceImageViewFrame = CGRectMake(paddingLeft, sourceImageViewY, sourceImageViewW, sourceImageViewH);
            
            CGFloat sourceX = CGRectGetMaxX(_noImageSourceImageViewFrame) + sourcePaddingLeft;
            _noImageSourceLabelFrame = CGRectMake(sourceX, sourceY, sourceW, sourceH);
            
            _noImageSourceListViewFrame = CGRectMake(sourceImageListViewX, sourceImageListViewY, CGRectGetMaxX(_noImageSourceLabelFrame), sourceImageListViewH);
            CGFloat titleW = ScreenWidth - paddingLeft * 2;
            NSMutableAttributedString *attrStr =  [title attributedStringWithFont:[UIFont systemFontOfSize:titleFontSize] lineSpacing:lineSpacing];
            CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
            CGFloat titleH = rect.size.height;
            CGFloat titleX = paddingLeft;
            CGFloat titleY = paddingTop + CGRectGetMaxY(_noImageSourceImageViewFrame);
            _noImageTitleLabelFrame = CGRectMake(titleX, titleY, titleW, titleH);
        
            switch (rtype) {
                case hotNewsType:case pushNewsType:case adNewsType:
                    _noImageNewsTypeLabelFrame = CGRectMake(titleX, titleY + rtypeGap, rtypeW, rtypeH);
                    break;
                default:
                    break;
            }
            deleteButtonY = CGRectGetMaxY(_noImageTitleLabelFrame) + deleteButtonPaddingTop;
            commentsY = deleteButtonY;
            
            _noImageCommentsCountLabelFrame = CGRectMake(commentsX, commentsY, commentsW, commentsH);
            
            _noImageDeleteButtonFrame = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
            CGFloat noImageSeperatorLineFrameY = CGRectGetMaxY(_noImageDeleteButtonFrame) + paddingBottom;

            _noImageSeperatorLineFrame = CGRectMake(0, noImageSeperatorLineFrameY, ScreenWidth, seperatorH);
            _cellHeight = CGRectGetMaxY(_noImageSeperatorLineFrame);
            
        } else if (([card.type integerValue]  == imageStyleOne) || ([card.type integerValue]  == imageStyleTwo)) {
            
            _singleImageTipButtonFrame = CGRectMake(tipButtonX, tipButtonY, tipButtonW, tipButtonH);
            
            // 广告位隐藏来源
            if ([card.rtype integerValue]  == 3) {
                sourceImageViewY = 0;
                sourceImageViewH = 0;
                sourceH = 0;
            }
            
            _singleImageSourceImageViewFrame = CGRectMake(paddingLeft, sourceImageViewY, sourceImageViewW, sourceImageViewH);
            
            CGFloat sourceX = CGRectGetMaxX(_singleImageSourceImageViewFrame) + sourcePaddingLeft;
            _singleImageSourceLabelFrame = CGRectMake(sourceX, sourceY, sourceW, sourceH);
            
            _singleImageSourceListViewFrame = CGRectMake(sourceImageListViewX, sourceImageListViewY, CGRectGetMaxX(_singleImageSourceLabelFrame), sourceImageListViewH);
            
            _singleImageDeleteButtonFrame = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
            
            // 定义单张图片的宽度
            CGFloat imageW = (ScreenWidth - paddingLeft * 2 - 6) / 3 ;
            CGFloat imageH = 76 * imageW / 114;
            CGFloat imageX = ScreenWidth - paddingLeft - imageW;
            CGFloat imageY =   CGRectGetMaxY(_singleImageSourceImageViewFrame) + paddingTop;
            
            if ([card.rtype integerValue]  == 3) {
                imageY = paddingTop + tipButtonH;
            }
            
            _singleImageImageViewFrame = CGRectMake(imageX, imageY, imageW, imageH);
            
            // 单图标题
            CGFloat titleX = paddingLeft;
            CGFloat titleW = ScreenWidth - imageW - paddingLeft * 2 - 30;
            
            // 计算单行文字高度
            NSMutableAttributedString *singleLineAttrStr =  [@"单行文本" attributedStringWithFont:[UIFont systemFontOfSize:titleFontSize] lineSpacing:lineSpacing];
            CGRect singleLineRect = [singleLineAttrStr boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
            CGFloat singleTitleH = singleLineRect.size.height;
            
            // 标题高度
            NSMutableAttributedString *attrStr =  [title attributedStringWithFont:[UIFont systemFontOfSize:titleFontSize] lineSpacing:lineSpacing];
            CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
            CGFloat titleH = rect.size.height;
            
            if (titleH > 3 * singleTitleH) {
                titleH = 3 * singleTitleH;
            }
            
            CGFloat titleY = 0.0f;
            CGFloat singleImageSeperatorLineY = 0.0f;
            // 比较图片和标题高度
            if ((titleH - lineSpacing * 2 + deleteButtonH + paddingTop) > imageH) {
                titleY =  imageY - lineSpacing;
                CGFloat maxHeight = MAX(titleH, imageH);
                deleteButtonY = titleY + maxHeight + deleteButtonPaddingTop;

            } else {
                titleY =  imageY + (imageH - (titleH + lineSpacing  + deleteButtonH + paddingTop)) / 2;
                deleteButtonX = titleW + paddingLeft - deleteButtonW;
                deleteButtonY = titleY + titleH + deleteButtonPaddingTop;
  
            }
            _singleImageTitleLabelFrame = CGRectMake(titleX, titleY, titleW, titleH);
            commentsY = deleteButtonY;
            
            _singleImageCommentsCountLabelFrame = CGRectMake(commentsX, commentsY, commentsW, commentsH);
            _singleImageDeleteButtonFrame = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
            
            singleImageSeperatorLineY = MAX(CGRectGetMaxY(_singleImageDeleteButtonFrame), CGRectGetMaxY(_singleImageImageViewFrame))  + paddingBottom;
            
            switch (rtype) {
                case hotNewsType:case pushNewsType:case adNewsType:
                    _singleImageNewsTypeLabelFrame = CGRectMake(titleX, titleY + rtypeGap, rtypeW, rtypeH);
                    break;
                default:
                    break;
            }
            _singleImageSeperatorLineFrame = CGRectMake(0, singleImageSeperatorLineY, ScreenWidth, seperatorH);
            _cellHeight =  CGRectGetMaxY(_singleImageSeperatorLineFrame);
            
        } else if ([card.type integerValue] == imageStyleEleven || [card.type integerValue] == imageStyleTwelve || [card.type integerValue] == imageStyleThirteen) {
            
            _singleBigImageTipButtonFrame = CGRectMake(tipButtonX, tipButtonY, tipButtonW, tipButtonH);
            _singleBigImageSourceImageViewFrame = CGRectMake(paddingLeft, sourceImageViewY, sourceImageViewW, sourceImageViewH);
            
            CGFloat sourceX = CGRectGetMaxX(_singleBigImageSourceImageViewFrame) + sourcePaddingLeft;
            _singleBigImageSourceLabelFrame = CGRectMake(sourceX, sourceY, sourceW, sourceH);

            _singleBigImageSourceListViewFrame = CGRectMake(sourceImageListViewX, sourceImageListViewY, CGRectGetMaxX(_singleBigImageSourceLabelFrame), sourceImageListViewH);
            CGFloat titleX = paddingLeft;
            CGFloat titleY = CGRectGetMaxY(_singleBigImageSourceImageViewFrame) + paddingTop;
            CGFloat titleW = ScreenWidth - paddingLeft * 2;
            NSMutableAttributedString *attrStr =  [title attributedStringWithFont:[UIFont systemFontOfSize:titleFontSize] lineSpacing:lineSpacing];
            CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
            CGFloat titleH = rect.size.height;
            _singleBigImageTitleLabelFrame = CGRectMake(titleX, titleY, titleW, titleH);
            
            CGFloat imageY =   CGRectGetMaxY(_singleBigImageTitleLabelFrame) + paddingTop;
            
            // 定义单张图片的宽度
            CGFloat imageW = (ScreenWidth - paddingLeft * 2) ;
            
            CGFloat imageH = 183 * imageW / 350;
            
            _singleBigImageImageViewFrame = CGRectMake(paddingLeft, imageY, imageW, imageH);
            
            deleteButtonY = CGRectGetMaxY(_singleBigImageImageViewFrame) + deleteButtonPaddingTop;
            commentsY = deleteButtonY;
            _singleBigImageCommentsCountLabelFrame = CGRectMake(commentsX, commentsY, commentsW, commentsH);
            _singleBigImageDeleteButtonFrame = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
            // 分割线
            CGFloat singleBigImageSeperatorLineY = CGRectGetMaxY(_singleBigImageDeleteButtonFrame) + paddingBottom;
            _singleBigImageSeperatorLineFrame = CGRectMake(0, singleBigImageSeperatorLineY, ScreenWidth, seperatorH);
            
            switch (rtype) {
                case hotNewsType:case pushNewsType:case adNewsType:
                    _singleBigImageNewsTypeLabelFrame = CGRectMake(titleX, titleY + rtypeGap, rtypeW, rtypeH);
                    break;
                default:
                    break;
            }
            _cellHeight = CGRectGetMaxY(_singleBigImageSeperatorLineFrame);
        }
        
        else if ([card.type integerValue] == imageStyleThree) {
            
            _multipleImageTipButtonFrame = CGRectMake(tipButtonX, tipButtonY, tipButtonW, tipButtonH);
            
            // 广告位隐藏来源
            if ([card.rtype integerValue]  == 3) {
                sourceImageViewY = 0;
                sourceImageViewH = 0;
                sourceH = 0;
            }
            _multipleImageSourceImageViewFrame = CGRectMake(paddingLeft, sourceImageViewY, sourceImageViewW, sourceImageViewH);
            
            CGFloat sourceX = CGRectGetMaxX(_multipleImageSourceImageViewFrame) + sourcePaddingLeft;
            _multipleImageSourceLabelFrame = CGRectMake(sourceX, sourceY, sourceW, sourceH);
         
            _multipleImageSourceListViewFrame = CGRectMake(sourceImageListViewX, sourceImageListViewY, CGRectGetMaxX(_multipleImageSourceLabelFrame), sourceImageListViewH);

            CGFloat titleW = ScreenWidth - paddingLeft * 2;
            // 计算单行文字高度
            NSMutableAttributedString *singleLineAttrStr =  [@"单行文本" attributedStringWithFont:[UIFont systemFontOfSize:titleFontSize] lineSpacing:lineSpacing];
            CGRect singleLineRect = [singleLineAttrStr boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
            CGFloat singleTitleH = singleLineRect.size.height;
            
            NSMutableAttributedString *attrStr =  [title attributedStringWithFont:[UIFont systemFontOfSize:titleFontSize] lineSpacing:lineSpacing];
            CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
            CGFloat titleH = rect.size.height;
            
            if (titleH > 2 * singleTitleH) {
                titleH = 2 * singleTitleH;
            }
            CGFloat titleX = paddingLeft;
            CGFloat titleY = CGRectGetMaxY(_multipleImageSourceImageViewFrame) + paddingTop;
            
            if ([card.rtype integerValue]  == 3) {
                titleY = paddingTop + tipButtonH;
            }
            
            _multipleImageTitleLabelFrame = CGRectMake(titleX, titleY, titleW, titleH);
            
            CGFloat imageY =   CGRectGetMaxY(_multipleImageTitleLabelFrame) + paddingTop;
            
            // 定义单张图片的宽度
            CGFloat imageW = (ScreenWidth - paddingLeft * 2 - 6) / 3 ;
            
            CGFloat imageH = 76 * imageW / 114;
            
            _multipleImageViewFrame = CGRectMake(titleX, imageY, ScreenWidth - paddingLeft * 2, imageH);
            switch (rtype) {
                case hotNewsType:case pushNewsType:case adNewsType:
                    _multipleImageNewsTypeLabelFrame = CGRectMake(titleX, titleY + rtypeGap, rtypeW, rtypeH);
                    break;
                default:
                    break;
            }
            deleteButtonY = CGRectGetMaxY(_multipleImageViewFrame) + deleteButtonPaddingTop;
            commentsY = deleteButtonY;
            _multipleImageCommentsCountLabelFrame = CGRectMake(commentsX, commentsY, commentsW, commentsH);
            
            _multipleImageDeleteButtonFrame = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
            
            CGFloat multipleImageSeperatorLineY = CGRectGetMaxY(_multipleImageDeleteButtonFrame)+ paddingBottom;
            _multipleImageSeperatorLineFrame = CGRectMake(0, multipleImageSeperatorLineY, ScreenWidth, seperatorH);
            _cellHeight = CGRectGetMaxY(_multipleImageSeperatorLineFrame);
        }

    }
    
   }

@end
