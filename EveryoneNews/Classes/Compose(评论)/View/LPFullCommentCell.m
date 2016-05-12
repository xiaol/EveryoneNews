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
@property (nonatomic, strong) CAShapeLayer *lineLayer;


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
        self.backgroundColor = [UIColor colorFromHexString:LPColor9];        
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.numberOfLines = 0;
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.textColor = [UIColor colorFromHexString:LPColor2];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.numberOfLines = 0;
        timeLabel.font = [UIFont systemFontOfSize:10];
        timeLabel.textColor = [UIColor colorFromHexString:LPColor4];
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;

        UILabel *commentLabel = [[UILabel alloc] init];
        commentLabel.numberOfLines = 0;
        commentLabel.textColor = [UIColor colorFromHexString:LPColor1];
        commentLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:commentLabel];
        self.commentLabel = commentLabel;
        
        
        
        UILabel *upCountLabel = [[UILabel alloc] init];
        upCountLabel.font = [UIFont systemFontOfSize:12];
        upCountLabel.textColor = [UIColor colorFromHexString:@"#4d4f51"];
        [self.contentView addSubview:upCountLabel];
        self.upCountLabel = upCountLabel;
        
        UIButton *upButton = [[UIButton alloc] init];
        [self.contentView addSubview:upButton];
        self.upButton = upButton;
        [self.upButton addTarget:self action:@selector(upButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        CAShapeLayer *lineLayer= [CAShapeLayer layer];
        [self.layer addSublayer:lineLayer];
        self.lineLayer = lineLayer;
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
        [self.upButton setBackgroundImage:[UIImage imageNamed:@"详情页已点赞"] forState:UIControlStateNormal];
    } else {
        [self.upButton setBackgroundImage:[UIImage imageNamed:@"详情页未点赞"] forState:UIControlStateNormal];
    }
    
    if ([comment.up isEqualToString:@"0"]) {
        self.upCountLabel.hidden = YES;
    } else {
        self.upCountLabel.hidden = NO;
    }
    
    self.upCountLabel.frame = self.fullCommentFrame.upCountsLabelF;
    self.upCountLabel.text = [NSString stringWithFormat:@"%@", comment.up];
  
    
    CGFloat padding = 18.0f;
    
    CGFloat cellWidth = ScreenWidth - padding ;
    // 绘制边框
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(padding, _fullCommentFrame.cellHeight - 1)];
    [linePath addLineToPoint:CGPointMake(cellWidth, _fullCommentFrame.cellHeight - 1)];
    self.lineLayer.path = linePath.CGPath;
    self.lineLayer.fillColor = nil;
    self.lineLayer.lineWidth = 1.0f;
    self.lineLayer.strokeColor = [UIColor colorFromHexString:LPColor5].CGColor;
}

- (void)upButtonClick {
    if ([self.delegate respondsToSelector:@selector(fullCommentCell:comment:)]) {
        [self.delegate fullCommentCell:self comment:self.fullCommentFrame.comment];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

- (void)setHighlighted:(BOOL)highlighted {
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}
@end
