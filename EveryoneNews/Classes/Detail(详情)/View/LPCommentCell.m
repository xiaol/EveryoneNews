//
//  LPCommentCell.m
//  EveryoneNews
//
//  Created by dongdan on 16/3/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPCommentCell.h"
#import "LPComment.h"
#import "UIImageView+WebCache.h"
#import "LPCommentFrame.h"
#import "LPFontSizeManager.h"

@interface LPCommentCell()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel  *commentLabel;
@property (nonatomic, strong) UILabel *upCountLabel;
@property (nonatomic, strong) UIButton *upButton;

@property (nonatomic, strong) CAShapeLayer *lineLayer;

@end

@implementation LPCommentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID= @"commentCell";
    LPCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LPCommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       self.backgroundColor = [UIColor colorFromHexString:LPColor9];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *iconImageView = [[UIImageView alloc] init];
        iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:iconImageView];
        self.iconImageView = iconImageView;
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.numberOfLines = 0;
        nameLabel.font = [UIFont systemFontOfSize:LPFont4];
        nameLabel.textColor = [UIColor colorFromHexString:LPColor2];
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;

        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.numberOfLines = 0;
        timeLabel.font = [UIFont systemFontOfSize:LPFont7];
        timeLabel.textColor = [UIColor colorFromHexString:LPColor4];
        [self addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        UILabel *commentLabel = [[UILabel alloc] init];
        commentLabel.numberOfLines = 0;
        commentLabel.textColor = [UIColor colorFromHexString:LPColor1];
        commentLabel.font = [UIFont systemFontOfSize:[LPFontSizeManager sharedManager].currentDetailCommentFontSize];
        [self addSubview:commentLabel];
        self.commentLabel = commentLabel;
        
        UILabel *upCountLabel = [[UILabel alloc] init];
        upCountLabel.font = [UIFont systemFontOfSize:LPFont5];
        upCountLabel.textColor = [UIColor colorFromHexString:@"#4d4f51"];
        [self addSubview:upCountLabel];
        self.upCountLabel = upCountLabel;
        
        UIButton *upButton = [[UIButton alloc] init];
        [self addSubview:upButton];
        self.upButton = upButton;
        
        CAShapeLayer *lineLayer= [CAShapeLayer layer];
        [self.layer addSublayer:lineLayer];
        self.lineLayer = lineLayer;

        
    }
    return self;
}

- (void)setCommentFrame:(LPCommentFrame *)commentFrame {
    _commentFrame = commentFrame;
    LPComment *comment = commentFrame.comment;
    if ([comment.up isEqualToString:@"0"]) {
        self.upCountLabel.hidden = YES;
    } else {
        self.upCountLabel.hidden = NO;
    }
    
    NSString *upCount = [NSString stringWithFormat:@"%@", comment.up];
    
    self.iconImageView.frame = self.commentFrame.iconF;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:comment.userIcon] placeholderImage:[UIImage imageNamed:@"评论用户占位图"]];
    
    self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.height / 2;
    self.iconImageView.layer.borderWidth = 0;
    self.iconImageView.layer.masksToBounds = YES;
    
    self.nameLabel.frame = self.commentFrame.nameF;
    self.nameLabel.text = comment.userName;
    
    self.timeLabel.frame = self.commentFrame.timeF;
    self.timeLabel.text = comment.createTime;
    
    self.commentLabel.frame = self.commentFrame.textF;
    self.commentLabel.text = comment.srcText;
    
    self.upButton.frame = self.commentFrame.upButtonF;
    
    self.upCountLabel.frame = self.commentFrame.upCountF;
    self.upCountLabel.text = upCount;
    self.upCountLabel.centerY = self.nameLabel.centerY;
    
    if (comment.isPraiseFlag.boolValue) {
        [self.upButton setBackgroundImage:[UIImage imageNamed:@"详情页已点赞"] forState:UIControlStateNormal];
    } else {
        [self.upButton setBackgroundImage:[UIImage imageNamed:@"详情页未点赞"] forState:UIControlStateNormal];
    }
    
    CGFloat cellWidth = ScreenWidth - BodyPadding * 2;
    // 绘制边框
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(BodyPadding, _commentFrame.cellHeight)];
    [linePath addLineToPoint:CGPointMake(cellWidth, _commentFrame.cellHeight)];
    self.lineLayer.path = linePath.CGPath;
    self.lineLayer.fillColor = nil;
    self.lineLayer.lineWidth = 1.0f;
    self.lineLayer.strokeColor = [UIColor colorFromHexString:LPColor5].CGColor;

}

@end
