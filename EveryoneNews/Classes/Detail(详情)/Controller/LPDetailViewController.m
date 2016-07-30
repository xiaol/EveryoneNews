//
//  LPDetailViewController.m
//  EveryoneNews
//
//  Created by apple on 15/5/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//  header: imgUrl title updateTime

#import "LPDetailViewController.h"
#import "LPPress.h"
#import "LPContent.h"
#import "LPContentFrame.h"
#import "LPComment.h"
#import "LPZhihuPoint.h"
#import "LPWeiboPoint.h"
#import "LPContentCell.h"
#import "UIImageView+WebCache.h"
#import "LPZhihuView.h"
#import "LPWaterfallView.h"
#import "LPPressTool.h"
#import "LPCommentView.h"
#import "AccountTool.h"
#import "MBProgressHUD+MJ.h"
#import "LPConcernPress.h"
#import "LPConcern.h"
#import "LPPhoto.h"
#import "LPPhotoCell.h"
#import "MainNavigationController.h"
#import "LPRelateView.h"
#import "CardFrame.h"
#import "CardImage.h"
#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "MobClick.h"
#import "LPShareView.h"
#import "LPShareViewController.h"
#import "LPShareCell.h"
#import "LPCommentCell.h"
#import "LPRelateCell.h"
#import "LPDetailViewController+Share.h"
#import "LPDetailViewController+RelatePoint.h"
#import "LPDetailViewController+FulltextComment.h"
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
#import "LPTextView.h"
#import "LPDetailScrollView.h"
#import "LPDetailTipView.h"
#import "Card+Create.h"
#import <SafariServices/SafariServices.h>
#import "Comment+Create.h"
#import "LPDetailVideoController.h"
#import <WebKit/WebKit.h>
#import "LPSearchCardFrame.h"
#import "LPSearchCard.h"
#import "LPConcernDetailViewController.h"
#import "LPConcernCardFrame.h"
#import "LPConcernCard.h"

static const NSString * privateContext;

const static CGFloat changeFontSizeViewH = 150;

@interface LPDetailViewController () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate,LPRelateCellDelegate, LPDetailTopViewDelegate, LPShareViewDelegate,LPDetailBottomViewDelegate, LPShareCellDelegate, LPContentCellDelegate, LPBottomShareViewDelegate, LPDetailChangeFontSizeViewDelegate, LPFullCommentCellDelegate, UITextViewDelegate,SFSafariViewControllerDelegate,LPCommentCellDelegate>


#pragma mark - 属性声明
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

@property (nonatomic, strong) Card *card;

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



@end

@implementation LPDetailViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6"];
    self.statusWindow.hidden = YES;
    
    [self setupSubviews];
    [self setupBottomView];
    [self setupData];
    // 收藏状态
    [self collectedButtonStatusChange];
    
    [noteCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [noteCenter addObserver:self  selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 添加关注
    [noteCenter addObserver:self selector:@selector(addConcernNotification) name:LPAddConcernSourceNotification object:nil];
    // 取消关注
    [noteCenter addObserver:self selector:@selector(cancelConcernNotification) name:LPRemoveConcernSourceNotification object:nil];
    
    [noteCenter addObserver:self selector:@selector(applicationTerminateNotification) name:UIApplicationWillTerminateNotification object:nil];
    
    
}

#pragma mark - applicationTerminateNotification 
- (void)applicationTerminateNotification {
    [self endTimer];
    // 提交用户日志
    [self submitUserOperationLog];
}


#pragma mark - viewWillAppear
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 友盟统计打开详情页次数
    //    [MobClick beginLogPageView:@"DetailPage"];
    self.stayTimeInterval = 0;
    [self startTimer];
}

#pragma mark - 懒加载
- (NSArray *)relates
{
    if (_relates == nil) {
        _relates = [NSArray array];
    }
    return _relates;
}

- (NSMutableArray *)relatePointFrames {
    if (!_relatePointFrames) {
        _relatePointFrames = [NSMutableArray array];
    }
    return _relatePointFrames;
}

- (NSMutableArray *)contentArray {
    if (!_contentArray) {
        _contentArray = [NSMutableArray array];
    }
    return _contentArray;
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

- (NSMutableDictionary *)contentDictionary {
    if (_contentDictionary == nil) {
        _contentDictionary = [NSMutableDictionary dictionary];
    }
    return _contentDictionary;
}

- (NSMutableDictionary *)heightDictionary {
    if (_contentDictionary == nil) {
        _contentDictionary = [NSMutableDictionary dictionary];
    }
    return _contentDictionary;
    
}

- (NSMutableArray *)contentFrames {
    if (_contentFrames == nil) {
        _contentFrames = [NSMutableArray array];
    }
    return _contentFrames;
}

#pragma mark - 收藏按钮状态变化
- (void)collectedButtonStatusChange {
    if ([AccountTool account]) {
        // 搜索页面跳转
        if (self.searchCardFrame) {
            if ([self nid]) {
                [Card cardIsCollected:[self nid] cardIsCollectedBlock:^(BOOL isCollected, BOOL isExists) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (!isCollected) {
                            [self.bottomView.favoriteBtn setBackgroundImage:[UIImage imageNamed:@"详情页未收藏"] forState:UIControlStateNormal];
                            
                        } else {
                            [self.bottomView.favoriteBtn setBackgroundImage:[UIImage imageNamed:@"详情页已收藏"] forState:UIControlStateNormal];
                        }
                    });
                }];
            }
        } else {
            if (![self.card.isCollected isEqual:@(1)]) {
                [self.bottomView.favoriteBtn setBackgroundImage:[UIImage imageNamed:@"详情页未收藏"] forState:UIControlStateNormal];
                
            } else {
                [self.bottomView.favoriteBtn setBackgroundImage:[UIImage imageNamed:@"详情页已收藏"] forState:UIControlStateNormal];
            }
        }
    }
}


//当键盘出现或改变时调用
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



#pragma mark - 发表评论文字变化
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


#pragma mark - 结束编辑
- (void)composeCommentBackgroundViewTap {
    [self.textView endEditing:YES];
    [self.textView setText:@""];
}


#pragma mark - dealloc
- (void)dealloc {
    [noteCenter removeObserver:self];
    ////NSLog(@"%@", NSStringFromSelector(_cmd));
}

