//
//  LPDetailBottomView.m
//  EveryoneNews
//
//  Created by dongdan on 16/3/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPDetailBottomView.h"
#import "NSString+LP.h"

@interface LPDetailBottomView ()
 
@property (nonatomic, strong) UIButton *shareButton;

@property (nonatomic, strong) UIView *composeView;

//@property (nonatomic, assign) CGFloat commentsLabelFontSize;


@end

@implementation LPDetailBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        CGFloat bottomViewHeight = 40.0f;
        if (iPhone6Plus) {
            bottomViewHeight = 48.5f;
      
        } else if (iPhone5) {
             bottomViewHeight = 40.0f;
        } else if (iPhone6) {
            bottomViewHeight = 46.0f;
        }
        self.frame = CGRectMake(0, ScreenHeight - bottomViewHeight, ScreenWidth, bottomViewHeight);
        self.backgroundColor = [UIColor colorFromHexString:@"#f5f5f5"];
        
        CGFloat commonWidth = 26;
        CGFloat commonHeight = 24;
        CGFloat minusHeight = 4.0f;
        CGFloat minusWidth = (commonWidth / commonHeight) * minusHeight;
        
        CGFloat shareButtonPaddingRight = 20;
     
        if(iPhone6Plus) {
            shareButtonPaddingRight = 20;
           // self.commentsLabelFontSize = 11;

        } else if (iPhone5) {
            shareButtonPaddingRight = 16;
            commonWidth = commonWidth - minusWidth;
            commonHeight = commonHeight - minusHeight;
            
          //  self.commentsLabelFontSize = 9;
        }
        
        // 添加分享按钮
        UIButton *shareBtn = [[UIButton alloc] init];
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"详情页分享"]  forState:UIControlStateNormal];
        shareBtn.enlargedEdge = 10;
        [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
        shareBtn.frame = CGRectMake(ScreenWidth  - shareButtonPaddingRight - commonWidth, (bottomViewHeight - commonHeight) / 2 , commonWidth, commonHeight);
        [self addSubview:shareBtn];
        self.shareButton = shareBtn;
        
 
        CGFloat favoriteBtnPaddingRight = 37;
        if (iPhone5) {
             favoriteBtnPaddingRight = 31;
        }
        
        // 收藏按钮
        UIButton *favoriteBtn = [[UIButton alloc] init];
        [favoriteBtn setBackgroundImage:[UIImage imageNamed:@"详情页未收藏"] forState:UIControlStateNormal];
        favoriteBtn.enlargedEdge = 10;
        favoriteBtn.frame = CGRectMake(CGRectGetMinX(shareBtn.frame) - favoriteBtnPaddingRight - commonWidth, (bottomViewHeight - commonHeight) / 2 , commonWidth, commonHeight);
        [favoriteBtn addTarget:self action:@selector(favoriteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:favoriteBtn];
        self.favoriteBtn = favoriteBtn;
        
        // 沙发  评论
        CGFloat commentsPaddingRight = 37;
   
        
        if (iPhone6Plus) {
           commentsPaddingRight = 37;
 
        } else if (iPhone5) {
            commentsPaddingRight = 30.5;
      
        }
        
        CGFloat noCommentsPaddingRight = 37;
        CGFloat noCommentsBtnW = 29;
        CGFloat noCommentsBtnH = 24;
        CGFloat minusNoCommentWidth = (noCommentsBtnW / noCommentsBtnH) * minusHeight;
        if (iPhone5) {
            noCommentsPaddingRight = 30.5;
            noCommentsBtnH = noCommentsBtnH - minusHeight;
            noCommentsBtnW = noCommentsBtnW - minusNoCommentWidth;
        }
        
        
        // 没有评论
        UIButton *noCommentsBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(favoriteBtn.frame) - noCommentsPaddingRight - noCommentsBtnW, (bottomViewHeight - noCommentsBtnH) / 2, noCommentsBtnW, noCommentsBtnH)];
        [noCommentsBtn setBackgroundImage:[UIImage imageNamed:@"详情页未评论"] forState:UIControlStateNormal];
        [noCommentsBtn addTarget:self action:@selector(noCommentsBtnClick) forControlEvents:UIControlEventTouchUpInside];
        noCommentsBtn.enlargedEdge = 10;
        [self addSubview:noCommentsBtn];
        self.noCommentsBtn = noCommentsBtn;
        
        
        // 有评论
        UIButton *commentsBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(favoriteBtn.frame) - commentsPaddingRight - commonWidth, (bottomViewHeight - commonHeight) / 2, commonWidth, commonHeight)];
        [commentsBtn setBackgroundImage:[UIImage imageNamed:@"详情页已评论"] forState:UIControlStateNormal];
        [commentsBtn addTarget:self action:@selector(commentsBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];
        commentsBtn.enlargedEdge = 10;
        commentsBtn.hidden = YES;
        [self addSubview:commentsBtn];
        self.commentsBtn = commentsBtn;
        
        // 原文按钮
        CGFloat contentsBtnW = 34.0f;
        CGFloat contentsBtnH = 24.0f;
        CGFloat minusContentsBtnWidth = (contentsBtnW / contentsBtnH) * minusHeight;
        if (iPhone5) {
            
            contentsBtnH = contentsBtnH - minusHeight;
            contentsBtnW = contentsBtnW - minusContentsBtnWidth;
        }
        
        
        UIButton *contentBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(favoriteBtn.frame) - commentsPaddingRight - contentsBtnW, (bottomViewHeight - contentsBtnH) / 2 + 1, contentsBtnW, contentsBtnH)];
        [contentBtn setBackgroundImage:[UIImage imageNamed:@"详情页原文"] forState:UIControlStateNormal];
        [contentBtn addTarget:self action:@selector(contentsBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];
        contentBtn.hidden = YES;
        contentBtn.enlargedEdge = 10;
        [self addSubview:contentBtn];
        self.contentBtn = contentBtn;
        
        // 评论数量
        UILabel *commentCountLabel = [[UILabel alloc] init];
        commentCountLabel.textAlignment = NSTextAlignmentCenter;
        commentCountLabel.textColor = [UIColor colorFromHexString:@"#e94221"];
        commentCountLabel.font = [UIFont systemFontOfSize:13];
        commentCountLabel.backgroundColor = [UIColor clearColor];
        commentCountLabel.layer.backgroundColor = [UIColor colorFromHexString:LPColor9].CGColor;
        commentCountLabel.hidden = YES;
        [self addSubview:commentCountLabel];
        self.commentCountLabel = commentCountLabel;
        
        
        UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        seperatorView.backgroundColor = [UIColor colorFromHexString:@"#dadada"];
        [self addSubview:seperatorView];
        
        
        UIView *composeView = [[UIView alloc] init];
        composeView.userInteractionEnabled = YES;
        composeView.layer.borderWidth = 0.5;
        composeView.layer.borderColor = [UIColor colorFromHexString:@"#efefef"].CGColor;
        composeView.layer.cornerRadius = 16;
        
        if (iPhone5) {
            composeView.layer.cornerRadius = 12;
        } else if (iPhone6) {
            composeView.layer.cornerRadius = 15;
        }
        
        composeView.backgroundColor = [UIColor whiteColor];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentDidComposed)];
        [composeView addGestureRecognizer:tapGestureRecognizer];
        
        CGFloat composeViewX = 18;
        CGFloat composeViewW = 116;
        CGFloat composeViewPaddingTop = 8;
        if (iPhone6Plus) {
            composeViewX = 18;
            composeViewPaddingTop = 8;
            composeViewW = 169;
        } else if (iPhone5) {
            composeViewX = 15;
            composeViewPaddingTop = 8;
            composeViewW = 116;
        } else if (iPhone6) {
            composeViewX = 18;
            composeViewPaddingTop = 7;
             composeViewW = 134;
        }
        
        UILabel *composeLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 100, bottomViewHeight - 2 * composeViewPaddingTop - 1)];
        composeLabel.text = @"说一下...";
        composeLabel.textColor = [UIColor colorFromHexString:@"#909090"];
        composeLabel.textAlignment = NSTextAlignmentLeft;
        if (iPhone6Plus) {
            composeLabel.font = [UIFont systemFontOfSize:18];
        } else if(iPhone5){
            composeLabel.font = [UIFont systemFontOfSize:16];
        } else {
             composeLabel.font = [UIFont systemFontOfSize:16];
        }
        
        [composeView addSubview:composeLabel];
        composeView.frame = CGRectMake(composeViewX, composeViewPaddingTop, composeViewW, bottomViewHeight - composeViewPaddingTop * 2);
        [self addSubview:composeView];
        self.composeView = composeView;
    }
    return self;
}

