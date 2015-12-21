//
//  LPHomeViewFrame.m
//  EveryoneNews
//
//  Created by dongdan on 15/12/16.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPHomeViewFrame.h"
#import "Card.h"

static const CGFloat PaddingHorizontal = 10;
static const CGFloat PaddingVertical = 15;

@implementation LPHomeViewFrame

- (void)setCard:(Card *)card {
    _card = card;
    _cellHeight = 0.0f;
    if(card.cardImages.count == 0) {
        
        _noImageLabelF = CGRectMake(PaddingHorizontal, PaddingVertical, ScreenWidth - 20, 75);
        _cellHeight = CGRectGetMaxY(_noImageLabelF);
        
    } else if (card.cardImages.count == 1 || card.cardImages.count == 2) {
        
        CGFloat imageX = PaddingHorizontal;
        CGFloat imageY = PaddingVertical;
        CGFloat imageW = 90;
        CGFloat imageH = 75;
        _singleImageImageViewFrame = CGRectMake(imageX, imageY, imageW, imageH);
        
        NSString *title = card.title;
        CGFloat titleX = CGRectGetMaxX(_singleImageImageViewFrame) + PaddingVertical;
        CGFloat titleW = ScreenWidth - CGRectGetMaxX(_singleImageImageViewFrame) - PaddingVertical * 2;
        CGFloat titleH = [title sizeWithFont:[UIFont systemFontOfSize:ConcernPressTitleFontSize] maxSize:CGSizeMake(titleW, MAXFLOAT)].height;
        CGFloat titleY = (titleH < imageH) ? (PaddingVertical + (imageH - titleH) / 2) : PaddingVertical;
        
        _singleImageTitleLabelFrame = CGRectMake(titleX, titleY, titleW, titleH);
        _cellHeight = MAX(CGRectGetMaxY(_singleImageImageViewFrame), CGRectGetMaxY(_singleImageTitleLabelFrame));
        
    } else if (card.cardImages.count >= 3) {
        
        _multipleImageTitleLabelFrame = CGRectMake(PaddingHorizontal, PaddingVertical, ScreenWidth - PaddingHorizontal * 2, 40);
        
        _multipleImageViewFrame = CGRectMake(PaddingHorizontal, 40 + PaddingVertical, ScreenWidth - PaddingHorizontal * 2, 75);
        _cellHeight = CGRectGetMaxY(_multipleImageViewFrame);
    }
}

@end
