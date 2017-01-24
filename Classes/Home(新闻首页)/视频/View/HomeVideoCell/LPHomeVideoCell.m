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
@property (nonatomic, strong) Card *card;

@end

@implementation LPHomeVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        CGFloat commentFontSize = 13;
        
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
        UIImage *playButtonImage = [UIImage oddityImage:@"video_play"];
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
        shareButton.alpha = 0;
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

    CGFloat lineSpacing = 2.0f;
    _videoFrame = videoFrame;
    
    CGFloat titleFontSize =  self.videoFrame.homeViewFontSize;
    
    Card *card = videoFrame.card;
    
    self.card = card;
    
    NSString *title = card.title;
    
    if ([card.rtype integerValue] == adNewsType) {
        title = [NSString stringWithFormat:@"广告 %@", title];
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
    NSAttributedString *attributeTitle =  [title attributedStringWithFont:[UIFont systemFontOfSize:titleFontSize] lineSpacing:lineSpacing];
    if ([card.rtype integerValue] == adNewsType) {
        attributeTitle  = [title adsAttributedStringWithFont:[UIFont systemFontOfSize:titleFontSize] lineSpacing:lineSpacing];
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
    UIImage *shareImage = [UIImage oddityImage:@"video_share_black"];
    [self.shareButton setImage:shareImage forState:UIControlStateNormal];
    
    self.commentImageView.frame = videoFrame.commentImageViewF;
    self.commentImageView.image = [UIImage oddityImage:@"video_comment"];
    
    self.seperatorView.frame = videoFrame.seperatorViewF;
    
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
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
