//
//  LPPagingViewPage.h
//  EveryoneNews
//
//  Created by apple on 15/12/1.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  自定义 page
 */

@interface LPPagingViewPage : UIView

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *homeViewFrames;
@property (nonatomic, assign) NSInteger pageIndex;
//- (void)loadNewDataWithCount:(NSNumber *)count channelID:(NSString *)channelID;

/**
 *  复用前的准备工作(复写该方法)
 */
//- (void)prepareForReuse;

// table view, collection view, label, image view, ... and so on (your custom subviews)

// - @property (nonatomic, strong) UITableView *tableView;
@end
