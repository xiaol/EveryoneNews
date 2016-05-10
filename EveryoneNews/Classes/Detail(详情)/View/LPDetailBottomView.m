//
//  LPDetailBottomView.m
//  EveryoneNews
//
//  Created by dongdan on 16/3/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPDetailBottomView.h"
#import "NSString+LP.h"


const static CGFloat commentsLabelFontSize = 12;
@interface LPDetailBottomView ()

@property (nonatomic, strong) UILabel *commentCountLabel;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *commentsBtn;
@property (nonatomic, strong) UIButton *noCommentsBtn;
@property (nonatomic, strong) UIView *composeView;
@property (nonatomic, strong) UIButton *favoriteBtn;
@property (nonatomic, strong) UIView *commentsCountView;


@end

@implementation LPDetailBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        CGFloat bottomViewHeight = 40.0f;
        if (iPhone6Plus) {
            bottomViewHeight = 48.5f;
      
        }
        self.frame = CGRectMake(0, ScreenHeight - bottomViewHeight, ScreenWidth, bottomViewHeight);
        self.backgroundColor = [UIColor colorFromHexString:@"#f5f5f5"];
        
        double shareButtonWidth = 25;
        double shareButtonHeight = 26;
        double shareButtonPaddingRight = 20;
        
        double commentButtonWidth = 18;
        double commentButtonHeight = 17;
        double commentButtonPaddingTop = 33.5;
        double commentButtonPaddingRight = 5;
        
        if(iPhone6Plus)
        {
            shareButtonWidth = 25;
            shareButtonHeight = 26;
            shareButtonPaddingRight = 20;
            
            commentButtonWidth = 21;
            commentButtonHeight = 19;
            commentButtonPaddingTop = 30.5;
            commentButtonPaddingRight = 5;
        }
        
        // 添加分享按钮
        UIButton *shareBtn = [[UIButton alloc] init];
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"详情页分享"]  forState:UIControlStateNormal];
        shareBtn.enlargedEdge = 10;
        [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
        shareBtn.frame = CGRectMake(ScreenWidth  - shareButtonPaddingRight - shareButtonWidth, (bottomViewHeight - shareButtonHeight) / 2 , shareButtonWidth, shareButtonHeight);
        [self addSubview:shareBtn];
        self.shareButton = shareBtn;
        
        // 收藏按钮
        double favoriteBtnW = 28;
        double favoriteBtnH = 27;
        double favoriteBtnPaddingRight = 37;
        if (iPhone6Plus) {
            favoriteBtnW = 28;
            favoriteBtnH = 27;
            favoriteBtnPaddingRight = 37;
        }
    
        // 收藏按钮
        UIButton *favoriteBtn = [[UIButton alloc] init];
        [favoriteBtn setBackgroundImage:[UIImage imageNamed:@"详情页未收藏"] forState:UIControlStateNormal];
        favoriteBtn.enlargedEdge = 10;
        favoriteBtn.frame = CGRectMake(CGRectGetMinX(shareBtn.frame) - favoriteBtnPaddingRight - favoriteBtnW, (bottomViewHeight - favoriteBtnH) / 2 , favoriteBtnW, favoriteBtnH);
        [favoriteBtn addTarget:self action:@selector(favoriteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:favoriteBtn];
        self.favoriteBtn = favoriteBtn;
        
        // 沙发  评论
        CGFloat commentsPaddingRight = 37;
        CGFloat commentsBtnW = 27;
        CGFloat commentsBtnH = 26;
        
        if (iPhone6Plus) {
           commentsPaddingRight = 37;
           commentsBtnW = 27;
           commentsBtnH = 26;
        }
        
        // 没有评论
        UIButton *noCommentsBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(favoriteBtn.frame) - commentsPaddingRight - commentsBtnW, (bottomViewHeight - commentsBtnH) / 2, commentsBtnW, commentsBtnH)];
        [noCommentsBtn setBackgroundImage:[UIImage imageNamed:@"详情页未评论"] forState:UIControlStateNormal];
        [self addSubview:noCommentsBtn];
        self.noCommentsBtn = noCommentsBtn;
        
        
        // 有评论
        UIButton *commentsBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(favoriteBtn.frame) - commentsPaddingRight - commentsBtnW, (bottomViewHeight - commentsBtnH) / 2, commentsBtnW, commentsBtnH)];
        [commentsBtn setBackgroundImage:[UIImage imageNamed:@"详情页已评论"] forState:UIControlStateNormal];
        commentsBtn.hidden = YES;
        [self addSubview:commentsBtn];
        self.commentsBtn = commentsBtn;
        
        UIView *commentsCountView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(commentsBtn.frame) - 4, bottomViewHeight - 13 - commentsBtnH / 2, commentsBtnW, commentsBtnH / 2)];
        commentsCountView.backgroundColor = [UIColor whiteColor];
        commentsCountView.layer.cornerRadius = 4.0f;
        
        // 评论数量
        UILabel *commentCountLabel = [[UILabel alloc] init];
        commentCountLabel.textAlignment = NSTextAlignmentCenter;
        commentCountLabel.backgroundColor = [UIColor colorFromHexString:@"67a8e7"];
        commentCountLabel.font = [UIFont systemFontOfSize:commentsLabelFontSize];
        commentCountLabel.textColor = [UIColor whiteColor];
        commentCountLabel.layer.cornerRadius = 3.0f;
        commentCountLabel.clipsToBounds = YES;
        commentCountLabel.hidden = YES;

        [commentsCountView addSubview:commentCountLabel];
        self.commentCountLabel = commentCountLabel;
        self.commentsCountView = commentsCountView;
        
        [self addSubview:self.commentsCountView];
        
