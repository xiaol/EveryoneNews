//
//  LPMyCommentTableViewCell.m
//  EveryoneNews
//
//  Created by dongdan on 16/6/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPMyCommentTableViewCell.h"
#import "LPMyCommentFrame.h"
#import "LPMyComment.h"
#import "UIImage+LP.h"
 

@interface LPMyCommentTableViewCell ()

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIButton *upButton;
@property (nonatomic, strong) UIImageView *commentImageView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *spreadImageView;
@property (nonatomic, strong) UIView *seperatorView;


@end

@implementation LPMyCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor colorFromHexString:@"#f0efef"];
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont systemFontOfSize:14];
        timeLabel.textColor = [UIColor colorFromHexString:@"#9a9a9a"];
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        UIButton *deleteButton = [[UIButton alloc] init];
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"我的评论删除按钮"] forState:UIControlStateNormal];
        deleteButton.enlargedEdge = 10;
        [deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:deleteButton];
        self.deleteButton = deleteButton;
        
        UILabel *commentLabel = [[UILabel alloc] init];
        commentLabel.font = [UIFont systemFontOfSize:18];
        commentLabel.textColor = [UIColor blackColor];
        commentLabel.numberOfLines = 0;
        self.commentLabel = commentLabel;
        
        UIButton *upButton = [[UIButton alloc] init];
        [upButton setBackgroundImage:[UIImage imageNamed:@"我的评论未点赞"] forState:UIControlStateNormal];
        [upButton addTarget:self action:@selector(upButtonClick) forControlEvents:UIControlEventTouchUpInside];
        upButton.enlargedEdge = 5;
        upButton.userInteractionEnabled = YES;
        self.upButton = upButton;
        
        UIImageView *commentImageView = [[UIImageView alloc] init];
        commentImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:commentImageView];
        self.commentImageView = commentImageView;
        
        [commentImageView addSubview:commentLabel];
        [commentImageView addSubview:upButton];
        
        
        UIView *titleView = [[UIView alloc] init];
        [self.contentView addSubview:titleView];
        self.titleView = titleView;
        
        
        UILabel *titleLabel = [[UILabel alloc] init];
        self.titleLabel = titleLabel;
        
        UIImageView *spreadImageView = [[UIImageView alloc] init];
        spreadImageView.image = [UIImage imageNamed:@"我的评论展开"];
        self.spreadImageView = spreadImageView;
        
        [titleView addSubview:titleLabel];
        [titleView addSubview:spreadImageView];
        self.titleView = titleView;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleViewTapRecognizer:)];
        [titleView addGestureRecognizer:tapGesture];
        
        UIView *seperatorView = [[UIView alloc] init];
        seperatorView.backgroundColor = [UIColor colorFromHexString:@"#e5e4e4"];
        [self.contentView addSubview:seperatorView];
        self.seperatorView = seperatorView;
        
        
    }
    return self;
}

- (void)setCommentFrame:(LPMyCommentFrame *)commentFrame {
    _commentFrame = commentFrame;
    LPMyComment *comment = _commentFrame.comment;
    
    NSDate *currentDate = [NSDate date];

    NSDate *updateTime = [NSDate dateWithTimeIntervalSince1970:comment.commentTime.longLongValue / 1000.0];
    NSString *publishTime = @"刚刚";
    int interval = (int)[currentDate timeIntervalSinceDate: updateTime] / 60;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm"];

    
    if (interval > 10 && interval < 60) {
        publishTime = [NSString stringWithFormat:@"%d分钟前",interval];
    } else if (interval > 60) {
        publishTime = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:updateTime]];
    
        
    }
    
    self.timeLabel.frame = commentFrame.timeLabeF;
    self.timeLabel.text = publishTime;
    
    self.deleteButton.frame = commentFrame.deleteButtonF;



    // 评论内容
    self.commentImageView.frame = commentFrame.commentImageViewF;
    self.commentImageView.image = [UIImage resizedImageWithName:@"我的评论边框"];
    
    self.commentLabel.frame = commentFrame.commentLabelF;
    self.commentLabel.text = comment.comment;

    // 点赞
    self.upButton.frame = commentFrame.upButtonF;
    
    // 正文标题
    self.titleView.frame = commentFrame.titleViewF;
 
    self.titleLabel.frame = commentFrame.titleLabelF;
    
    NSString *title = [NSString stringWithFormat:@"[原文] %@", comment.title ];
    
    NSMutableAttributedString *titleAttrStr = [title  attributedStringWithFont:[UIFont systemFontOfSize:16]];
    [titleAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"#666666"] range:NSMakeRange(0, title.length)];
    [titleAttrStr addAttribute:NSFontAttributeName
                         value:[UIFont boldSystemFontOfSize:16]
                         range:NSMakeRange(0, 4)];
    self.titleLabel.attributedText = titleAttrStr;
    
    self.spreadImageView.frame = commentFrame.spreadImageViewF;
    self.spreadImageView.centerY = self.titleLabel.centerY;
    
    self.seperatorView.frame = commentFrame.seperatorViewF;
}

#pragma mark - 点击标题跳转到详情页
- (void)titleViewTapRecognizer:(UIView *)view {
    if ([self.delegate respondsToSelector:@selector(didTapTitleView:commentFrame:)]) {
        [self.delegate didTapTitleView:self commentFrame:self.commentFrame];
    }
}

#pragma mark - 点击删除按钮
- (void)deleteButtonClick {
    if ([self.delegate respondsToSelector:@selector(deleteButtonDidClick:commentFrame:)]) {
        [self.delegate deleteButtonDidClick:self commentFrame:self.commentFrame];
    }
}

#pragma mark - 点赞按钮
- (void)upButtonClick {
    if ([self.delegate respondsToSelector:@selector(upButtonDidClick:)]) {
        [self.delegate upButtonDidClick:self];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

- (void)setHighlighted:(BOOL)highlighted {
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}


@end
