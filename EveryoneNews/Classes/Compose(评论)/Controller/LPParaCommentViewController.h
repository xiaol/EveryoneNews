//
//  LPParaCommentViewController.h
//  EveryoneNews
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPPress;
@class LPDetailViewController;

@interface LPParaCommentViewController : UIViewController
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) UIImage *bgImage;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) int contentIndex;
@property (nonatomic, copy) NSString *commentText;
@property (nonatomic, strong) LPPress *press;
@property (nonatomic, strong) LPDetailViewController *fromVc;
@end
