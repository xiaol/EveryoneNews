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
- (void)showMoreComment {
    LPFullCommentViewController *fullCommentVc = [[LPFullCommentViewController alloc] init];
    fullCommentVc.docId = self.docId;
    [self.navigationController pushViewController:fullCommentVc animated:YES];
}

#pragma maek -  全文评论
- (void)fulltextCommentDidClick {
    LPFullCommentViewController *fullCommentVc = [[LPFullCommentViewController alloc] init];
    fullCommentVc.docId = self.docId;
    fullCommentVc.commentsCount = self.commentsCount;
    [fullCommentVc fulltextCommentDidComposed:^(NSInteger count) {
        self.topView.badgeNumber = count;
    }];
}

#pragma mark - 顶部全文评论按钮
- (void)fulltextCommentDidClick:(LPDetailTopView *)detailTopView
{
    LPFullCommentViewController *fullCommentVc = [[LPFullCommentViewController alloc] init];
    fullCommentVc.docId = self.docId;
    fullCommentVc.commentsCount = self.commentsCount;
    
    [fullCommentVc fulltextCommentDidComposed:^(NSInteger count) {
        self.topView.badgeNumber = count;
        NSLog(@"count1:%d",count);
    }];
    
    [self.navigationController pushViewController:fullCommentVc animated:YES];
}

- (void)pushFulltextCommentComposeVc {
    LPComposeViewController *composeVc = [[LPComposeViewController alloc] init];
    composeVc.delegate = self;
    composeVc.docId = self.docId;
//    composeVc.commentsCount = self.commentsCount;
//    [composeVc returnCommentsCount:^(NSInteger count) {
//        NSLog(@"comment:%d", count);
//    }];
    
    [self.navigationController pushViewController:composeVc animated:YES];
}

- (void)pushCommentViewControllerWithDetailBottomView:(LPDetailBottomView *)detailBottomView {
    LPFullCommentViewController *fullCommentVc = [[LPFullCommentViewController alloc] init];
    fullCommentVc.docId = self.docId;
    [self.navigationController pushViewController:fullCommentVc animated:YES];
}

#pragma mark - 加载精选评论数据
- (void)setupCommentsData {
    NSString *url = @"http://api.deeporiginalx.com/bdp/news/comment/ydzx";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"docid"] = self.docId;
    params[@"page"] = @(1);
    params[@"offset"] = @"20";
    [LPHttpTool getWithURL:url params:params success:^(id json) {
        NSMutableArray *fulltextCommentArray = [NSMutableArray array];
        
        // NSLog(@"%@", json[@"code"]);
        if ([json[@"code"] integerValue] == 0) {
            NSArray *commentsArray = json[@"data"];
            for (NSDictionary *dict in commentsArray) {
                LPComment *comment = [[LPComment alloc] init];
                comment.srcText = dict[@"content"];
                comment.createTime = dict[@"create_time"];
                comment.up = [NSString stringWithFormat:@"%@", dict[@"love"]] ;
                comment.userIcon = dict[@"profile"];
                comment.commentId = dict[@"comment_id"];
                comment.userName = dict[@"nickname"];
                comment.color = [UIColor colorFromHexString:@"#747474"];
                comment.isPraiseFlag = @"0";
                comment.Id = dict[@"id"];
                
                LPCommentFrame *commentFrame = [[LPCommentFrame alloc] init];
                commentFrame.comment = comment;
                [self.fulltextCommentFrames addObject:commentFrame];
                
                [fulltextCommentArray addObject:comment];
                if (fulltextCommentArray.count == 3) {
                    break;
                }
                [self.tableView reloadData];
                
            }
        }
    } failure:^(NSError *error) {
        
    }];
    
}
@end
