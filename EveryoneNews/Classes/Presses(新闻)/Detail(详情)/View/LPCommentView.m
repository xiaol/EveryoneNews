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
#import "LPUpButton.h"

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
        upBtn.clipsToBounds = NO;
        if (iPhone6Plus) {
            upBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 4, UpCountBottomPadding - UpCountTopPadding - 0.3, 0);
            upBtn.imageView.contentScaleFactor = 1.5;
        } else {
            upBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, UpCountBottomPadding - UpCountTopPadding, 0);
            upBtn.imageView.contentScaleFactor = 1.9;
        }
        upBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 4, 5);
        [upBtn setBackgroundImage:[UIImage imageNamed:@"点赞数量框"] forState:UIControlStateNormal];
        [upBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [upBtn setImage:[UIImage imageNamed:@"心"] forState:UIControlStateNormal];
        upBtn.titleLabel.font = [UIFont systemFontOfSize:UpCountFontSize];
        upBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        upBtn.imageView.contentMode = UIViewContentModeLeft;
        upBtn.imageView.clipsToBounds = NO;
        [self addSubview:upBtn];
        self.upBtn = upBtn;
        
        UIImageView *userIcon = [[UIImageView alloc] init];
        userIcon.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:userIcon];
        self.userIcon = userIcon;
        
        UIButton *commentsCountBtn = [[UIButton alloc] init];
        commentsCountBtn.titleEdgeInsets = UIEdgeInsetsMake(CommentCountTopPadding, CommentCountLeftPadding, CommentCountBottomPadding, CommentCountRightPadding);
        [commentsCountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        commentsCountBtn.titleLabel.font = [UIFont systemFontOfSize:CommentCountFontSize];
        commentsCountBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        commentsCountBtn.titleLabel.numberOfLines = 0;
        [self addSubview:commentsCountBtn];
        self.commentsCountBtn = commentsCountBtn;
        
        UIButton *plusBtn = [[UIButton alloc] init];
        [plusBtn addTarget:self action:@selector(plusBtnClicked) forControlEvents:UIControlEventTouchUpInside];
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
    LPContent *content = contentFrame.content;
    NSString *category = content.category;
    
    self.plusBtn.frame = self.contentFrame.plusBtnF;
    [self.plusBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_发表评论初始", category]] forState:UIControlStateNormal];
    if (!content.hasComment) {
        // 没有评论列表，只有添加评论按钮
        self.upBtn.hidden = YES;
        self.userIcon.hidden = YES;
        self.commentsCountBtn.hidden = YES;
        self.commentLabel.hidden = YES;
    } else {
        LPComment *comment = content.displayingComment;
        if (!comment.up || comment.up.intValue == 0) {
            self.upBtn.hidden = YES;
        } else {
            self.upBtn.hidden = NO;
            self.upBtn.frame = self.contentFrame.upBtnF;
            [self.upBtn setTitle:comment.up forState:UIControlStateNormal];
        }
//        self.upBtn.hidden = NO;
//        self.upBtn.frame = self.contentFrame.upBtnF;
//        if (!comment.up || comment.up.intValue == 0) {
//            [self.upBtn setTitle:@"" forState:UIControlStateNormal];
//        } else {
//            [self.upBtn setTitle:comment.up forState:UIControlStateNormal];
//        }
        
        self.userIcon.hidden = NO;
        self.userIcon.frame = self.contentFrame.userIconF;
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
        
        self.commentLabel.hidden = NO;
        self.commentLabel.frame = self.contentFrame.commentLabelF;
        self.commentLabel.attributedText = [comment commentStringWithCategory:category];
        
        self.commentsCountBtn.hidden = NO;
        self.commentsCountBtn.frame = self.contentFrame.commentsCountBtnF;
        [self.commentsCountBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_评论数图形", category]] forState:UIControlStateNormal];
        [self.commentsCountBtn setTitle:[NSString stringFromIntValue:(int)content.comments.count] forState:UIControlStateNormal];
    }
}

- (void)plusBtnClicked
{
    LPContent *content = self.contentFrame.content;
    NSDictionary *info = @{LPComposeParaIndex: @(content.paragraphIndex)};
    [noteCenter postNotificationName:LPCommentWillComposeNotification object:self userInfo:info];
}
@end