#pragma mark - 加载详情页所有数据
- (void)setupData {
    
    // 详情页block
    void (^contentBlock)(id json) = ^(id json) {
          //NSLog(@"详情页--%@", json[@"code"]);
        if ([json[@"code"] integerValue] == 2000) {
            [self.contentFrames removeAllObjects];
            NSInteger i = 0;
            
            NSMutableDictionary *dict = json[@"data"];
            NSString *title = dict[@"title"];
            NSString *pubTime = dict[@"ptime"];
            NSString *pubName = dict[@"pname"];
            NSString *concern = [NSString stringWithFormat:@"%@", dict[@"concern"]] ;
            
            self.concernCount = concern;
            
            self.contentTitle = title;
            self.pubTime = pubTime;
            self.pubName = pubName;
            
            self.shareURL = [NSString stringWithFormat:@"http://deeporiginalx.com/news.html?type=0&nid=%@", [self nid] ] ;

            self.shareTitle = title;
            self.submitDocID = dict[@"docid"];
            self.channel = dict[@"channel"];
            // 更新详情页评论数量
            self.commentsCount = [dict[@"comment"] integerValue];
            self.topView.badgeNumber = self.commentsCount;
            self.bottomView.badgeNumber = self.commentsCount ;

            [self setupHeaderView:title pubTime:pubTime pubName:pubName];
            
            // 关注本文
            NSString *conpubFlag = [dict[@"conpubflag"] stringValue];
            self.conpubFlag = conpubFlag;
            
            // 关心本文
            NSString *conFlag = [dict[@"conflag"] stringValue];
            self.conFlag = conFlag;
            
            
            NSMutableArray *bodyArray = [[NSMutableArray alloc] initWithArray:dict[@"content"]];
            // 第一个图片作为分享图片
            for (NSDictionary *dict in bodyArray) {
                if (dict[@"img"] && i == 0) {
                    self.shareImageURL = dict[@"img"];
                }
            }

            for (NSDictionary *dict in bodyArray) {
                
                LPContent *content = [[LPContent alloc] init];
                
                content.isAbstract = NO;
                content.index = dict[@"index"];
                content.photo = dict[@"img"];
                content.photoDesc = dict[@"img_info"];
                content.body = dict[@"txt"];
                if (dict[@"vid"]) {
                    content.video = [self subVideoString:dict[@"vid"]];
                }
                if (content.photo) {
                    content.isPhoto = YES;
                    content.contentType = 1;
                    
                } else if(content.video){
                    
                    content.contentType = 3;
                    content.isPhoto = NO;
                } else if(content.body) {
                    
                    content.contentType = 2;
                    content.isPhoto = NO;
                }
                LPContentFrame *contentFrame = [[LPContentFrame alloc] init];
                contentFrame.content = content;
                [self.contentFrames addObject:contentFrame];
            }
        }
    };

    // 精选评论block
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
    
    // 全文评论
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

    // 相关观点block
    void (^relatePointBlock)(id json) = ^(id json) {
        
        //NSLog(@"相关观点--%@", json[@"code"]);
        
        if ([json[@"code"] integerValue] == 2000) {
            [self.relatePointFrames removeAllObjects];
            NSDictionary *dict = json[@"data"];
        
            NSArray *relatePointArray = [LPRelatePoint objectArrayWithKeyValuesArray:dict];
            // 按照时间排序
            NSArray *sortedRelateArray = [relatePointArray sortedArrayUsingComparator:^NSComparisonResult(LPRelatePoint *p1, LPRelatePoint *p2) {
                return [p2.ptime compare:p1.ptime];
            }];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy"];
            NSString *currentYear = [formatter stringFromDate:[NSDate date]];
            
            for (int i = 0; i < sortedRelateArray.count; i++) {
                LPRelatePoint *point = sortedRelateArray[i];
                NSString *updateTime = point.ptime;
                NSString *updateYear = [updateTime substringToIndex:4];
                NSString *updateMonthDay = [[updateTime substringWithRange:NSMakeRange(5, 5)] stringByReplacingOccurrencesOfString:@"-"withString:@"/"];
                if ([updateYear isEqualToString:currentYear]) {
                    point.ptime = updateMonthDay;
                } else {
                    point.ptime = [NSString stringWithFormat:@"%@/%@", updateYear,updateMonthDay];
                }
                currentYear = updateYear;
                if ([point.from isEqualToString:@"Google"]) {
                    self.googleSourceExistsInRelatePoint = true;
                }
               
            }
            
            self.relatePointArray = sortedRelateArray;
            for (int i = 0; i < sortedRelateArray.count; i ++) {
                LPRelatePoint *point = sortedRelateArray[i];
                LPRelateFrame *relateFrame = [[LPRelateFrame alloc] init];
                relateFrame.currentRowIndex = i;
                relateFrame.relatePoint = point;
                relateFrame.totalCount = sortedRelateArray.count;
                relateFrame.googleSourceExistsInRelatePoint = self.googleSourceExistsInRelatePoint;
                [self.relatePointFrames addObject:relateFrame];
                if (i == 2) {
                    break;
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
        self.reloadPage.hidden = YES;
        self.bottomView.userInteractionEnabled = YES;
        self.topView.shareButton.enabled = YES;
    };
    
    void (^showReloadPageBlock)() = ^{
        self.tableView.hidden = YES;
        self.reloadPage.hidden = NO;
        self.bottomView.userInteractionEnabled = NO;
        self.topView.shareButton.enabled = NO;
    };

    // 详情页正文
    NSMutableDictionary *detailContentParams = [NSMutableDictionary dictionary];
    NSString *detailContentURL = [NSString stringWithFormat:@"%@/v2/ns/con", ServerUrlVersion2];
    NSString *uid = [userDefaults objectForKey:@"uid"];
    detailContentParams[@"nid"] = [self nid];
    detailContentParams[@"uid"] = uid;
    
    
    NSLog(@"%@?nid=%@&&uid=%@",detailContentURL, [self nid], uid);
    
    // 精选评论
    NSString *excellentDetailCommentsURL = [NSString stringWithFormat:@"%@/v2/ns/coms/h", ServerUrlVersion2];
    NSMutableDictionary *excellentDetailCommentsParams = [NSMutableDictionary dictionary];
    
//    NSLog(@"%@", [self docId]);
    
    excellentDetailCommentsParams[@"did"] = [[[self docId] stringByBase64Encoding] stringByTrimmingString:@"="] ;
    excellentDetailCommentsParams[@"uid"] = [userDefaults objectForKey:@"uid"];
 
//    //NSLog(@"%@", excellentDetailCommentsParams);
    
    
    // 相关观点
    NSMutableDictionary *detailRelatePointParams = [NSMutableDictionary dictionary];
    detailRelatePointParams[@"nid"] = [self nid];
    NSString *relateURL = [NSString stringWithFormat:@"%@/v2/ns/asc", ServerUrlVersion2];

//    //NSLog(@"%@?url=%@",relateURL,  [self.card valueForKey:@"newId"]);
    
    // 全文评论
    NSString *detailCommentsURL = [NSString stringWithFormat:@"%@/v2/ns/coms/c", ServerUrlVersion2];
    NSMutableDictionary *detailCommentsParams = [NSMutableDictionary dictionary];
    detailCommentsParams[@"did"] = [[[self docId] stringByBase64Encoding] stringByTrimmingString:@"="];
    detailCommentsParams[@"p"] = @(1);
    detailCommentsParams[@"c"] = @"20";
    detailCommentsParams[@"uid"] = [userDefaults objectForKey:@"uid"];
    
   // //NSLog(@"%@",    detailCommentsParams[@"did"] );
    
    
    // 详情页正文
    [LPHttpTool getWithURL:detailContentURL params:detailContentParams success:^(id json) {
        
        contentBlock(json);
        // 推送跳转到详情页
        if (!excellentDetailCommentsParams[@"did"]) {
            excellentDetailCommentsParams[@"did"]  = [[[self submitDocID] stringByBase64Encoding] stringByTrimmingString:@"="];
        }
        // 详情页精选评论
        [LPHttpTool getWithURL:excellentDetailCommentsURL params:excellentDetailCommentsParams success:^(id json) {

            excellentCommentsBlock(json);
            // 相关观点
            [LPHttpTool getWithURL:relateURL params:detailRelatePointParams success:^(id json) {
                relatePointBlock(json);
                
                // 推送跳转到详情页
                if (!detailCommentsParams[@"did"]) {
                    detailCommentsParams[@"did"]  = [[[self submitDocID] stringByBase64Encoding] stringByTrimmingString:@"="];
                }
                // 全文评论
                [LPHttpTool getWithURL:detailCommentsURL params:detailCommentsParams success:^(id json) {
                    commentsBlock(json);
                    reloadTableViewBlock();
                    
//                    NSLog(@"%@", self.conpubFlag);
                    
                } failure:^(NSError *error) {
                    showReloadPageBlock();
                    NSLog(@"全文评论：%@", error);
                }];
                
            } failure:^(NSError *error) {
               showReloadPageBlock();
                NSLog(@"相关观点：%@", error);

            }];

        } failure:^(NSError *error) {
            showReloadPageBlock();
            NSLog(@"精选评论：%@", error);
        }];

    } failure:^(NSError *error) {
        showReloadPageBlock();
        NSLog(@"正文：%@", error);
 
        
    }];
}


- (void)noCommentsViewTip {
    if (self.fulltextCommentFrames.count > 0) {
        self.noCommentView.hidden = YES;
    } else {
        self.noCommentView.hidden = NO;
    }
}

#pragma mark - 视频链接截取 
- (NSString *)subVideoString:(NSString *)str {
    NSScanner *scanner = [NSScanner scannerWithString:str];
    NSString *dataSrc = @"data-src";
    if (![str containsString:dataSrc]) {
        dataSrc = @"src";
    }
    NSString *name;
    [scanner scanUpToString:dataSrc intoString:NULL];
    [scanner scanUpToString:@"auto=0" intoString:&name];
    NSRange range = [name rangeOfString:@"\""];//匹配得到的下标
    return  [[name substringFromIndex:range.location + 1] stringByReplacingOccurrencesOfString:@"preview" withString:@"player"];
}

#pragma mark - viewDidDisappear
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if(!self.searchCardFrame) {
        if (self.navigationController.viewControllers.count == 0) {
            if (!self.isRead) {
                [self.card setValue:@(1) forKey:@"isRead"];
                CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
                [cdh saveBackgroundContext];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //NSLog(@"success");
                });
            }
            [self endTimer];
            // 提交用户日志
            [self submitUserOperationLog];
            
        }
        self.statusWindow.hidden = NO;
    }
}

