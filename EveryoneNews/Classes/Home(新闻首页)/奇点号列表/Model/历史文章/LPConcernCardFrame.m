//
//  videoFrame.m
//  EveryoneNews
//
//  Created by dongdan on 16/7/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPConcernCardFrame.h"
#import "Card+Create.h"
#import "TTTAttributedLabel.h"
#import "LPConcernCard.h"
#import "LPFontSizeManager.h"
#import "LPFontSize.h"

const static CGFloat paddingLeft = 17;
const static CGFloat paddingTop = 15;

@implementation LPConcernCardFrame

- (void)setCard:(LPConcernCard *)card {
    
    _card = card;
 
    NSMutableAttributedString *htmlTitle = [Card titleHtmlString:card.title];
    
    NSDate *currentDate = [NSDate date];
    NSDate *updateTime = [NSDate dateWithTimeIntervalSince1970:card.updateTime.longLongValue / 1000.0];
    NSString *publishTime = nil;
    int interval = (int)[currentDate timeIntervalSinceDate: updateTime] / 60;
    if (interval > 0 && interval < 60) {
        publishTime = [NSString stringWithFormat:@"%d分钟前",interval];
    } else if (interval == 0) {
        publishTime = @"3秒前";
    } else if(interval > 60 && interval < 60 * 12) {
        publishTime = [NSString stringWithFormat:@"%d小时前",interval / 60];
    } else {
        publishTime = [NSString stringFromDate:updateTime];
    }
    
    NSString *commentsCount = [NSString stringWithFormat:@"%@评", card.commentsCount != nil ? card.commentsCount: @"0"];
    
    CGFloat commentFontSize = LPFont6;
    CGFloat publishTimeFontSize = LPFont6;
    CGFloat publishTimePaddingHorizontal = 10;
    CGFloat publishTimePadddingVertical = 6;
    
    // 视频
    if (card.rtype == videoNewsType) {
        
        // 定义单张图片的宽度
        CGFloat imageW = (ScreenWidth - paddingLeft * 2 - 6) / 3 ;
        // 单图标题
        CGFloat titleX = paddingLeft;
        CGFloat titleW = ScreenWidth - imageW - paddingLeft * 2 - 20;
        CGFloat titleH = [htmlTitle tttAttributeLabel:titleW];
        
        CGFloat titleFontSize = [LPFontSizeManager sharedManager].lpFontSize.currentHomeViewFontSize;
        
        // 计算单行文字高度
        NSMutableAttributedString *singleLineAttrStr =  [@"单行文本" attributedStringWithFont:[UIFont systemFontOfSize:titleFontSize] lineSpacing:0];
        CGRect singleLineRect = [singleLineAttrStr boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        CGFloat singleTitleH = singleLineRect.size.height;
        
        if (titleH > 3 * singleTitleH) {
            titleH = 3 * singleTitleH;
        }
        // 图片
        CGFloat imageX = ScreenWidth - paddingLeft - imageW;
        CGFloat imageY = paddingTop;
        CGFloat imageH = 76 * imageW / 114;
        
        // 图片高度
        _videoImageImageViewFrame = CGRectMake(imageX, imageY, imageW, imageH);
        
        // 关键字
        CGFloat publishTimeX = paddingLeft;
        CGFloat publishTimeW = [publishTime sizeWithFont:[UIFont systemFontOfSize:publishTimeFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + publishTimePaddingHorizontal;
        CGFloat publishTimeH = [publishTime sizeWithFont:[UIFont systemFontOfSize:publishTimeFontSize] maxSize:CGSizeMake(publishTimeW, MAXFLOAT)].height;
        
        CGFloat publishTimePaddingTop = 15;
        CGFloat titleY = 0.0f;
        
        // 评论数目
        CGFloat commentLabelW = [commentsCount sizeWithFont:[UIFont systemFontOfSize:commentFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
        CGFloat commentLabelH = [commentsCount sizeWithFont:[UIFont systemFontOfSize:commentFontSize] maxSize:CGSizeMake(commentLabelW, MAXFLOAT)].height ;
        
        CGFloat commentLabelX = 0;
        // 判断图片和标题+来源高度
        if ((titleH + publishTimeH + publishTimePaddingTop) > imageH) {
            titleY = paddingTop;
            commentLabelX = ScreenWidth - paddingLeft - commentLabelW;
        } else {
            titleY = paddingTop + (imageH - (titleH + publishTimeH + publishTimePaddingTop)) / 2 ;
            commentLabelX = ScreenWidth - paddingLeft - commentLabelW - imageW - 8;
        }
        _videoImageTitleLabelFrame = CGRectMake(titleX, titleY, titleW, titleH);
        
        CGFloat publishTimeY = CGRectGetMaxY(_videoImageTitleLabelFrame) + publishTimePaddingTop;
        
        if ((titleH + publishTimeH + publishTimePaddingTop) < imageH) {
            publishTimeY = CGRectGetMaxY(_videoImageImageViewFrame) + paddingTop;
        } else {
            
        }
        
        _videoImagePublishTimeLabelFrame = CGRectMake(publishTimeX, publishTimeY, publishTimeW, publishTimeH);
        
        CGFloat commentLabelY = publishTimeY;
        _videoImageCommentLabelFrame = CGRectMake(commentLabelX, commentLabelY, commentLabelW, commentLabelH);
        
        // 分割线
        CGFloat videoImageSeperatorLineY = CGRectGetMaxY(_videoImagePublishTimeLabelFrame) + 15;
        _videoImageSeperatorLineFrame = CGRectMake(0, videoImageSeperatorLineY, ScreenWidth, 0.5);
        
        
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
        
        
        _cellHeight = CGRectGetMaxY(_videoImageSeperatorLineFrame);
        
    } else {
        
        // 无图
        if(card.cardImages.count == 0) {
            // 标题
            CGFloat titleX = paddingLeft;
            CGFloat titleY = paddingTop;
            CGFloat titleW = ScreenWidth - titleX * 2;
            CGFloat titleH = [htmlTitle tttAttributeLabel:titleW];
            _noImageTitleLabelFrame = CGRectMake(titleX, titleY, titleW, titleH);
            
            // 时间
            CGFloat publishTimeX = paddingLeft;
            CGFloat publishTimeY = CGRectGetMaxY(_noImageTitleLabelFrame) + 15;
            CGFloat publishTimeW = [publishTime sizeWithFont:[UIFont systemFontOfSize:publishTimeFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + publishTimePaddingHorizontal;
            CGFloat publishTimeH = [publishTime sizeWithFont:[UIFont systemFontOfSize:publishTimeFontSize] maxSize:CGSizeMake(publishTimeW, MAXFLOAT)].height + publishTimePadddingVertical;
            _noImagePublishTimeLabelFrame = CGRectMake(publishTimeX, publishTimeY, publishTimeW, publishTimeH);
            
            // 评论数目
            CGFloat commentLabelW = [commentsCount sizeWithFont:[UIFont systemFontOfSize:commentFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
            CGFloat commentLabelX = ScreenWidth - paddingLeft - commentLabelW;
            CGFloat commentLabelY = publishTimeY;
            CGFloat commentLabelH = [commentsCount sizeWithFont:[UIFont systemFontOfSize:commentFontSize] maxSize:CGSizeMake(commentLabelW, MAXFLOAT)].height ;
            _noImageCommentLabelFrame = CGRectMake(commentLabelX, commentLabelY, commentLabelW, commentLabelH);
            
            // 分割线
            CGFloat noImageSeperatorLineY = CGRectGetMaxY(_noImagePublishTimeLabelFrame) + 15;
            _noImageSeperatorLineFrame = CGRectMake(0, noImageSeperatorLineY, ScreenWidth, 0.5);
            _cellHeight = CGRectGetMaxY(_noImageSeperatorLineFrame);
            
        }  else if (card.cardImages.count == 1 || card.cardImages.count == 2) {
            // 定义单张图片的宽度
            CGFloat imageW = (ScreenWidth - paddingLeft * 2 - 6) / 3 ;
            // 单图标题
            CGFloat titleX = paddingLeft;
            CGFloat titleW = ScreenWidth - imageW - paddingLeft * 2 - 20;
            CGFloat titleH = [htmlTitle tttAttributeLabel:titleW];
            
            // 图片
            CGFloat imageX = ScreenWidth - paddingLeft - imageW;
            CGFloat imageY = paddingTop;
            CGFloat imageH = 76 * imageW / 114;
            
            // 图片高度
            _singleImageImageViewFrame = CGRectMake(imageX, imageY, imageW, imageH);
            
            // 关键字
            CGFloat publishTimeX = paddingLeft;
            CGFloat publishTimeW = [publishTime sizeWithFont:[UIFont systemFontOfSize:publishTimeFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + publishTimePaddingHorizontal;
            CGFloat publishTimeH = [publishTime sizeWithFont:[UIFont systemFontOfSize:publishTimeFontSize] maxSize:CGSizeMake(publishTimeW, MAXFLOAT)].height;
            
            CGFloat publishTimePaddingTop = 15;
            CGFloat titleY = 0.0f;
            
            // 评论数目
            CGFloat commentLabelW = [commentsCount sizeWithFont:[UIFont systemFontOfSize:commentFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
            CGFloat commentLabelH = [commentsCount sizeWithFont:[UIFont systemFontOfSize:commentFontSize] maxSize:CGSizeMake(commentLabelW, MAXFLOAT)].height ;
            
            CGFloat commentLabelX = 0;
            // 判断图片和标题+来源高度
            if ((titleH + publishTimeH + publishTimePaddingTop) > imageH) {
                titleY = paddingTop;
                commentLabelX = ScreenWidth - paddingLeft - commentLabelW;
            } else {
                titleY = paddingTop + (imageH - (titleH + publishTimeH + publishTimePaddingTop)) / 2 ;
                commentLabelX = ScreenWidth - paddingLeft - commentLabelW - imageW - 8;
            }
            _singleImageTitleLabelFrame = CGRectMake(titleX, titleY, titleW, titleH);
            
            CGFloat publishTimeY = CGRectGetMaxY(_singleImageTitleLabelFrame) + publishTimePaddingTop;
            
            if ((titleH + publishTimeH + publishTimePaddingTop) < imageH) {
                publishTimeY = CGRectGetMaxY(_singleImageImageViewFrame) + paddingTop;
            } else {
                
            }
            
            _singleImagePublishTimeLabelFrame = CGRectMake(publishTimeX, publishTimeY, publishTimeW, publishTimeH);
            
            CGFloat commentLabelY = publishTimeY;
            _singleImageCommentLabelFrame = CGRectMake(commentLabelX, commentLabelY, commentLabelW, commentLabelH);
            
            // 分割线
            CGFloat singleImageSeperatorLineY = CGRectGetMaxY(_singleImagePublishTimeLabelFrame) + 15;
            _singleImageSeperatorLineFrame = CGRectMake(0, singleImageSeperatorLineY, ScreenWidth, 0.5);
            _cellHeight = CGRectGetMaxY(_singleImageSeperatorLineFrame);
            
        } else if (card.cardImages.count >= 3) {
            
            CGFloat titleX = paddingLeft;
            CGFloat titleW = ScreenWidth - paddingLeft * 2;
            CGFloat titleY = paddingTop;
            CGFloat titleH = [htmlTitle tttAttributeLabel:titleW];
            _multipleImageTitleLabelFrame = CGRectMake(titleX, titleY , titleW, titleH);
            
            CGFloat imageY =   CGRectGetMaxY(_multipleImageTitleLabelFrame) + 8;
            CGFloat imageW = (ScreenWidth - paddingLeft * 2 - 6) / 3 ;
            CGFloat imageH = 76 * imageW / 114;
            _multipleImageViewFrame = CGRectMake(paddingLeft, imageY, ScreenWidth - paddingLeft * 2, imageH);
            
            // 时间
            CGFloat publishTimeX = paddingLeft;
            CGFloat publishTimeY = CGRectGetMaxY(_multipleImageViewFrame) + 15;
            CGFloat publishTimeW = [publishTime sizeWithFont:[UIFont systemFontOfSize:publishTimeFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + publishTimePaddingHorizontal;
            CGFloat publishTimeH = [publishTime sizeWithFont:[UIFont systemFontOfSize:publishTimeFontSize] maxSize:CGSizeMake(publishTimeW, MAXFLOAT)].height + publishTimePadddingVertical;
            _multipleImagePublishTimeLabelFrame = CGRectMake(publishTimeX, publishTimeY, publishTimeW, publishTimeH);
            
            // 评论数目
            CGFloat commentLabelW = [commentsCount sizeWithFont:[UIFont systemFontOfSize:commentFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
            CGFloat commentLabelX = ScreenWidth - paddingLeft - commentLabelW;
            CGFloat commentLabelY = publishTimeY;
            CGFloat commentLabelH = [commentsCount sizeWithFont:[UIFont systemFontOfSize:commentFontSize] maxSize:CGSizeMake(commentLabelW, MAXFLOAT)].height ;
            _noImageCommentLabelFrame = CGRectMake(commentLabelX, commentLabelY, commentLabelW, commentLabelH);
            
            // 分割线
            CGFloat mutipleImageSeperatorLineY = CGRectGetMaxY(_multipleImagePublishTimeLabelFrame) + 15;
            _mutipleImageSeperatorLineFrame = CGRectMake(0, mutipleImageSeperatorLineY, ScreenWidth, 0.5);
            
            _cellHeight = CGRectGetMaxY(_mutipleImageSeperatorLineFrame);
        }

    }
    
    
}

@end
