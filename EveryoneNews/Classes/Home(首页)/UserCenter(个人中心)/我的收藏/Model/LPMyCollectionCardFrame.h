//
//  LPMyCollectionCardFrame.h
//  EveryoneNews
//
//  Created by dongdan on 16/8/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPMyCollectionCard;
@interface LPMyCollectionCardFrame : NSObject

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

// 三图模式以及三图以上模式
@property (nonatomic, assign, readonly) CGRect multipleImageTitleLabelFrame;
@property (nonatomic, assign, readonly) CGRect multipleImageViewFrame;
@property (nonatomic, assign, readonly) CGRect multipleImageSourceLabelFrame;
@property (nonatomic, assign, readonly) CGRect mutipleImageSeperatorLineFrame;
@property (nonatomic, assign, readonly) CGRect mutipleImageDeleteButtonFrame;
@property (nonatomic, assign, readonly) CGRect mutipleImageCommentLabelFrame;
@property (nonatomic, assign, readonly) CGRect mutipleTipButtonFrame;
@property (nonatomic, assign, readonly) CGRect multipleImageNewsTypeLabelFrame;

@property (nonatomic, strong) LPMyCollectionCard *card;
@property (nonatomic, assign, readonly) CGFloat cellHeight;
@property (nonatomic, assign) NSInteger homeViewFontSize;

@end
