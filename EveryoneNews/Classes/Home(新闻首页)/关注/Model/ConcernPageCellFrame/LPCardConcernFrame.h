//
//  LPCardConcernFrame.h
//  EveryoneNews
//
//  Created by dongdan on 16/7/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Card;

@interface LPCardConcernFrame : NSObject

// 无图
@property (nonatomic, assign) CGRect noImageTitleLabelFrame;
@property (nonatomic, assign) CGRect noImageKeywordLabelFrame;
@property (nonatomic, assign) CGRect noImageSourceLabelFrame;
@property (nonatomic, assign) CGRect noImageSeperatorLineFrame;
@property (nonatomic, assign) CGRect noImageSourceListViewFrame;

// 单图
@property (nonatomic, assign) CGRect singleImageTitleLabelFrame;
@property (nonatomic, assign) CGRect singleImageImageViewFrame;
@property (nonatomic, assign) CGRect singleImageKeywordFrame;
@property (nonatomic, assign) CGRect singleImageSourceLabelFrame;
@property (nonatomic, assign) CGRect singleImageSeperatorLineFrame;
@property (nonatomic, assign) CGRect singleImageSourceListViewFrame;

// 三图
@property (nonatomic, assign) CGRect multipleImageTitleLabelFrame;
@property (nonatomic, assign) CGRect multipleImageViewFrame;
@property (nonatomic, assign) CGRect multipleImageKeywordFrame;
@property (nonatomic, assign) CGRect multipleImageSourceLabelFrame;
@property (nonatomic, assign) CGRect multipleImageSeperatorLineFrame;
@property (nonatomic, assign) CGRect multipleImageSourceListFrame;

// cell高度
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) Card *card;

@property (nonatomic, assign) NSInteger homeViewFontSize;

@end