- (void)setBadgeNumber:(NSInteger)badgeNumber {

    
     _badgeNumber = badgeNumber;
    if (_badgeNumber == 0) {
        self.noCommentsBtn.hidden = NO;
        self.commentsBtn.hidden = YES;
        self.commentCountLabel.hidden = YES;
    } else {
        self.noCommentsBtn.hidden = YES;
        self.commentsBtn.hidden = NO;
        self.commentCountLabel.hidden = NO;
        
        NSString *commentCountStr = @"";
        if (_badgeNumber > 10000) {
            commentCountStr = [NSString stringWithFormat:@"%.1f万", (floor)(_badgeNumber)/ 10000];
        } else {
            commentCountStr = [NSString stringWithFormat:@"%ld", (long)_badgeNumber];
        }
        
 
        CGSize fontSize = [commentCountStr sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        self.commentCountLabel.text = commentCountStr;
        
        CGFloat commentsCountLabelW = fontSize.width;
        CGFloat commentsCountLabelH = fontSize.height;
        CGFloat commentsCountLabelX = CGRectGetMaxX(self.commentsBtn.frame) - 1 ;
        CGFloat commentsCountLabelY = CGRectGetMinY(self.commentsBtn.frame) + 2;
        
        if (iPhone5) {
            commentsCountLabelW = commentsCountLabelW + 4;
            commentsCountLabelH = commentsCountLabelH ;
            commentsCountLabelX = commentsCountLabelX - commentsCountLabelW / 2;
            commentsCountLabelY = commentsCountLabelY - commentsCountLabelH / 2;
            
        } else if (iPhone6Plus) {
            commentsCountLabelW = commentsCountLabelW + 8;
            commentsCountLabelH = commentsCountLabelH ;
            commentsCountLabelX = commentsCountLabelX - commentsCountLabelW / 2;
            commentsCountLabelY = commentsCountLabelY - commentsCountLabelH / 2;
        } else if (iPhone6) {
            commentsCountLabelW = commentsCountLabelW + 8;
            commentsCountLabelH = commentsCountLabelH + 2;
            commentsCountLabelX = commentsCountLabelX - commentsCountLabelW / 2;
            commentsCountLabelY = commentsCountLabelY - commentsCountLabelH / 2;
        }
        self.commentCountLabel.frame = CGRectMake(commentsCountLabelX, commentsCountLabelY, commentsCountLabelW, commentsCountLabelH);
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

#pragma mark - 评论
- (void)noCommentsBtnClick {
    if ([self.delegate respondsToSelector:@selector(didClickCommentsWithDetailBottomView:)]) {
        [self.delegate didClickCommentsWithDetailBottomView:self];
    }
}

- (void)commentsBtnBtnClick {
    if ([self.delegate respondsToSelector:@selector(didClickCommentsWithDetailBottomView:)]) {
        [self.delegate didClickCommentsWithDetailBottomView:self];
    }
}

#pragma mark - 原文
- (void)contentsBtnBtnClick {
    if ([self.delegate respondsToSelector:@selector(didClickContentsWithDetailBottomView:)]) {
        [self.delegate didClickContentsWithDetailBottomView:self];
    }
}



@end