#pragma mark - 开启定时器
- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeating:YES firing:^{
    self.stayTimeInterval++;
    }];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:UITrackingRunLoopMode];
}

#pragma mark - 清空定时器
- (void)endTimer {
    [self.timer invalidate];
    self.timer = nil;

}

#pragma mark - viewWillDisappear
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [MobClick endLogPageView:@"DetailPage"];

}


#pragma mark - 上传用户操作日志
- (void)submitUserOperationLog {
    
    NSString *uid = (NSString *)[userDefaults objectForKey:@"uid"];
    NSString *province = @""; // 省
    NSString *city = @""; // 城市
    NSString *county  = @""; // 区，县
    NSString *n = [self nid];
    NSString *c = [NSString stringWithFormat:@"%ld", (long)[self channelID].integerValue]; // 频道编号
    NSString *t = @"0";
    NSString *s = [NSString stringWithFormat:@"%d",self.stayTimeInterval];
    NSString *f = @"0";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:n forKey:@"n"];
    [dic setValue:c forKey:@"c"];
    [dic setValue:t forKey:@"t"];
    [dic setValue:s forKey:@"s"];
    [dic setValue:f forKey:@"f"];
   
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *data  = [[jsonData base64EncodedStringWithOptions:0] stringByTrimmingString:@"="];
    NSString *url = [NSString stringWithFormat:@"http://bdp.deeporiginalx.com/rep/v2/c?u=%@&p=%@t=%@&i=%@&d=%@", uid,province,city,county,data];

    if (!error) {
        self.http = [LPHttpTool http];
        [self.http getImageWithURL:url params:nil success:^(id json) {
        } failure:^(NSError *error) {
            //NSLog(@"%@", error);

        }];
    }
}

#pragma mark - 设置状态栏样式
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
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
        // self.lastContentOffsetY < scrollView.contentOffset.y ? [self fadeOut] : [self fadeIn];
    } else if ([scrollView isKindOfClass:[UIScrollView class]]) {
        int page = scrollView.contentOffset.x / self.view.frame.size.width;
        self.pageControl.currentPage = page;
        if (page == 0) {
            [self hideContentBtn];
        } else {
            [self hideCommentBtn];
        }
    }
}

#pragma mark - 返回上一界面
-(void)backButtonDidClick:(LPDetailTopView *)detailTopView {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 创建视图
- (void)setupSubviews {
    CGFloat bottomViewHeight = 40.0f;
    if (iPhone6Plus) {
        bottomViewHeight = 48.5f;
        
    }
    
    CGFloat tableViewX = 0;
    CGFloat tableViewY = StatusBarHeight + TabBarHeight + 0.5;
    CGFloat tableViewW = ScreenWidth;
    CGFloat tableViewH = ScreenHeight - tableViewY;
    
    LPDetailScrollView *scrollView = [[LPDetailScrollView alloc] initWithFrame:CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH)] ;
    self.automaticallyAdjustsScrollViewInsets = NO;
    scrollView.bounces = NO;
    scrollView.contentInset = UIEdgeInsetsZero;
    scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0,0.0,0.0,0.0);
    scrollView.contentSize = CGSizeMake(tableViewW * 2, tableViewH);
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled=YES;
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.scrollsToTop = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;

    // 文章内容
    UITableView *tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0,tableViewW, tableViewH) style:UITableViewStyleGrouped];
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
    
    // 上拉加载更多
    __weak typeof(self) weakSelf = self;
    self.tableView.footer = [LPRelatePointFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreRelateData];
    }];
    
    
    // 评论列表
    UITableView *commentsTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth + 1, 0, ScreenWidth - 1, tableViewH - bottomViewHeight) style:UITableViewStyleGrouped];
    commentsTableView.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6"];
    commentsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    commentsTableView.delegate = self;
    commentsTableView.dataSource = self;
    commentsTableView.scrollEnabled = NO;
    commentsTableView.scrollsToTop = NO;
    
    self.commentsTableView = commentsTableView;
    // 上拉加载更多
    self.commentsTableView.footer = [LPLoadFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreCommentsData];
    }];
    [scrollView addSubview:commentsTableView];
    
    // 顶部视图
    LPDetailTopView *topView = [[LPDetailTopView alloc] initWithFrame: self.view.bounds];
    topView.delegate = self;
    [self.view addSubview:topView];
    self.topView = topView;
    
    [self setupLoadingView];
    [self showLoadingView];
 
 
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth + 0.5, 0, 0.5, tableViewH)];
    seperatorView.backgroundColor = [UIColor colorFromHexString:LPColor10];
    [scrollView addSubview:seperatorView];
    
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = 2;
    [self.view addSubview:pageControl];
    
    self.pageControl= pageControl;
    
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
    
    // 详情页重新加载
    [self setupReloadPage];
    
    
}

#pragma mark - 重新加载
- (void)setupReloadPage {
    CGFloat bottomViewHeight = 40.0f;
    
    if (iPhone6Plus) {
        bottomViewHeight = 48.5f;
        
    }
    double topViewHeight = TabBarHeight + StatusBarHeight + 0.5;
    if (iPhone6) {
        topViewHeight = 72;
    }
    // 重新加载提示框
    UIView *reloadPage = [[UIView alloc] initWithFrame:CGRectMake(0, topViewHeight, ScreenWidth, ScreenHeight - topViewHeight - bottomViewHeight)];
    reloadPage.backgroundColor = [UIColor colorFromHexString:LPColor9];
    reloadPage.userInteractionEnabled = YES;
    UITapGestureRecognizer *reloadTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReloadPage)];
    [reloadPage addGestureRecognizer:reloadTapGesture];
    reloadPage.hidden = YES;
    self.reloadPage = reloadPage;
    
    CGFloat reloadImageViewW = 107;
    CGFloat reloadImageViewH = 109;
    CGFloat reloadImageViewX = (ScreenWidth - reloadImageViewW) / 2;
    CGFloat reloadImageViewY = (ScreenHeight - reloadImageViewH) / 2 - topViewHeight;
    
    UIImageView *reloadImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"重新加载"]];
    reloadImageView.frame = CGRectMake(reloadImageViewX, reloadImageViewY, reloadImageViewW, reloadImageViewH);
    [reloadPage addSubview:reloadImageView];
    
    NSString *reloadStr = @"点击屏幕重新加载";
    CGFloat fontSize = 12;
    CGSize size = [reloadStr sizeWithFont:[UIFont systemFontOfSize:fontSize] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    CGFloat labelW = size.width;
    CGFloat labelH = size.height;
    CGFloat labelX = (ScreenWidth - labelW) / 2;
    CGFloat labelY = CGRectGetMaxY(reloadImageView.frame) + 20;
    
    UILabel *reloadLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
    reloadLabel.text = reloadStr;
    reloadLabel.font = [UIFont systemFontOfSize:fontSize];
    reloadLabel.textColor = [UIColor colorFromHexString:LPColor4];
    [reloadPage addSubview:reloadLabel];
    
    [self.view addSubview:reloadPage];
}


