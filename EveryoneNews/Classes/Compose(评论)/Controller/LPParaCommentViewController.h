//
//  LPParaCommentViewController.h
//  EveryoneNews
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPDetailViewController;

@interface LPParaCommentViewController : LPBaseViewController
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) UIImage *bgImage;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) int contentIndex;
@property (nonatomic, copy) NSString *commentText;
@property (nonatomic, strong) LPDetailViewController *fromVc;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, copy) NSString *sourceURL;
@end
