//
//  LPComposeViewController.h
//  EveryoneNews
//
//  Created by apple on 15/6/29.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnTextBlock)(NSString *text);

typedef void(^returnCommentsCountBlock)(NSInteger count);
@class LPComment;

@protocol LPComposeViewControllerDelegate <NSObject>

@optional
- (void)insertComment:(LPComment *)comment;

@end


@interface LPComposeViewController : LPBaseViewController
@property (nonatomic, copy) NSString *draftText;

@property (nonatomic, copy) returnTextBlock returnTextBlock;
@property (nonatomic, copy) returnCommentsCountBlock returnCommentsCountBlock;

@property (nonatomic, copy) NSString *docId;
// 全文评论数量
@property (nonatomic, assign) NSInteger commentsCount;

- (void)returnText:(returnTextBlock)returnTextBlock;

- (void)returnCommentsCount:(returnCommentsCountBlock)returnCommentsCountBlock;

@property (nonatomic, weak) id<LPComposeViewControllerDelegate> delegate;
@end

