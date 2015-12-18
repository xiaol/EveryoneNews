//
//  LPPagingViewPage.m
//  EveryoneNews
//
//  Created by apple on 15/12/1.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPPagingViewPage.h"
#import "UIView+LPReusePage.h"
#import "LPHomeViewCell.h"
#import "LPHomeViewFrame.h"
#import "CardTool.h"
#import "CardParam.h"
#import "Card+CoreDataProperties.h"

@interface LPPagingViewPage () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation LPPagingViewPage

- (void)prepareForReuse {
    [self.tableView setContentOffset:CGPointZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        self.tableView = tableView;
        [self addSubview:tableView];
    }
    return self;
}

- (NSMutableArray *)homeViewFrames {
    if(_homeViewFrames == nil) {
        _homeViewFrames = [[NSMutableArray alloc] init];
    }
    return _homeViewFrames;
}

#pragma -mark tableView  数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.homeViewFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPHomeViewCell *cell = [LPHomeViewCell cellWithTableView:tableView];
    cell.homeViewFrame = self.homeViewFrames[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPHomeViewFrame *homeViewFrame = self.homeViewFrames[indexPath.row];
    return homeViewFrame.cellHeight;
}

@end
