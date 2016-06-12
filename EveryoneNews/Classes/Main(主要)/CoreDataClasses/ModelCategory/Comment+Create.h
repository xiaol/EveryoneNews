//
//  Comment+Create.h
//  EveryoneNews
//
//  Created by dongdan on 16/6/6.
//  Copyright © 2016年 apple. All rights reserved.
//


#import "Comment.h"

@class Card;
@interface Comment (Create)

+ (void)createCommentWithDict:(NSDictionary *)dict card:(Card *)card;

+ (NSArray *)getPersonalComment;

+ (void)deleteComment:(Comment *)comment;
@end
