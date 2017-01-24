//
//  LPVideoDetailViewController.m
//  AVPlayerDemo
//
//  Created by dongdan on 2016/12/22.
//  Copyright © 2016年 dongdan. All rights reserved.
//

#import "LPVideoDetailViewController.h"
#import "LPPlayerView.h"
#import "LPPlayerModel.h"
#import "Card.h"
#import "LPPlayerControlView.h"
#import "LPComment.h"
#import "LPCommentFrame.h"
#import "AccountTool.h"
#import "MBProgressHUD+MJ.h"
#import "LPFullCommentCell.h"
#import "LPFullCommentFrame.h"
#import "LPHttpTool.h"
#import "LPLoadingView.h"
#import "LPContent.h"
#import "LPContentFrame.h"
#import "LPComment.h"
#import "LPContentCell.h"
#import "UIImageView+WebCache.h"
#import "LPWaterfallView.h"
#import "AccountTool.h"
#import "MBProgressHUD+MJ.h"
#import "MainNavigationController.h"
#import "LPRelateView.h"
#import "CardFrame.h"
#import "CardImage.h"
#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "MobClick.h"
#import "LPCommentCell.h"
#import "LPRelateCell.h"
#import "LPDetailViewController+Share.h"
#import "LPDetailViewController+RelatePoint.h"
#import "LPFontSizeManager.h"
#import "UIControl+Swizzle.h"
#import "NSTimer+Additions.h"
#import "LPRelatePointFooter.h"
#import <libkern/OSAtomic.h>
#import "LPRelatePoint.h"
#import "LPRelateFrame.h"
#import "LPDetailChangeFontSizeView.h"
#import "LPFullCommentCell.h"
#import "LPFullCommentFrame.h"
#import "LPLoadFooter.h"
#import "LPDetailScrollView.h"
#import "LPDetailTipView.h"
#import "Card+Create.h"
#import <SafariServices/SafariServices.h>
#import "Comment+Create.h"
#import <WebKit/WebKit.h>
#import "LPSearchCardFrame.h"
#import "LPSearchCard.h"
#import "LPConcernDetailViewController.h"
#import "LPConcernCardFrame.h"
#import "LPConcernCard.h"
#import "LPMyCommentFrame.h"
#import "LPMyComment.h"
#import "LPMyCollectionCardFrame.h"
#import "LPMyCollectionCard.h"
#import "CollectionTool.h"
#import "Card+Create.h"
#import "LPSearchResultViewController.h"
#import "TFHpple.h"
#import "LPFontSize.h"
#import "LPSpecailTopicCardFrame.h"
#import "LPSpecialTopicCard.h"
#import "LPLoadingView.h"

// --- 分割线
#import "LPDetailBottomView.h"
#import "LPDetailVideoCell.h"
#import "LPDetailVideoFrame.h"
#import "LPVideoModel.h"
#import "LPAdRequestTool.h"
#import "LPAdsDetailViewController.h"
#import "CardTool.h"



@interface LPVideoDetailViewController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate,LPPlayerDelegate, LPDetailBottomViewDelegate, LPFullCommentCellDelegate,LPCommentCellDelegate, LPDetailVideoCellDelegate, UITextViewDelegate>

@property (nonatomic, strong) LPPlayerModel *playerModel;
@property (nonatomic, strong) LPPlayerControlView *videoDetailControlView;

@property (nonatomic, assign) CGFloat lastContentOffsetY;

@property (nonatomic, assign) CGFloat lastContentOffsetX;

@property (nonatomic, strong) NSMutableArray *contentArray;

@property (nonatomic, strong) NSArray *relates;

@property (nonatomic, strong) LPHttpTool *http;

@property (nonatomic, strong)   UIImageView *animationImageView;

@property (nonatomic, strong) UILabel *loadingLabel;

@property (nonatomic, strong) UIView *contentLoadingView;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger stayTimeInterval;

@property (nonatomic, strong) NSMutableDictionary *contentDictionary;

@property (nonatomic, strong) NSMutableDictionary *heightDictionary;

@property (nonatomic, strong) NSMutableArray *contentFrames;

@property (nonatomic, strong) LPDetailChangeFontSizeView *changeFontSizeView;

@property (nonatomic, copy) NSString *submitDocID;

@property (nonatomic, copy) NSString *contentTitle;

@property (nonatomic, copy) NSString *pubTime;

@property (nonatomic, copy) NSString *pubName;

@property (nonatomic, strong) UIPageControl *pageControl;

// 精选评论
@property (nonatomic, strong) NSMutableArray *excellentCommentsFrames;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) UIScrollView *scrollView;
// 没有评论视图框
@property (nonatomic, strong) UIView *noCommentView;
@property (nonatomic, strong) UIView *composeCommentBackgroundView;
@property (nonatomic, strong) UIView *textViewBg;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *composeButton;

@property (nonatomic, strong) UIView *leftView;
// 关心本文图标
@property (nonatomic, strong) UIImageView *concernImageView;
// 关心本文数量
@property (nonatomic, strong) UILabel *concernCountLabel;
@property (nonatomic, copy) NSString *concernCount;

@property (nonatomic, strong) UIView *contentBottomView;
// 重新加载提示信息
@property (nonatomic, strong) UIView *reloadPage;

@property (nonatomic, assign, getter=isComposeComment) BOOL composeComment;

@property (nonatomic, strong) NSNumber *channel;
@property (nonatomic, copy) NSString *sourceSiteName;

// 关注
@property (nonatomic, strong) UIImageView *forwardImageView;
@property (nonatomic, strong) UIImageView *focusImageView;
@property (nonatomic, strong) UILabel *focusLabel;
@property (nonatomic, strong) UIView *focusBlurBackgroundView;
// 关注状态
@property (nonatomic, copy) NSString *conpubFlag;

// 关心本文状态
@property (nonatomic, copy) NSString *conFlag;
@property (nonatomic, copy) NSString *colFlag;

@property (nonatomic, copy) NSString *selectedText;

// --------------------- 分割线 ---------------------------------
@property (nonatomic, strong) UIView *topView;

// 相关视频
@property (nonatomic, strong) NSArray *relateVideoArray;
@property (nonatomic, strong) NSMutableArray *relateVideoFrames;
@property (nonatomic, copy) NSString *sourceImageURL;
@property (nonatomic, strong) UIImageView *detailVideoImageView;
// 正在加载
@property (nonatomic, strong) LPLoadingView *loadingView;
// 分享
@property (nonatomic, strong) UIButton *shareButton;
// 返回
@property (nonatomic, strong) UIButton *backBtn;

// 相关视频nid
@property (nonatomic, copy) NSString *videoNid;
// 相关视频docID
@property (nonatomic, copy) NSString *videoDocID;
// 是否是点击相关视频
@property (nonatomic, assign, getter=isRelateVideo) BOOL relateVideo;

// 详情页面广告
@property (nonatomic, strong) UIImageView *adsImageView;
@property (nonatomic, copy) NSString *adsImageUrl;
@property (nonatomic, copy) NSString *adsImpression;
@property (nonatomic, copy) NSString *adsPuburl;
@property (nonatomic, assign) BOOL adsSuccess;
@property (nonatomic, copy) NSString *adsTitle;
@property (nonatomic, strong) UIView *headerView;


@end

@implementation LPVideoDetailViewController


#pragma mark - 懒加载
- (NSString *)docId {
    if (self.isRelateVideo) {
        return self.videoDocID;
    } else {
        switch (self.sourceViewController) {
                
            case searchSource:
                return  self.searchCardFrame.card.docId;
                break;
            case concernHistorySource:
                return  self.concernCardFrame.card.docId;
                break;
            case remoteNotificationSource:
                return nil;
                break;
            case commentSource:
                return  self.myCommentFrame.comment.docID;
                break;
            case collectionSource:
                return   self.myCollectionCardFrame.card.docId;
                break;
            default:
                return [[self card] valueForKey:@"docId"];
                break;
        }
    }
}

- (NSString *)nid {
    if (self.isRelateVideo) {
          return self.videoNid;
    } else {
        switch (self.sourceViewController) {
            case searchSource:
                return [NSString stringWithFormat:@"%@", self.searchCardFrame.card.nid];
                break;
            case concernHistorySource:
                return [NSString stringWithFormat:@"%@", self.concernCardFrame.card.nid];
                break;
            case commentSource:
                return [NSString stringWithFormat:@"%@", self.myCommentFrame.comment.nid];
                break;
                
            case collectionSource:
                return [NSString stringWithFormat:@"%@",  self.myCollectionCardFrame.card.nid];
                break;
                
            default:
                return [[self card] valueForKey:@"nid"];
                break;
        }
 
    }
}

- (NSMutableArray *)relateVideoFrames {
    if (_relateVideoFrames == nil) {
        _relateVideoFrames = [NSMutableArray array];
    }
    return _relateVideoFrames;
}

- (NSMutableArray*)fulltextCommentFrames {
    if (_fulltextCommentFrames == nil) {
        _fulltextCommentFrames = [NSMutableArray array];
    }
    return _fulltextCommentFrames;
}

- (NSMutableArray *)excellentCommentsFrames {
    if (_excellentCommentsFrames == nil) {
        _excellentCommentsFrames = [NSMutableArray array];
    }
    return _excellentCommentsFrames;
}

- (LPPlayerControlView *)videoDetailControlView {
    if (!_videoDetailControlView) {
        _videoDetailControlView = [[LPPlayerControlView alloc] init];
    }
    return _videoDetailControlView;
}

- (LPPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [LPPlayerView sharedPlayerView];
        _playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;
        
    }
    return _playerView;
}


