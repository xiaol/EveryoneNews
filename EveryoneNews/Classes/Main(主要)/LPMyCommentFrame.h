//
//  LPMyCommentFrame.h
//  EveryoneNews
//
//  Created by dongdan on 16/6/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Comment;
@interface LPMyCommentFrame : NSObject

@property (nonatomic, strong) Comment *comment;
@property (nonatomic, assign) CGRect timeLabeF;
@property (nonatomic, assign) CGRect deleteButtonF;
@property (nonatomic, assign) CGRect commentLabelF;
@property (nonatomic, assign) CGRect upButtonF;
@property (nonatomic, assign) CGRect commentImageViewF;
@property (nonatomic, assign) CGRect titleViewF;
@property (nonatomic, assign) CGRect titleLabelF;
@property (nonatomic, assign) CGRect spreadImageViewF;
@property (nonatomic, assign) CGRect seperatorViewF;
@property (nonatomic, assign) CGFloat cellHeight;

@end
