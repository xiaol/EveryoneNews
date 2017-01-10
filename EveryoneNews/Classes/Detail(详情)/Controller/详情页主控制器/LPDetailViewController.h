//
//  LPDetailViewController.h
//  EveryoneNews
//
//  Created by apple on 15/5/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Card.h"
#import "LPHttpTool.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "LPDetailTopView.h"
#import "LPDetailBottomView.h"
#import "LPCommentFrame.h"
#import "LPBottomShareView.h"
#import "LPBaseViewController.h"

@class LPSearchCardFrame;
@class LPConcernCardFrame;
@class LPMyCommentFrame;
@class LPMyCollectionCardFrame;
@class LPSpecailTopicCardFrame;

// 取消收藏
@interface LPDetailViewController : LPBaseViewController
// 存储全文评论内容
@property (nonatomic,strong) NSArray *fullTextComments;
// 评论数量
@property (nonatomic, assign) NSInteger commentsCount;

// 评论相关
@property (nonatomic, strong) NSMutableArray *fulltextCommentFrames;

@property (nonatomic, strong) NSManagedObjectID *cardID;

@property (nonatomic, strong) LPDetailTopView *topView;
@property (nonatomic, strong) LPDetailBottomView *bottomView;

// 分享url
@property (nonatomic, copy) NSString *shareURL;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareImageURL;
// 相关观点
@property (nonatomic, strong) NSMutableArray *relatePointFrames;
@property (nonatomic, strong) NSArray *relatePointArray;
@property (nonatomic, assign) BOOL relatePointIsFinishedLoad;
@property (nonatomic, assign) BOOL googleSourceExistsInRelatePoint;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITableView *commentsTableView;

@property (nonatomic, strong) UIView *detailBackgroundView;
@property (nonatomic, strong) LPBottomShareView *bottomShareView;
@property (nonatomic, strong) NSNumber *isRead;

@property (nonatomic, strong) UIWindow *statusWindow;

@property (nonatomic, assign) NSInteger sourceViewController;
@property (nonatomic, strong) LPSearchCardFrame *searchCardFrame;
@property (nonatomic, strong) LPConcernCardFrame *concernCardFrame;
@property (nonatomic, strong) LPMyCommentFrame *myCommentFrame;
@property (nonatomic, strong) LPMyCollectionCardFrame *myCollectionCardFrame;
@property (nonatomic, strong) LPSpecailTopicCardFrame *specialTopicCardFrame;

@property (nonatomic, copy) NSString *remotePushNid;
@property (nonatomic, copy) NSString *sourceImageURL;


- (void)removeBackgroundView;

- (NSString *)docId;

@end
