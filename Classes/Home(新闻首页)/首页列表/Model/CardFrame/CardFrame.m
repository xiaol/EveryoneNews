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
    CGFloat paddingBottom = 14;
    CGFloat deleteButtonPaddingTop = 10;
    CGFloat seperatorH = 4;
    CGFloat lineSpacing = 2.0;    
    CGFloat sourceX = paddingLeft;
    
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
    
    switch (rtype) {
        case hotNewsType:case pushNewsType:case adNewsType:case zhuantiNewsType:case videoNewsType:
            title = [NSString stringWithFormat:@"占位%@", title];
            break;
        default:
            break;
    }

    CGFloat commentsY = 0.0f;
    CGFloat commentsW = 0.0f;
    CGFloat commentsH = 0.0f;
    if (commentsCount > 0) {
        if (commentsCount > 10000) {
            commentStr = [NSString stringWithFormat:@"%.1f万评", (floor)(commentsCount)/ 10000];
        } else {
            commentStr = [NSString stringWithFormat:@"%d评", commentsCount];
        }
      
        commentsH = [commentStr sizeWithFont:[UIFont systemFontOfSize:commentsFontSize] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
        commentsW = [commentStr sizeWithFont:[UIFont systemFontOfSize:commentsFontSize] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
    }
    
    CGFloat sourceH = [sourceSiteName sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
    CGFloat sourceW = [sourceSiteName sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
    
    if (sourceW > 100) {
        sourceW = 100;
    }
    
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
        
        CGFloat titleW = ScreenWidth - paddingLeft * 2;
        NSMutableAttributedString *attrStr =  [title attributedStringWithFont:[UIFont systemFontOfSize:titleFontSize] lineSpacing:lineSpacing];
        CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        CGFloat titleH = rect.size.height;
        CGFloat titleX = paddingLeft;
        CGFloat titleY = paddingTop + CGRectGetMaxY(_specialTopicTipButtonFrame);
        _specialTopicTitleLabelFrame = CGRectMake(titleX, titleY, titleW, titleH);
        
        CGFloat specialTopicImageX = paddingLeft;
        CGFloat specialTopicImageW = ScreenWidth - paddingLeft * 2;
        CGFloat specialTopicImageH = 85 * specialTopicImageW / 351;
        CGFloat specialTopicImageY = CGRectGetMaxY(_specialTopicTitleLabelFrame) + paddingTop;
        _specialTopicImageViewFrame = CGRectMake(specialTopicImageX, specialTopicImageY, specialTopicImageW, specialTopicImageH);
        
        NSString *topStr = @"顶";
        CGFloat specialTopicTopLabelW = [topStr sizeWithFont:[UIFont systemFontOfSize:LPFont7] maxSize:CGSizeMake(ScreenWidth, ScreenHeight)].width + 2;
        CGFloat specialTopicTopLabelH = [topStr sizeWithFont:[UIFont systemFontOfSize:LPFont7] maxSize:CGSizeMake(ScreenWidth, ScreenHeight)].height + 2;
        CGFloat specailTopicTopLabelX = paddingLeft;
        CGFloat specailTopicTopLabelY = CGRectGetMaxY(_specialTopicImageViewFrame) + paddingTop;
        _specailTopicTopLabelFrame = CGRectMake(specailTopicTopLabelX, specailTopicTopLabelY, specialTopicTopLabelW, specialTopicTopLabelH);
        
        deleteButtonX = ScreenWidth - deleteButtonW - paddingLeft * 2;
        deleteButtonY = CGRectGetMaxY(_specialTopicImageViewFrame) + deleteButtonPaddingTop;
        
        CGFloat commentsX = CGRectGetMaxX(_specailTopicTopLabelFrame) + 6;
        commentsY = deleteButtonY;
        // 有置顶评论数位置
        _specialTopicCommentsCountLabelFrame = CGRectMake(commentsX, commentsY, commentsW, commentsH);
        // 无置顶评论数位置
        _specialTopicCommentsCountLabelNoTopFrame = CGRectMake(paddingLeft, commentsY, commentsW, commentsH);
        _specialTopicDeleteButtonFrame = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
        
        switch (rtype) {
            case hotNewsType:case pushNewsType:case adNewsType:case zhuantiNewsType:
                _specialTopicNewsTypeLabelFrame = CGRectMake(titleX, titleY + rtypeGap, rtypeW, rtypeH);
                break;
            default:
                break;
        }
        CGFloat specialTopicSeperatorLineFrameY = CGRectGetMaxY(_specialTopicDeleteButtonFrame) + paddingBottom;
        _specialTopicSeperatorLineFrame = CGRectMake(0, specialTopicSeperatorLineFrameY, ScreenWidth, seperatorH);
        _cellHeight = CGRectGetMaxY(_specialTopicSeperatorLineFrame);
        
    } else if(rtype == 6) {
        // 视频
        _videoTipButtonFrame = CGRectMake(tipButtonX, tipButtonY, tipButtonW, tipButtonH);
        
        // 定义单张图片的宽度
        CGFloat imageW = (ScreenWidth - paddingLeft * 2 - 6) / 3 ;
        CGFloat imageH = 76 * imageW / 114;
        CGFloat imageX = ScreenWidth - paddingLeft - imageW;
        CGFloat imageY =   CGRectGetMaxY(_videoTipButtonFrame) + paddingTop;
        
        _videoImageViewFrame = CGRectMake(imageX, imageY, imageW, imageH);
        
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
        CGFloat titleH = rect.size.height + 2.0f;
        
        if (titleH > 3 * singleTitleH) {
            titleH = 3 * singleTitleH;
        }
        
        // 新闻来源高度
        CGFloat sourceSiteNameH = [sourceSiteName sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(titleW, MAXFLOAT)].height;
        
        CGFloat deleteButtonPaddingTop = 10.0f;
        CGFloat deleteButtonY = 0;
        CGFloat titleY = 0.0f;
        // 判断图片和标题+来源高度
        if ((titleH + deleteButtonH + deleteButtonPaddingTop )> imageH) {
            titleY =  CGRectGetMaxY(_videoTipButtonFrame) + paddingTop;
            _videoTitleLabelFrame = CGRectMake(paddingLeft, titleY, titleW, titleH);
            CGFloat maxHeight = MAX(titleH, imageH);
            deleteButtonY = titleY + maxHeight + deleteButtonPaddingTop;
        } else {
            titleY =  CGRectGetMaxY(_videoTipButtonFrame) + paddingTop + (imageH - (titleH +  deleteButtonH + deleteButtonPaddingTop)) / 2 ;
            _videoTitleLabelFrame = CGRectMake(paddingLeft, titleY, titleW, titleH);
            deleteButtonY = CGRectGetMaxY(_videoTitleLabelFrame) + paddingTop;
        }
        // 来源
        CGFloat sourceY = deleteButtonY;
        
        if([card.rtype integerValue] == 3) {
            sourceW = 0;
        }
        _videoSourceLabelFrame = CGRectMake(sourceX, sourceY, sourceW, sourceH);
        
        CGFloat videoImageSeperatorLineY = 0.0f;

        if ( titleH + deleteButtonH + deleteButtonPaddingTop > imageH) {
            CGFloat deleteButtonX = ScreenWidth - paddingLeft - deleteButtonW;
            _videoDeleteButtonFrame = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
            videoImageSeperatorLineY = CGRectGetMaxY(_videoDeleteButtonFrame) + paddingBottom;
            
        } else {
            CGFloat deleteButtonX = ScreenWidth - paddingLeft - deleteButtonW - paddingLeft - imageW;
            
            _videoDeleteButtonFrame = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
            
            videoImageSeperatorLineY = CGRectGetMaxY(_videoImageViewFrame)+ paddingBottom;
        }
         CGFloat commentLabelPaddingRight = 10;
        _videoCommentsCountLabelFrame = CGRectMake(CGRectGetMinX(_videoDeleteButtonFrame) - commentsW - commentLabelPaddingRight, sourceY, commentsW, sourceH);

        switch (rtype) {
             case hotNewsType:case pushNewsType:case adNewsType:case zhuantiNewsType:case videoNewsType:
                _videoNewsTypeLabelFrame = CGRectMake(titleX, titleY + rtypeGap, rtypeW, rtypeH);
                break;
            default:
                break;
        }
        
        // 播放按钮 播放时长
        NSString *duration = @"000000";
        CGFloat durationFontSize = 10;
        CGFloat durationLabelW = [duration sizeWithFont:[UIFont systemFontOfSize:durationFontSize] maxSize:CGSizeMake(ScreenWidth, ScreenHeight)].width;
        CGFloat durationLabelH = [duration sizeWithFont:[UIFont systemFontOfSize:durationFontSize] maxSize:CGSizeMake(ScreenWidth, ScreenHeight)].height;
        
        CGFloat playImageViewW  = 10;
        CGFloat playImageViewH  = 10;
        CGFloat playImageViewX = (imageW - playImageViewW) / 2 - 10;
        CGFloat playImageViewY = (imageH - playImageViewH - 10);
        _videoPlayImageViewFrame = CGRectMake(playImageViewX, playImageViewY, playImageViewW, playImageViewH);
        
        CGFloat durationLabelX = CGRectGetMaxX(_videoPlayImageViewFrame) + 5;
        CGFloat durationLabelY = 0;
        _videoDurationLabelFrame = CGRectMake(durationLabelX, durationLabelY, durationLabelW, durationLabelH);
        
        _videoSeperatorLineFrame = CGRectMake(0, videoImageSeperatorLineY, ScreenWidth, seperatorH);
        _cellHeight =  CGRectGetMaxY(_videoSeperatorLineFrame);        
    } else {
        // 无图
        if([card.type integerValue] == imageStyleZero) {
            
            _noImageTipButtonFrame = CGRectMake(tipButtonX, tipButtonY, tipButtonW, tipButtonH);

            CGFloat titleW = ScreenWidth - paddingLeft * 2;
            NSMutableAttributedString *attrStr =  [title attributedStringWithFont:[UIFont systemFontOfSize:titleFontSize] lineSpacing:lineSpacing];
            CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
            CGFloat titleH = rect.size.height + 2.0f;
            CGFloat titleX = paddingLeft;
            CGFloat titleY = paddingTop + CGRectGetMaxY(_noImageTipButtonFrame);
            _noImageTitleLabelFrame = CGRectMake(titleX, titleY, titleW, titleH);

            switch (rtype) {
                case hotNewsType:case pushNewsType:case adNewsType:case zhuantiNewsType:case videoNewsType:
                    _noImageNewsTypeLabelFrame = CGRectMake(titleX, titleY + rtypeGap, rtypeW, rtypeH);
                    break;
                default:
                    break;
            }

            CGFloat sourcePaddingTop = 10;
            
            if (iPhone6Plus) {
                sourcePaddingTop = 11;
            } else if (iPhone5) {
                sourcePaddingTop = 10;
            } else if (iPhone6) {
                sourcePaddingTop = 11;
            }
            
            CGFloat sourceY = CGRectGetMaxY(_noImageTitleLabelFrame) + sourcePaddingTop;
            deleteButtonY = CGRectGetMaxY(_noImageTitleLabelFrame) + deleteButtonPaddingTop;
            commentsY = deleteButtonY;

            _noImageSourceLabelFrame = CGRectMake(sourceX, sourceY, sourceW, sourceH);
            CGFloat commentsX = CGRectGetMaxX(_noImageSourceLabelFrame) + 12;

            _noImageCommentsCountLabelFrame = CGRectMake(commentsX, commentsY, commentsW, commentsH);

            _noImageDeleteButtonFrame = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
            CGFloat noImageSeperatorLineFrameY = CGRectGetMaxY(_noImageDeleteButtonFrame) + paddingBottom;

            _noImageSeperatorLineFrame = CGRectMake(0, noImageSeperatorLineFrameY, ScreenWidth, seperatorH);
            _cellHeight = CGRectGetMaxY(_noImageSeperatorLineFrame);
            
        } else if (([card.type integerValue]  == imageStyleOne) || ([card.type integerValue]  == imageStyleTwo)) {
            
            _singleImageTipButtonFrame = CGRectMake(tipButtonX, tipButtonY, tipButtonW, tipButtonH);
            
            // 图片
            CGFloat imageW = (ScreenWidth - paddingLeft * 2 - 6) / 3 ;
            CGFloat imageH = 76 * imageW / 114;
            CGFloat imageX = ScreenWidth - paddingLeft - imageW;
            CGFloat imageY =   CGRectGetMaxY(_singleImageTipButtonFrame) + paddingTop;
            
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
            CGFloat titleH = rect.size.height + 2.0f;
            
            if (titleH > 3 * singleTitleH) {
                titleH = 3 * singleTitleH;
            }
            
            CGFloat deleteButtonPaddingTop = 10.0f;
            CGFloat titleY = 0.0f;
            CGFloat deleteButtonY = 0.0f;
            
            // 判断图片和标题+来源高度
            if ((titleH  + deleteButtonH + deleteButtonPaddingTop ) > imageH) {
                titleY =  CGRectGetMaxY(_singleImageTipButtonFrame) + paddingTop;
                // 标题
                _singleImageTitleLabelFrame = CGRectMake(titleX, titleY, titleW, titleH);
                CGFloat maxHeight = MAX(titleH, imageH);
                deleteButtonY = titleY + maxHeight + deleteButtonPaddingTop;
                
            } else {
                titleY =  CGRectGetMaxY(_singleImageTipButtonFrame) + paddingTop + (imageH - (titleH  + deleteButtonH + deleteButtonPaddingTop)) / 2 ;
                // 标题
                _singleImageTitleLabelFrame = CGRectMake(titleX, titleY, titleW, titleH);
                deleteButtonY = CGRectGetMaxY(_singleImageTitleLabelFrame) + paddingTop;
            }
            
            CGFloat commentLabelPaddingRight = 10;
            // 来源
            CGFloat sourceY = deleteButtonY;
            
            if([card.rtype integerValue] == 3) {
                sourceW = 0;
            }
            _singleImageSourceLabelFrame = CGRectMake(sourceX, sourceY, sourceW, sourceH);
            
            CGFloat singleImageSeperatorLineY = 0.f;
            if (titleH + deleteButtonH + deleteButtonPaddingTop > imageH) {
                CGFloat deleteButtonX = ScreenWidth - paddingLeft - deleteButtonW;
                _singleImageDeleteButtonFrame = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
                singleImageSeperatorLineY = CGRectGetMaxY(_singleImageDeleteButtonFrame) + paddingBottom;
                
            } else {
                CGFloat deleteButtonX = ScreenWidth - paddingLeft - deleteButtonW - paddingLeft - imageW;
                
                _singleImageDeleteButtonFrame = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
                
                singleImageSeperatorLineY = CGRectGetMaxY(_singleImageImageViewFrame)+ paddingBottom;
            }
            
            _singleImageCommentsCountLabelFrame = CGRectMake(CGRectGetMinX(_singleImageDeleteButtonFrame) - commentsW - commentLabelPaddingRight, sourceY, commentsW, sourceH);
            
            switch (rtype) {
                case hotNewsType:case pushNewsType:case adNewsType:case zhuantiNewsType:case videoNewsType:
                    _singleImageNewsTypeLabelFrame = CGRectMake(titleX, titleY + rtypeGap, rtypeW, rtypeH);
                    break;
                default:
                    break;
            }
            _singleImageSeperatorLineFrame = CGRectMake(0, singleImageSeperatorLineY, ScreenWidth, seperatorH);
            _cellHeight =  CGRectGetMaxY(_singleImageSeperatorLineFrame);

        } else if ([card.type integerValue] == imageStyleEleven || [card.type integerValue] == imageStyleTwelve || [card.type integerValue] == imageStyleThirteen) {
            
            // 上次阅读位置
            _singleBigImageTipButtonFrame = CGRectMake(tipButtonX, tipButtonY, tipButtonW, tipButtonH);
            
            // 标题
            CGFloat titleX = paddingLeft;
            CGFloat titleY = CGRectGetMaxY(_singleBigImageTipButtonFrame) + paddingTop;
            CGFloat titleW = ScreenWidth - paddingLeft * 2;
            NSMutableAttributedString *attrStr =  [title attributedStringWithFont:[UIFont systemFontOfSize:titleFontSize] lineSpacing:lineSpacing];
            CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
            CGFloat titleH = rect.size.height;
            _singleBigImageTitleLabelFrame = CGRectMake(titleX, titleY, titleW, titleH);
            
            switch (rtype) {
                case hotNewsType:case pushNewsType:case adNewsType:case zhuantiNewsType:case videoNewsType:
                    _singleBigImageNewsTypeLabelFrame = CGRectMake(titleX, titleY + rtypeGap, rtypeW, rtypeH);
                    break;
                default:
                    break;
            }


            // 图片
            CGFloat imageY =   CGRectGetMaxY(_singleBigImageTitleLabelFrame) + paddingTop;
            
            // 定义单张图片的宽度
            CGFloat imageW = (ScreenWidth - paddingLeft * 2) ;
            
            CGFloat imageH = 183 * imageW / 350;
            
            _singleBigImageImageViewFrame = CGRectMake(paddingLeft, imageY, imageW, imageH);

            // 删除
            deleteButtonY = CGRectGetMaxY(_singleBigImageImageViewFrame) + deleteButtonPaddingTop;
            _singleBigImageDeleteButtonFrame = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
            
            // 来源
            CGFloat sourceY = deleteButtonY;
            _singleBigImageSourceLabelFrame = CGRectMake(sourceX, sourceY, sourceW, sourceH);
            
            // 评论数
           CGFloat commentsX = CGRectGetMaxX(_singleBigImageSourceLabelFrame) + 12;
            commentsY = deleteButtonY;
            _singleBigImageCommentsCountLabelFrame = CGRectMake(commentsX, commentsY, commentsW, commentsH);

            // 分割线
            CGFloat singleBigImageSeperatorLineY = CGRectGetMaxY(_singleBigImageDeleteButtonFrame) + paddingBottom;
            _singleBigImageSeperatorLineFrame = CGRectMake(0, singleBigImageSeperatorLineY, ScreenWidth, seperatorH);

            _cellHeight = CGRectGetMaxY(_singleBigImageSeperatorLineFrame);
        }
        
        else if ([card.type integerValue] == imageStyleThree) {
            // 上次阅读位置
            _multipleImageTipButtonFrame = CGRectMake(tipButtonX, tipButtonY, tipButtonW, tipButtonH);
            
            CGFloat titleW = ScreenWidth - paddingLeft * 2;
            NSMutableAttributedString *attrStr =  [title attributedStringWithFont:[UIFont systemFontOfSize:titleFontSize] lineSpacing:lineSpacing];
            CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
            // 计算单行文字高度
            CGFloat titleH = rect.size.height;
            
            NSMutableAttributedString *singleLineAttrStr =  [@"单行文本" attributedStringWithFont:[UIFont systemFontOfSize:titleFontSize] lineSpacing:lineSpacing];
            CGRect singleLineRect = [singleLineAttrStr boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
            CGFloat singleTitleH = singleLineRect.size.height;
            if (titleH > 2 * singleTitleH) {
                titleH = 2 * singleTitleH;
            }
            CGFloat titleX = paddingLeft;
            CGFloat titleY = CGRectGetMaxY(_multipleImageTipButtonFrame) + paddingTop;

            if ([card.rtype integerValue]  == 3) {
                titleY = paddingTop + tipButtonH;
            }
            // 标题
            _multipleImageTitleLabelFrame = CGRectMake(titleX, titleY, titleW, titleH);
            
            // 图片
            CGFloat imageY =   CGRectGetMaxY(_multipleImageTitleLabelFrame) + paddingTop;
            // 定义单张图片的宽度
            CGFloat imageW = (ScreenWidth - paddingLeft * 2 - 6) / 3 ;

            CGFloat imageH = 76 * imageW / 114;

            _multipleImageViewFrame = CGRectMake(titleX, imageY, ScreenWidth - paddingLeft * 2, imageH);
            
            switch (rtype) {
                case hotNewsType:case pushNewsType:case adNewsType:case zhuantiNewsType:case videoNewsType:
                    _multipleImageNewsTypeLabelFrame = CGRectMake(titleX, titleY + rtypeGap, rtypeW, rtypeH);
                    break;
                default:
                    break;
            }
            deleteButtonY = CGRectGetMaxY(_multipleImageViewFrame) + deleteButtonPaddingTop;
            _multipleImageDeleteButtonFrame = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonW, deleteButtonH);
            
            // 来源
            CGFloat sourceY = deleteButtonY;
            _multipleImageSourceLabelFrame = CGRectMake(sourceX, sourceY, sourceW, sourceH);
            
            // 评论数目
            CGFloat commentsX = CGRectGetMaxX(_multipleImageSourceLabelFrame) + 12;
            if ([card.rtype integerValue] == 3) {
                commentsX = 0;
            }
            commentsY = deleteButtonY;
            _multipleImageCommentsCountLabelFrame = CGRectMake(commentsX, commentsY, commentsW, commentsH);
            
            // 分割线
            CGFloat multipleImageSeperatorLineY = CGRectGetMaxY(_multipleImageDeleteButtonFrame)+ paddingBottom;
            _multipleImageSeperatorLineFrame = CGRectMake(0, multipleImageSeperatorLineY, ScreenWidth, seperatorH);
            _cellHeight = CGRectGetMaxY(_multipleImageSeperatorLineFrame);
        }

    }
    
   }

@end
