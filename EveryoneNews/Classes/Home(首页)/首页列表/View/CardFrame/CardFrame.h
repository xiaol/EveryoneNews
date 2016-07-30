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
@property (nonatomic, assign) CGRect noImageLabelFrame;
@property (nonatomic, assign) CGRect noImageSourceLabelFrame;
@property (nonatomic, assign) CGRect noImageSeperatorLineFrame;
@property (nonatomic, assign) CGRect noImageDeleteButtonFrame;
@property (nonatomic, assign) CGRect noImageCommentLabelFrame;
@property (nonatomic, assign) CGRect noImageTipButtonFrame;

// 单图（小图）
@property (nonatomic, assign) CGRect singleImageTitleLabelFrame;
@property (nonatomic, assign) CGRect singleImageImageViewFrame;
@property (nonatomic, assign) CGRect singleImageSourceLabelFrame;
@property (nonatomic, assign) CGRect singleImageSeperatorLineFrame;
@property (nonatomic, assign) CGRect singleImageDeleteButtonFrame;
@property (nonatomic, assign) CGRect singelImageCommentLabelFrame;
@property (nonatomic, assign) CGRect singleTipButtonFrame;

// 单图（大图）
@property (nonatomic, assign) CGRect singleBigImageTitleLabelFrame;
@property (nonatomic, assign) CGRect singleBigImageImageViewFrame;
@property (nonatomic, assign) CGRect singleBigImageSourceLabelFrame;
@property (nonatomic, assign) CGRect singleBigImageSeperatorLineFrame;
@property (nonatomic, assign) CGRect singleBigImageDeleteButtonFrame;
@property (nonatomic, assign) CGRect singelBigImageCommentLabelFrame;
@property (nonatomic, assign) CGRect singleBigTipButtonFrame;

// 三图模式以及三图以上模式
@property (nonatomic, assign) CGRect multipleImageTitleLabelFrame;
@property (nonatomic, assign) CGRect multipleImageViewFrame;
@property (nonatomic, assign) CGRect multipleImageSourceLabelFrame;
@property (nonatomic, assign) CGRect mutipleImageSeperatorLineFrame;
@property (nonatomic, assign) CGRect mutipleImageDeleteButtonFrame;
@property (nonatomic, assign) CGRect mutipleImageCommentLabelFrame;
@property (nonatomic, assign) CGRect mutipleTipButtonFrame;
//@property (nonatomic, assign) BOOL mutipleLabelSelected;

// 是否显示提示
@property (nonatomic, assign, getter=isTipButtonHidden) BOOL tipButtonHidden;

// cell高度
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) Card *card;

@property (nonatomic, assign) NSInteger homeViewFontSize;

- (void)setCard:(Card *)card tipButtonHidden:(BOOL)tipButtonHidden;

@end
