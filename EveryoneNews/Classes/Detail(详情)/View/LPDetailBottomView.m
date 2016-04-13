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

@property (nonatomic, strong) UILabel *commentCountLabel;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *commentsBtn;
@property (nonatomic, strong) UIView *composeView;

@end

@implementation LPDetailBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        CGFloat bottomViewHeight = 40.0f;
        if (iPhone6Plus) {
            bottomViewHeight = 45.0f;
      
        }
        self.frame = CGRectMake(0, ScreenHeight - bottomViewHeight, ScreenWidth, bottomViewHeight);
        self.backgroundColor = [UIColor colorFromHexString:@"#f5f5f5"];
        
        double shareButtonWidth = 17;
        double shareButtonHeight = 17;
        double shareButtonPaddingRight = 15;
        
        double commentButtonWidth = 18;
        double commentButtonHeight = 17;
        double commentButtonPaddingTop = 33.5;
        double commentButtonPaddingRight = 5;
        
        if(iPhone6Plus)
        {
            shareButtonWidth = 17;
            shareButtonHeight = 19;
            
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
        
        // 评论数量
        UILabel *commentCountLabel = [[UILabel alloc] init];
        commentCountLabel.textColor = [UIColor colorFromHexString:@"#909090"];
        commentCountLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:commentCountLabel];
        self.commentCountLabel = commentCountLabel;
        
        // 全文评论
        UIButton *commentsBtn = [[UIButton alloc] init];
        [commentsBtn setBackgroundImage:[UIImage imageNamed:@"详情页评论"]  forState:UIControlStateNormal];
        commentsBtn.enlargedEdge = 15;
        
        [commentsBtn addTarget:self action:@selector(fulltextCommentDidClick) forControlEvents:UIControlEventTouchUpInside];
        commentsBtn.frame = CGRectMake(self.shareButton.frame.origin.x - 20  - commentButtonPaddingRight - commentButtonWidth, bottomViewHeight / 2- commentButtonHeight / 2 , commentButtonWidth, commentButtonHeight);;
        [self addSubview:commentsBtn];
        self.commentsBtn = commentsBtn;
        
        UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        seperatorView.backgroundColor = [UIColor colorFromHexString:@"#e9e9e9"];
        [self addSubview:seperatorView];
        
        
        UIView *composeView = [[UIView alloc] init];
        composeView.userInteractionEnabled = YES;
        composeView.layer.borderWidth = 0.5;
        composeView.layer.borderColor = [UIColor colorFromHexString:@"#c6c6c6"].CGColor;
        composeView.layer.cornerRadius = 10;
        composeView.backgroundColor = [UIColor whiteColor];
      
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentDidComposed)];
        [composeView addGestureRecognizer:tapGestureRecognizer];
        
        CGFloat composeViewPaddingTop = 5;
        UIImageView *composeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 0, 18, bottomViewHeight - 2 * composeViewPaddingTop)];
        composeImageView.contentMode = UIViewContentModeScaleAspectFit;
        composeImageView.image = [UIImage imageNamed:@"发表评论"];
        
        UILabel *composeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(composeImageView.frame) + 10, 0, 100, bottomViewHeight - 2 * composeViewPaddingTop)];
        composeLabel.text = @"写评论...";
        composeLabel.textColor = [UIColor colorFromHexString:@"#909090"];
        composeLabel.textAlignment = NSTextAlignmentLeft;
        if (iPhone6Plus) {
            composeLabel.font = [UIFont systemFontOfSize:18];
        } else {
            composeLabel.font = [UIFont systemFontOfSize:15];
        }
    
        
        [composeView addSubview:composeImageView];
        
        [composeView addSubview:composeLabel];
        
    
        composeView.frame = CGRectMake(BodyPadding, composeViewPaddingTop, CGRectGetMinX(self.commentsBtn.frame)- BodyPadding - 15, bottomViewHeight - composeViewPaddingTop * 2);
        
        [self addSubview:composeView];
        self.composeView = composeView;
    }
    return self;
}

- (void)setBadgeNumber:(NSInteger)badgeNumber {
    CGFloat bottomViewHeight = 40.0f;
    if (iPhone6Plus) {
        bottomViewHeight = 45.0f;
        
    }
    double shareButtonWidth = 17;
    double shareButtonHeight = 17;
    double shareButtonPaddingRight = 15;
    
    double commentButtonWidth = 18;
    double commentButtonHeight = 17;
    double commentButtonPaddingTop = 33.5;
    double commentButtonPaddingRight = 5;
    
    if(iPhone6Plus)
    {
        shareButtonWidth = 17;
        shareButtonHeight = 19;
        
        commentButtonWidth = 21;
        commentButtonHeight = 19;
        commentButtonPaddingTop = 30.5;
        commentButtonPaddingRight = 5;
    }

    self.shareButton.frame = CGRectMake(ScreenWidth  - shareButtonPaddingRight - shareButtonWidth, bottomViewHeight / 2 - shareButtonHeight / 2 , shareButtonWidth, shareButtonHeight);
    
    _badgeNumber = badgeNumber;
    
    NSString *commentCountText = [NSString stringWithFormat:@"%@",@(_badgeNumber)];
    
    CGFloat commentCountLabelWidth = [commentCountText sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    CGFloat commentCountLabelHeight = bottomViewHeight;
    CGFloat commentCountLabelX = CGRectGetMinX(self.shareButton.frame) - commentCountLabelWidth - 15;
    
    self.commentCountLabel.frame = CGRectMake(commentCountLabelX, 0, commentCountLabelWidth, commentCountLabelHeight);
    self.commentCountLabel.text = commentCountText;
    
    if (_badgeNumber == 0) {
        self.commentCountLabel.hidden = YES;
    } else {
        self.commentCountLabel.hidden = NO;
    }
    
    self.commentsBtn.frame = CGRectMake(self.commentCountLabel.frame.origin.x  - commentButtonPaddingRight - commentButtonWidth, bottomViewHeight / 2 - commentButtonHeight / 2 , commentButtonWidth, commentButtonHeight);
    
    CGFloat composeViewPaddingTop = 5;
    self.composeView.frame = CGRectMake(BodyPadding, composeViewPaddingTop, CGRectGetMinX(self.commentsBtn.frame)- BodyPadding - 15, bottomViewHeight - composeViewPaddingTop * 2);
    
    
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


@end
