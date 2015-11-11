//
//  LPFullCommentViewController.h
//  EveryoneNews
//
//  Created by dongdan on 15/10/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPBaseViewController.h"

@class LPDetailViewController;

@interface LPFullCommentViewController : LPBaseViewController
// 全文评论集合
@property (nonatomic, strong) NSArray *comments;
// 全文评论列表展示
@property (nonatomic, strong) UITableView *tableView;
// 全文评论内容
@property (nonatomic, copy) NSString *commentText;
// 详情页控制器
@property (nonatomic, strong) LPDetailViewController *fromVc;
// 评论头背景颜色
@property (nonatomic, strong) UIColor *color;
// 全文评论对应的链接地址
@property (nonatomic, copy) NSString *sourceURL;

@end
