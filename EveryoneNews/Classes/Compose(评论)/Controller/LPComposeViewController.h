//
//  LPComposeViewController.h
//  EveryoneNews
//
//  Created by apple on 15/6/29.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnTextBlock)(NSString *text);
@class LPComment;

@protocol LPComposeViewControllerDelegate <NSObject>

@optional
- (void)insertComment:(LPComment *)comment;

@end


@interface LPComposeViewController : LPBaseViewController
@property (nonatomic, copy) NSString *draftText;
@property (nonatomic, copy) returnTextBlock returnTextBlock;
@property (nonatomic, copy) NSString *docId;

- (void)returnText:(returnTextBlock)returnTextBlock;

@property (nonatomic, weak) id<LPComposeViewControllerDelegate> delegate;
@end

