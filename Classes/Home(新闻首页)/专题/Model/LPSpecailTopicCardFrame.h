//
//  LPSpecailTopicCardFrame.h
//  EveryoneNews
//
//  Created by dongdan on 2016/10/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPSpecialTopicCard;
@interface LPSpecailTopicCardFrame : NSObject

// 无图模式
@property (nonatomic, assign) CGRect noImageLabelFrame;
@property (nonatomic, assign) CGRect noImageSourceLabelFrame;
@property (nonatomic, assign) CGRect noImageSeperatorLineFrame;
@property (nonatomic, assign) CGRect noImageCommentLabelFrame;

// 单图模式 以及两张图 （目前没有大图和小图区分，暂时不做头图区分）
@property (nonatomic, assign) CGRect singleImageTitleLabelFrame;
@property (nonatomic, assign) CGRect singleImageImageViewFrame;
@property (nonatomic, assign) CGRect singleImageSourceLabelFrame;
@property (nonatomic, assign) CGRect singleImageSeperatorLineFrame;
@property (nonatomic, assign) CGRect singelImageCommentLabelFrame;


// 三图模式以及三图以上模式
@property (nonatomic, assign) CGRect multipleImageTitleLabelFrame;
@property (nonatomic, assign) CGRect multipleImageViewFrame;
@property (nonatomic, assign) CGRect multipleImageSourceLabelFrame;
@property (nonatomic, assign) CGRect mutipleImageSeperatorLineFrame;
@property (nonatomic, assign) CGRect mutipleImageCommentLabelFrame;

// cell高度
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) LPSpecialTopicCard *card;
@property (nonatomic, assign) NSInteger homeViewFontSize;
@property (nonatomic, strong) NSArray *keywords;


@end