- (void)tapReloadPage {
    [self showLoadingView];
    [self setupData];
    [self.tableView reloadData];
    [self.commentsTableView reloadData];
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
                [weakSelf.commentsTableView.footer endRefreshing];
            } else {
                [weakSelf.commentsTableView.footer noticeNoMoreData];
            }
        } failure:^(NSError *error) {
            [weakSelf.commentsTableView.footer endRefreshing];
        }];
}


#pragma mark - Loading View
- (void)setupLoadingView {
    UIView *contentLoadingView = [[UIView alloc] initWithFrame:CGRectMake(0, StatusBarHeight + TabBarHeight, ScreenWidth, ScreenHeight - StatusBarHeight - TabBarHeight)];
    
    // Load images
    NSArray *imageNames = @[@"xl_1", @"xl_2", @"xl_3", @"xl_4"];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i++) {
        [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
    }
    
    // Normal Animation
    UIImageView *animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 36) / 2, (ScreenHeight - StatusBarHeight - TabBarHeight) / 3, 36 , 36)];
    animationImageView.animationImages = images;
    animationImageView.animationDuration = 1;
    [self.view addSubview:animationImageView];
    self.animationImageView = animationImageView;
    contentLoadingView.hidden = YES;
    [contentLoadingView addSubview:animationImageView];
    [self.view addSubview:contentLoadingView];
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(animationImageView.frame), ScreenWidth, 40)];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.text = @"正在努力加载...";
    loadingLabel.font = [UIFont systemFontOfSize:12];
    loadingLabel.textColor = [UIColor colorFromHexString:@"#999999"];
    [contentLoadingView addSubview:loadingLabel];
    self.loadingLabel = loadingLabel;
    
    self.contentLoadingView = contentLoadingView;
    
}

#pragma mark - 首页显示正在加载提示
- (void)showLoadingView {
    [self.animationImageView startAnimating];
    self.contentLoadingView.hidden = NO;
    self.reloadPage.hidden = YES;
}


#pragma mark - 首页隐藏正在加载提示
- (void)hideLoadingView {
    
    [self.animationImageView stopAnimating];
    self.contentLoadingView.hidden = YES;
}

#pragma mark - 创建底部视图
- (void)setupBottomView {
    LPDetailBottomView *bottomView = [[LPDetailBottomView alloc] initWithFrame:CGRectZero];
    bottomView.delegate = self;
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
}

#pragma mark - 获取Card内容
- (Card *)card {
    switch (self.sourceViewController) {
        case searchSource: case remoteNotificationSource: case concernHistorySource:
            return nil;
            break;
            
        default:
            // 小于100
            if (!_card) {
                CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
                _card = (Card *)[cdh.importContext existingObjectWithID:self.cardID error:nil];
                return _card;
            }
            return _card;
            
            break;
    }
    
}

- (NSString *)nid {
    
    switch (self.sourceViewController) {
            
        case searchSource:
            return [NSString stringWithFormat:@"%@", self.searchCardFrame.card.nid];
            break;
        case concernHistorySource:
            return [NSString stringWithFormat:@"%@", self.concernCardFrame.card.nid];
            break;
        case remoteNotificationSource:
            return self.remotePushNid;
            break;
            
        default:
            if (![self card]) return nil;
                return [[self card] valueForKey:@"nid"];
            break;
    }
}

- (NSString *)docId {
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
            
        default:
            if (![self card]) return nil;
            return [[self card] valueForKey:@"docId"];
            break;
    }
}

