//
//  LPFullCommentCell.m
//  EveryoneNews
//
//  Created by dongdan on 15/10/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPFullCommentCell.h"
#import "LPFullCommentFrame.h"
#import "LPComment.h"
#import "UIImageView+WebCache.h"

@interface LPFullCommentCell ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UILabel *upCountLabel;


@end

@implementation LPFullCommentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"text_comment";
    LPFullCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
      cell = [[LPFullCommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
   return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.numberOfLines = 0;
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.textColor = [UIColor colorFromHexString:@"#5d5d5d"];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.numberOfLines = 0;
        timeLabel.font = [UIFont systemFontOfSize:10];
        timeLabel.textColor = [UIColor colorFromHexString:@"#808080"];
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;

        UILabel *commentLabel = [[UILabel alloc] init];
        commentLabel.numberOfLines = 0;
        commentLabel.textColor = [UIColor colorFromHexString:@"#060606"];
        commentLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:commentLabel];
        self.commentLabel = commentLabel;
        
        
        
        UILabel *upCountLabel = [[UILabel alloc] init];
        upCountLabel.textAlignment = NSTextAlignmentRight;
        upCountLabel.font = [UIFont systemFontOfSize:12];
        upCountLabel.textColor = [UIColor colorFromHexString:@"#808080"];
        [self.contentView addSubview:upCountLabel];
        self.upCountLabel = upCountLabel;
        
        UIButton *upButton = [[UIButton alloc] init];
        [self.contentView addSubview:upButton];
        self.upButton = upButton;
        [self.upButton addTarget:self action:@selector(upButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


- (void)setFullCommentFrame:(LPFullCommentFrame *)fullCommentFrame
{
    _fullCommentFrame = fullCommentFrame;
    LPComment *comment = fullCommentFrame.comment;
    
    self.iconView.frame = self.fullCommentFrame.iconF;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:comment.userIcon] placeholderImage:[UIImage imageNamed:@"评论用户占位图"]];
    
    self.iconView.layer.cornerRadius = self.iconView.frame.size.height / 2;
    self.iconView.layer.borderWidth = 0;
    self.iconView.layer.masksToBounds = YES;
    
    self.nameLabel.frame = self.fullCommentFrame.nameLabelF;
    self.nameLabel.text = comment.userName;
    
    self.timeLabel.frame = self.fullCommentFrame.timeLabelF;
    self.timeLabel.text = comment.createTime;
    
    self.commentLabel.frame = self.fullCommentFrame.commentLabelF;
    self.commentLabel.text = comment.srcText;

    self.upButton.frame = self.fullCommentFrame.upButtonF;
    self.upButton.enlargedEdge = 10;
    self.upButton.centerY = self.nameLabel.centerY;
    
    
    if (comment.isPraiseFlag.boolValue) {
        [self.upButton setBackgroundImage:[UIImage imageNamed:@"点赞心1"] forState:UIControlStateNormal];
    } else {
        [self.upButton setBackgroundImage:[UIImage imageNamed:@"点赞心0"] forState:UIControlStateNormal];
    }
    
    if ([comment.up isEqualToString:@"0"]) {
        self.upCountLabel.hidden = YES;
    } else {
        self.upCountLabel.hidden = NO;
    }
    
    self.upCountLabel.frame = self.fullCommentFrame.upCountsLabelF;
    self.upCountLabel.text = [NSString stringWithFormat:@"%@赞", comment.up];
    self.upCountLabel.centerY = self.upButton.centerY;
}

- (void)upButtonClick {
    if ([self.delegate respondsToSelector:@selector(fullCommentCell:comment:)]) {
        [self.delegate fullCommentCell:self comment:self.fullCommentFrame.comment];
    }
}
@end
