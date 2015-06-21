//
//  LPParaCommentViewController.h
//  EveryoneNews
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LPParaCommentViewController;

@protocol LPParaCommentViewControllerDelegate <NSObject>
@optional
- (void)paraCommentViewControllerWillDismiss:(LPParaCommentViewController *)paraCommentViewController;
@end

@interface LPParaCommentViewController : UIViewController
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) UIImage *bgImage;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, weak) id<LPParaCommentViewControllerDelegate> delegate;
@end
