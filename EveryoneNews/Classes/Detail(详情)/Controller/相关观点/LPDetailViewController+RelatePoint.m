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
            relateFrame.currentRowIndex = i;
            relateFrame.relatePoint = self.relatePointArray[i];
            relateFrame.totalCount = self.relatePointArray.count;
            [self.relatePointFrames addObject:relateFrame];
        }
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        self.relatePointIsFinishedLoad = YES;
    }
}

@end
