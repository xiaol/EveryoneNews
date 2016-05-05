//
//  LPDetailViewController+FulltextComment.h
//  EveryoneNews
//
//  Created by dongdan on 16/4/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPDetailViewController.h"
#import "LPComposeViewController.h"

@interface LPDetailViewController (FulltextComment)<LPComposeViewControllerDelegate>
- (void)showMoreComment ;
- (void)fulltextCommentDidClick;
//- (void)fulltextCommentDidClick:(LPDetailTopView *)detailTopView;
- (void)pushFulltextCommentComposeVc;

@end
