//
//  LPHomeVideoCell.m
//  AVPlayerDemo
//
//  Created by dongdan on 2016/12/6.
//  Copyright © 2016年 dongdan. All rights reserved.
//

#import "LPHomeVideoCell.h"
#import "LPHomeVideoFrame.h"
#import "Card.h"
#import "CardImage.h"


@interface LPHomeVideoCell()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UIImageView *commentImageView;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *seperatorView;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *tipButton;
@property (nonatomic, strong) UILabel *newsTypeLabel;
@property (nonatomic, strong) Card *card;

@end

@implementation LPHomeVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSString *tipString = @"刚刚看到这里，点击刷新";
        NSString *tipColor = LPColor15;
        
        CGFloat commentFontSize = 13;
        CGFloat newsTypeCornerRadius = 7.0f;
        CGFloat tipFontSize = LPFont5;
        CGFloat newsTypeFontSize = LPFont6;
        CGFloat interval = 5.0f;
        CGFloat tipLabelTitleWidth = [tipString sizeWithFont:[UIFont systemFontOfSize:tipFontSize] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
        CGFloat tipImageViewWidth = 12.0f;
        
        UIButton *tipButton = [[UIButton alloc] init];
        tipButton.userInteractionEnabled = YES;
        tipButton.backgroundColor = [UIColor colorFromHexString:LPColor23];
        [tipButton setTitle:tipString forState:UIControlStateNormal];
        [tipButton setTitleColor:[UIColor colorFromHexString:tipColor] forState:UIControlStateNormal];
        tipButton.titleLabel.font = [UIFont systemFontOfSize:tipFontSize];
        [tipButton addTarget:self action:@selector(didClickTipButton) forControlEvents:UIControlEventTouchUpInside];
        [tipButton setImage:[UIImage imageNamed:@"上次位置刷新"] forState:UIControlStateNormal];
        tipButton.imageEdgeInsets = UIEdgeInsetsMake(0, tipLabelTitleWidth + interval, 0, -(tipLabelTitleWidth + interval));
        tipButton.titleEdgeInsets = UIEdgeInsetsMake(0, -(tipImageViewWidth + interval), 0, tipImageViewWidth + interval);
        [self.contentView addSubview:tipButton];
        self.tipButton = tipButton;
        
        // 新闻类型
        UILabel *newsTypeLabel =  [[UILabel alloc] init];
        newsTypeLabel.textColor = [UIColor whiteColor];
        newsTypeLabel.font = [UIFont systemFontOfSize:newsTypeFontSize];
        newsTypeLabel.textAlignment = NSTextAlignmentCenter;
        newsTypeLabel.layer.cornerRadius = newsTypeCornerRadius;
        newsTypeLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:newsTypeLabel];
        self.newsTypeLabel = newsTypeLabel;
        
        // 标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.userInteractionEnabled = YES;
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = [UIColor colorFromHexString:LPColor1];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        // 播放器封面
        UIImageView *coverImageView = [[UIImageView alloc] init];
        coverImageView.clipsToBounds = YES;
        coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        coverImageView.userInteractionEnabled = YES;
        // 建议设置成100以上
        coverImageView.tag = 101;
        
        UITapGestureRecognizer *coverImageViewRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverImageViewTap:)];
        [coverImageView addGestureRecognizer:coverImageViewRecognizer];
        
        [self.contentView addSubview:coverImageView];
        self.coverImageView = coverImageView;
        
        // 播放按钮
        UIButton *playButton = [[UIButton alloc] init];
        UIImage *playButtonImage = [UIImage imageNamed:@"video_play"];
        [playButton setImage:playButtonImage forState:UIControlStateNormal];
        [playButton addTarget:self action:@selector(playButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [coverImageView addSubview:playButton];
        self.playButton = playButton;
        
        // 底部视图
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bottomView];
        self.bottomView = bottomView;
        
        UIButton *shareButton = [[UIButton alloc] init];
        [bottomView addSubview:shareButton];
        self.shareButton = shareButton;
        
        UIImageView *commentImageView = [[UIImageView alloc] init];
        [bottomView addSubview:commentImageView];
        self.commentImageView = commentImageView;
        
        UILabel *commentLabel = [[UILabel alloc] init];
        commentLabel.font = [UIFont systemFontOfSize:commentFontSize];
        commentLabel.textColor = [UIColor colorFromHexString:LPColor22];
        [bottomView addSubview:commentLabel];
        self.commentLabel = commentLabel;
        
        // 分割线
        UIView *seperatorView = [[UIView alloc] init];
        seperatorView.backgroundColor = [UIColor colorFromHexString:LPColor16];
        [self.contentView addSubview:seperatorView];
        self.seperatorView = seperatorView;
        
    }
    return self;
}

