//
//  LPDetailViewController+FulltextComment.m
//  EveryoneNews
//
//  Created by dongdan on 16/4/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPDetailViewController+FulltextComment.h"
#import "LPFullCommentViewController.h"
#import "LPComment.h"


@implementation LPDetailViewController (FulltextComment)

#pragma mark - 查看更多评论
//- (void)showMoreComment {
//    LPFullCommentViewController *fullCommentVc = [[LPFullCommentViewController alloc] init];
//    fullCommentVc.docId = [self docId];
//    [self.navigationController pushViewController:fullCommentVc animated:YES];
//}

#pragma maek -  全文评论
- (void)fulltextCommentDidClick {
    LPFullCommentViewController *fullCommentVc = [[LPFullCommentViewController alloc] init];
    fullCommentVc.docId = [self docId];
    fullCommentVc.commentsCount = self.commentsCount;
    [fullCommentVc fulltextCommentDidComposed:^(NSInteger count) {
        self.topView.badgeNumber = count;
    }];
}

#pragma mark - 底部直接发表评论
- (void)pushFulltextCommentComposeVc {
    LPComposeViewController *composeVc = [[LPComposeViewController alloc] init];
    composeVc.delegate = self;
    composeVc.docId = self.docId;
    composeVc.commentsCount = self.commentsCount;
    [composeVc returnCommentsCount:^(NSInteger count) {
        self.topView.badgeNumber = count;
        self.bottomView.badgeNumber = count;
        self.commentsCount = count;
    }];
    
    [self.navigationController pushViewController:composeVc animated:YES];
}

#pragma mark - 底部点击发表评论
- (void)pushCommentViewControllerWithDetailBottomView:(LPDetailBottomView *)detailBottomView {
    LPFullCommentViewController *fullCommentVc = [[LPFullCommentViewController alloc] init];
    fullCommentVc.docId = self.docId;
    fullCommentVc.commentsCount = self.commentsCount;
    [fullCommentVc fulltextCommentDidComposed:^(NSInteger count) {
        self.topView.badgeNumber = count;
        self.bottomView.badgeNumber = count;
        self.commentsCount = count;
    }];
    
    [self.navigationController pushViewController:fullCommentVc animated:YES];
}



@end
