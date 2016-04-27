//
//  LPDetailViewController+RelatePoint.m
//  EveryoneNews
//
//  Created by dongdan on 16/4/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPDetailViewController+RelatePoint.h"
#import "LPRelateFrame.h"
#import "LPRelatePoint.h"


@implementation LPDetailViewController (RelatePoint)


#pragma mark - 加载相关观点数据
- (void)loadMoreRelateData {
    if (self.relatePointArray.count > 3 && self.relatePointIsFinishedLoad == NO) {
        for (int i = 3; i < self.relatePointArray.count; i++) {
            LPRelateFrame *relateFrame = [[LPRelateFrame alloc] init];
            relateFrame.relatePoint = self.relatePointArray[i];
            [self.relatePointFrames addObject:relateFrame];
        }
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
        [self.tableView.footer noticeNoMoreData];
        self.relatePointIsFinishedLoad = YES;
    }
}

@end
