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
- (void)setupRelateData {
    // 相关观点
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"url"] = [self.card valueForKey:@"newId"];
    NSString *relateURL = @"http://api.deeporiginalx.com/bdp/news/related";
    [LPHttpTool getWithURL:relateURL params:params success:^(id json) {
        NSDictionary *dict = json[@"data"];
        NSArray *relatePointArray = [LPRelatePoint objectArrayWithKeyValuesArray:dict[@"searchItems"]];
        // 按照时间排序
        NSArray *sortedRelateArray = [relatePointArray sortedArrayUsingComparator:^NSComparisonResult(LPRelatePoint *p1, LPRelatePoint *p2){
            return [p2.updateTime compare:p1.updateTime];
        }];
        self.relatePointArray = sortedRelateArray;
        
        for (int i = 0; i < sortedRelateArray.count; i ++) {
            LPRelatePoint *point = sortedRelateArray[i];
            LPRelateFrame *relateFrame = [[LPRelateFrame alloc] init];
            relateFrame.relatePoint = point;
            [self.relatePointFrames addObject:relateFrame];
            if (i == 2) {
                break;
            }
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

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
