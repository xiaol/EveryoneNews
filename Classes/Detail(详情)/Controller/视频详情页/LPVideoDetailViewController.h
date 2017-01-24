//
//  LPVideoDetailViewController.h
//  AVPlayerDemo
//
//  Created by dongdan on 2016/12/22.
//  Copyright © 2016年 dongdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPBaseViewController.h"

@class LPPlayerView;
@class LPPlayerModel;
@class Card;
@class LPDetailBottomView;
@class LPSearchCardFrame;
@class LPConcernCardFrame;
@class LPMyCommentFrame;
@class LPMyCollectionCardFrame;

typedef void(^VideoDetailControllerBlock)();

@interface LPVideoDetailViewController : LPBaseViewController

@property (nonatomic, strong) LPPlayerView *playerView;

@property (nonatomic, strong) Card *card;

@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, copy) VideoDetailControllerBlock videoDetailControllerBlock;

// 存储全文评论内容
@property (nonatomic,strong) NSArray *fullTextComments;
// 评论数量
@property (nonatomic, assign) NSInteger commentsCount;

// 评论相关
@property (nonatomic, strong) NSMutableArray *fulltextCommentFrames;
@property (nonatomic, strong) LPDetailBottomView *bottomView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITableView *commentsTableView;

// 奇点频道跳转
@property (nonatomic, assign, getter=isQidianChannel) BOOL qidianChannel;

@property (nonatomic, assign) NSInteger sourceViewController;
@property (nonatomic, strong) LPSearchCardFrame *searchCardFrame;
@property (nonatomic, strong) LPConcernCardFrame *concernCardFrame;
@property (nonatomic, strong) LPMyCommentFrame *myCommentFrame;
@property (nonatomic, strong) LPMyCollectionCardFrame *myCollectionCardFrame;
 
- (void)videoDetailLoadFailed;

@end
