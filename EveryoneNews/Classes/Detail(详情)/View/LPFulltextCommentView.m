//
//  LPFulltextCommentView.m
//  EveryoneNews
//
//  Created by dongdan on 16/3/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPFulltextCommentView.h"
#import "LPComment.h"
#import "UIImageView+WebCache.h"

const static CGFloat headerViewHeight = 40;
const static CGFloat bottomViewHeight = 47;

const static CGFloat padding = 13;
const static CGFloat contentPadding = 10;

static const CGFloat iconPaddingLeft = 10.0f;
static const CGFloat iconPaddingTop = 15.0f;
static const CGFloat namePaddingLeft = 6;
static const CGFloat namePaddingTop = 18;

static const CGFloat userIconWidth = 25.0f;
static const CGFloat upButtonWidth = 14;
static const CGFloat upButtonHeight = 13;

@interface LPFulltextCommentView ()

@property (nonatomic, strong) NSMutableArray *seperateViews;

@end

@implementation LPFulltextCommentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - padding * 2, headerViewHeight)];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentPadding, 0, 200, headerViewHeight - 0.5)];
        titleLabel.textColor = [UIColor colorFromHexString:@"#0086d1"];
        titleLabel.text = @"精选评论";
        titleLabel.font = [UIFont systemFontOfSize:15];
        [headerView addSubview:titleLabel];
        
        UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), ScreenWidth - padding * 2, 0.5)];
        seperatorView.backgroundColor = [UIColor colorFromHexString:@"#e9e9e9"];
        [self addSubview:seperatorView];
        
        [self addSubview:headerView];
    }
    return self;
}

- (NSMutableArray *)seperateViews {
    if (_seperateViews == nil) {
        _seperateViews = [NSMutableArray array];
    }
    return _seperateViews;
}