#pragma mark -   viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6"];
    [self setupData];
    [self setupSubviews];
    [self setupBottomView];
    
    [noteCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [noteCenter addObserver:self  selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - subview

- (void)setupData {
    
    // 详情页视频
    void (^contentBlock)(id json) = ^(id json) {
        if ([json[@"code"] integerValue] == 2000) {
            NSMutableDictionary *dict = json[@"data"];
            NSString *title = dict[@"title"];
            NSString *pubTime = dict[@"ptime"];
            NSString *pubName = dict[@"pname"];
            NSString *concern = [NSString stringWithFormat:@"%@", dict[@"concern"]] ;
            
            self.concernCount = concern;
            self.contentTitle = title;
            self.pubTime = pubTime;
            self.pubName = pubName;
            
            if (self.isRelateVideo || self.playerModel.videoURL == nil) {

                self.videoDocID = dict[@"docid"];
                self.submitDocID = dict[@"docid"];
                
                
                NSString *thumbnail =  dict[@"thumbnail"];
                LPPlayerModel *playerModel = [[LPPlayerModel alloc] init];
                playerModel.title = title;
                playerModel.videoURL = [NSURL URLWithString:dict[@"videourl"]];
                

                playerModel.placeHolderImageURLString = thumbnail;
                playerModel.tableView = nil;
                playerModel.indexPath = nil;

                
                NSURL *coverImageURL = [NSURL URLWithString:thumbnail];
                UIImage *coverPlaceHolder = [UIImage imageNamed:@"video_background"];
                [self.detailVideoImageView sd_setImageWithURL:coverImageURL placeholderImage:coverPlaceHolder];
                
                playerModel.parentView =  self.detailVideoImageView ;
                self.playerModel = playerModel;
                
                
                [self.playerView resetToPlayNewVideo:playerModel];
                [self.playerView playerControlView:self.videoDetailControlView playerModel:playerModel];
                [self.playerView autoPlayVideo];
            } else {
                self.submitDocID = dict[@"docid"];
              
            }
            self.channel = dict[@"channel"];
            // 更新详情页评论数量
            self.commentsCount = [dict[@"comment"] integerValue];
            
            self.bottomView.badgeNumber = self.commentsCount ;

            // 关注本文
            NSString *conpubFlag = [dict[@"conpubflag"] stringValue];
            self.conpubFlag = conpubFlag;

            // 关心本文
            NSString *conFlag = [dict[@"conflag"] stringValue];
            self.conFlag = conFlag;
            
            // 收藏状态
            NSString *colFlag = [dict[@"colflag"] stringValue];
            self.colFlag = colFlag;
        }
    };
    // 热门评论
    void (^excellentCommentsBlock)(id json) = ^(id json) {
        //NSLog(@"精选评论--%@", json[@"code"]);
        if ([json[@"code"] integerValue] == 2000) {
            [self.excellentCommentsFrames removeAllObjects];
            NSArray *commentsArray = json[@"data"];
            int i = 0;
            for (NSDictionary *dict in commentsArray) {
                i++;
                // 精选评论
                LPComment *excellentComment = [[LPComment alloc] init];
                excellentComment.srcText = dict[@"content"];
                excellentComment.createTime = dict[@"ctime"];
                excellentComment.up = [NSString stringWithFormat:@"%@", dict[@"commend"]] ;
                excellentComment.userIcon = dict[@"avatar"];
                excellentComment.userName = dict[@"uname"];
                excellentComment.color = [UIColor colorFromHexString:@"#747474"];
                excellentComment.isPraiseFlag = [NSString stringWithFormat:@"%@", dict[@"upflag"]] ;
                excellentComment.Id = dict[@"id"];
                
                LPCommentFrame *excellentCommentFrame = [[LPCommentFrame alloc] init];
                excellentCommentFrame.comment = excellentComment;
                excellentCommentFrame.currentIndex = i;
                excellentCommentFrame.totalCount = commentsArray.count > 3 ? 3 : commentsArray.count;
                [self.excellentCommentsFrames addObject:excellentCommentFrame];
                
                if (self.excellentCommentsFrames.count == 3) {
                    break;
                }
            }
         
        }
    };
    // 全部评论
    void (^commentsBlock)(id json) = ^(id json) {
        //NSLog(@"全文评论--%@", json[@"code"]);
        if ([json[@"code"] integerValue] == 2000) {
            [self.fulltextCommentFrames removeAllObjects];
            NSArray *commentsArray = json[@"data"];
            for (NSDictionary *dict in commentsArray) {
                
                LPComment *comment = [[LPComment alloc] init];
                comment.srcText = dict[@"content"];
                comment.createTime = dict[@"ctime"];
                comment.up = [NSString stringWithFormat:@"%@", dict[@"commend"]] ;
                comment.userIcon = dict[@"avatar"];
                comment.userName = dict[@"uname"];
                comment.color = [UIColor colorFromHexString:@"#747474"];
                comment.isPraiseFlag = [NSString stringWithFormat:@"%@", dict[@"upflag"]] ;
                comment.Id = dict[@"id"];
                
                LPFullCommentFrame *commentFrame = [[LPFullCommentFrame alloc] init];
                commentFrame.comment = comment;
                [self.fulltextCommentFrames addObject:commentFrame];
                
                if (self.fulltextCommentFrames.count > 0) {
                    self.commentsTableView.scrollEnabled = YES;
                }
            }
            self.pageIndex = 1;
        }
    };
    // 相关视频
    void (^relateVideoBlock)(id json) = ^(id json) {
        if ([json[@"code"] integerValue] == 2000) {
            [self.relateVideoFrames removeAllObjects];
            NSArray *relateVideoArray = json[@"data"];
            for (NSDictionary *dict in relateVideoArray) {
                LPVideoModel *video = [[LPVideoModel alloc] init];
                video.title = dict[@"title"];
                video.thumbnail = dict[@"img"];
                video.sourceName = dict[@"pname"];
                video.duration = [dict[@"duration"] integerValue];
                video.nid = dict[@"nid"];
                LPDetailVideoFrame *videoFrame = [[LPDetailVideoFrame alloc] init];
                videoFrame.videoModel = video;
                [self.relateVideoFrames addObject:videoFrame];
            }
        }
    };
    
    self.adsSuccess = NO;
    void (^adsBlock)(id json) = ^(id json) {
        if ([json[@"code"] integerValue] == 2000) {
            NSArray *adsArray = json[@"data"];
            if (adsArray.count > 0) {
                NSDictionary *adsDict = [adsArray objectAtIndex:0];
                NSArray *images = adsDict[@"imgs"];
                NSArray *impression = adsDict[@"adimpression"];
                if (images.count > 0 && impression.count > 0) {
                    self.adsImageUrl = [images objectAtIndex:0];
                    self.adsImpression = [impression objectAtIndex:0];
                    self.adsPuburl = adsDict[@"purl"];
                    self.adsTitle = adsDict[@"title"];
                    self.adsSuccess = YES;
                    
                    [self setupHeaderView:self.contentTitle pubTime:self.pubName pubName:self.pubName];
                }
                
            }
            
        }
    };
    
    void (^reloadTableViewBlock)() = ^{
        [self.tableView reloadData];
        [self noCommentsViewTip];
        [self.commentsTableView reloadData];
        [self hideLoadingView];
        self.tableView.hidden = NO;
        self.bottomView.userInteractionEnabled = YES;
    };
    
    // 详情页正文
    NSMutableDictionary *detailContentParams = [NSMutableDictionary dictionary];
    NSString *detailContentURL = [NSString stringWithFormat:@"%@/v2/vi/con", ServerUrlVersion2];
    NSString *uid = [userDefaults objectForKey:@"uid"];
    detailContentParams[@"nid"] = [self nid];
    detailContentParams[@"uid"] = uid;

    // 精选评论
    NSString *excellentDetailCommentsURL = [NSString stringWithFormat:@"%@/v2/ns/coms/h", ServerUrlVersion2];
    NSMutableDictionary *excellentDetailCommentsParams = [NSMutableDictionary dictionary];
    excellentDetailCommentsParams[@"uid"] = [userDefaults objectForKey:@"uid"];
    
    // 相关视频
    NSMutableDictionary *detailRelateVideoParams = [NSMutableDictionary dictionary];
    detailRelateVideoParams[@"nid"] = [self nid];
    NSString *relateURL = [NSString stringWithFormat:@"%@/v2/ns/asc", ServerUrlVersion2];
    
    // 全文评论
    NSString *detailCommentsURL = [NSString stringWithFormat:@"%@/v2/ns/coms/c", ServerUrlVersion2];
    NSMutableDictionary *detailCommentsParams = [NSMutableDictionary dictionary];

    detailCommentsParams[@"p"] = @(1);
    detailCommentsParams[@"c"] = @"20";
    detailCommentsParams[@"uid"] = [userDefaults objectForKey:@"uid"];
    
    
    NSString *adsURL = [NSString stringWithFormat:@"%@/v2/ns/ad", ServerUrlVersion2];
    NSMutableDictionary *adsParams = [NSMutableDictionary dictionary];
    adsParams[@"uid"] = [userDefaults objectForKey:@"uid"];
    adsParams[@"b"] = [LPAdRequestTool adBase64WithType:@"243"];
    adsParams[@"s"] = @(1);
    
    // 详情页正文
    [LPHttpTool getWithURL:detailContentURL params:detailContentParams success:^(id json) {
        contentBlock(json);
        NSString *videoDocID = [[[self docId] stringByBase64Encoding] stringByTrimmingString:@"="] ;
        NSLog(@"正文");
        excellentDetailCommentsParams[@"did"] = videoDocID;
        detailCommentsParams[@"did"] = videoDocID;
        [LPHttpTool getWithURL:relateURL params:detailRelateVideoParams success:^(id json) {
            relateVideoBlock(json);
            NSLog(@"相关视频");
            // 详情页精选评论
            [LPHttpTool getWithURL:excellentDetailCommentsURL params:excellentDetailCommentsParams success:^(id json) {
                NSLog(@"精选评论");
                excellentCommentsBlock(json);
                // 全文评论
                [LPHttpTool getWithURL:detailCommentsURL params:detailCommentsParams success:^(id json) {
                    NSLog(@"全文评论");
                    commentsBlock(json);
                    [LPHttpTool postJSONWithURL:adsURL params:adsParams success:^(id json) {
                        adsBlock(json);
                        reloadTableViewBlock();
                    } failure:^(NSError *error) {
                        
                    }];
                    
                } failure:^(NSError *error) {
                    NSLog(@"全文评论：%@", error);
                }];
                
            } failure:^(NSError *error) {
                NSLog(@"相关视频：%@", error);
                
            }];
            
        } failure:^(NSError *error) {
            NSLog(@"精选评论：%@", error);
        }];
        
    } failure:^(NSError *error) {
        NSLog(@"正文：%@", error);
    }];
    
}

#pragma mark - setupSubviews

- (void)setupSubviews {
    
    [self setupVideoImageView];
  
    [self setupScrollView];
    [self setupTopView];
    [self setupBottomView];
 
}

#pragma mark - 无评论提示
- (void)setupNoCommentView {
    CGFloat imageViewH = 90;
    CGFloat imageViewW = 83;
    CGFloat imageViewX = (ScreenWidth - imageViewW) / 2.0f;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qiangshafa"]];
    imageView.frame = CGRectMake(imageViewX, 0, imageViewW, imageViewH);
    
    NSString *noCommentStr = @"还不快来抢沙发";
    CGSize size = [noCommentStr sizeWithFont:[UIFont systemFontOfSize:LPFont4] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    UILabel *noCommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), ScreenWidth - 1, size.height)];
    noCommentLabel.text = noCommentStr;
    noCommentLabel.font = [UIFont systemFontOfSize:LPFont4];
    noCommentLabel.textColor = [UIColor colorFromHexString:@"#888888"];
    noCommentLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView *noCommentView = [[UIView alloc] init];
    [noCommentView addSubview:imageView];
    [noCommentView addSubview:noCommentLabel];
    
    [self.scrollView addSubview:noCommentView];
    self.noCommentView = noCommentView;
    self.noCommentView.hidden = YES;
}


#pragma mark - setupLoadingView
- (void)setupLoadingView {
    
    CGFloat loadingViewX = 0;
    CGFloat loadingViewY = CGRectGetMaxY(self.detailVideoImageView.frame) + StatusBarHeight;
    CGFloat loadingViewW = ScreenWidth;
    CGFloat loadingViewH = (ScreenHeight - loadingViewY) / 2;
    
    LPLoadingView *loadingView = [[LPLoadingView alloc] initWithFrame:CGRectMake(loadingViewX, loadingViewY, loadingViewW, loadingViewH)];
    [self.view addSubview:loadingView];
    self.loadingView = loadingView;
}

- (void)showLoadingView {
    [self.loadingView startAnimating];
}

- (void)hideLoadingView {
    [self.loadingView stopAnimating];
}


#pragma mark - setupVideoImageView
- (void)setupVideoImageView {
    CGFloat imageViewX = 0 ;
    CGFloat imageViewY = StatusBarHeight;
    CGFloat imageViewW = ScreenWidth;
    CGFloat imageViewH = 211 * imageViewW / 375;

    UIImageView *detailVideoImageView = [[UIImageView alloc] init];
    detailVideoImageView.userInteractionEnabled = YES;
    detailVideoImageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    
    LPPlayerModel *playerModel = [[LPPlayerModel alloc] init];
    switch (self.sourceViewController) {
        case commentSource:
            playerModel.title = @"";
            playerModel.videoURL = nil;
            playerModel.placeHolderImageURLString = @"";
            break;
            
        case collectionSource:
            playerModel.title = self.myCollectionCardFrame.card.title;
            playerModel.videoURL = [NSURL URLWithString:self.myCollectionCardFrame.card.videoURL] ;
            playerModel.placeHolderImageURLString = self.myCollectionCardFrame.card.thumbnail;
            break;
            
        default:
            playerModel.title = self.card.title;
            playerModel.videoURL = [NSURL URLWithString:self.card.videoUrl] ;
            playerModel.placeHolderImageURLString = self.card.thumbnail;
            break;
    }

    playerModel.tableView = nil;
    playerModel.indexPath  = nil;
    playerModel.parentView = detailVideoImageView;

    self.playerModel = playerModel;

    NSURL *coverImageURL = [NSURL URLWithString:self.card.thumbnail];
    UIImage *coverPlaceHolder = [UIImage imageNamed:@"video_background"];
    [detailVideoImageView sd_setImageWithURL:coverImageURL placeholderImage:coverPlaceHolder];
 
    self.detailVideoImageView = detailVideoImageView;

    if (self.isPlaying) {

        self.playerView.delegate = self;
        self.playerView.playerModel = playerModel;
       
        [self.playerView play];
    } else {
        [self.playerView playerControlView:self.videoDetailControlView playerModel:playerModel];
        [self.playerView autoPlayVideo];
     }
    
}