- (NSNumber *)channelID {
    switch (self.sourceViewController) {
            
        case searchSource:
            return  self.searchCardFrame.card.channelId;
            break;
            
         case remoteNotificationSource:
            return self.channel;
            break;
        case concernHistorySource:
            return  self.concernCardFrame.card.channelId;
            break;
        default:
            if (![self card]) return nil;
            return [[self card] valueForKey:@"channelId"];
            break;
    }
  
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        return 3;
    } else if (tableView == self.commentsTableView) {
        return 1;
    } else {
        return 1;
    }
 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        if (section == 0) {
            return self.contentFrames.count;
        } else if (section == 1) {
            return self.excellentCommentsFrames.count;
        } else if(section == 2) {
            return self.relatePointFrames.count;
        } else {
            return 1;
        }
    } else if (tableView == self.commentsTableView) {
        return self.fulltextCommentFrames.count;
    } else {
        return 1;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            
            LPContentCell *cell = [LPContentCell cellWithTableView:tableView];
            cell.delegate = self;
            cell.contentFrame = self.contentFrames[indexPath.row];
            return cell;
            
        } else if (indexPath.section == 1) {
            
            LPCommentCell *cell = [LPCommentCell cellWithTableView:tableView];
            cell.commentFrame = self.excellentCommentsFrames[indexPath.row];
            cell.delegate = self;
            return cell;
            
        } else if (indexPath.section == 2) {
            
            LPRelateCell *cell = [LPRelateCell cellWithTableView:tableView];
            cell.relateFrame = self.relatePointFrames[indexPath.row];
            cell.delegate = self;
            return cell;
        } else {
            return nil;
        }
    } else if (tableView == self.commentsTableView) {
        LPFullCommentCell *cell = [LPFullCommentCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.fullCommentFrame = self.fulltextCommentFrames[indexPath.row];
        return cell;
    } else {
        return nil;
    }
  
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            LPContentFrame *contentFrame = self.contentFrames[indexPath.row];
            return contentFrame.cellHeight;
        } else if (indexPath.section == 1) {
            
            LPCommentFrame *commentFrame = self.excellentCommentsFrames[indexPath.row];
            return commentFrame.cellHeight;
        } else if (indexPath.section == 2) {
            
            LPRelateFrame *relateFrame = self.relatePointFrames[indexPath.row];
            return relateFrame.cellHeight;
        } else {
            return 0.0;
            
        }
    } else if (tableView == self.commentsTableView) {
        LPFullCommentFrame *commentFrame = self.fulltextCommentFrames[indexPath.row];
        return commentFrame.cellHeight;
        
    } else {
        return 0.0;
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
        firstSeperatorView.backgroundColor = [UIColor colorFromHexString:LPColor2];
        
        [headerView addSubview:firstSeperatorView];
        
        UIView *secondSeperatorView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(firstSeperatorView.frame), CGRectGetMaxY(titleLabel.frame) + 6, ScreenWidth - padding - CGRectGetMaxX(firstSeperatorView.frame), 1)];
        secondSeperatorView.backgroundColor = [UIColor colorFromHexString:LPColor5];
        
        [headerView addSubview:secondSeperatorView];
        
        if (section == 1) {
            if (self.excellentCommentsFrames.count > 0) {
                titleLabel.text = @"热门评论";
                return headerView;
            } else {
                return nil;
            }
            
        } else if(section == 2) {
            if (self.relatePointArray.count > 0) {
                titleLabel.text = @"相关观点";
                return headerView;
            } else {
                return nil;
            }
            
        } else {
            return nil;
        }
    } else if (tableView == self.commentsTableView) {
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
        firstSeperatorView.backgroundColor = [UIColor colorFromHexString:LPColor2];
        
        [headerView addSubview:firstSeperatorView];
        
        UIView *secondSeperatorView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(firstSeperatorView.frame), CGRectGetMaxY(titleLabel.frame) + 6, ScreenWidth - padding - CGRectGetMaxX(firstSeperatorView.frame), 1)];
        secondSeperatorView.backgroundColor = [UIColor colorFromHexString:LPColor5];
        titleLabel.text = @"热门评论";
        [headerView addSubview:secondSeperatorView];
        return headerView;

    } else {
        return nil;
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
 
    
    UIView *commonFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.1)];
    if (tableView == self.tableView) {

        CGFloat bottomPaddingY = 30;
        CGFloat contentBottomViewH = 200;
        if (iPhone6) {
            bottomPaddingY = 22;
            contentBottomViewH = 192;
        }
        
        if (section == 0) {
            UIView *contentBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, contentBottomViewH)];
            
            // 关心本文数量
            CGFloat labelFontSize = 13;
            CGFloat labelW = [self.concernCount sizeWithFont:[UIFont systemFontOfSize:labelFontSize] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width + 2;
            
            CGFloat concernImageViewH = 18;
            CGFloat concernImageViewW = 21;
            CGFloat concernImageViewY = 5;
            
            CGFloat leftViewX = 18;
            CGFloat leftViewY = bottomPaddingY;
            CGFloat leftViewW = concernImageViewW + labelW + 43;
            CGFloat leftViewH = 29;
            
            if (iPhone6) {
                leftViewH = 28;
            }
            
            CGFloat concernImageViewX = 19;
            if (iPhone6) {
                concernImageViewX = 18;
            }
            
            UIView *leftView = [[UIView alloc] init];
            UIImageView *concernImageView = [[UIImageView alloc] initWithFrame:CGRectMake(concernImageViewX, concernImageViewY, concernImageViewW, concernImageViewH)];
            
            UITapGestureRecognizer *tapConcernGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapConcern)];
           [leftView addGestureRecognizer:tapConcernGesture];
            concernImageView.image = [UIImage imageNamed:@"详情页心未关注"];
            leftView.userInteractionEnabled = YES;
            [leftView addSubview:concernImageView];
            self.concernImageView = concernImageView;
            
            self.leftView = leftView;
            
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
      
            
            // 朋友圈
            CGFloat rightViewH = leftViewH;
            CGFloat friendsPaddingRight = 11;
            NSString *friendsStr = @"朋友圈";
            CGFloat rightLabelW = [friendsStr sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
            
            CGFloat rightImageViewW = 21;
            CGFloat rightViewW = 90;
            CGFloat rightViewX = ScreenWidth - rightViewW - 18;
            CGFloat rightViewY = bottomPaddingY;
            
            
            UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(rightViewX, rightViewY, rightViewW, rightViewH)];
            rightView.layer.borderColor = [UIColor colorFromHexString:LPColor5].CGColor;
            rightView.layer.borderWidth = 1.0f;
            rightView.layer.cornerRadius = borderRadius;
            rightView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *friendsTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(friendsTap)];
            [rightView addGestureRecognizer:friendsTapGesture];
            
            
            CGFloat rightLabelX = rightViewW - rightLabelW - friendsPaddingRight;
            UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(rightLabelX, 0, rightLabelW, rightViewH)];
            rightLabel.text = friendsStr;
            rightLabel.font = [UIFont systemFontOfSize:13];
            rightLabel.textColor = [UIColor colorFromHexString:LPColor4];
            
            [rightView addSubview:rightLabel];
            
            CGFloat rightImageViewH = 21;
            CGFloat rightImageViewY = (rightViewH - rightImageViewH) / 2;
            CGFloat rightImageViewX = CGRectGetMinX(rightLabel.frame) - 8 - rightImageViewW;
            
            UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(rightImageViewX, rightImageViewY, rightImageViewW, rightImageViewH)];
            rightImageView.image = [UIImage imageNamed:@"详情页朋友圈"];
            [rightView addSubview:rightImageView];
            
            CGFloat concernLabelY = CGRectGetMaxY(rightView.frame) + 11;
            NSString *concernStr = @"关心本文，会推荐更多类似内容";
            CGFloat concernLabelW = [concernStr sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
            CGFloat concernLabelH = [concernStr sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
            
            if (iPhone6) {
                 concernLabelW = [concernStr sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
                 concernLabelH = [concernStr sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
            }
            
            
            UILabel *concernLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, concernLabelY, concernLabelW, concernLabelH)];
            concernLabel.text = concernStr;
            concernLabel.font = [UIFont systemFontOfSize:12];
            if (iPhone6) {
                concernLabel.font = [UIFont systemFontOfSize:13];
            }
            
            
            concernLabel.textColor = [UIColor colorFromHexString:LPColor4];
            
            [contentBottomView addSubview:concernLabel];
            [contentBottomView addSubview:rightView];
            
            // 详情页关注
            CGFloat focusViewY = CGRectGetMaxY(concernLabel.frame) + 30;
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
            focusIconImageView.image = [UIImage imageNamed:@"奇点号占位图2"];
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

            self.contentBottomView = contentBottomView;
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
            
            return contentBottomView;
        }
        else if (section == 1 && self.excellentCommentsFrames.count > 0) {
            
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
            [bottomButton setTitleColor:[UIColor colorFromHexString:@"#0086d1"] forState:UIControlStateNormal];
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
            
         
            bottomLabel.textColor = [UIColor colorFromHexString:@"#0086d1"];
            bottomLabel.font = [UIFont systemFontOfSize:15];
            bottomLabel.textAlignment = NSTextAlignmentCenter;
            [footerView addSubview:bottomLabel];
            
            bottomButton.hidden = (self.excellentCommentsFrames.count < 3);
            bottomLabel.hidden = !bottomButton.hidden;
            
            return footerView;
        } else if (section == 2 && self.relatePointArray.count > 0) {
            // 底部视图
            CGFloat bottomWidth = ScreenWidth - BodyPadding * 2;
            CGFloat bottomHeight = 24;
            
            UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(BodyPadding, 0, bottomWidth , bottomHeight)];
            
            
            UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bottomWidth, bottomHeight - 12)];
            bottomLabel.backgroundColor = [UIColor colorFromHexString:LPColor9];
            [footerView addSubview:bottomLabel];
            return footerView;
            
        } else {
            return commonFooterView;
        }
    } else if (tableView == self.commentsTableView) {
        return commonFooterView;
    } else {
        return commonFooterView;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat headerViewHeight = 42;
    
    if (iPhone6) {
        headerViewHeight = 42;
    }
    
    if (tableView == self.tableView) {
        
        if (section == 1) {
            if (self.excellentCommentsFrames.count > 0) {
                return headerViewHeight;
            } else {
                return 0.1f;
            }
            
        } else if (section == 2) {
            if (self.relatePointArray.count > 0) {
                return headerViewHeight + 4;
            } else {
                return 0.1f;
            }
            
        } else {
            return 0.1f;
        }
    } else if (tableView == self.commentsTableView) {
        return headerViewHeight ;
    } else {
        return 0.1f;
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
        if (section == 0) {
            
            return contentBottomViewH;
            
        } else if (section == 1) {
            if (self.excellentCommentsFrames.count > 0) {
                return commentsBottomViewH;
            } else {
                return 0.1f;
            }
        } else if (section == 2){
            if (self.relatePointArray.count > 0 ) {
                return 24;
            } else {
                return 0.1f;
            }
        } else {
            return 0.1f;
        }
    } else if (tableView == self.commentsTableView) {
        return 10.0f;
    } else {
        return 0.1f;
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



#pragma mark - 分享到朋友圈
- (void)friendsTap {
    [self shareToWechatTimelineBtnClick];
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



#pragma mark - 详情页标题
- (void)setupHeaderView:(NSString *)title pubTime:(NSString *)pubtime pubName:(NSString *)pubName {
    
    CGFloat padding = 13;
    if (iPhone6Plus) {
        padding = 19;
    } else if (iPhone6) {
        padding = 16;
    }
    
    // 内容页面标题
    UIView *headerView = [[UIView alloc] init];
    CGFloat titleFontSize = [LPFontSizeManager sharedManager].currentDetaiTitleFontSize;
    CGFloat sourceFontSize = [LPFontSizeManager sharedManager].currentDetailSourceFontSize;;

    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    
    NSMutableAttributedString *titleString = [title attributedStringWithFont:[UIFont  systemFontOfSize:titleFontSize weight:0.5] color:[UIColor colorFromHexString:@"#060606"] lineSpacing:2.0f];
    
    CGFloat titleX = padding;
    CGFloat titleW = ScreenWidth - padding * 2;
    CGFloat titleH = [titleString heightWithConstraintWidth:titleW] + 30;
    CGFloat titleY = 0;
    
    if (iPhone6) {
        titleY = 7;
    }
    titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    titleLabel.attributedText = titleString;
  
    [headerView addSubview:titleLabel];
    
    // 来源
    UILabel *sourceLabel = [[UILabel alloc] init];
    sourceLabel.textColor = [UIColor colorFromHexString:LPColor4];
    sourceLabel.font = [UIFont fontWithName:OpinionFontName size:sourceFontSize];
    CGFloat sourceX = padding;
    CGFloat sourceY = CGRectGetMaxY(titleLabel.frame) - 7;
    
    if (iPhone6) {
        sourceY = CGRectGetMaxY(titleLabel.frame) - 10;
    }
    
    CGFloat sourceW = ScreenWidth - titleX * 2;
    CGFloat sourceH = [@"123" sizeWithFont:[UIFont systemFontOfSize:sourceFontSize] maxSize:CGSizeMake(sourceW, MAXFLOAT)].height;
    sourceLabel.frame = CGRectMake(sourceX, sourceY, sourceW, sourceH);
    NSString *sourceSiteName = [pubName  isEqualToString: @""] ? @"未知来源": pubName;
    
    self.sourceSiteName = sourceSiteName;
    
    NSString *source = [NSString stringWithFormat:@"%@    %@",pubtime, sourceSiteName];
    sourceLabel.text = source;
    [headerView addSubview:sourceLabel];
    headerView.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(sourceLabel.frame) + 30);
    
    if (iPhone6) {
        headerView.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(sourceLabel.frame) + 24);
    }
    
    if (iPhone6) {
        titleW = titleW - 2;
    }
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(padding, headerView.frame.size.height - 11, titleW, 0.5)];
    seperatorView.backgroundColor = [UIColor colorFromHexString:LPColor5];
    [headerView addSubview:seperatorView];
    self.tableView.tableHeaderView = headerView;
    
    
    // 评论列表标题
    UIView *headerView1 = [[UIView alloc] init];
    // 标题
    UILabel *titleLabel1 = [[UILabel alloc] init];
    titleLabel1.numberOfLines = 0;
    titleLabel1.frame = CGRectMake(titleX, titleY, titleW, titleH);
    titleLabel1.attributedText = titleString;
    
    [headerView1 addSubview:titleLabel1];
    
    // 来源
    UILabel *sourceLabel1 = [[UILabel alloc] init];
    sourceLabel1.textColor = [UIColor colorFromHexString:LPColor4];
    sourceLabel1.font = [UIFont fontWithName:OpinionFontName size:sourceFontSize];
    sourceLabel1.frame = CGRectMake(sourceX, sourceY, sourceW, sourceH);
    sourceLabel1.text = source;
    [headerView1 addSubview:sourceLabel1];
    headerView1.frame = CGRectMake(0, 0, ScreenWidth - 1, CGRectGetMaxY(sourceLabel.frame) + 16);
    self.commentsTableView.tableHeaderView = headerView1;
    
    CGFloat headerViewHeight = 40;
    CGFloat marginTop = 100;
    if (iPhone6Plus) {
        marginTop = 176;
    }
    CGFloat noCommentViewY = CGRectGetMaxY(headerView1.frame) + headerViewHeight + marginTop;
    
    CGFloat imageViewH = 41;
    CGFloat imageViewW = 47;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"暂无评论"]];
    imageView.frame = CGRectMake(0, 0, imageViewW, imageViewH);
    
    NSString *noCommentStr = @"哎呦，快抢沙发";
    CGSize size = [noCommentStr sizeWithFont:[UIFont systemFontOfSize:LPFont4] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    UILabel *noCommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 5, size.width, size.height)];
    noCommentLabel.text = noCommentStr;
    noCommentLabel.font = [UIFont systemFontOfSize:LPFont4];
    noCommentLabel.textColor = [UIColor colorFromHexString:@"#888888"];
    
    UIView *noCommentView = [[UIView alloc] initWithFrame:CGRectMake(0, noCommentViewY, ScreenWidth - 1, 200)];
    imageView.centerX = noCommentView.centerX;
    noCommentLabel.centerX = noCommentView.centerX;
    [noCommentView addSubview:imageView];
    [noCommentView addSubview:noCommentLabel];
    
    [self.commentsTableView addSubview:noCommentView];
    
    self.noCommentView = noCommentView;
    self.noCommentView.hidden = YES;
    
    
    

}
#pragma mark - Content Cell Delegate
-(void)contentCell:(LPContentCell *)contentCell didOpenURL:(NSString *)url {
    [LPPressTool loadWebViewWithURL:url viewController:self];
}


