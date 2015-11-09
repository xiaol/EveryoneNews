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
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) UIImage *bgImage;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) int contentIndex;
@property (nonatomic, copy) NSString *commentText;
@property (nonatomic, strong) LPDetailViewController *fromVc;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, copy) NSString *sourceURL;
@end
