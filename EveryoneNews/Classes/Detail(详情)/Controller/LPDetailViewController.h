//
//  LPDetailViewController.h
//  EveryoneNews
//
//  Created by apple on 15/5/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPPress;
@class LPConcernPress;
@class LPConcern;
@class CardFrame;

typedef void (^returnCommentsToUpBlock)(NSArray *contents);

// 全文评论点赞
typedef void (^fulltextCommentsUpHandler)(NSArray *fulltextComments);

@interface LPDetailViewController : LPBaseViewController
@property (nonatomic, strong) LPPress *press;
@property (nonatomic, strong) LPConcernPress *concernPress;
@property (nonatomic, assign) BOOL isConcernDetail;
@property (nonatomic, strong) LPConcern *concern;
// 存储全文评论内容
@property (nonatomic,strong) NSArray *fullTextComments;
- (void)returnContentsBlock:(returnCommentsToUpBlock)returnBlock;
// 全文评论点赞block
- (void)fulltextCommentsUpDidComposed:(fulltextCommentsUpHandler) fulltextCommentsUpHandle;

@property (nonatomic, strong) CardFrame *cardFrame;
@end