- (void)setVideoFrame:(LPHomeVideoFrame *)videoFrame {

    _videoFrame = videoFrame;
    Card *card = videoFrame.card;
    self.card = card;
    NSString *newsType = @"";
    NSString *newsTypeColor = LPColor17;
    switch ([card.rtype integerValue]) {
        case hotNewsType:
            newsType = @"热点";
            newsTypeColor = LPColor17;
            break;
        case pushNewsType:
            newsType = @"推送";
            newsTypeColor = LPColor18;
            break;
        case adNewsType:
            newsType = @"广告";
            newsTypeColor = LPColor19;
            break;
        default:
            break;
    }
    
    CGFloat lineSpacing = 2.0f;
    _videoFrame = videoFrame;
    
    CGFloat titleFontSize =  self.videoFrame.homeViewFontSize;
    NSString *fontSizeType = self.videoFrame.fontSizeType;
    
    CGFloat newsTypeFontSize = 12;
    // standard  superlarger  larger
    if ([fontSizeType isEqualToString:@"standard"]) {
        newsTypeFontSize = 12;
    } else if ([fontSizeType isEqualToString:@"larger"]) {
        newsTypeFontSize = 14;
    } else {
        newsTypeFontSize = 16;
    }
    
    NSString *title = card.title;
    NSInteger rtype = [card.rtype intValue];
    
    self.newsTypeLabel.font = [UIFont systemFontOfSize:newsTypeFontSize];
    
    switch (rtype) {
        case hotNewsType:case pushNewsType:case adNewsType:
            title = [NSString stringWithFormat:@"%@%@",newsType, title];
            break;
        default:
            break;
    }
    // 评论数量
    NSInteger commentsCount = [card.commentsCount intValue];
    NSString *commentsStr = @"";
    if (commentsCount > 0) {
        if (commentsCount > 10000) {
            commentsStr = [NSString stringWithFormat:@"%.1f万评", (floor)(commentsCount)/ 10000];
        } else {
            commentsStr = [NSString stringWithFormat:@"%d评", commentsCount];
        }
    }

    NSAttributedString *attributeTitle =  nil;
    switch (rtype) {
        case hotNewsType:case pushNewsType:case adNewsType:
            attributeTitle =   [title truncatingTailAttributedStringWithFont:titleFontSize lineSpacing:lineSpacing rtype:YES];
            break;
        default:
            attributeTitle =   [title truncatingTailAttributedStringWithFont:titleFontSize lineSpacing:lineSpacing rtype:NO];
            break;
    }
    
    self.titleLabel.frame = videoFrame.titleF;
    self.titleLabel.attributedText = attributeTitle;
    self.coverImageView.frame = videoFrame.coverImageF;
    
    
    // 广告
    if ([card.rtype integerValue] == adNewsType) {
        NSString *firstImageURL;
        if (card.cardImages.count > 0) {
            firstImageURL = [card.cardImages objectAtIndex:0].imgUrl;
        }
        UIImage *coverPlaceHolder = [UIImage sharePlaceholderImage:[UIColor colorFromHexString:@"#f8f8f8"] sizes:CGSizeMake(100, 100)];
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:firstImageURL] placeholderImage:coverPlaceHolder];
        self.playButton.hidden = YES;
    } else {
        NSURL *coverImageURL = [NSURL URLWithString:card.thumbnail];
        UIImage *coverPlaceHolder = [UIImage sharePlaceholderImage:[UIColor colorFromHexString:@"#f8f8f8"] sizes:CGSizeMake(100, 100)];
        
        
        [self.coverImageView sd_setImageWithURL:coverImageURL placeholderImage:coverPlaceHolder];
        
        self.playButton.hidden = NO;
    }
    
    self.playButton.frame = videoFrame.playButtonF;
    self.bottomView.frame = videoFrame.bottomViewF;
    
    self.commentLabel.frame = videoFrame.commentLabelF;
    self.commentLabel.text = commentsStr;
    
    self.shareButton.frame = videoFrame.shareButtonF;
    UIImage *shareImage = [UIImage imageNamed:@"video_share_black"];
    [self.shareButton setImage:shareImage forState:UIControlStateNormal];
    
    self.newsTypeLabel.layer.backgroundColor = [UIColor colorFromHexString:newsTypeColor].CGColor;
    self.newsTypeLabel.frame = videoFrame.newsTypeLabelF;
    self.newsTypeLabel.text = newsType;
    
    self.tipButton.frame = videoFrame.tipButtonFrame;
    self.tipButton.hidden = videoFrame.isTipButtonHidden;
    
    self.seperatorView.frame = videoFrame.seperatorViewF;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

#pragma mark - 首页上次看到哪里
- (void)didClickTipButton{
    if (self.didClickTipBlock) {
        self.didClickTipBlock();
    }
}

- (void)didClickTipButtonBlock:(didClickTipButtonBlock)didClickTipButtonBlock {
    self.didClickTipBlock = didClickTipButtonBlock;
}

- (void)playButtonDidClick:(UIButton *)sender {
    if (self.playButtonBlock) {
        self.playButtonBlock(sender);
    }
}

- (void)coverImageViewTap:(UIImageView *)sender {
    if ([self.card.rtype integerValue] == adNewsType) {
        if ([self.delegate respondsToSelector:@selector(cell:didTapImageViewWithCard:)]) {
            [self.delegate cell:self didTapImageViewWithCard:self.card];
        }
        
    } else {
        if (self.coverImageBlock) {
            self.coverImageBlock(sender);
        }
    }
}

@end