#pragma mark - setupScrollView 
- (void)setupScrollView {
    
    __weak typeof(self) weakSelf = self;
    CGFloat bottomViewHeight = 40.0f;
    if (iPhone6Plus) {
        bottomViewHeight = 48.5f;
        
    }

    CGFloat scrollViewX = 0;
    CGFloat scrollViewY = 0;
    CGFloat scrollViewW = ScreenWidth;
    CGFloat scrollViewH = ScreenHeight - bottomViewHeight;
    
    LPDetailScrollView *scrollView = [[LPDetailScrollView alloc] initWithFrame:CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH)] ;
    self.automaticallyAdjustsScrollViewInsets = NO;
    scrollView.bounces = NO;
    scrollView.contentInset = UIEdgeInsetsZero;
    scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0,0.0,0.0,0.0);
    scrollView.contentSize = CGSizeMake(scrollViewW * 2, scrollViewH);
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.scrollsToTop = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    [scrollView addSubview:self.detailVideoImageView];
    
    // 文章内容
    CGFloat tableViewX = 0;
    CGFloat tableViewY = CGRectGetMaxY(self.detailVideoImageView.frame);
    CGFloat tableViewW = ScreenWidth;
    CGFloat tableViewH = ScreenHeight - tableViewY - bottomViewHeight;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame: CGRectMake(tableViewX, tableViewY,tableViewW, tableViewH) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.hidden = YES;
    tableView.scrollsToTop = YES;
    self.tableView = tableView;
    [scrollView addSubview:tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //---------------------- 评论列表 ---------------------
    CGFloat commentsTableViewH = ScreenHeight - (StatusBarHeight + TabBarHeight + 0.5 + bottomViewHeight) ;
    CGFloat commentsTableViewY = StatusBarHeight + TabBarHeight;
    UITableView *commentsTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth + 1, commentsTableViewY, ScreenWidth - 1, commentsTableViewH) style:UITableViewStyleGrouped];
    commentsTableView.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6"];
    commentsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    commentsTableView.delegate = self;
    commentsTableView.dataSource = self;
    commentsTableView.scrollEnabled = NO;
    commentsTableView.scrollsToTop = NO;
    
    self.commentsTableView = commentsTableView;
    // 上拉加载更多
    self.commentsTableView.mj_footer = [LPLoadFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreCommentsData];
    }];
    [scrollView addSubview:commentsTableView];
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = 2;
    [self.view addSubview:pageControl];
    
    self.pageControl = pageControl;
    
    [self setupLoadingView];
    [self showLoadingView];
    
    [self setupNoCommentView];
    
}

#pragma mark - setupTopView
- (void)setupTopView {
    // 分享，评论，添加按钮边距设置
    CGFloat topViewHeight = TabBarHeight + StatusBarHeight + 0.5;
    CGFloat padding = 15;
    
    CGFloat returnButtonWidth = 13;
    CGFloat returnButtonHeight = 22;
    
    if (iPhone6Plus) {
        returnButtonWidth = 12;
        returnButtonHeight = 21;
    }
    CGFloat shareButtonW = 25;
    CGFloat shareButtonH = 5;
    CGFloat shareButtonX = ScreenWidth - padding - shareButtonW;
    
    if (iPhone6) {
        topViewHeight = 72;
    }
    CGFloat returnButtonPaddingTop = (topViewHeight - returnButtonHeight + StatusBarHeight) / 2;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0 , 0, ScreenWidth, topViewHeight)];
    // 返回button
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(padding, returnButtonPaddingTop, returnButtonWidth, returnButtonHeight)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"video_back"] forState:UIControlStateNormal];
    backBtn.enlargedEdge = 15;
    [backBtn addTarget:self action:@selector(topViewBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    self.backBtn = backBtn;
    
    // 详情页右上角分享
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(shareButtonX, 0 , shareButtonW, shareButtonH)];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"video_share_white"] forState:UIControlStateNormal];
    shareBtn.centerY = backBtn.centerY;
    shareBtn.enlargedEdge = 15;
    [shareBtn addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.shareButton = shareBtn;
    [topView addSubview:shareBtn];
    
    [self.view addSubview:topView];
}

