//
//  LPParaCommentFrame.h
//  EveryoneNews
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LPComment;
@interface LPParaCommentFrame : NSObject
@property (nonatomic, strong) LPComment *comment;

@property (nonatomic, assign) CGRect iconF;
@property (nonatomic, assign) CGRect nameLabelF;
@property (nonatomic, assign) CGRect timeLabelF;
@property (nonatomic, assign) CGRect commentLabelF;
@property (nonatomic, assign) CGRect upImageViewF;
@property (nonatomic, assign) CGRect upCountsLabelF;
@property (nonatomic, assign) CGRect dividerViewF;
@property (nonatomic, assign) CGRect upViewF;

@property (nonatomic, assign) CGFloat cellHeight;
@end
