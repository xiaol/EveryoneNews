//
//  LPConcernCardFrame.h
//  EveryoneNews
//
//  Created by dongdan on 16/7/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>


@class LPConcernCard;
@interface LPConcernCardFrame : NSObject

// 无图
@property (nonatomic, assign) CGRect noImageTitleLabelFrame;
@property (nonatomic, assign) CGRect noImagePublishTimeLabelFrame;
@property (nonatomic, assign) CGRect noImageCommentLabelFrame;
@property (nonatomic, assign) CGRect noImageSeperatorLineFrame;

// 单图
@property (nonatomic, assign) CGRect singleImageTitleLabelFrame;
@property (nonatomic, assign) CGRect singleImageImageViewFrame;
@property (nonatomic, assign) CGRect singleImagePublishTimeLabelFrame;
@property (nonatomic, assign) CGRect singleImageCommentLabelFrame;
@property (nonatomic, assign) CGRect singleImageSeperatorLineFrame;

// 三图
@property (nonatomic, assign) CGRect multipleImageTitleLabelFrame;
@property (nonatomic, assign) CGRect multipleImageViewFrame;
@property (nonatomic, assign) CGRect multipleImagePublishTimeLabelFrame;
@property (nonatomic, assign) CGRect multipleImageCommentLabelFrame;
@property (nonatomic, assign) CGRect mutipleImageSeperatorLineFrame;

// cell高度
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) LPConcernCard *card;

@end