#pragma mark - 详情页标题
- (void)setupHeaderView:(NSString *)title pubTime:(NSString *)pubtime pubName:(NSString *)pubName {
    
    NSString *sourceSiteName = [pubName  isEqualToString: @""] ? @"未知来源": pubName;
    
    self.sourceSiteName = sourceSiteName;
    
    CGFloat padding = 13;
    if (iPhone6Plus) {
        padding = 19;
    } else if (iPhone6) {
        padding = 16;
    }
    
    //--------------------- 内容页面标题 ----------------------
    UIView *contentHeaderView = [[UIView alloc] init];
    
    LPFontSize *lpFontSize = [LPFontSizeManager sharedManager].lpFontSize;
    CGFloat contentFontSize = lpFontSize.currentDetailContentFontSize;
    CGFloat titleFontSize = lpFontSize.currentDetaiTitleFontSize;
    CGFloat sourceFontSize = lpFontSize.currentDetailSourceFontSize;;
    
    CGFloat titleX = padding;
    CGFloat titleW = ScreenWidth - padding * 2;
    
    // 正文标题
    UILabel *contentTitleLabel = [[UILabel alloc] init];
    contentTitleLabel.numberOfLines = 0;
    contentTitleLabel.font = [UIFont systemFontOfSize:contentFontSize];
    NSMutableAttributedString *contentTitleString = [title attributedStringWithFont:[UIFont  systemFontOfSize:contentFontSize] color:[UIColor colorFromHexString:LPColor1] lineSpacing:2.0f];
    CGFloat contentTitleH = [contentTitleString heightWithConstraintWidth:titleW] + 2;
    CGFloat contentTitleY = 14;
    contentTitleLabel.frame = CGRectMake(titleX, contentTitleY, titleW, contentTitleH);
    contentTitleLabel.attributedText = contentTitleString;
    [contentHeaderView addSubview:contentTitleLabel];
    
    // 关心本文
    CGFloat bottomPaddingY = 20;
    if (iPhone6) {
        bottomPaddingY = 22;
    }
    CGFloat contentBottomViewY = CGRectGetMaxY(contentTitleLabel.frame);
    
    UIView *contentBottomView = [[UIView alloc] init];
    
    // 关心本文数量
    CGFloat labelFontSize = 13;
    CGFloat labelW = [self.concernCount sizeWithFont:[UIFont systemFontOfSize:labelFontSize] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width + 2;
    
    CGFloat concernImageViewH = 16;
    CGFloat concernImageViewW = 18;
    
    
    CGFloat leftViewX = 18;
    CGFloat leftViewY = bottomPaddingY;
    CGFloat leftViewW = concernImageViewW + labelW + 43;
    CGFloat leftViewH = 29;
    CGFloat concernImageViewY = (leftViewH - concernImageViewH) / 2;
    
    if (iPhone6) {
        leftViewH = 28;
    }
    
    CGFloat concernImageViewX = 19;
    if (iPhone6) {
        concernImageViewX = 18;
    }
    
    UIView *leftView = [[UIView alloc] init];
    
    // 关心本文图标
    UIImageView *concernImageView = [[UIImageView alloc] initWithFrame:CGRectMake(concernImageViewX, concernImageViewY, concernImageViewW, concernImageViewH)];
    
    UITapGestureRecognizer *tapConcernGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapConcern)];
    [leftView addGestureRecognizer:tapConcernGesture];
    concernImageView.image = [UIImage imageNamed:@"详情页心未关注"];
    leftView.userInteractionEnabled = YES;
    [leftView addSubview:concernImageView];
    self.concernImageView = concernImageView;
    
    self.leftView = leftView;
    
    // 关心本文数量
    CGFloat labelY = concernImageViewY;
    CGFloat labelH = concernImageViewH;
    UILabel *concernCountLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetMaxX(concernImageView.frame) + 7), labelY, labelW, labelH)];
    concernCountLabel.font = [UIFont systemFontOfSize:labelFontSize];
    concernCountLabel.textColor = [UIColor colorFromHexString:@"#e94221"];
    concernCountLabel.text = self.concernCount;
    [leftView addSubview:concernCountLabel];
    self.concernCountLabel = concernCountLabel;
    
    CGFloat borderRadius = 14.0f;
    
    leftView.frame = CGRectMake(leftViewX, leftViewY, leftViewW, leftViewH);
    leftView.layer.borderWidth = 1;
    leftView.layer.borderColor = [UIColor colorFromHexString:LPColor5].CGColor;
    leftView.layer.cornerRadius = borderRadius;
    [contentBottomView addSubview:leftView];
    self.contentBottomView = contentBottomView;
    
    // 详情页关注
    CGFloat focusViewPaddingTop = 30;
    
    CGFloat focusViewY = CGRectGetMaxY(leftView.frame) + focusViewPaddingTop;
    CGFloat focusViewX = leftViewX;
    CGFloat focusViewW = ScreenWidth - 2 * leftViewX;
    CGFloat focusViewH = 70;
    
    UIView *focusView = [[UIView alloc] initWithFrame:CGRectMake(focusViewX, focusViewY, focusViewW, focusViewH)];
    focusView.userInteractionEnabled = YES;
    focusView.backgroundColor = [UIColor whiteColor];
    [contentBottomView addSubview:focusView];
    UITapGestureRecognizer *focusViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusViewTap)];
    [focusView addGestureRecognizer:focusViewTapGesture];
    
    
    CGFloat rightFocusViewW = 80;
    CGFloat rightFocusViewH = 70;
    CGFloat rightFocusViewX = focusViewW - rightFocusViewW;
    CGFloat rightFocusViewY = 0;
    
    UIView *rightFocusView = [[UIView alloc] initWithFrame:CGRectMake(rightFocusViewX, rightFocusViewY, rightFocusViewW, rightFocusViewH)];
    rightFocusView.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer *rightFocusViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightFocusViewTapGesture)];
    [rightFocusView addGestureRecognizer:rightFocusViewTap];
    
    CGFloat focusImageViewW = 18;
    CGFloat focusImageViewH = 18;
    CGFloat focusImageViewX = (rightFocusViewW - focusImageViewW) / 2;
    NSString *focusStr = @"关注";
    CGFloat focusLabelW = [focusStr sizeWithFont:[UIFont systemFontOfSize:LPFont11] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
    CGFloat focusLabelH = [focusStr sizeWithFont:[UIFont systemFontOfSize:LPFont11] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
    
    CGFloat focusLabelPaddingTop = 8;
    CGFloat focusImageViewY = (rightFocusViewH - focusImageViewH - focusLabelH - focusLabelPaddingTop) / 2;
    CGFloat focusLabelX = (rightFocusViewW - focusLabelW) / 2;
    
    
    UIImageView *focusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(focusImageViewX, focusImageViewY, focusImageViewW, focusImageViewH)];
    focusImageView.image = [UIImage imageNamed:@"详情页关注加号"];
    focusImageView.userInteractionEnabled = NO;
    CGFloat focusLabelY = CGRectGetMaxY(focusImageView.frame) + focusLabelPaddingTop;
    
    
    UILabel *focusLabel = [[UILabel alloc] initWithFrame:CGRectMake(focusLabelX, focusLabelY, focusLabelW, focusLabelH)];
    focusLabel.text = focusStr;
    focusLabel.font = [UIFont systemFontOfSize:LPFont11];
    focusLabel.textColor = [UIColor colorFromHexString:@"#e94221"];
    focusLabel.textAlignment = NSTextAlignmentCenter;
    focusLabel.userInteractionEnabled = NO;
    
    
    CGFloat forwardImageViewW = 12;
    CGFloat forwardImageViewH = 21;
    CGFloat forwardImageViewY = (rightFocusViewW - forwardImageViewH) / 2;
    CGFloat forwardImageViewX = (rightFocusViewW - forwardImageViewW) / 2;
    
    UIImageView *forwardImageView = [[UIImageView alloc] init];
    forwardImageView.image = [UIImage imageNamed:@"详情页关注前进"];
    forwardImageView.frame = CGRectMake(forwardImageViewX, forwardImageViewY, forwardImageViewW, forwardImageViewH);
    forwardImageView.hidden = YES;
    
    [rightFocusView addSubview:forwardImageView];
    [rightFocusView addSubview:focusImageView];
    [rightFocusView addSubview:focusLabel];
    [focusView addSubview:rightFocusView];
    self.forwardImageView = forwardImageView;
    self.focusImageView = focusImageView;
    self.focusLabel = focusLabel;
    
    CGFloat middleSeperatorViewW = 1.5f;
    CGFloat middleSeperatorViewH = 47;
    CGFloat middleSeperatorViewX = CGRectGetMinX(rightFocusView.frame) - middleSeperatorViewW;
    CGFloat middleSeperatorViewY = (focusViewH - middleSeperatorViewH) / 2;
    UIView *middleSeperatorView = [[UIView alloc] initWithFrame:CGRectMake(middleSeperatorViewX, middleSeperatorViewY, middleSeperatorViewW, middleSeperatorViewH)];
    middleSeperatorView.userInteractionEnabled = NO;
    middleSeperatorView.backgroundColor = [UIColor colorFromHexString:@"#e9e9e9"];
    [focusView addSubview:middleSeperatorView];
    
    
    // 关注左边视图
    CGFloat leftFocusViewX = 0;
    CGFloat leftFocusViewY = 0;
    CGFloat leftFocusViewW = (focusViewW - rightFocusViewW - middleSeperatorViewW);
    CGFloat leftFocusViewH = focusViewH;
    
    UIView *leftFocusView = [[UIView alloc] initWithFrame:CGRectMake(leftFocusViewX, leftFocusViewY, leftFocusViewW, leftFocusViewH)];
    leftFocusView.userInteractionEnabled = NO;
    
    CGFloat focusIconImageViewX = 11;
    CGFloat focusIconImageViewW = 59;
    CGFloat focusIconImageViewH = 59;
    CGFloat focusIconImageViewY = (leftFocusViewH - focusIconImageViewH) / 2;
    
    UIImageView *focusIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(focusIconImageViewX, focusIconImageViewY, focusIconImageViewW, focusIconImageViewH)];
    focusIconImageView.userInteractionEnabled = NO;
    focusIconImageView.layer.cornerRadius = focusIconImageViewW / 2.0f;
    focusIconImageView.clipsToBounds = YES;
    if ([self.sourceImageURL hasPrefix:@"来源_"]) {
        
        focusIconImageView.image = [UIImage imageNamed:@"奇点号占位图2"];
    } else {
        [focusIconImageView sd_setImageWithURL:[NSURL URLWithString:self.sourceImageURL] placeholderImage:[UIImage imageNamed:@"奇点号占位图2"]];
    }
    
    
    [leftFocusView addSubview:focusIconImageView];
    
    NSString *focusSourceSiteName = self.sourceSiteName;
    
   
    
    CGFloat focusSourceSiteNameLabelW = [focusSourceSiteName sizeWithFont:[UIFont systemFontOfSize:LPFont3] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
    CGFloat focusSourceSiteNameLabelH = [focusSourceSiteName sizeWithFont:[UIFont systemFontOfSize:LPFont3] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
    CGFloat focusSourceSiteNameLabelX = CGRectGetMaxX(focusIconImageView.frame) + 12;
    CGFloat focusSourceSiteNameLabelY = (leftFocusViewH - focusSourceSiteNameLabelH) / 2;
    
    if (focusSourceSiteNameLabelW > (leftFocusViewW - focusIconImageViewW - 24)) {
        focusSourceSiteNameLabelW = leftFocusViewW - focusIconImageViewW - 24;
    }
    
    UILabel *focusSourceSiteNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(focusSourceSiteNameLabelX, focusSourceSiteNameLabelY, focusSourceSiteNameLabelW, focusSourceSiteNameLabelH)];
    focusSourceSiteNameLabel.userInteractionEnabled = NO;
    focusSourceSiteNameLabel.text = focusSourceSiteName;
    focusSourceSiteNameLabel.font = [UIFont systemFontOfSize:LPFont3];
    focusSourceSiteNameLabel.textColor = [UIColor colorFromHexString:LPColor1];
    
    [leftFocusView addSubview:focusSourceSiteNameLabel];
    
    [focusView addSubview:leftFocusView];
    CGFloat contentBottomViewH = focusViewH + leftViewH + leftViewY + focusViewPaddingTop;
    contentBottomView.frame = CGRectMake(0, contentBottomViewY, ScreenWidth, contentBottomViewH);
    [contentHeaderView addSubview:contentBottomView];
    
    
    
    self.contentBottomView = contentBottomView;
 

    
    NSLog(@"关注状态:%@", self.conpubFlag);
    
    // 显示和隐藏关注
    if([self.conpubFlag isEqualToString:@"1"]) {
        self.forwardImageView.hidden = NO;
        self.focusImageView.hidden = YES;
        self.focusLabel.hidden = YES;
    } else {
        self.forwardImageView.hidden = YES;
        self.focusImageView.hidden = NO;
        self.focusLabel.hidden = NO;
    }
    
    // 关心状态
    if ([self.conFlag isEqualToString:@"1"]) {
        self.concernImageView.image = [UIImage imageNamed:@"详情页心已关注"];
    } else {
        self.concernImageView.image = [UIImage imageNamed:@"详情页心未关注"];
    }
    
    // 广告
    
    UIView *footerAdsView = [[UIView alloc] init];
    CGFloat footerAdsViewX = 0;
    CGFloat footerAdsViewY = CGRectGetMaxY(contentBottomView.frame);
    CGFloat footerAdsViewH = 0;
    CGFloat footerAdsViewW = ScreenWidth;
    
    if (self.adsSuccess) {
        
        UIView *adsView = [[UIView alloc] init];
        adsView.backgroundColor = [UIColor whiteColor];
        CGFloat adsViewX = BodyPadding;
        CGFloat adsViewY = 22;
        CGFloat adsViewW = ScreenWidth - 2 * BodyPadding;
        CGFloat adsViewH = 0;
        
        
        CGFloat imageX = 10;
        CGFloat imageY = 10;
        CGFloat imageW = ScreenWidth - 2 * imageX - 2 * BodyPadding;
        CGFloat imageH = (10 * imageW/ 19) ;
        UIImageView *adsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
        UIImage *placeHolder = [UIImage sharePlaceholderImage:[UIColor colorFromHexString:@"#000000" alpha:0.2f] sizes:CGSizeMake(imageW, imageH)];
        [adsImageView sd_setImageWithURL:[NSURL URLWithString:self.adsImageUrl] placeholderImage:
         placeHolder];
        self.adsImageView = adsImageView;
        
        [adsView addSubview:adsImageView];
        
        UILabel *adsLabel = [[UILabel alloc] init];
        CGFloat adsFontSize = 10;
        NSString *adsStr = @"广告";
        CGFloat adsLabelW = [adsStr sizeWithFont:[UIFont systemFontOfSize:adsFontSize] maxSize:CGSizeMake(ScreenWidth, ScreenHeight)].width + 5;
        CGFloat adsLabelH = [adsStr sizeWithFont:[UIFont systemFontOfSize:adsFontSize] maxSize:CGSizeMake(ScreenWidth, ScreenHeight)].height + 5;
        CGFloat adsLabelX = CGRectGetMaxX(adsImageView.frame) - 5 - adsLabelW;
        CGFloat adsLabelY = CGRectGetMaxY(adsImageView.frame) - 5 - adsLabelH;
        adsLabel.frame = CGRectMake(adsLabelX, adsLabelY, adsLabelW, adsLabelH);
        adsLabel.textColor = [UIColor whiteColor];
        adsLabel.font = [UIFont systemFontOfSize:adsFontSize];
        adsLabel.clipsToBounds = YES;
        adsLabel.layer.cornerRadius = 5;
        adsLabel.backgroundColor = [UIColor colorFromHexString:@"#000000" alpha:0.5];
        adsLabel.text = adsStr;
        adsLabel.textAlignment = NSTextAlignmentCenter;
        
        [adsView addSubview:adsLabel];
        
        NSString *adsTitle = self.adsTitle;
        CGFloat adsTitleFontSize = 14;
        
        UILabel *adsTitleLabel = [[UILabel alloc] init];
        adsTitleLabel.numberOfLines = 0;
        adsTitleLabel.textColor = [UIColor colorFromHexString:@"#333333"];
        adsTitleLabel.text = adsTitle;
        adsTitleLabel.font = [UIFont systemFontOfSize:adsTitleFontSize];
        
        CGFloat adsTitleW = imageW;
        CGFloat adsTitleH = 0.0f;
        CGFloat adsTitleY = CGRectGetMaxY(adsImageView.frame) + 5;
        CGFloat adsTitleX = imageX;
        
        
        NSString *singleStr = @"单行";
        CGFloat singleH = [singleStr sizeWithFont:[UIFont systemFontOfSize:adsTitleFontSize] maxSize:CGSizeMake(adsTitleW, ScreenHeight)].height;
        
        //  标题
        if (adsTitle.length > 0) {
            adsTitleH = [adsTitle sizeWithFont:[UIFont systemFontOfSize:adsTitleFontSize] maxSize:CGSizeMake(adsTitleW, ScreenHeight)].height;
            if (adsTitleH > 2 * singleH) {
                adsTitleH = 2 * singleH;
            }
        }
        
        adsTitleLabel.frame = CGRectMake(adsTitleX, adsTitleY, adsTitleW, adsTitleH);
        
        [adsView addSubview:adsTitleLabel];
        
        adsViewH = imageH + adsTitleH + 25;
        
        adsView.frame = CGRectMake(adsViewX, adsViewY , adsViewW, adsViewH);
        
        UITapGestureRecognizer *adsViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushAdsViewController)];
        [adsView addGestureRecognizer:adsViewTapGesture];
        
        footerAdsViewH = CGRectGetMaxY(adsView.frame) + 14;
        
        [footerAdsView addSubview:adsView];
        
    }
    
    footerAdsView.frame = CGRectMake(footerAdsViewX, footerAdsViewY, footerAdsViewW, footerAdsViewH);
    [contentHeaderView addSubview:footerAdsView];
    

    contentHeaderView.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(footerAdsView.frame));

    
    self.tableView.tableHeaderView = contentHeaderView;
    
    
    // --------------------------- 评论标题 -----------------------
    UIView *commentHeaderView = [[UIView alloc] init];
    UILabel *commentTitleLabel = [[UILabel alloc] init];
    commentTitleLabel.numberOfLines = 0;
    NSMutableAttributedString *commentTitleString = [title attributedStringWithFont:[UIFont  systemFontOfSize:titleFontSize weight:0.5] color:[UIColor colorFromHexString:@"#060606"] lineSpacing:2.0f];
    
    // 单行高度
    NSString *singleStr = @"单行";
    NSMutableAttributedString *singleTitleString = [singleStr attributedStringWithFont:[UIFont  systemFontOfSize:titleFontSize weight:0.5] color:[UIColor colorFromHexString:@"#060606"] lineSpacing:2.0f];
    CGFloat singleCommentTitleH = [singleTitleString heightWithConstraintWidth:titleW] ;
    
    CGFloat commentTitleH = [commentTitleString heightWithConstraintWidth:titleW] ;
    if (commentTitleH > 3 * singleCommentTitleH) {
        commentTitleH = 3 * (singleCommentTitleH + 2);
    }
    CGFloat commentTitleY = 0;
    
    if (iPhone6) {
        commentTitleY = 7;
    }
    commentTitleLabel.frame = CGRectMake(titleX, commentTitleY, titleW, commentTitleH);
    commentTitleLabel.attributedText = commentTitleString;
    
    [commentHeaderView addSubview:commentTitleLabel];
    
    // 来源
    UILabel *sourceLabel = [[UILabel alloc] init];
    sourceLabel.textColor = [UIColor colorFromHexString:LPColor4];
    sourceLabel.font = [UIFont fontWithName:OpinionFontName size:sourceFontSize];
    CGFloat sourceX = padding;
    CGFloat sourceY = CGRectGetMaxY(commentTitleLabel.frame);
    
    if (iPhone6) {
        sourceY = CGRectGetMaxY(commentTitleLabel.frame);
    }
    
    CGFloat sourceW = ScreenWidth - titleX * 2;
    CGFloat sourceH = [@"123" sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(sourceW, MAXFLOAT)].height;
    sourceLabel.frame = CGRectMake(sourceX, sourceY, sourceW, sourceH);

    
    NSString *source = [NSString stringWithFormat:@"%@    %@",pubtime, sourceSiteName];
    sourceLabel.text = source;
    [commentHeaderView addSubview:sourceLabel];
    commentHeaderView.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(sourceLabel.frame) + 30);
    
    if (iPhone6) {
        commentHeaderView.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(sourceLabel.frame) + 24);
    }
    
    if (iPhone6) {
        titleW = titleW - 2;
    }
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(padding, commentHeaderView.frame.size.height - 11, titleW, 0.5)];
    seperatorView.backgroundColor = [UIColor colorFromHexString:LPColor5];
    [commentHeaderView addSubview:seperatorView];
    self.commentsTableView.tableHeaderView = commentHeaderView;
    
    // 无评论提示
    CGFloat headerViewHeight = 40;
    CGFloat marginTop = 80;
    if (iPhone6Plus) {
        marginTop = 100;
    }
    CGFloat noCommentViewY = CGRectGetMaxY(commentHeaderView.frame) + headerViewHeight + marginTop;
    self.noCommentView.frame = CGRectMake(ScreenWidth + 1, noCommentViewY, ScreenWidth - 1, 200);
}

