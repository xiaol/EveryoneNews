//
//  CommentTool.h
//  EveryoneNews
//
//  Created by dongdan on 16/8/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CommentsQuerySuccessHandler)(NSArray *cards);
typedef void (^CommentsQueryFailureHandler)(NSError *error);
typedef void (^CommentsDeleteFlag)(NSString *deleteFlag);

@class LPMyComment;
@interface CommentTool : NSObject

+ (void)commentsQuerySuccess:(CommentsQuerySuccessHandler)success failure:(CommentsQueryFailureHandler)failure;

+ (void)deleteComment:(LPMyComment *)comment deleteFlag:(CommentsDeleteFlag)deleteFlag;

@end