- (void)contentCell:(LPContentCell *)contentCell videoImageViewDidTapped:(NSString *)url webView:(WKWebView *)webView webViewF:(CGRect)webViewF {
//         [webView reloadFromOrigin];
    // 处理视频宽高
        NSArray *array = [url componentsSeparatedByString:@";"];
        NSMutableString *mutableString = [[NSMutableString alloc] init];
        for (NSString *str in array) {
            NSString *tempStr = [str copy];
            if ([tempStr containsString:@"width"]) {
                tempStr = [NSString stringWithFormat:@"width=%f&amp", webViewF.size.width];
            } else if ([tempStr containsString:@"height"]) {
                tempStr = [NSString stringWithFormat:@"height=%f&amp", webViewF.size.height];
            }
            if (tempStr.length > 0) {
                [mutableString appendString:[NSString stringWithFormat:@"%@;",tempStr]];
            }
        }

        NSURL *videoUrl =[NSURL URLWithString:mutableString];
        NSURLRequest *request =[NSURLRequest requestWithURL:videoUrl];
        [webView loadRequest:request];
}

//- (void)contentCell:(LPContentCell *)contentCell videoImageViewDidTapped:(NSString *)url {
//    // 处理视频宽高
//        NSArray *url = [url componentsSeparatedByString:@";"];
//        NSMutableString *mutableString = [[NSMutableString alloc] init];
//        for (NSString *str in array) {
//            NSString *tempStr = [str copy];
//            if ([tempStr containsString:@"width"]) {
//                tempStr = [NSString stringWithFormat:@"width=%f&amp", self.contentFrame.webViewF.size.width];
//            } else if ([tempStr containsString:@"height"]) {
//                tempStr = [NSString stringWithFormat:@"height=%f&amp", self.contentFrame.webViewF.size.height];
//            }
//            if (tempStr.length > 0) {
//                [mutableString appendString:[NSString stringWithFormat:@"%@;",tempStr]];
//            }
//        }
//
//        NSURL *url =[NSURL URLWithString:mutableString];
//        NSURLRequest *request =[NSURLRequest requestWithURL:url];
//
//        [self.webView loadRequest:request];
//
//    
//    
//    
////    LPDetailVideoController *videoController = [[LPDetailVideoController alloc] init];
////    videoController.videoURL = url;
////    [self.navigationController pushViewController:videoController animated:YES];
//    
//}

#pragma mark - Bottom View Delegate
- (void)didComposeCommentWithDetailBottomView:(LPDetailBottomView *)detailBottomView {

    self.composeComment = YES;
    self.composeCommentBackgroundView.hidden = NO;
    [self.textView becomeFirstResponder];
}

#pragma mark - 发表评论 
- (void)composeButtonClick {
    __weak typeof(self) weakSelf = self;
    if (![AccountTool account]) {
        
        CGRect toFrame = CGRectMake(0, ScreenHeight, ScreenWidth, self.textViewBg.height);
        self.textViewBg.frame = toFrame;
        [self.textView endEditing:YES];
        self.composeCommentBackgroundView.alpha = 0.0;
        
        [AccountTool accountLoginWithViewController:self success:^(Account *account){
            [weakSelf composeComment];
        } failure:^{
        } cancel:nil];
    } else {
        [self composeComment];
        [self removeComposeView];
    }
  
}