#pragma mark - 跳转到广告页面
- (void)pushAdsViewController {
    
    [self.playerView pause];
    
    LPAdsDetailViewController *adsViewController = [[LPAdsDetailViewController alloc] init];
    adsViewController.publishURL = self.adsPuburl;
    [self.navigationController pushViewController:adsViewController animated:YES];
}


#pragma mark - 广告提交到后台
- (void)getAdsWithAdImpression:(NSString *)adImpression {
    if (adImpression.length > 0) {
        [CardTool getAdsImpression:adImpression];
    }
}

#pragma mark - 黄历天气
- (void)postWeatherAdsStatistics {
    [CardTool postWeatherAdsWithType:@"244"];
}


#pragma mark - TableView DataSource 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        if (section == 0) {
            return self.relateVideoFrames.count;
        } else {
            return self.excellentCommentsFrames.count;
        }
    } else  {
        return self.fulltextCommentFrames.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            LPDetailVideoCell *cell = [LPDetailVideoCell cellWithTableView:tableView];
            cell.detailVideoFrame = self.relateVideoFrames[indexPath.row];
            cell.delegate = self;
            return cell;
        } else  {
            LPCommentCell *cell = [LPCommentCell cellWithTableView:tableView];
            cell.commentFrame = self.excellentCommentsFrames[indexPath.row];
            cell.delegate = self;
            return cell;
            
        }
    } else {
        LPFullCommentCell *cell = [LPFullCommentCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.fullCommentFrame = self.fulltextCommentFrames[indexPath.row];
        return cell;
    }
    
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            LPDetailVideoFrame *detailVideoFrame = self.relateVideoFrames[indexPath.row];
            return detailVideoFrame.cellHeight;
        } else {
            
            LPCommentFrame *commentFrame = self.excellentCommentsFrames[indexPath.row];
            return commentFrame.cellHeight;
        }
    } else {
        LPFullCommentFrame *commentFrame = self.fulltextCommentFrames[indexPath.row];
        return commentFrame.cellHeight;
    }
}

#pragma mark - TableView header and footer
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        // 距离两边间距
        CGFloat padding = 18;
        CGFloat headerTitleFontSize = 15;
        CGFloat headerViewHeight = 42;
        
        // 评论和相关观点标题高度
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(padding, 0, ScreenWidth - padding * 2, headerViewHeight)];
        CGSize fontSize = [@"热门评论" sizeWithFont:[UIFont systemFontOfSize:headerTitleFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        
        // 标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, headerViewHeight - fontSize.height - 7, fontSize.width, fontSize.height)];
        titleLabel.textColor = [UIColor colorFromHexString:LPColor7];
        titleLabel.font = [UIFont systemFontOfSize:headerTitleFontSize];
        [headerView addSubview:titleLabel];
        // 分割线
        UIView *firstSeperatorView = [[UIView alloc] initWithFrame:CGRectMake(padding,CGRectGetMaxY(titleLabel.frame) + 6 , fontSize.width, 1)];
        firstSeperatorView.backgroundColor = [UIColor colorFromHexString:LPColorDetail];
        
        [headerView addSubview:firstSeperatorView];
        
        UIView *secondSeperatorView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(firstSeperatorView.frame), CGRectGetMaxY(titleLabel.frame) + 6, ScreenWidth - padding - CGRectGetMaxX(firstSeperatorView.frame), 1)];
        secondSeperatorView.backgroundColor = [UIColor colorFromHexString:LPColor5];
        
        [headerView addSubview:secondSeperatorView];
        
        if (section == 0) {
            if (self.relateVideoFrames.count > 0) {
                titleLabel.text = @"相关视频";
                return headerView;
            } else {
                return nil;
            }
            
        } else  {
            if (self.excellentCommentsFrames.count > 0) {
                titleLabel.text = @"精选评论";
                return headerView;
            } else {
                return nil;
            }
            
        }
    } else {
        // 距离两边间距
        CGFloat padding = 18;
        CGFloat headerTitleFontSize = 15;
        CGFloat headerViewHeight = 40;
        
        // 评论和相关观点标题高度
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(padding, 0, ScreenWidth - padding * 2, headerViewHeight)];
        
        CGSize fontSize = [@"热门评论" sizeWithFont:[UIFont systemFontOfSize:headerTitleFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        
        // 标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, headerViewHeight - fontSize.height - 7, fontSize.width, fontSize.height)];
        titleLabel.textColor = [UIColor colorFromHexString:LPColor7];
        titleLabel.font = [UIFont systemFontOfSize:headerTitleFontSize];
        [headerView addSubview:titleLabel];
        // 分割线
        UIView *firstSeperatorView = [[UIView alloc] initWithFrame:CGRectMake(padding,CGRectGetMaxY(titleLabel.frame) + 6 , fontSize.width, 1)];
        firstSeperatorView.backgroundColor = [UIColor colorFromHexString:LPColorDetail];
        
        [headerView addSubview:firstSeperatorView];
        
        UIView *secondSeperatorView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(firstSeperatorView.frame), CGRectGetMaxY(titleLabel.frame) + 6, ScreenWidth - padding - CGRectGetMaxX(firstSeperatorView.frame), 1)];
        secondSeperatorView.backgroundColor = [UIColor colorFromHexString:LPColor5];
        titleLabel.text = @"热门评论";
        [headerView addSubview:secondSeperatorView];
        return headerView;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        if (section == 1 && self.excellentCommentsFrames.count > 0) {
            
            // 查看全部评论
            CGFloat padding = 18;
            CGFloat bottomWidth = ScreenWidth - padding * 2;
            CGFloat bottomHeight = 51;
            CGFloat paddingTop = 11;
            
            if (iPhone6) {
                bottomHeight = 51;
                paddingTop = 11;
            }
            
            
            UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(padding, 0, bottomWidth , bottomHeight)];
            footerView.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6®"];
            
            
            UIButton *bottomButton = [[UIButton alloc] initWithFrame:CGRectMake(padding, 0, bottomWidth, bottomHeight - paddingTop)];
            bottomButton.backgroundColor = [UIColor colorFromHexString:@"#f0f0f0"];
            
            
            [bottomButton setTitle:@"查看全部评论 >" forState:UIControlStateNormal];
            [bottomButton setTitleColor:[UIColor colorFromHexString:LPColorDetail] forState:UIControlStateNormal];
            [bottomButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [bottomButton addTarget:self action:@selector(showMoreComment) forControlEvents:UIControlEventTouchUpInside];
            bottomButton.layer.cornerRadius = 8.0f;
            bottomButton.clipsToBounds = YES;
            [footerView addSubview:bottomButton];
            
            UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, 0, bottomWidth, bottomHeight - paddingTop)];
            bottomLabel.layer.cornerRadius = 4.0f;
            bottomLabel.clipsToBounds = YES;
            bottomLabel.backgroundColor = [UIColor colorFromHexString:@"#f0f0f0"];
            bottomLabel.text = @"已显示全部评论";
            
            
            bottomLabel.textColor = [UIColor colorFromHexString:LPColorDetail];
            bottomLabel.font = [UIFont systemFontOfSize:15];
            bottomLabel.textAlignment = NSTextAlignmentCenter;
            [footerView addSubview:bottomLabel];
            
            bottomButton.hidden = (self.excellentCommentsFrames.count < 3);
            bottomLabel.hidden = !bottomButton.hidden;
            return footerView;
        }

    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat headerViewHeight = 42;
    if (tableView == self.tableView) {
        if (section == 0) {
            if (self.relateVideoFrames.count > 0) {
              return headerViewHeight;
            } else {
                return 0.1f;
            }
        } else {
            if (self.excellentCommentsFrames.count > 0) {
                return headerViewHeight;
            
            } else {
                return 0.1f;
            }
        }
    } else {
        return headerViewHeight ;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat contentBottomViewH = 200;
    CGFloat commentsBottomViewH = 40;
    
    if (iPhone6) {
        contentBottomViewH = 192;
        commentsBottomViewH = 51;
    }
    if (tableView == self.tableView) {
       if (section == 1) {
            if (self.excellentCommentsFrames.count > 0) {
                return commentsBottomViewH;
            } else {
                return 0.1f;
            }
       } else {
           return 0.1f;
       }
       
    } else {
        return 10.0f;
    }
}

#pragma mark - 关心本文
- (void)tapConcern {
    
    if ([AccountTool account] ==  nil) {
        [AccountTool accountLoginWithViewController:self success:^(Account *account){
            [self concernCurrentArticle];
        } failure:^{
        } cancel:nil];
    } else {
        [self concernCurrentArticle];
    }
}

- (void)concernCurrentArticle {
    // 未关心状态
    if (![self.conFlag isEqualToString:@"1"]) {
        
        NSString *url = [NSString stringWithFormat:@"%@/v2/ns/cocs?nid=%@&&uid=%@", ServerUrlVersion2,[self nid], [userDefaults objectForKey:@"uid"]];
        NSString *authorization = [userDefaults objectForKey:@"uauthorization"];
        
        //NSLog(@"%@", url);
        [LPHttpTool postAuthorizationJSONWithURL:url authorization:authorization params:nil success:^(id json) {
            if ([json[@"code"] integerValue] == 2000) {
                self.concernImageView.image = [UIImage imageNamed:@"详情页心已关注"];
                self.concernImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
                [self tipViewWithCondition:3];
                
                // 加1
                CGFloat plusLabelX = self.leftView.frame.origin.x + self.concernImageView.frame.origin.x;
                CGFloat plusLabelY = self.leftView.frame.origin.y + self.concernImageView.frame.origin.y;
                CGFloat plusLabelW = self.concernImageView.frame.size.width;
                CGFloat plusLabelH = self.concernImageView.frame.size.height;
                
                UILabel *plusLabel = [[UILabel alloc] initWithFrame:CGRectMake(plusLabelX, plusLabelY, plusLabelW, plusLabelH)];
                plusLabel.textColor = [UIColor colorFromHexString:@"#e94220"];
                plusLabel.font = [UIFont boldSystemFontOfSize:LPFont4];
                plusLabel.text = @"+1";
                [self.contentBottomView addSubview:plusLabel];
                
                [UIView animateWithDuration:0.8 animations:^{
                    self.concernImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                    plusLabel.frame = CGRectMake(plusLabelX, plusLabelY - 40, plusLabelW, plusLabelH);
                    plusLabel.alpha = 0.2;
                } completion:^(BOOL finished) {
                    NSInteger concernCount = [json[@"data"] integerValue];
                    self.concernCountLabel.text = [NSString stringWithFormat:@"%d", concernCount];
                    [plusLabel removeFromSuperview];
                    self.conFlag = @"1";
                }];
                
            } else if ([json[@"code"] integerValue] == 2003) {
                
            }
        } failure:^(NSError *error) {
            // //NSLog(@"%@", error);
        }];
        
        
    } else {
        
        NSString *url = [NSString stringWithFormat:@"%@/v2/ns/cocs?nid=%@&&uid=%@", ServerUrlVersion2,[self nid], [userDefaults objectForKey:@"uid"]];
        NSString *authorization = [userDefaults objectForKey:@"uauthorization"];
        
        [LPHttpTool deleteAuthorizationJSONWithURL:url authorization:authorization params:nil success:^(id json) {
            // //NSLog(@"%@", json);
            if ([json[@"code"] integerValue] == 2000) {
                self.concernImageView.image = [UIImage imageNamed:@"详情页心未关注"];
                NSInteger concernCount =  [json[@"data"] integerValue];
                self.concernCountLabel.text = [NSString stringWithFormat:@"%d", concernCount];
                self.conFlag = @"0";
                
            }
        } failure:^(NSError *error) {
            // //NSLog(@"%@", error);
        }];
    }
}





#pragma mark - 底部评论按钮
- (void)didClickCommentsWithDetailBottomView:(LPDetailBottomView *)detailBottomView {
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width ;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"详情页返回"] forState:UIControlStateNormal];
    [self.shareButton setBackgroundImage:[UIImage imageNamed:@"详情页右上分享"] forState:UIControlStateNormal];
}

#pragma mark - Scroll To Page 0
- (void)didClickContentsWithDetailBottomView:(LPDetailBottomView *)detailBottomView {
    [self hideContentBtn];
    self.pageControl.currentPage = 0;
    CGRect frame = self.scrollView.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"video_back"] forState:UIControlStateNormal];
    [self.shareButton setBackgroundImage:[UIImage imageNamed:@"video_share_white"] forState:UIControlStateNormal];
}

