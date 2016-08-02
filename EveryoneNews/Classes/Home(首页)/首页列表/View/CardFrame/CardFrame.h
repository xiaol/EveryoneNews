//
//  LPHomeViewFrame.h
//  EveryoneNews
//
//  Created by dongdan on 15/12/16.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Card;
@interface CardFrame : NSObject

// 无图模式
@property (nonatomic, assign, readonly) CGRect noImageLabelFrame;
@property (nonatomic, assign, readonly) CGRect noImageSourceLabelFrame;
@property (nonatomic, assign, readonly) CGRect noImageSeperatorLineFrame;
@property (nonatomic, assign, readonly) CGRect noImageDeleteButtonFrame;
@property (nonatomic, assign, readonly) CGRect noImageCommentLabelFrame;
@property (nonatomic, assign, readonly) CGRect noImageTipButtonFrame;
@property (nonatomic, assign, readonly) CGRect noImageNewsTypeLabelFrame;

// 单图（小图）
@property (nonatomic, assign, readonly) CGRect singleImageTitleLabelFrame;
@property (nonatomic, assign, readonly) CGRect singleImageImageViewFrame;
@property (nonatomic, assign, readonly) CGRect singleImageSourceLabelFrame;
@property (nonatomic, assign, readonly) CGRect singleImageSeperatorLineFrame;
@property (nonatomic, assign, readonly) CGRect singleImageDeleteButtonFrame;
@property (nonatomic, assign, readonly) CGRect singelImageCommentLabelFrame;
@property (nonatomic, assign, readonly) CGRect singleTipButtonFrame;
@property (nonatomic, assign, readonly) CGRect singleNewsTypeLabelFrame;

// 单图（大图）
@property (nonatomic, assign, readonly) CGRect singleBigImageTitleLabelFrame;
@property (nonatomic, assign, readonly) CGRect singleBigImageImageViewFrame;
@property (nonatomic, assign, readonly) CGRect singleBigImageSourceLabelFrame;
@property (nonatomic, assign, readonly) CGRect singleBigImageSeperatorLineFrame;
@property (nonatomic, assign, readonly) CGRect singleBigImageDeleteButtonFrame;
@property (nonatomic, assign, readonly) CGRect singelBigImageCommentLabelFrame;
@property (nonatomic, assign, readonly) CGRect singleBigTipButtonFrame;
@property (nonatomic, assign, readonly) CGRect singleBigImageNewsTyeLabelFrame;

// 三图模式以及三图以上模式
@property (nonatomic, assign, readonly) CGRect multipleImageTitleLabelFrame;
@property (nonatomic, assign, readonly) CGRect multipleImageViewFrame;
@property (nonatomic, assign, readonly) CGRect multipleImageSourceLabelFrame;
@property (nonatomic, assign, readonly) CGRect mutipleImageSeperatorLineFrame;
@property (nonatomic, assign, readonly) CGRect mutipleImageDeleteButtonFrame;
@property (nonatomic, assign, readonly) CGRect mutipleImageCommentLabelFrame;
@property (nonatomic, assign, readonly) CGRect mutipleTipButtonFrame;
@property (nonatomic, assign, readonly) CGRect multipleImageNewsTypeLabelFrame;

// 是否显示提示
@property (nonatomic, assign, getter=isTipButtonHidden) BOOL tipButtonHidden;

// cell高度
@property (nonatomic, assign, readonly) CGFloat cellHeight;
@property (nonatomic, strong) Card *card;

@property (nonatomic, assign, readonly) NSInteger homeViewFontSize;

- (void)setCard:(Card *)card tipButtonHidden:(BOOL)tipButtonHidden;

@end