//        // 评论数量
//        UILabel *commentCountLabel = [[UILabel alloc] init];
//        commentCountLabel.textColor = [UIColor colorFromHexString:@"#909090"];
//        commentCountLabel.font = [UIFont systemFontOfSize:14];
//        [self addSubview:commentCountLabel];
//        self.commentCountLabel = commentCountLabel;
//        
//        // 全文评论
//        UIButton *commentsBtn = [[UIButton alloc] init];
//        [commentsBtn setBackgroundImage:[UIImage imageNamed:@"详情页评论"]  forState:UIControlStateNormal];
//        commentsBtn.enlargedEdge = 15;
//        
//        [commentsBtn addTarget:self action:@selector(fulltextCommentDidClick) forControlEvents:UIControlEventTouchUpInside];
//        commentsBtn.frame = CGRectMake(self.shareButton.frame.origin.x - 20  - commentButtonPaddingRight - commentButtonWidth, bottomViewHeight / 2- commentButtonHeight / 2 , commentButtonWidth, commentButtonHeight);;
//        [self addSubview:commentsBtn];
//        self.commentsBtn = commentsBtn;
        
        UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        seperatorView.backgroundColor = [UIColor colorFromHexString:@"#dadada"];
        [self addSubview:seperatorView];
        
        
        UIView *composeView = [[UIView alloc] init];
        composeView.userInteractionEnabled = YES;
        composeView.layer.borderWidth = 0.5;
        composeView.layer.borderColor = [UIColor colorFromHexString:@"#efefef"].CGColor;
        composeView.layer.cornerRadius = 16;
        composeView.backgroundColor = [UIColor whiteColor];
      
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentDidComposed)];
        [composeView addGestureRecognizer:tapGestureRecognizer];
        
        CGFloat composeViewPaddingTop = 8;
        
        UILabel *composeLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 100, bottomViewHeight - 2 * composeViewPaddingTop)];
        composeLabel.text = @"说一下...";
        composeLabel.textColor = [UIColor colorFromHexString:@"#909090"];
        composeLabel.textAlignment = NSTextAlignmentLeft;
        if (iPhone6Plus) {
            composeLabel.font = [UIFont systemFontOfSize:18];
        } else {
            composeLabel.font = [UIFont systemFontOfSize:15];
        }
        
        [composeView addSubview:composeLabel];
        
        CGFloat composeViewX = 18;
        CGFloat composeViewW = 169;
        if (iPhone6Plus) {
            composeViewX = 18;
            composeViewPaddingTop = 8;
            composeViewW = 169;
        }
        
        composeView.frame = CGRectMake(composeViewX, composeViewPaddingTop, composeViewW, bottomViewHeight - composeViewPaddingTop * 2);
        [self addSubview:composeView];
        self.composeView = composeView;
        
        
        
    }
    return self;
}