#pragma mark - Bottom View Delegate
- (void)didComposeCommentWithDetailBottomView:(LPDetailBottomView *)detailBottomView {
    
    self.composeComment = YES;
    self.composeCommentBackgroundView.hidden = NO;
    [self.textView becomeFirstResponder];
}

#pragma mark - LPDetailVideoCellDelegate
- (void)videoCell:(LPDetailVideoCell *)cell didClickCellWithVideoModel:(LPVideoModel *)videoModel {
    self.relateVideo = YES;
    self.videoNid = videoModel.nid;
    [self setupData];
}



#pragma mark - 返回
- (void)topViewBackBtnClick {
    [self popToHomeViewController];
}


#pragma mark - 分享
- (void)shareButtonClick {
    NSLog(@"分享");
    
}

#pragma mark - 发表评论 (键盘出现或消失)
- (void)keyboardWillShow:(NSNotification *)note
{
    if (self.isComposeComment == YES) {
        //获取键盘的高度
        NSDictionary *userInfo = [note userInfo];
        CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [value CGRectValue];
        CGFloat height = keyboardRect.size.height;
        CGRect toFrame = CGRectMake(0, ScreenHeight - self.textViewBg.height - height, ScreenWidth, self.textViewBg.height);
        [UIView animateWithDuration:duration animations:^{
            self.textViewBg.frame = toFrame;
            self.composeCommentBackgroundView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            self.composeCommentBackgroundView.hidden = NO;
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)note {
    if (self.isComposeComment == YES) {
        //获取键盘的高度
        NSDictionary *userInfo = [note userInfo];
        CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        CGRect toFrame = CGRectMake(0, ScreenHeight, ScreenWidth, self.textViewBg.height);
        [UIView animateWithDuration:duration animations:^{
            self.textViewBg.frame = toFrame;
            self.composeCommentBackgroundView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            self.composeCommentBackgroundView.hidden = YES;
            self.composeButton.backgroundColor = [UIColor colorFromHexString:@"#eaeaea"];
            [self.composeButton setTitleColor:[UIColor colorFromHexString:LPColor4] forState:UIControlStateNormal];
            self.composeButton.layer.borderColor  =  [UIColor colorFromHexString:LPColor4].CGColor;
        }];
    }
}

#pragma mark - 精选评论点赞 delegate
- (void)excellentCommentCell:(LPCommentCell *)commentCell commentFrame:(LPCommentFrame *)commentFrame {
    
    __block Account *account = [AccountTool account];
    // 如果已经登录直接点赞，没有登录登录成功后才能点赞
    if ([AccountTool account]) {
        [self excellentCommentUp:commentCell account:account commentFrame:commentFrame];
    } else {
        [AccountTool accountLoginWithViewController:self success:^(Account *account){
            [self excellentCommentUp:commentCell account:account commentFrame:commentFrame];
        } failure:^{
            [MBProgressHUD showError:@"登录失败"];
        } cancel:^{
            
        }];
    }
}

- (void)excellentCommentUp:(LPCommentCell *)commentCell account:(Account *)account commentFrame:(LPCommentFrame *)commentFrame {
    LPComment *comment = commentFrame.comment;
    
    // 已经赞过
    if ([comment.isPraiseFlag isEqualToString:@"1"]) {
        
        NSString *url = [NSString stringWithFormat:@"%@/v2/ns/coms/up?cid=%@&&uid=%@", ServerUrlVersion2,comment.Id, [userDefaults objectForKey:@"uid"]];
        NSString *authorization = [userDefaults objectForKey:@"uauthorization"];
        
        [LPHttpTool deleteAuthorizationJSONWithURL:url authorization:authorization params:nil success:^(id json) {
            
            if ([json[@"code"] integerValue] == 2000) {
                comment.isPraiseFlag = @"0";
                comment.up = [NSString stringWithFormat:@"%@", json[@"data"]];
                NSInteger index = [self.excellentCommentsFrames indexOfObject:commentFrame];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            }
        } failure:^(NSError *error) {
            //NSLog(@"%@", error);
        }];
    } else {
        NSString *url = [NSString stringWithFormat:@"%@/v2/ns/coms/up?cid=%@&&uid=%@", ServerUrlVersion2,comment.Id, [userDefaults objectForKey:@"uid"]];
        NSString *authorization = [userDefaults objectForKey:@"uauthorization"];
        
        [LPHttpTool postAuthorizationJSONWithURL:url authorization:authorization params:nil success:^(id json) {
            
            if ([json[@"code"] integerValue] == 4001) {
                [self tipViewWithCondition:7];
            } else if ([json[@"code"] integerValue] == 2000) {
                comment.isPraiseFlag = @"1";
                comment.up = [NSString stringWithFormat:@"%@", json[@"data"]];
                
                // 点赞动画效果
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:commentCell.upButton.frame];
                imageView.tag = -100;
                imageView.image = [UIImage imageNamed:@"详情页已点赞"];
                imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.0, 0.0);
                [commentCell addSubview:imageView];
                
                
                CGFloat plusLabelX = commentCell.upButton.frame.origin.x - 2;
                CGFloat plusLabelY =  commentCell.upButton.frame.origin.y;
                CGFloat plusLabelW = commentCell.upButton.frame.size.width;
                CGFloat plusLabelH = commentCell.upButton.frame.size.height;
                
                
                UILabel *plusLabel = [[UILabel alloc] initWithFrame:CGRectMake(plusLabelX, plusLabelY, plusLabelW, plusLabelH)];
                plusLabel.textColor = [UIColor colorFromHexString:@"#e94220"];
                plusLabel.font = [UIFont boldSystemFontOfSize:LPFont5];
                plusLabel.text = @"+1";
                [commentCell addSubview:plusLabel];
                
                [UIView animateWithDuration:0.6 animations:^{
                    imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                    plusLabel.frame = CGRectMake(plusLabelX, plusLabelY - 20, plusLabelW , plusLabelH);
                    plusLabel.alpha = 0.2;
                } completion:^(BOOL finished) {
                    // 刷新单元格
                    NSInteger index = [self.excellentCommentsFrames indexOfObject:commentFrame];
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
                    [imageView removeFromSuperview];
                    [plusLabel removeFromSuperview];
                }];
            }
        } failure:^(NSError *error) {
            [self tipViewWithCondition:6];
            
        }];
    }
}

#pragma mark -  全文评论点赞 delegate
- (void)fullCommentCell:(LPFullCommentCell *)cell fullCommentFrame:(LPFullCommentFrame *)fullCommentFrame {
    
    __block Account *account = [AccountTool account];
    // 如果已经登录直接点赞，没有登录登录成功后才能点赞
    if ([AccountTool account]) {
        [self commentUp:cell account:account fullCommentFrame:fullCommentFrame];
    } else {
        [AccountTool accountLoginWithViewController:self success:^(Account *account){
            [self commentUp:cell account:account fullCommentFrame:fullCommentFrame];
        } failure:^{
            [MBProgressHUD showError:@"登录失败"];
        } cancel:^{
            
        }];
    }
}

- (void)commentUp:(LPFullCommentCell *)cell account:(Account *)account fullCommentFrame:(LPFullCommentFrame *)fullCommentFrame
{
    LPComment *comment = fullCommentFrame.comment;
    NSString *url = [NSString stringWithFormat:@"%@/v2/ns/coms/up?cid=%@&&uid=%@", ServerUrlVersion2,comment.Id, [userDefaults objectForKey:@"uid"]];
    NSString *authorization = [userDefaults objectForKey:@"uauthorization"];
    if ([comment.isPraiseFlag isEqualToString:@"1"]) {
        [LPHttpTool deleteAuthorizationJSONWithURL:url authorization:authorization params:nil success:^(id json) {
            if ([json[@"code"] integerValue] == 2000) {
                comment.isPraiseFlag = @"0";
                comment.up = [NSString stringWithFormat:@"%@", json[@"data"]];
                NSInteger index = [self.excellentCommentsFrames indexOfObject:fullCommentFrame];
                [self.commentsTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
        } failure:^(NSError *error) {
            //  //NSLog(@"%@", error);
        }];
        
        
    } else {
        
        [LPHttpTool postAuthorizationJSONWithURL:url authorization:authorization params:nil success:^(id json) {
            
            // //NSLog(@"%@",json);
            if ([json[@"code"] integerValue] == 4001) {
                [self tipViewWithCondition:7];
            } else if ([json[@"code"] integerValue] == 2000) {
                comment.isPraiseFlag = @"1";
                comment.up = [NSString stringWithFormat:@"%@", json[@"data"]];
                
                // 点赞动画效果
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.upButton.frame];
                imageView.tag = -100;
                imageView.image = [UIImage imageNamed:@"详情页已点赞"];
                imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.0, 0.0);
                [cell addSubview:imageView];
                
                
                CGFloat plusLabelX = cell.upButton.frame.origin.x - 2;
                CGFloat plusLabelY =  cell.upButton.frame.origin.y;
                CGFloat plusLabelW = cell.upButton.frame.size.width;
                CGFloat plusLabelH = cell.upButton.frame.size.height;
                
                
                UILabel *plusLabel = [[UILabel alloc] initWithFrame:CGRectMake(plusLabelX, plusLabelY, plusLabelW, plusLabelH)];
                plusLabel.textColor = [UIColor colorFromHexString:@"#e94220"];
                plusLabel.font = [UIFont boldSystemFontOfSize:LPFont5];
                plusLabel.text = @"+1";
                [cell addSubview:plusLabel];
                
                [UIView animateWithDuration:0.6 animations:^{
                    imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                    plusLabel.frame = CGRectMake(plusLabelX, plusLabelY - 20, plusLabelW , plusLabelH);
                    plusLabel.alpha = 0.2;
                } completion:^(BOOL finished) {
                    // 刷新单元格
                    NSInteger index = [self.fulltextCommentFrames indexOfObject:fullCommentFrame];
                    [self.commentsTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    [imageView removeFromSuperview];
                    [plusLabel removeFromSuperview];
                }];
            }
        } failure:^(NSError *error) {
            [self tipViewWithCondition:6];
            
        }];
    }
}


#pragma mark - 发表评论 (文字变化)
- (void)textViewDidChange:(UITextView*)textView {
    if (textView == self.textView) {
        if (self.textView.text.length > 0) {
            self.composeButton.enabled = YES;
            self.composeButton.backgroundColor = [UIColor colorFromHexString:@"ff0000"];
            self.composeButton.layer.borderColor  =  [UIColor colorFromHexString:@"ff0000"].CGColor;
            [self.composeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else {
            self.composeButton.enabled = NO;
            self.composeButton.backgroundColor = [UIColor colorFromHexString:@"#eaeaea"];
            [self.composeButton setTitleColor:[UIColor colorFromHexString:LPColor4] forState:UIControlStateNormal];
            self.composeButton.layer.borderColor  =  [UIColor colorFromHexString:LPColor4].CGColor;
        }
        
    }
}

#pragma mark - 发表评论 (结束编辑)
- (void)composeCommentBackgroundViewTap {
    [self.textView endEditing:YES];
    [self.textView setText:@""];
}

#pragma mark - 无评论提示
- (void)noCommentsViewTip {
    if (self.fulltextCommentFrames.count > 0) {
        self.noCommentView.hidden = YES;
    } else {
        self.noCommentView.hidden = NO;
    }
}


#pragma mark - 发表评论
- (void)composeButtonClick {
    
    if (![AccountTool account]) {
        CGRect toFrame = CGRectMake(0, ScreenHeight, ScreenWidth, self.textViewBg.height);
        self.textViewBg.frame = toFrame;
        [self.textView endEditing:YES];
        self.composeCommentBackgroundView.alpha = 0.0;
        
        [AccountTool accountLoginWithViewController:self success:^(Account *account){
            [self composeComment];
        } failure:^{
        } cancel:nil];
    } else {
        [self composeComment];
        [self removeComposeView];
    }
    
}

// 移除发表评论提示框
- (void)removeComposeView {
    
    CGRect toFrame = CGRectMake(0, ScreenHeight, ScreenWidth, self.textViewBg.height);
    [UIView animateWithDuration:0.3 animations:^{
        self.textViewBg.frame = toFrame;
        [self.textView endEditing:YES];
        self.composeCommentBackgroundView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        self.composeCommentBackgroundView.hidden = YES;
        [self.textView setText:@""];
        self.composeButton.enabled = NO;
        self.composeButton.backgroundColor = [UIColor colorFromHexString:@"#eaeaea"];
        self.composeButton.layer.borderColor  =  [UIColor colorFromHexString:LPColor4].CGColor;
        [self.composeButton setTitleColor:[UIColor colorFromHexString:LPColor4] forState:UIControlStateNormal];
    }];
}


// 提交评论到服务器
- (void)composeComment {
    Account *account = [AccountTool account];
    // 1.1 创建comment对象
    LPComment *comment = [[LPComment alloc] init];
    comment.srcText = [self.textView.text stringByTrimmingWhitespaceAndNewline];
    comment.userIcon = account.userIcon;
    comment.userName = account.userName;
    comment.createTime = [NSString stringFromNowDate];
    comment.color = [UIColor colorFromHexString:@"#747474"];
    comment.up = @"0";
    comment.isPraiseFlag = @"0";
    
    // 判断评论字数不超过1000字符
    if (comment.srcText.length < 1000) {
        // 2. 发送post请求
        NSString *url = [NSString stringWithFormat:@"%@/v2/ns/coms", ServerUrlVersion2];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"content"] = comment.srcText;
        params[@"uname"]  = comment.userName;
        params[@"uid"] = @([[userDefaults objectForKey:@"uid"] integerValue]);
        params[@"commend"]  = @(0);
        params[@"ctime"]  = comment.createTime;
        params[@"avatar"] = comment.userIcon;
        params[@"docid"] = self.docId == nil ? self.submitDocID: self.docId;
        NSString *authorization = [userDefaults objectForKey:@"uauthorization"];
        if (authorization) {
            [LPHttpTool postAuthorizationJSONWithURL:url authorization:authorization params:params success:^(id json) {
                if ([json[@"code"] integerValue] == 2000) {
                    
                    [self tipViewWithCondition:4];
                    comment.Id = [NSString stringWithFormat:@"%@", json[@"data"]];
                    LPFullCommentFrame *commentFrame = [[LPFullCommentFrame alloc] init];
                    commentFrame.comment = comment;
                    [self.fulltextCommentFrames insertObject:commentFrame atIndex:0];
                    self.commentsTableView.scrollEnabled = YES;
                    [self.commentsTableView reloadData];
                    [self.commentsTableView setContentOffset:CGPointZero animated:NO];
                    self.noCommentView.hidden = YES;
                    
                    self.commentsCount = self.commentsCount + 1;
                    self.bottomView.badgeNumber = self.commentsCount ;
                    
                    if (self.pageControl.currentPage == 1) {
                        self.bottomView.noCommentsBtn.hidden = YES;
                        self.bottomView.commentsBtn.hidden = YES;
                        self.bottomView.commentCountLabel.hidden = YES;
                        self.bottomView.commentsCountView.hidden = YES;
                    }
                    
                    // 发表成功禁用按钮
                    self.composeButton.enabled = NO;
                    self.composeButton.backgroundColor = [UIColor colorFromHexString:LPColor4];
                    self.composeButton.layer.borderColor  =  [UIColor colorFromHexString:LPColor4].CGColor;
                    [self.composeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    self.composeComment = NO;
                }
                
            } failure:^(NSError *error) {
                NSLog(@"%@", error);
                
                [self tipViewWithCondition:5];
            }];
        }
    } else {
        [self tipViewWithCondition:9];
    }
}

#pragma mark - 提示信息
- (void)tipViewWithCondition:(NSInteger)condition {
    LPDetailTipView *tipView = [[LPDetailTipView alloc] initWithCondition:condition];
    [self.view addSubview:tipView];
    
    [UIView animateWithDuration:0.4f delay:0.8f options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         tipView.alpha = 0.2f;
                     } completion:^(BOOL finished) {
                         [tipView removeFromSuperview];
                     }];
}

#pragma mark - 收藏文章
- (void)didFavoriteWithDetailBottomView:(LPDetailBottomView *)detailBottomView {
    
    if ([AccountTool account] ==  nil) {
        [AccountTool accountLoginWithViewController:self success:^(Account *account){
            NSMutableDictionary *detailContentParams = [NSMutableDictionary dictionary];
            NSString *detailContentURL = [NSString stringWithFormat:@"%@/v2/ns/con", ServerUrlVersion2];
            NSString *uid = [userDefaults objectForKey:@"uid"];
            detailContentParams[@"nid"] = [self nid];
            detailContentParams[@"uid"] = uid;
            
            
            [LPHttpTool getWithURL:detailContentURL params:detailContentParams success:^(id json) {
                
                NSMutableDictionary *dict = json[@"data"];
                NSString *colflag = [dict[@"colflag"] stringValue];
                // 已经收藏
                if ([colflag isEqualToString:@"1"]) {
                    [self.bottomView.favoriteBtn setBackgroundImage:[UIImage imageNamed:@"详情页已收藏"] forState:UIControlStateNormal];
                    self.colFlag = colflag;
                } else {
                    // 收藏
                    [self collect];
                }
            } failure:^(NSError *error) {
                
            }];
        } failure:^{
        } cancel:nil];
    } else {
        [self collectOrNot];
    }
}

// 改变收藏状态
- (void)changeCollectionState {
    if ([self.colFlag isEqualToString:@"1"]) {
        [self.bottomView.favoriteBtn setBackgroundImage:[UIImage imageNamed:@"详情页已收藏"] forState:UIControlStateNormal];
    } else {
        [self.bottomView.favoriteBtn setBackgroundImage:[UIImage imageNamed:@"详情页未收藏"] forState:UIControlStateNormal];
    }
}

// 收藏和取消收藏
- (void)collectOrNot {
    if ([self.colFlag isEqualToString:@"1"]) {
        [self cancelCollect];
    } else {
        [self collect];
    }
}

// 收藏
- (void)collect {
    [CollectionTool addConcernWithNid:[self nid] codeFlag:^(NSString *codeFlag) {
        if ([codeFlag isEqualToString:LPSuccess]) {
            self.colFlag = @"1";
            [self.bottomView.favoriteBtn setBackgroundImage:[UIImage imageNamed:@"详情页已收藏"] forState:UIControlStateNormal];
            [self tipViewWithCondition:1];
        }
    }];
    
    
}


#pragma mark - 取消收藏
- (void)cancelCollect {
    [CollectionTool cancelConcernWithNid:[self nid] codeFlag:^(NSString *codeFlag) {
        if ([codeFlag isEqualToString:LPSuccess]) {
            self.colFlag = @"0";
            [self.bottomView.favoriteBtn setBackgroundImage:[UIImage imageNamed:@"详情页未收藏"] forState:UIControlStateNormal];
            [self tipViewWithCondition:2];
        }
    }];
    
}


#pragma mark - 跳转到关注列表
- (void)focusViewTap {
    
    [self.playerView removePlayerObserver];
    LPConcernDetailViewController *concernDetailViewController = [[LPConcernDetailViewController alloc] init];
    concernDetailViewController.sourceName = self.sourceSiteName;
    concernDetailViewController.conpubFlag = self.conpubFlag;
    concernDetailViewController.sourceImageURL = self.sourceImageURL;
    [self.navigationController pushViewController:concernDetailViewController animated:YES];
}

#pragma mark - 点击关注
- (void)rightFocusViewTapGesture {
    
    if (self.forwardImageView.hidden == NO) {
        [noteCenter postNotificationName:LPReloadAddConcernPageNotification object:nil];
        [self focusViewTap];
        
    } else {
        // 用户未登录
        if (![AccountTool account]) {
            [AccountTool accountLoginWithViewController:self success:^(Account *account) {
                NSMutableDictionary *detailContentParams = [NSMutableDictionary dictionary];
                NSString *detailContentURL = [NSString stringWithFormat:@"%@/v2/ns/con", ServerUrlVersion2];
                NSString *uid = [userDefaults objectForKey:@"uid"];
                detailContentParams[@"nid"] = [self nid];
                detailContentParams[@"uid"] = uid;
                [LPHttpTool getWithURL:detailContentURL params:detailContentParams success:^(id json) {
                    NSMutableDictionary *dict = json[@"data"];
                    NSString *conpubflag = [dict[@"conpubflag"] stringValue];
                    // 用户已关注
                    if ([conpubflag isEqualToString:@"1"]) {
                        self.conpubFlag = @"1";
                        self.forwardImageView.hidden = NO;
                        self.focusImageView.hidden = YES;
                        self.focusLabel.hidden = YES;
                        [noteCenter postNotificationName:LPReloadAddConcernPageNotification object:nil];
                    } else {
                        [self addConcernSourceSiteName];
                    }
                } failure:^(NSError *error) {
                    
                }];
            } failure:^{
            } cancel:nil
             ];
        } else {
            [self addConcernSourceSiteName];
        }
    }
}

- (void)addConcernSourceSiteName {
    __weak typeof(self) weakSelf = self;
    NSString *uid = [userDefaults objectForKey:@"uid"];
    
    // 必须进行编码操作
    NSString *pname = [self.sourceSiteName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"%@/v2/ns/pbs/cocs?pname=%@&&uid=%@", ServerUrlVersion2, pname, uid];
    NSString *authorization = [userDefaults objectForKey:@"uauthorization"];
    
    [LPHttpTool postAuthorizationJSONWithURL:url authorization:authorization params:nil success:^(id json) {
        if ([json[@"code"] integerValue] == 2000 ) {
            weakSelf.forwardImageView.hidden = NO;
            weakSelf.focusImageView.hidden = YES;
            weakSelf.focusLabel.hidden = YES;
            [weakSelf addFocusTips];
            self.conpubFlag = @"1";
            [noteCenter postNotificationName:LPReloadAddConcernPageNotification object:nil];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - 添加关注提示信息
- (void)addFocusTips {
    UIView *focusBlurBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    [focusBlurBackgroundView setBackgroundColor: [[UIColor blackColor] colorWithAlphaComponent:0.8]];
    [self.view addSubview:focusBlurBackgroundView];
    
    CGFloat tipsViewW = 252;
    CGFloat tipsViewH = 153;
    CGFloat tipsViewX = (ScreenWidth - tipsViewW) / 2;
    CGFloat tipsViewY = (ScreenHeight - tipsViewH) / 2;
    
    UIView *tipsView = [[UIView alloc] init];
    tipsView.frame = CGRectMake(tipsViewX, tipsViewY, tipsViewW, tipsViewH);
    tipsView.backgroundColor = [UIColor colorFromHexString:LPColor9];
    tipsView.clipsToBounds = YES;
    tipsView.layer.cornerRadius = 6;
    
    
    CGFloat focusSuccessImageViewW = 19;
    CGFloat focusSuccessImageViewH = 19;
    CGFloat focusSuccessImageViewY = 25;
    
    NSString *focusSuccessStr = @"关注成功";
    CGFloat focusSuccessLabelW = [focusSuccessStr sizeWithFont:[UIFont systemFontOfSize:LPFont3] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
    CGFloat focusSuccessLabelH = [focusSuccessStr sizeWithFont:[UIFont systemFontOfSize:LPFont3] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
    CGFloat focusSuccessImageViewX = (tipsViewW - 6 - focusSuccessImageViewW - focusSuccessLabelW) / 2;
    UIImageView *focusSuccessImageView = [[UIImageView alloc] initWithFrame:CGRectMake(focusSuccessImageViewX, focusSuccessImageViewY, focusSuccessImageViewW, focusSuccessImageViewH)];
    focusSuccessImageView.image = [UIImage imageNamed:@"详情页关注成功"];
    [tipsView addSubview:focusSuccessImageView];
    
    CGFloat focusSuccessLabelX = CGRectGetMaxX(focusSuccessImageView.frame) + 6;
    CGFloat focusSuccessLabelY = 26;
    
    UILabel *focusSuccessLabel = [[UILabel alloc] initWithFrame:CGRectMake(focusSuccessLabelX, focusSuccessLabelY, focusSuccessLabelW, focusSuccessLabelH)];
    focusSuccessLabel.text = focusSuccessStr;
    [focusSuccessLabel setFont:[UIFont systemFontOfSize:LPFont3]];
    focusSuccessLabel.textColor = [UIColor colorFromHexString:LPColor3];
    
    
    [tipsView addSubview:focusSuccessLabel];
    
    NSString *firstRowStr  = @"你可以在  [关注]  频道";
    NSString *secondRowStr = @"查看它更新的相关内容";
    
    CGFloat firstRowLabelW = tipsViewW;
    CGFloat firstRowLabelH = [firstRowStr sizeWithFont:[UIFont systemFontOfSize:LPFont5] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
    CGFloat firstRowLabelX = 0;
    CGFloat firstRowLabelY = CGRectGetMaxY(focusSuccessImageView.frame) + 12;
    
    UILabel *firstRowLabel = [[UILabel alloc] initWithFrame:CGRectMake(firstRowLabelX, firstRowLabelY, firstRowLabelW, firstRowLabelH)];
    firstRowLabel.text = firstRowStr;
    [firstRowLabel setFont:[UIFont systemFontOfSize:LPFont5]];
    firstRowLabel.textColor = [UIColor colorFromHexString:LPColor7];
    firstRowLabel.textAlignment = NSTextAlignmentCenter;
    [tipsView addSubview:firstRowLabel];
    
    CGFloat secondRowLabelW = tipsViewW;
    CGFloat secondRowLabelH = [secondRowStr sizeWithFont:[UIFont systemFontOfSize:LPFont5] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
    CGFloat secondRowLabelX = 0;
    CGFloat secondRowLabelY = CGRectGetMaxY(firstRowLabel.frame) + 5;
    
    UILabel *secondRowLabel = [[UILabel alloc] initWithFrame:CGRectMake(secondRowLabelX, secondRowLabelY, secondRowLabelW, secondRowLabelH)];
    secondRowLabel.text = secondRowStr;
    [secondRowLabel setFont:[UIFont systemFontOfSize:LPFont5]];
    secondRowLabel.textColor = [UIColor colorFromHexString:LPColor7];
    secondRowLabel.textAlignment = NSTextAlignmentCenter;
    [tipsView addSubview:firstRowLabel];
    [tipsView addSubview:secondRowLabel];
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(secondRowLabel.frame) + 25, tipsViewW, 0.5)];
    seperatorView.backgroundColor = [UIColor colorFromHexString:LPColor10];
    [tipsView addSubview:seperatorView];
    
    CGFloat tipsConfirmButtonY = CGRectGetMaxY(seperatorView.frame);
    CGFloat tipsConfirmButtonH = tipsViewH - tipsConfirmButtonY;
    CGFloat tipsConfirmButtonX = 0;
    CGFloat tipsConfirmButtonW = tipsViewW;
    UIButton *tipsConfirmButton = [[UIButton alloc] initWithFrame:CGRectMake(tipsConfirmButtonX, tipsConfirmButtonY, tipsConfirmButtonW, tipsConfirmButtonH)];
    [tipsConfirmButton setTitle:@"知道了" forState:UIControlStateNormal];
    [tipsConfirmButton setTitleColor:[UIColor colorFromHexString:LPColor3] forState:UIControlStateNormal];
    [tipsConfirmButton.titleLabel setFont:[UIFont systemFontOfSize:LPFont10]];
    [tipsConfirmButton addTarget:self action:@selector(removeFocusTips) forControlEvents:UIControlEventTouchUpInside];
    [tipsView addSubview:tipsConfirmButton];
    
    [focusBlurBackgroundView addSubview:tipsView];
    self.focusBlurBackgroundView = focusBlurBackgroundView;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3f animations:^{
            self.focusBlurBackgroundView.alpha = 0.4;
        } completion:^(BOOL finished) {
            [self.focusBlurBackgroundView removeFromSuperview];
        }];
    });
}


#pragma mark - 移除关注提示信息
- (void)removeFocusTips {
    [UIView animateWithDuration:0.3f animations:^{
        self.focusBlurBackgroundView.alpha = 0.4;
    } completion:^(BOOL finished) {
        [self.focusBlurBackgroundView removeFromSuperview];
    }];
}

#pragma mark - 添加关注
- (void)addConcernNotification {
    self.forwardImageView.hidden = NO;
    self.focusImageView.hidden = YES;
    self.focusLabel.hidden = YES;
    self.conpubFlag = @"1";
}

#pragma mark - 取消关注
- (void)cancelConcernNotification {
    self.forwardImageView.hidden = YES;
    self.focusImageView.hidden = NO;
    self.focusLabel.hidden = NO;
    self.conpubFlag = @"0";
    
}


#pragma mark - scrollViewWillBeginDragging

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        self.lastContentOffsetY = self.tableView.contentOffset.y;
    } else if ([scrollView isKindOfClass:[UIScrollView class]]) {
        self.lastContentOffsetX = scrollView.contentOffset.x;
    }
}

#pragma mark - scrollViewDidScroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]]) {
        if (scrollView == self.tableView) {
            static CGFloat lastY = 0;
            
            CGFloat currentY = scrollView.contentOffset.y;
            CGFloat headerHeight = self.headerView.frame.size.height;
            
            
            if ((lastY > headerHeight) && (currentY <= headerHeight)) {
                if (self.adsSuccess) {
                    [self getAdsWithAdImpression:self.adsImpression];
                    [self postWeatherAdsStatistics];
                }
            }
            
            lastY = currentY;
        }

    } else if ([scrollView isKindOfClass:[UIScrollView class]]) {
        int page = scrollView.contentOffset.x / self.view.frame.size.width;
        self.pageControl.currentPage = page;
        if (page == 0) {
            [self hideContentBtn];
            [self.backBtn setBackgroundImage:[UIImage imageNamed:@"video_back"] forState:UIControlStateNormal];
            [self.shareButton setBackgroundImage:[UIImage imageNamed:@"video_share_white"] forState:UIControlStateNormal];
            
            
        } else {
            [self hideCommentBtn];
            [self.backBtn setBackgroundImage:[UIImage imageNamed:@"详情页返回"] forState:UIControlStateNormal];
            [self.shareButton setBackgroundImage:[UIImage imageNamed:@"详情页右上分享"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - 隐藏评论按钮
- (void)hideCommentBtn {
    self.bottomView.noCommentsBtn.hidden = YES;
    self.bottomView.commentsBtn.hidden = YES;
    self.bottomView.commentsCountView.hidden = YES;
    self.bottomView.commentCountLabel.hidden = YES;
    self.bottomView.contentBtn.hidden = NO;
    
    self.tableView.scrollsToTop = NO;
    self.commentsTableView.scrollsToTop = YES;
}


#pragma mark -  隐藏内容按钮
- (void)hideContentBtn {
    if (self.fulltextCommentFrames.count > 0) {
        self.bottomView.commentsBtn.hidden = NO;
        self.bottomView.noCommentsBtn.hidden = YES ;
        self.bottomView.commentsCountView.hidden = NO;
        self.bottomView.commentCountLabel.hidden = NO;
    } else {
        self.bottomView.commentsBtn.hidden = YES;
        self.bottomView.noCommentsBtn.hidden = NO ;
        self.bottomView.commentsCountView.hidden = YES;
        self.bottomView.commentCountLabel.hidden = YES;
    }
    self.bottomView.contentBtn.hidden = YES;
    self.tableView.scrollsToTop = YES;
    self.commentsTableView.scrollsToTop = NO;
    
}

#pragma mark - 查看更多评论
- (void)showMoreComment {
    [self hideCommentBtn];
    self.pageControl.currentPage = 1;
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width ;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

#pragma mark - 全文评论加载更多
- (void)loadMoreCommentsData {
    self.pageIndex = self.pageIndex + 1;
    
    NSString *url = [NSString stringWithFormat:@"%@/v2/ns/coms/c", ServerUrlVersion2];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"did"] = [[[self docId] stringByBase64Encoding] stringByTrimmingString:@"="];
    params[@"p"] = @(self.pageIndex);
    params[@"c"] = @"20";
    params[@"uid"] = [userDefaults objectForKey:@"uid"];
    
    __weak typeof(self) weakSelf = self;
    [LPHttpTool getWithURL:url params:params success:^(id json) {
        if ([json[@"code"] integerValue] == 2000) {
            NSArray *commentsArray = json[@"data"];
            for (NSDictionary *dict in commentsArray) {
                LPComment *comment = [[LPComment alloc] init];
                comment.srcText = dict[@"content"];
                comment.createTime = dict[@"ctime"];
                comment.up = [NSString stringWithFormat:@"%@", dict[@"commend"]] ;
                comment.userIcon = dict[@"avatar"];
                comment.Id = dict[@"id"];
                comment.userName = dict[@"uname"];
                comment.color = [UIColor colorFromHexString:@"#747474"];
                comment.isPraiseFlag = [NSString stringWithFormat:@"%@", dict[@"upflag"]] ;
                
                LPFullCommentFrame *commentFrame = [[LPFullCommentFrame alloc] init];
                commentFrame.comment = comment;
                
                [weakSelf.fulltextCommentFrames addObject:commentFrame];
            }
            if (weakSelf.fulltextCommentFrames.count > 0) {
                weakSelf.commentsTableView.scrollEnabled = YES;
            }
            
            [weakSelf.commentsTableView reloadData];
            [weakSelf.commentsTableView.mj_footer endRefreshing];
        } else {
            [weakSelf.commentsTableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        [weakSelf.commentsTableView.mj_footer endRefreshing];
    }];
}


#pragma mark - 创建底部视图
- (void)setupBottomView {
    
    // 弹出发表评论对话框
    UIView *composeCommentBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    composeCommentBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    composeCommentBackgroundView.hidden = YES;
    composeCommentBackgroundView.alpha = 1.0f;
    composeCommentBackgroundView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(composeCommentBackgroundViewTap)];
    [composeCommentBackgroundView addGestureRecognizer:tapGesture];
    
    [self.view addSubview:composeCommentBackgroundView];
    self.composeCommentBackgroundView = composeCommentBackgroundView;
    
    // 发表评论输入框
    CGFloat textViewX = 15;
    CGFloat textViewY = 18;
    CGFloat textViewW = ScreenWidth - textViewX * 2;
    CGFloat textViewH = 59;
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(textViewX, textViewY,textViewW, textViewH)];
    textView.layer.cornerRadius = 4.0f;
    textView.scrollsToTop = NO;
    textView.textColor = [UIColor colorFromHexString:LPColor3];
    textView.font = [UIFont systemFontOfSize:LPFont4];
    textView.delegate = self;
    textView.backgroundColor = [UIColor colorFromHexString:@"#fafafa"];
    self.textView = textView;
    
    CGFloat composeButtonW = 59;
    CGFloat composeButtonH = 29;
    CGFloat composeButtonX = ScreenWidth - composeButtonW - textViewX;
    CGFloat composeButtonY = CGRectGetMaxY(textView.frame) + 17;
    
    UIButton *composeButton = [[UIButton alloc] initWithFrame:CGRectMake(composeButtonX, composeButtonY, composeButtonW, composeButtonH)];
    composeButton.titleLabel.font = [UIFont systemFontOfSize:17];
    composeButton.layer.cornerRadius = 4.0;
    composeButton.layer.borderColor = [UIColor colorFromHexString:LPColor4].CGColor;
    composeButton.backgroundColor = [UIColor colorFromHexString:@"#eaeaea"];
    composeButton.layer.borderWidth = 1;
    [composeButton setTitle:@"发表" forState:UIControlStateNormal];
    [composeButton setTitleColor:[UIColor colorFromHexString:LPColor4] forState:UIControlStateNormal];
    
    [composeButton addTarget:self action:@selector(composeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    composeButton.enabled = NO;
    self.composeButton = composeButton;
    
    CGFloat composeButtonPaddingBottom = 14;
    
    CGFloat textViewBgH = composeButtonPaddingBottom + composeButtonH + 17 + textViewH + textViewY;
    CGFloat textViewBgY = ScreenHeight;
    CGFloat textViewBgW = ScreenWidth;
    UIView *textViewBg = [[UIView alloc] initWithFrame:CGRectMake(0, textViewBgY, textViewBgW, textViewBgH)];
    textViewBg.backgroundColor = [UIColor colorFromHexString:@"eaeaea"];
    
    
    [textViewBg addSubview:textView];
    
    [textViewBg addSubview:composeButton];
    [self.view addSubview:textViewBg];
    self.textViewBg = textViewBg;
    
    
    LPDetailBottomView *bottomView = [[LPDetailBottomView alloc] initWithFrame:CGRectZero];
    bottomView.delegate = self;
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
}




#pragma mark - 跳转到首页
- (void)popToHomeViewController {
    if (self.isPlaying && !self.isRelateVideo) {
        LPPlayerModel *playerModel = [[LPPlayerModel alloc] init];
        playerModel = self.playerModel;
        playerModel.parentView = self.coverImageView;
        self.playerView.playerModel = playerModel;
        [self.playerView pause];
        [self.playerView.controlView hideControlView];
        self.playerView.controlView.cellVideo = YES;
        self.videoDetailControllerBlock();
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        [self.playerView removePlayerObserver];
        self.playerView.controlView.cellVideo = YES;
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)dealloc {
    
    [self popToHomeViewController];
 
}

@end
