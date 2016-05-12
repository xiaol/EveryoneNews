//
//  LPCommentFrame.h
//  EveryoneNews
//
//  Created by dongdan on 16/3/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPComment;
@interface LPCommentFrame : NSObject

@property (nonatomic, strong) LPComment *comment;
@property (nonatomic, assign) CGRect iconF;
@property (nonatomic, assign) CGRect nameF;
@property (nonatomic, assign) CGRect timeF;
@property (nonatomic, assign) CGRect textF;
@property (nonatomic, assign) CGRect upCountF;
@property (nonatomic, assign) CGRect upButtonF;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat currentIndex;
@property (nonatomic, assign) NSInteger totalCount;

@end
