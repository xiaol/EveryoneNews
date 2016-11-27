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
@property (nonatomic, assign, readonly) CGRect noImageTitleLabelFrame;
@property (nonatomic, assign, readonly) CGRect noImageSourceImageViewFrame;
@property (nonatomic, assign, readonly) CGRect noImageSourceLabelFrame;
@property (nonatomic, assign, readonly) CGRect noImageSeperatorLineFrame;
@property (nonatomic, assign, readonly) CGRect noImageDeleteButtonFrame;
@property (nonatomic, assign, readonly) CGRect noImageTipButtonFrame;
@property (nonatomic, assign, readonly) CGRect noImageNewsTypeLabelFrame;
@property (nonatomic, assign, readonly) CGRect noImageCommentsCountLabelFrame;
@property (nonatomic, assign, readonly) CGRect noImageSourceListViewFrame;

// 单图（小图）
@property (nonatomic, assign, readonly) CGRect singleImageTitleLabelFrame;
@property (nonatomic, assign, readonly) CGRect singleImageSourceImageViewFrame;
@property (nonatomic, assign, readonly) CGRect singleImageImageViewFrame;
@property (nonatomic, assign, readonly) CGRect singleImageSourceLabelFrame;
@property (nonatomic, assign, readonly) CGRect singleImageSeperatorLineFrame;
@property (nonatomic, assign, readonly) CGRect singleImageDeleteButtonFrame;
@property (nonatomic, assign, readonly) CGRect singleImageTipButtonFrame;
@property (nonatomic, assign, readonly) CGRect singleImageNewsTypeLabelFrame;
@property (nonatomic, assign, readonly) CGRect singleImageCommentsCountLabelFrame;
@property (nonatomic, assign, readonly) CGRect singleImageSourceListViewFrame;


// 单图（大图）
@property (nonatomic, assign, readonly) CGRect singleBigImageTitleLabelFrame;
@property (nonatomic, assign, readonly) CGRect singleBigImageSourceImageViewFrame;
@property (nonatomic, assign, readonly) CGRect singleBigImageImageViewFrame;
@property (nonatomic, assign, readonly) CGRect singleBigImageSourceLabelFrame;
@property (nonatomic, assign, readonly) CGRect singleBigImageSeperatorLineFrame;
@property (nonatomic, assign, readonly) CGRect singleBigImageDeleteButtonFrame;
@property (nonatomic, assign, readonly) CGRect singleBigImageTipButtonFrame;
@property (nonatomic, assign, readonly) CGRect singleBigImageNewsTypeLabelFrame;
@property (nonatomic, assign, readonly) CGRect singleBigImageCommentsCountLabelFrame;
@property (nonatomic, assign, readonly) CGRect singleBigImageSourceListViewFrame;

// 三图模式以及三图以上模式
@property (nonatomic, assign, readonly) CGRect multipleImageTitleLabelFrame;
@property (nonatomic, assign, readonly) CGRect multipleImageSourceImageViewFrame;
@property (nonatomic, assign, readonly) CGRect multipleImageViewFrame;
@property (nonatomic, assign, readonly) CGRect multipleImageSourceLabelFrame;
@property (nonatomic, assign, readonly) CGRect multipleImageSeperatorLineFrame;
@property (nonatomic, assign, readonly) CGRect multipleImageDeleteButtonFrame;
@property (nonatomic, assign, readonly) CGRect multipleImageTipButtonFrame;
@property (nonatomic, assign, readonly) CGRect multipleImageNewsTypeLabelFrame;
@property (nonatomic, assign, readonly) CGRect multipleImageCommentsCountLabelFrame;
@property (nonatomic, assign, readonly) CGRect multipleImageSourceListViewFrame;

// 专题
@property (nonatomic, assign, readonly) CGRect specialTopicOutsideViewFrame;
@property (nonatomic, assign, readonly) CGRect specialTopicInsideViewFrame;
@property (nonatomic, assign, readonly) CGRect specialTopicLogoFrame;
@property (nonatomic, assign, readonly) CGRect specialTopicTitleLabelFrame;
@property (nonatomic, assign, readonly) CGRect specialTopicImageViewFrame;
@property (nonatomic, assign, readonly) CGRect specialTopicDeleteButtonFrame;
@property (nonatomic, assign, readonly) CGRect specialTopicTipButtonFrame;
@property (nonatomic, assign, readonly) CGRect specialTopicCommentsCountLabelFrame;
@property (nonatomic, assign, readonly) CGRect specialTopicNewsTypeLabelFrame;

// 是否显示提示
@property (nonatomic, assign, getter=isTipButtonHidden) BOOL tipButtonHidden;

// cell高度
@property (nonatomic, assign, readonly) CGFloat cellHeight;
@property (nonatomic, strong) Card *card;

@property (nonatomic, assign) NSInteger homeViewFontSize;
@property (nonatomic, copy) NSString *fontSizeType;

- (void)setCard:(Card *)card tipButtonHidden:(BOOL)tipButtonHidden;

@end
