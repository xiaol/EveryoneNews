//
//  Comment+Create.h
//  EveryoneNews
//
//  Created by dongdan on 16/6/6.
//  Copyright © 2016年 apple. All rights reserved.
//


#import "Comment.h"

typedef void (^CommentsQuerySuccessHandler)(NSArray *cards);
typedef void (^CommentsQueryFailureHandler)(NSError *error);

@class Card;
@interface Comment (Create)

//+ (void)createCommentWithDict:(NSDictionary *)dict card:(Card *)card;
//
//+ (NSArray *)getPersonalComment;
//
//+ (void)deleteComment:(Comment *)comment;
 

@end