#pragma mark - 移除发表评论提示框
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
        params[@"docid"] = self.docId;
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
                    
                    // 存储评论内容
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    dict[@"commentID"] = comment.commentId;
                    dict[@"upFlag"] = @"0";
                    dict[@"title"] = self.contentTitle;
                    dict[@"nid"] = [NSString stringWithFormat:@"%@", [self nid]];
                    dict[@"commend"] = @"0";
                    dict[@"commentTime"] = comment.createTime;
                    dict[@"comment"] = comment.srcText;
                    // 搜索页面跳转
                    if (self.searchCardFrame) {
                        NSMutableDictionary *cardDict = [NSMutableDictionary dictionary];
                        LPSearchCard *searchCard = self.searchCardFrame.card;
                        [cardDict setObject:searchCard.nid forKey:@"nid"];
                        [cardDict setObject:searchCard.docId forKey:@"docid"];
                        [cardDict setObject:self.contentTitle forKey:@"title"];
                        [cardDict setObject:searchCard.sourceSiteURL forKey:@"purl"];
                        [cardDict setObject:searchCard.sourceSiteName forKey:@"pname"];
                        [cardDict setObject:searchCard.updateTime forKey:@"ptime"];
                        [cardDict setObject:searchCard.channelId forKey:@"channel"];
                        [cardDict setObject:searchCard.commentsCount forKey:@"comment"];
                        if (searchCard.cardImages.count > 0) {
                             [cardDict setObject:searchCard.cardImages forKey:@"imgs"];
                        }
                        [Card createCardWithDict:cardDict commentDict:dict];
                    } else {
                         [Comment createCommentWithDict:dict card:self.card];
                    }
                }
                
            } failure:^(NSError *error) {
                
                [self tipViewWithCondition:5];
            }];
        }
    } else {
          [self tipViewWithCondition:9];
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

#pragma mark - 底部分享按钮
- (void)didShareWithDetailBottomView:(LPDetailBottomView *)detailBottomView {
    [self popShareView];
}

#pragma mark - 顶部分享按钮
- (void)shareButtonDidClick:(LPDetailTopView *)detailTopView {
    [self popShareView];
}

#pragma mark - 顶部Tap

- (void)detailTopViewDidTap:(LPDetailTopView *)detailTopView {
    [self.tableView setContentOffset:CGPointZero animated:YES];
}

#pragma mark - 收藏文章
- (void)didFavoriteWithDetailBottomView:(LPDetailBottomView *)detailBottomView {
    
    if ([AccountTool account] ==  nil) {
        [AccountTool accountLoginWithViewController:self success:^(Account *account){
            [self collectOrNot];
        } failure:^{
        } cancel:nil];
    } else {
        [self collectOrNot];
    }
}

#pragma mark - 收藏和取消收藏
- (void)collectOrNot {
    // 从搜索页面跳转
    if (self.sourceViewController == searchSource) {
          [Card cardIsCollected:[self nid]  cardIsCollectedBlock:^(BOOL isCollected, BOOL isExists) {
              NSMutableDictionary *cardDict = [NSMutableDictionary dictionary];
              LPSearchCard *searchCard = self.searchCardFrame.card;
              [cardDict setObject:searchCard.nid forKey:@"nid"];
              [cardDict setObject:searchCard.docId forKey:@"docid"];
              [cardDict setObject:self.contentTitle forKey:@"title"];
              [cardDict setObject:searchCard.sourceSiteURL forKey:@"purl"];
              [cardDict setObject:searchCard.sourceSiteName forKey:@"pname"];
              [cardDict setObject:searchCard.updateTime forKey:@"ptime"];
              [cardDict setObject:searchCard.channelId forKey:@"channel"];
              [cardDict setObject:searchCard.commentsCount forKey:@"comment"];
              if (searchCard.cardImages.count > 0) {
                [cardDict setObject:searchCard.cardImages forKey:@"imgs"];
              }

              if (isCollected) {
                  // 取消收藏
                  [Card createCardWithDict:cardDict isCollected:false];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self.bottomView.favoriteBtn setBackgroundImage:[UIImage imageNamed:@"详情页未收藏"] forState:UIControlStateNormal];
                     [self tipViewWithCondition:2];
                 });

              } else {
                  // 添加收藏
                 [Card createCardWithDict:cardDict isCollected:true];
                 dispatch_async(dispatch_get_main_queue(), ^{
                      [self tipViewWithCondition:1];
                      [self.bottomView.favoriteBtn setBackgroundImage:[UIImage imageNamed:@"详情页已收藏"] forState:UIControlStateNormal];
                 });
              }
            [noteCenter postNotificationName:@"UserCollectionedChangeer" object:nil userInfo:nil];
          }];
    } else if(self.sourceViewController == concernHistorySource) {
        [Card cardIsCollected:[self nid]  cardIsCollectedBlock:^(BOOL isCollected, BOOL isExists) {
            NSMutableDictionary *cardDict = [NSMutableDictionary dictionary];
            LPConcernCard *concernCard = self.concernCardFrame.card;
            [cardDict setObject:concernCard.nid forKey:@"nid"];
            [cardDict setObject:concernCard.docId forKey:@"docid"];
            [cardDict setObject:self.contentTitle forKey:@"title"];
            [cardDict setObject:concernCard.sourceSiteURL forKey:@"purl"];
            [cardDict setObject:concernCard.sourceSiteName forKey:@"pname"];
            [cardDict setObject:concernCard.updateTime forKey:@"ptime"];
            [cardDict setObject:concernCard.channelId forKey:@"channel"];
            [cardDict setObject:concernCard.commentsCount forKey:@"comment"];
            if (concernCard.cardImages.count > 0) {
                [cardDict setObject:concernCard.cardImages forKey:@"imgs"];
            }
            
            if (isCollected) {
                // 取消收藏
                [Card createCardWithDict:cardDict isCollected:false];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.bottomView.favoriteBtn setBackgroundImage:[UIImage imageNamed:@"详情页未收藏"] forState:UIControlStateNormal];
                    [self tipViewWithCondition:2];
                });
                
            } else {
                // 添加收藏
                [Card createCardWithDict:cardDict isCollected:true];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self tipViewWithCondition:1];
                    [self.bottomView.favoriteBtn setBackgroundImage:[UIImage imageNamed:@"详情页已收藏"] forState:UIControlStateNormal];
                });
            }
            [noteCenter postNotificationName:@"UserCollectionedChangeer" object:nil userInfo:nil];
        }];

    }
    else {
        
        if ([self.card.isCollected isEqual:@(1)]) {
            [self tipViewWithCondition:2];
        } else {
            [self tipViewWithCondition:1];
        }
        [self updateCardCollectedStatus];
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

#pragma mark - 修改收藏状态
- (void)updateCardCollectedStatus {
    // 修改按钮图标禁用收藏按钮
    if (![self.card.isCollected  isEqual: @(1)]) {
        [self.bottomView.favoriteBtn setBackgroundImage:[UIImage imageNamed:@"详情页已收藏"] forState:UIControlStateNormal];
        [self.card setValue:@(1) forKey:@"isCollected"];
    } else {
        [self.bottomView.favoriteBtn setBackgroundImage:[UIImage imageNamed:@"详情页未收藏"] forState:UIControlStateNormal];
        [self.card setValue:@(0) forKey:@"isCollected"];
    }
    [Card updateCard:self.card];
    [noteCenter postNotificationName:@"UserCollectionedChangeer" object:nil userInfo:nil];
}

#pragma mark - 底部弹出分享对话框
- (void)popShareView {
    UIView *detailBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    detailBackgroundView.backgroundColor = [UIColor blackColor];
    detailBackgroundView.alpha = 0.6;
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBackgroundView)];
    [detailBackgroundView addGestureRecognizer:tapGestureRecognizer];
    
    [self.view addSubview:detailBackgroundView];
    self.detailBackgroundView = detailBackgroundView;
    
    
    // 添加分享
    LPBottomShareView *bottomShareView = [[LPBottomShareView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    bottomShareView.delegate = self;
    [self.view addSubview:bottomShareView];
    
    // 改变字体大小视图
    LPDetailChangeFontSizeView *changeFontSizeView = [[LPDetailChangeFontSizeView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, changeFontSizeViewH)];
    changeFontSizeView.delegate = self;
    [self.view addSubview:changeFontSizeView];
    self.changeFontSizeView = changeFontSizeView;
    
    CGRect toFrame = CGRectMake(0, ScreenHeight - bottomShareView.size.height, ScreenWidth, bottomShareView.size.height);
    
    [UIView animateWithDuration:0.3f animations:^{
        bottomShareView.frame = toFrame;
    }];
    self.bottomShareView = bottomShareView;
}

#pragma mark LPDetailTopView Delegate
- (void)shareView:(LPBottomShareView *)shareView cancelButtonDidClick:(UIButton *)cancelButton {
    [self removeBackgroundView];
}

- (void)removeBackgroundView {
    CGRect bottomShareViewToFrame = CGRectMake(0, ScreenHeight, ScreenWidth, self.bottomShareView.size.height);
    CGRect changeFontSizeViewToFrame = CGRectMake(0, ScreenHeight, ScreenWidth, self.changeFontSizeView.height);

    [UIView animateWithDuration:0.3f animations:^{
        if (self.bottomShareView.origin.y == ScreenHeight - self.bottomShareView.size.height) {
            self.bottomShareView.frame = bottomShareViewToFrame;
        }
        if (self.changeFontSizeView.origin.y == ScreenHeight - self.changeFontSizeView.size.height) {
            self.changeFontSizeView.frame = changeFontSizeViewToFrame;
        }
        self.detailBackgroundView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.bottomShareView removeFromSuperview];
        [self.changeFontSizeView removeFromSuperview];
        [self.detailBackgroundView removeFromSuperview];
    }];
}