- (void)setFulltextCommentArray:(NSArray *)commentsArray {
    _fulltextCommentArray = commentsArray;
    CGFloat totalHeight = 0.0;
    for (int i = 0; i < commentsArray.count; i ++) {
        LPComment *comment =  self.fulltextCommentArray[i];
        
        NSString *upCount = [NSString stringWithFormat:@"%@赞", comment.up];
    
        CGFloat iconX = iconPaddingLeft;
        CGFloat iconY = iconPaddingTop + headerViewHeight;
        CGFloat iconW = userIconWidth;
        CGFloat iconH = userIconWidth;
        
        CGFloat nameY = namePaddingTop + headerViewHeight;
        if (i > 0) {
            UIView *lastSeperatorView = self.seperateViews[i - 1];
            iconY = CGRectGetMaxY(lastSeperatorView.frame) + iconPaddingTop ;
            nameY = CGRectGetMaxY(lastSeperatorView.frame) + namePaddingTop ;
        }
    
        UIImageView *iconImageView = [[UIImageView alloc] init];
        iconImageView.frame = CGRectMake(iconX, iconY, iconW, iconH);
        iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:comment.userIcon] placeholderImage:[UIImage imageNamed:@"评论用户占位图"]];
        [self addSubview:iconImageView];
        
        CGFloat nameX = CGRectGetMaxX(iconImageView.frame) + namePaddingLeft;
      
        CGFloat nameW = 200;
        CGFloat nameH = [@"123" heightForLineWithFont:[UIFont systemFontOfSize:15]];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(nameX, nameY, nameW, nameH);
        nameLabel.numberOfLines = 0;
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.textColor = [UIColor colorFromHexString:@"#5d5d5d"];
        nameLabel.text = comment.userName;
        [self addSubview:nameLabel];
  
        CGFloat timeX = nameX;
        CGFloat timeY = CGRectGetMaxY(nameLabel.frame) + 8;
        CGFloat timeW = nameW;
        CGFloat timeH = [@"123" heightForLineWithFont:[UIFont systemFontOfSize:10]];
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.frame = CGRectMake(timeX, timeY, timeW, timeH);
        timeLabel.numberOfLines = 0;
        timeLabel.font = [UIFont systemFontOfSize:10];
        timeLabel.textColor = [UIColor colorFromHexString:@"#808080"];
        timeLabel.text = comment.createTime;
        [self addSubview:timeLabel];
        
        CGFloat textX = nameX;
        CGFloat textY = CGRectGetMaxY(timeLabel.frame) + 16;
        CGFloat textW = ScreenWidth - textX * 2 - iconPaddingLeft;
        CGFloat textH = [[comment commentStringWithColor:comment.color] heightWithConstraintWidth:textW];
        
        UILabel *commentLabel = [[UILabel alloc] init];
        commentLabel.frame = CGRectMake(textX, textY, textW, textH);
        commentLabel.numberOfLines = 0;
        commentLabel.textColor = [UIColor colorFromHexString:@"#060606"];
        commentLabel.font = [UIFont systemFontOfSize:16];
        commentLabel.text = comment.srcText;
        [self addSubview:commentLabel];

        CGSize size = [upCount sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        CGFloat upCountsW = size.width + 6;
        CGFloat upCountsH = size.height;
        CGFloat upCountsX = ScreenWidth - upCountsW - iconPaddingLeft - padding * 2;
        CGFloat upCountsY = 0;
        
        UILabel *upCountLabel = [[UILabel alloc] init];
        upCountLabel.frame = CGRectMake(upCountsX, upCountsY, upCountsW, upCountsH);
        upCountLabel.textAlignment = NSTextAlignmentRight;
        upCountLabel.font = [UIFont systemFontOfSize:12];
        upCountLabel.textColor = [UIColor colorFromHexString:@"#808080"];
        upCountLabel.text = upCount;
        upCountLabel.centerY = nameLabel.centerY;
        
        [self addSubview:upCountLabel];

        CGFloat upButtonX = CGRectGetMinX(upCountLabel.frame) - upButtonWidth;
        CGFloat upButtonY =  0;
        UIButton *upButton = [[UIButton alloc] init];
        upButton.frame = CGRectMake(upButtonX, upButtonY, upButtonWidth, upButtonHeight);
        upButton.centerY = nameLabel.centerY;
        
        if (comment.isPraiseFlag.boolValue) {
            [upButton setBackgroundImage:[UIImage imageNamed:@"点赞心1"] forState:UIControlStateNormal];
        } else {
            [upButton setBackgroundImage:[UIImage imageNamed:@"点赞心0"] forState:UIControlStateNormal];
        }
        [self addSubview:upButton];
  
        UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(commentLabel.frame) + 16, ScreenWidth - padding * 2, 0.5)];
        seperatorView.backgroundColor = [UIColor colorFromHexString:@"#e9e9e9"];
        [self addSubview:seperatorView];
        
        CGFloat cellHeight = 0.0f;
        cellHeight = 18 + 8 + 16 + 16 + nameH + timeH + textH;
        [self.seperateViews addObject:seperatorView];
        
        totalHeight += cellHeight;
    }
    
    CGRect bottomFrame = CGRectMake(0, totalHeight + headerViewHeight, ScreenWidth - padding * 2, bottomViewHeight - 1);
    UIButton *bottomButton = [[UIButton alloc] initWithFrame:bottomFrame];
    bottomButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bottomButton setTitle:@"查看更多评论" forState:UIControlStateNormal];
    [bottomButton setTitleColor:[UIColor colorFromHexString:@"#0086d1"] forState:UIControlStateNormal];

    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:bottomFrame];
    bottomLabel.text = @"已加载完毕";
    bottomLabel.textColor = [UIColor colorFromHexString:@"#0086d1"];
    bottomLabel.font = [UIFont systemFontOfSize:15];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    
    if (commentsArray.count < 3) {
      [self addSubview:bottomLabel];
    } else {
        [self addSubview:bottomButton];
    }
    self.totalHeight = totalHeight + headerViewHeight + bottomViewHeight;
}

@end