- (void)setBadgeNumber:(NSInteger)badgeNumber {
//    CGFloat bottomViewHeight = 40.0f;
//    if (iPhone6Plus) {
//        bottomViewHeight = 48.5f;
//        
//    }
//    double shareButtonWidth = 17;
//    double shareButtonHeight = 17;
//    double shareButtonPaddingRight = 15;
//    
//    double commentButtonWidth = 18;
//    double commentButtonHeight = 17;
//    double commentButtonPaddingTop = 33.5;
//    double commentButtonPaddingRight = 5;
//    
//    if(iPhone6Plus)
//    {
//        shareButtonWidth = 17;
//        shareButtonHeight = 19;
//        
//        commentButtonWidth = 21;
//        commentButtonHeight = 19;
//        commentButtonPaddingTop = 30.5;
//        commentButtonPaddingRight = 5;
//    }
//
//    self.shareButton.frame = CGRectMake(ScreenWidth  - shareButtonPaddingRight - shareButtonWidth, bottomViewHeight / 2 - shareButtonHeight / 2 , shareButtonWidth, shareButtonHeight);
//    
//    _badgeNumber = badgeNumber;
//    
//    NSString *commentCountText = [NSString stringWithFormat:@"%@",@(_badgeNumber)];
//    
//    CGFloat commentCountLabelWidth = [commentCountText sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
//    CGFloat commentCountLabelHeight = bottomViewHeight;
//    CGFloat commentCountLabelX = CGRectGetMinX(self.shareButton.frame) - commentCountLabelWidth - 15;
//    
//    self.commentCountLabel.frame = CGRectMake(commentCountLabelX, 0, commentCountLabelWidth, commentCountLabelHeight);
//    self.commentCountLabel.text = commentCountText;
//    
//    if (_badgeNumber == 0) {
//        self.commentCountLabel.hidden = YES;
//    } else {
//        self.commentCountLabel.hidden = NO;
//    }
//    
//    self.commentsBtn.frame = CGRectMake(self.commentCountLabel.frame.origin.x  - commentButtonPaddingRight - commentButtonWidth, bottomViewHeight / 2 - commentButtonHeight / 2 , commentButtonWidth, commentButtonHeight);
//    
//    CGFloat composeViewPaddingTop = 8;
    
//    CGFloat composeViewX = 18;
//    if (iPhone6Plus) {
//        composeViewX = 18;
//        composeViewPaddingTop = 8;
//    }
//    
//    self.composeView.frame = CGRectMake(composeViewX, composeViewPaddingTop, CGRectGetMinX(self.commentsBtn.frame)- BodyPadding - 15, bottomViewHeight - composeViewPaddingTop * 2);
    
     _badgeNumber = badgeNumber;
    //self.composeView.hidden = YES;
    CGFloat bottomViewHeight = 40.0f;
    if (iPhone6Plus) {
        bottomViewHeight = 48.5f;
        
    }
    if (_badgeNumber == 0) {
        self.noCommentsBtn.hidden = NO;
        self.commentsBtn.hidden = YES;
        self.commentCountLabel.hidden = YES;
        self.commentsCountView.hidden = YES;
    } else {
        self.noCommentsBtn.hidden = YES;
        self.commentsBtn.hidden = NO;
        self.commentCountLabel.hidden = NO;
        self.commentsCountView.hidden = NO;
        NSString *commentCountStr = [NSString stringWithFormat:@"%ld", (long)_badgeNumber];
        CGSize fontSize = [commentCountStr sizeWithFont:[UIFont systemFontOfSize:commentsLabelFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        self.commentCountLabel.text = commentCountStr;
        
        self.commentsCountView.frame = CGRectMake(CGRectGetMinX(self.commentsBtn.frame) - 4, bottomViewHeight -  fontSize.height - 13, fontSize.width + 8, fontSize.height + 4);
        CGFloat commentsCountLabelW = fontSize.width + 4;
        CGFloat commentsCountLabelH = fontSize.height + 2;
        CGFloat commentsCountLabelX = 2;
        CGFloat commentsCountLabelY = 1;
        
        self.commentCountLabel.frame = CGRectMake(commentsCountLabelX, commentsCountLabelY, commentsCountLabelW, commentsCountLabelH);
        
        
        
//        self.commentsCountView.frame  = CGRectMake(CGRectGetMinX(self.commentsBtn.frame) - 4, bottomViewHeight -  fontSize.height - 13, fontSize.width + 8, fontSize.height + 4);
//  
//        self.commentCountLabel.frame = CGRectMake(0, 0,  self.commentsCountView.frame.size.width, self.commentsCountView.frame.size.height);
//        self.commentCountLabel.center = CGPointMake(self.commentCountLabel.frame.size.width / 2, self.commentCountLabel.frame.size.height / 2);
        
        
        
//        self.commentCountLabel.center = self.commentsCountView.center;
//        self.commentCountLabel.layer.cornerRadius = 2.0f;
    }
    
    
    
}
#pragma mark - 查看评论
- (void)fulltextCommentDidClick {
    if ([self.delegate respondsToSelector:@selector(pushCommentViewControllerWithDetailBottomView:)]) {
        [self.delegate pushCommentViewControllerWithDetailBottomView:self];
    }
}

#pragma mark - 发表评论
- (void)commentDidComposed {
    if ([self.delegate respondsToSelector:@selector(didComposeCommentWithDetailBottomView:)]) {
        [self.delegate didComposeCommentWithDetailBottomView:self];
    }
    
}

#pragma mark - 分享
- (void)shareBtnClick {
    if ([self.delegate respondsToSelector:@selector(didShareWithDetailBottomView:)]) {
        [self.delegate didShareWithDetailBottomView:self];
    }
}

#pragma mark - 收藏
- (void)favoriteBtnClick {
    if ([self.delegate respondsToSelector:@selector(didFavoriteWithDetailBottomView:)]) {
        [self.delegate didFavoriteWithDetailBottomView:self];
    }
}


@end
