//
//  LPCommentView.m
//  EveryoneNews
//
//  Created by apple on 15/6/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPCommentView.h"
#import "LPComment.h"
#import "LPContent.h"
#import "LPContentFrame.h"
#import "UIImageView+WebCache.h"

@interface LPCommentView ()

@property (nonatomic, strong) UIButton *upBtn;
@property (nonatomic, strong) UIImageView *userIcon;
@property (nonatomic, strong) UIButton *plusBtn;
@property (nonatomic, strong) UIButton *commentsCountBtn;
@property (nonatomic, strong) UILabel *commentLabel;

@end

@implementation LPCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIButton *upBtn = [[UIButton alloc] init];
        upBtn.contentEdgeInsets = UIEdgeInsetsMake(UpCountTopPadding, UpCountLeftPadding, UpCountBottomPadding, UpCountRightPadding);
        [upBtn setBackgroundImage:[UIImage resizedImageWithName:@"受赞气泡"] forState:UIControlStateNormal];
        [upBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        upBtn.titleLabel.font = [UIFont systemFontOfSize:UpCountFontSize];
        upBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:upBtn];
        self.upBtn = upBtn;
        
        UIImageView *userIcon = [[UIImageView alloc] init];
        userIcon.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:userIcon];
        self.userIcon = userIcon;
        
        UIButton *commentsCountBtn = [[UIButton alloc] init];
        commentsCountBtn.contentEdgeInsets = UIEdgeInsetsMake(CommentCountLeftPadding, CommentCountTopPadding, CommentCountRightPadding, CommentCountBottomPadding);
        [commentsCountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        commentsCountBtn.titleLabel.font = [UIFont systemFontOfSize:CommentCountFontSize];
//        commentsCountBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        commentsCountBtn.titleLabel.numberOfLines = 0;
        [self addSubview:commentsCountBtn];
        self.commentsCountBtn = commentsCountBtn;
        
        UIButton *plusBtn = [[UIButton alloc] init];
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;
        
        UILabel *commentLabel = [[UILabel alloc] init];
        commentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        commentLabel.numberOfLines = 0;
        [self addSubview:commentLabel];
        self.commentLabel = commentLabel;
    }
    return self;
}

- (void)setContentFrame:(LPContentFrame *)contentFrame
{
    _contentFrame = contentFrame;
    LPComment *comment = contentFrame.content.displayingComment;
    NSString *category = contentFrame.content.category;
    
    if (!comment.up || comment.up.intValue == 0) {
        self.upBtn.hidden = YES;
    } else {
        self.upBtn.hidden = NO;
        self.upBtn.frame = self.contentFrame.upBtnF;
        [self.upBtn setTitle:comment.up forState:UIControlStateNormal];
    }
    
    self.userIcon.frame = self.contentFrame.userIconF;
//    if (comment.userIcon) {
//        [self.userIcon sd_setImageWithURL:[NSURL URLWithString:comment.userIcon] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            self.userIcon.image = [UIImage circleImageWithImage:image borderWidth:UserIconBorderWidth borderColor:[UIColor colorFromCategory:category]];
//        }];
//    } else {
//        self.userIcon.image = [UIImage circleImageWithName:@"登录icon" borderWidth:UserIconBorderWidth borderColor:[UIColor colorFromCategory:category]];
//    }
    if (comment.userIcon && comment.userIcon.length) {
        [self.userIcon sd_setImageWithURL:[NSURL URLWithString:comment.userIcon] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
    } else {
        self.userIcon.image = [UIImage imageNamed:@"登录icon"];
    }
    self.userIcon.layer.cornerRadius = self.userIcon.frame.size.height / 2;
    self.userIcon.layer.borderWidth = 2;
    self.userIcon.layer.masksToBounds = YES;
    self.userIcon.layer.borderColor = [UIColor colorFromCategory:category].CGColor;

    
    self.commentLabel.frame = self.contentFrame.commentLabelF;
    self.commentLabel.attributedText = [comment commentStringWithCategory:category];
    
    self.commentsCountBtn.frame = self.contentFrame.commentsCountBtnF;
    [self.commentsCountBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_评论数图形", category]] forState:UIControlStateNormal];
    [self.commentsCountBtn setTitle:comment.comments_count forState:UIControlStateNormal];
    
    self.plusBtn.frame = self.contentFrame.plusBtnF;
    [self.plusBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_发表评论初始", category]] forState:UIControlStateNormal];
    
}
@end
