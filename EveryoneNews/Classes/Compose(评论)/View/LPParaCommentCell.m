//
//  LPParaCommentCell.m
//  EveryoneNews
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPParaCommentCell.h"
#import "LPParaCommentFrame.h"
#import "LPComment.h"
#import "UIImageView+WebCache.h"
#import "LPUpView.h"

@interface LPParaCommentCell ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UIView *dividerView;
@property (nonatomic, strong) LPUpView *upView;
@end

@implementation LPParaCommentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"para_comment";
    LPParaCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LPParaCommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = LPColor(255, 255, 250);
        
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.numberOfLines = 0;
        nameLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;

        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.numberOfLines = 0;
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        UILabel *commentLabel = [[UILabel alloc] init];
        commentLabel.numberOfLines = 0;
        [self.contentView addSubview:commentLabel];
        self.commentLabel = commentLabel;
        
        LPUpView *upView = [[LPUpView alloc] init];
        [self.contentView addSubview:upView];
        self.upView = upView;
        
        UIView *dividerView = [[UIView alloc] init];
        dividerView.backgroundColor = [UIColor colorFromHexString:@"dadada"];
        [self.contentView addSubview:dividerView];
        self.dividerView = dividerView;
        
        [self.upView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(upTap)]];
    }
    return self;
}

- (void)setParaCommentFrame:(LPParaCommentFrame *)paraCommentFrame
{
    _paraCommentFrame = paraCommentFrame;
    LPComment *comment = paraCommentFrame.comment;
    
    self.iconView.frame = self.paraCommentFrame.iconF;
    if (comment.userIcon && comment.userIcon.length) {
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:comment.userIcon]];
    } else {
        self.iconView.image = [UIImage imageNamed:@"登录icon"];
    }
    self.iconView.layer.cornerRadius = self.iconView.frame.size.height / 2;
    self.iconView.layer.borderWidth = 2;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.borderColor = comment.color.CGColor;
    
    self.nameLabel.frame = self.paraCommentFrame.nameLabelF;
    self.nameLabel.text = comment.userName;
    
    self.timeLabel.frame = self.paraCommentFrame.timeLabelF;
    self.timeLabel.text = comment.createTime;
    
    self.commentLabel.frame = self.paraCommentFrame.commentLabelF;
    self.commentLabel.attributedText = [comment commentStringWithColor:comment.color];
    
    self.upView.frame = self.paraCommentFrame.upViewF;
    self.upView.commentFrame = self.paraCommentFrame;
    
    self.dividerView.frame = self.paraCommentFrame.dividerViewF;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{

}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{

}

- (void)upTap
{
    if ([self.delegate respondsToSelector:@selector(paraCommentCell:didClickUpView:withUpComment:)]) {
        [self.delegate paraCommentCell:self didClickUpView:self.upView withUpComment:self.paraCommentFrame.comment];
    }
}

@end