- (void)shareView:(LPBottomShareView *)shareView index:(NSInteger)index {
    switch (index) {
        case -2:
            [self shareToWechatSessionBtnClick];
            break;
        case -1:
            [self shareToWechatTimelineBtnClick];
            break;
        case -3:
            [self shareToQQBtnClick];
            break;
        case -4:
            [self shareToSinaBtnClick];
            break;
        case -5:
            [self shareToSmsBtnClick];
            break;
        case -6:
            [self shareToEmailBtnClick];
            break;
        case -7:
            [self shareToLinkBtn];
            break;
         case -8:
            [self changeDetailFontSize];
            break;
            
    }
}

#pragma mark - 改变详情页字体大小
- (void)changeDetailFontSize {
    CGRect shareViewToFrame = CGRectMake(0, ScreenHeight, ScreenWidth, self.bottomShareView.size.height);
    CGRect changeFontSizeViewToFrame = CGRectMake(0, ScreenHeight - changeFontSizeViewH, ScreenWidth, self.changeFontSizeView.height);
    [UIView animateWithDuration:0.3f animations:^{
        self.bottomShareView.frame = shareViewToFrame;
        self.changeFontSizeView.frame = changeFontSizeViewToFrame;
      
    } completion:^(BOOL finished) {
 
    }];
    
}

#pragma mark - LPDetailChangeFontSizeView delegate
- (void)changeFontSizeView:(LPDetailChangeFontSizeView *)changeFontSizeView reloadTableViewWithFontSize:(NSInteger)fontSize fontSizeType:(NSString *)fontSizeType currentDetailContentFontSize:(NSInteger)currentDetailContentFontSize currentDetaiTitleFontSize:(NSInteger)currentDetaiTitleFontSize currentDetailCommentFontSize:(NSInteger)currentDetailCommentFontSize currentDetailRelatePointFontSize:(NSInteger)currentDetailRelatePointFontSize currentDetailSourceFontSize:(NSInteger)currentDetailSourceFontSize {
    
    [LPFontSizeManager sharedManager].currentHomeViewFontSize = fontSize;
    [LPFontSizeManager sharedManager].currentHomeViewFontSizeType = fontSizeType;
    [LPFontSizeManager sharedManager].currentDetailContentFontSize = currentDetailContentFontSize;
    [LPFontSizeManager sharedManager].currentDetaiTitleFontSize = currentDetaiTitleFontSize;
    [LPFontSizeManager sharedManager].currentDetailCommentFontSize = currentDetailCommentFontSize;
    [LPFontSizeManager sharedManager].currentDetailRelatePointFontSize = currentDetailRelatePointFontSize;
    [LPFontSizeManager sharedManager].currentDetailSourceFontSize = currentDetailSourceFontSize;

    [[LPFontSizeManager sharedManager] saveHomeViewFontSizeAndType];
   
    for (LPContentFrame *contentFrame in self.contentFrames) {
        [contentFrame setContentWhenFontSizeChanged:contentFrame];
    }
    
    [self setupHeaderView:self.contentTitle pubTime:self.pubTime pubName:self.pubName];
    [self.tableView reloadData];
  
    [noteCenter postNotificationName:LPFontSizeChangedNotification object:nil];
}

- (void)finishButtonDidClick:(LPDetailChangeFontSizeView *)changeFontSizeView {
    [self removeBackgroundView];
}

#pragma mark - LPZhihuView delegate

- (void)zhihuView:(LPZhihuView *)zhihuView didClickURL:(NSString *)url
{
    [LPPressTool loadWebViewWithURL:url viewController:self];
}

#pragma mark - LPRelateCell delegate

- (void)relateCell:(LPRelateCell *)cell didClickURL:(NSString *)url {
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url] entersReaderIfAvailable:YES];
        safariVC.delegate = self;
        [self presentViewController:safariVC animated:NO completion:nil];
    } else {
      [LPPressTool loadWebViewWithURL:url viewController:self];
    }
    
}

#pragma mark- 外链返回
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
   [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - LPShareCell  Delegate
- (void)cell:(LPShareCell *)shareCell shareIndex:(NSInteger)index {
    switch (index) {
        case -1:
            [self shareToWechatSessionBtnClick];
            break;
        case -2:
            [self shareToWechatTimelineBtnClick];
            break;
        case -3:
            [self shareToQQBtnClick];
            break;
        case -4:
            [self shareToSinaBtnClick];
            break;
    }
}


#pragma mark - 底部评论按钮
- (void)didClickCommentsWithDetailBottomView:(LPDetailBottomView *)detailBottomView {
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width ;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
 
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

#pragma mark - Scroll To Page 0
- (void)didClickContentsWithDetailBottomView:(LPDetailBottomView *)detailBottomView {
    [self hideContentBtn];
    self.pageControl.currentPage = 0;
    CGRect frame = self.scrollView.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}


#pragma mark - 跳转到关注列表
- (void)focusViewTap {
    LPConcernDetailViewController *concernDetailViewController = [[LPConcernDetailViewController alloc] init];
    concernDetailViewController.sourceName = self.sourceSiteName;
    concernDetailViewController.conpubFlag = self.conpubFlag;
    [self.navigationController pushViewController:concernDetailViewController animated:YES];
}

#pragma mark - 点击关注
- (void)rightFocusViewTapGesture {
    
    if (self.forwardImageView.hidden == NO) {
        [self focusViewTap];
        
    } else {
        __weak typeof(self) weakSelf = self;
        if (![AccountTool account]) {
            [AccountTool accountLoginWithViewController:self success:^(Account *account){
                [weakSelf addConcernSourceSiteName];
            } failure:^{
            } cancel:nil];
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
@end
