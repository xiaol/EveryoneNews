//
//  LPMyCollectionViewCell.m
//  EveryoneNews
//
//  Created by dongdan on 16/8/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPMyCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "LPMyCollectionCardFrame.h"
#import "LPMyCollectionCard.h"

@interface LPMyCollectionViewCell()

// 无图
@property (nonatomic, strong) UILabel *noImageLabel;
@property (nonatomic, strong) UILabel *noImageSourceLabel;
@property (nonatomic, strong) UILabel *noImageCommentLabel;
@property (nonatomic, strong) UIView *noImageSeperatorLine;

// 单图
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *singleSourceLabel;
@property (nonatomic, strong) UILabel *singleCommentLabel;
@property (nonatomic, strong) UIView *singleSeperatorLine;

// 三图
@property (nonatomic, strong) UILabel *multipleImageLabel;
@property (nonatomic, strong) UILabel *mutipleCommentLabel;
@property (nonatomic, strong) UIImageView *firstMutipleImageView;
@property (nonatomic, strong) UIImageView *secondMutipleImageView;
@property (nonatomic, strong) UIImageView *thirdMutipleImageView;
@property (nonatomic, strong) UILabel *multipleSourceLabel;
@property (nonatomic, strong) UIView *mutipleSeperatorLine;

// 视频
@property (nonatomic, strong) UILabel *videoTitleLabel;
@property (nonatomic, strong) UIImageView *videoIconView;
@property (nonatomic, strong) UILabel *videoSourceLabel;
@property (nonatomic, strong) UILabel *videoCommentLabel;
@property (nonatomic, strong) UIView *videoSeperatorLine;
@property (nonatomic, strong) UIImageView *videoPlayImageView;
@property (nonatomic, strong) UILabel *videoDurationLabel;


@end


@implementation LPMyCollectionViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6"];
    CGFloat sourceFontSize = 10;
    if(self) {
        // 无图
        UILabel *noImageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        noImageLabel.textColor = [UIColor colorFromHexString:@"#1a1a1a"];
        noImageLabel.numberOfLines = 0;
        noImageLabel.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:noImageLabel];
        self.noImageLabel = noImageLabel;
        
        UILabel *noImageSourceLabel = [[UILabel alloc] init];
        noImageSourceLabel.font = [UIFont systemFontOfSize:sourceFontSize];
        noImageSourceLabel.textColor = [UIColor colorFromHexString:@"#999999"];
        [self.contentView addSubview:noImageSourceLabel];
        self.noImageSourceLabel = noImageSourceLabel;
        
        UILabel *noImageCommentLabel = [[UILabel alloc] init];
        noImageCommentLabel.font = [UIFont systemFontOfSize:sourceFontSize];
        noImageCommentLabel.textColor = [UIColor colorFromHexString:@"#999999"];
        noImageCommentLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:noImageCommentLabel];
        self.noImageCommentLabel = noImageCommentLabel;        
        
        UIView *noImageSeperatorLine = [[UIView alloc] init];
        noImageSeperatorLine.backgroundColor = [UIColor colorFromHexString:@"e4e4e4"];
        [self.contentView addSubview:noImageSeperatorLine];
        self.noImageSeperatorLine = noImageSeperatorLine;
        
        
        // 单图
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.contentMode = UIViewContentModeScaleAspectFill;
        iconView.clipsToBounds = YES;
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.textColor =  [UIColor colorFromHexString:@"#1a1a1a"];
        titleLabel.numberOfLines = 0;
        titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UILabel *singleSourceLabel = [[UILabel alloc] init];
        singleSourceLabel.font = [UIFont systemFontOfSize:sourceFontSize];
        singleSourceLabel.textColor = [UIColor colorFromHexString:@"999999"];
        [self.contentView addSubview:singleSourceLabel];
        self.singleSourceLabel= singleSourceLabel;
        
        
        UILabel *singleCommentLabel = [[UILabel alloc] init];
        singleCommentLabel.font = [UIFont systemFontOfSize:sourceFontSize];
        singleCommentLabel.textColor = [UIColor colorFromHexString:@"999999"];
        singleCommentLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:singleCommentLabel];
        self.singleCommentLabel= singleCommentLabel;
        
        UIView *singleSeperatorLine = [[UIView alloc] init];
        singleSeperatorLine.backgroundColor = [UIColor colorFromHexString:@"e4e4e4"];
        [self.contentView addSubview:singleSeperatorLine];
        self.singleSeperatorLine = singleSeperatorLine;
        
        //  三图及其三图以上
        UILabel *multipleImageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        multipleImageLabel.numberOfLines = 0;
        multipleImageLabel.backgroundColor = [UIColor clearColor];
        multipleImageLabel.textColor = [UIColor colorFromHexString:@"#1a1a1a"];
        [self.contentView addSubview:multipleImageLabel];
        self.multipleImageLabel = multipleImageLabel;
        
        UIImageView *firstMutipleImageView = [[UIImageView alloc] init];
        firstMutipleImageView.contentMode = UIViewContentModeScaleAspectFill;
        firstMutipleImageView.clipsToBounds = YES;
        [self.contentView addSubview:firstMutipleImageView];
        self.firstMutipleImageView = firstMutipleImageView;
        
        UIImageView *secondMutipleImageView = [[UIImageView alloc] init];
        secondMutipleImageView.contentMode = UIViewContentModeScaleAspectFill;
        secondMutipleImageView.clipsToBounds = YES;
        [self.contentView addSubview:secondMutipleImageView];
        self.secondMutipleImageView = secondMutipleImageView;
        
        UIImageView *thirdMutipleImageView = [[UIImageView alloc] init];
        thirdMutipleImageView.contentMode = UIViewContentModeScaleAspectFill;
        thirdMutipleImageView.clipsToBounds = YES;
        [self.contentView addSubview:thirdMutipleImageView];
        self.thirdMutipleImageView = thirdMutipleImageView;
        
        UILabel *multipleSourceLabel = [[UILabel alloc] init];
        multipleSourceLabel.font = [UIFont systemFontOfSize:sourceFontSize];
        multipleSourceLabel.textColor = [UIColor colorFromHexString:@"999999"];
        [self.contentView addSubview:multipleSourceLabel];
        self.multipleSourceLabel = multipleSourceLabel;
        
        UILabel *mutipleCommentLabel = [[UILabel alloc] init];
        mutipleCommentLabel.font = [UIFont systemFontOfSize:sourceFontSize];
        mutipleCommentLabel.textColor = [UIColor colorFromHexString:@"999999"];
        mutipleCommentLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:mutipleCommentLabel];
        self.mutipleCommentLabel = mutipleCommentLabel;
        
        
        UIView *mutipleSeperatorLine = [[UIView alloc] init];
        mutipleSeperatorLine.backgroundColor = [UIColor colorFromHexString:@"e4e4e4"];
        [self.contentView addSubview:mutipleSeperatorLine];
        self.mutipleSeperatorLine = mutipleSeperatorLine;
        
        // 视频
        UIImageView *videoIconView = [[UIImageView alloc] init];
        videoIconView.contentMode = UIViewContentModeScaleAspectFill;
        videoIconView.clipsToBounds = YES;
        [self.contentView addSubview:videoIconView];
        self.videoIconView = videoIconView;
        
        UILabel *videoTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        videoTitleLabel.textColor =  [UIColor colorFromHexString:@"#1a1a1a"];
        videoTitleLabel.numberOfLines = 0;
        videoTitleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:videoTitleLabel];
        self.videoTitleLabel = videoTitleLabel;
        
        UILabel *videoSourceLabel = [[UILabel alloc] init];
        videoSourceLabel.font = [UIFont systemFontOfSize:sourceFontSize];
        videoSourceLabel.textColor = [UIColor colorFromHexString:@"999999"];
        [self.contentView addSubview:videoSourceLabel];
        self.videoSourceLabel= videoSourceLabel;
        
        
        UILabel *videoCommentLabel = [[UILabel alloc] init];
        videoCommentLabel.font = [UIFont systemFontOfSize:sourceFontSize];
        videoCommentLabel.textColor = [UIColor colorFromHexString:@"999999"];
        videoCommentLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:videoCommentLabel];
        self.videoCommentLabel= videoCommentLabel;
        
        UIView *videoSeperatorLine = [[UIView alloc] init];
        videoSeperatorLine.backgroundColor = [UIColor colorFromHexString:@"e4e4e4"];
        [self.contentView addSubview:videoSeperatorLine];
        self.videoSeperatorLine = videoSeperatorLine;
        
        UIImageView *videoPlayImageView = [[UIImageView alloc] init];
        videoPlayImageView.image = [UIImage oddityImage:@"video_play2"];
        [videoIconView addSubview:videoPlayImageView];
        self.videoPlayImageView = videoPlayImageView ;
        
        UILabel *videoDurationLabel = [[UILabel alloc] init];
        videoDurationLabel.font = [UIFont systemFontOfSize:10];
        videoDurationLabel.textColor = [UIColor whiteColor];
        [videoIconView addSubview:videoDurationLabel];
        self.videoDurationLabel = videoDurationLabel;
    }
    return self;
}

- (void)setCardFrame:(LPMyCollectionCardFrame *)cardFrame {
    _cardFrame = cardFrame;
    CGFloat lineSpacing = 2.0;
    LPMyCollectionCard *card = _cardFrame.card;
    NSString *sourceSiteName = [card.sourceSiteName  isEqualToString: @""] ? @"未知来源": card.sourceSiteName;
    NSDate *currentDate = [NSDate date];
    NSDate *updateTime = [NSDate dateWithTimeIntervalSince1970:card.updateTime.longLongValue / 1000.0];
    NSString *publishTime = nil;
    int interval = (int)[currentDate timeIntervalSinceDate: updateTime] / 60;
    if (interval > 0 && interval < 60) {
        publishTime = [NSString stringWithFormat:@"%d分钟前",interval];
    } else if (interval == 0) {
        publishTime = @"3秒前";
    } else {
        publishTime = @" ";
    }

    NSString *commentsCount = [NSString stringWithFormat:@"%@评", card.commentsCount != nil ? card.commentsCount: @"0"];
    BOOL commentLabelHidden = [commentsCount isEqualToString:@"0评"] ? YES :NO;
    NSString *source = [NSString stringWithFormat:@"%@    %@",sourceSiteName, publishTime];
    
    NSAttributedString *attributeTitle  = [card.title attributedStringWithFont:[UIFont systemFontOfSize:self.cardFrame.homeViewFontSize] lineSpacing:lineSpacing];
    
    // 视频
    if (card.rtype == videoNewsType) {
        
        // 视频
        self.videoIconView.hidden = NO;
        self.videoTitleLabel.hidden = NO;
        self.videoSourceLabel.hidden = NO;
        self.videoCommentLabel.hidden = NO;
        self.videoSeperatorLine.hidden = NO;
        self.videoPlayImageView.hidden = NO;
        self.videoDurationLabel.hidden = NO;
        
        // 无图
        self.noImageLabel.hidden = NO;
        self.noImageSourceLabel.hidden = NO;
        self.noImageSeperatorLine.hidden = NO;
        self.noImageCommentLabel.hidden = NO;
        
        // 单图
        self.titleLabel.hidden = YES;
        self.iconView.hidden = YES;
        self.singleSourceLabel.hidden = YES;
        self.singleSeperatorLine.hidden = YES;
        self.singleCommentLabel.hidden = YES;
        
        // 多图
        self.multipleImageLabel.hidden = YES;
        self.firstMutipleImageView.hidden = YES;
        self.secondMutipleImageView.hidden = YES;
        self.thirdMutipleImageView.hidden = YES;
        self.multipleSourceLabel.hidden = YES;
        self.mutipleSeperatorLine.hidden = YES;
        self.mutipleCommentLabel.hidden = YES;
        
        NSString *imageURL = card.thumbnail;
        [self.videoIconView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage oddityImage:@"单图小图占位图"]];
        self.videoIconView.frame = self.cardFrame.videoImageViewFrame;
        self.videoTitleLabel.frame = self.cardFrame.videoTitleLabelFrame;
        self.videoTitleLabel.attributedText = attributeTitle;
        
        self.videoSourceLabel.text = source;
        self.videoSourceLabel.frame = self.cardFrame.videoSourceLabelFrame;

        self.videoSeperatorLine.frame = self.cardFrame.videoSeperatorLineFrame;
        self.videoCommentLabel.frame = self.cardFrame.videoCommentsCountLabelFrame;
        self.videoCommentLabel.hidden = commentLabelHidden;
        self.videoCommentLabel.text = commentsCount;
        
        // 播放按钮 播放时长
        self.videoPlayImageView.frame = self.cardFrame.videoPlayImageViewFrame;
        self.videoDurationLabel.frame = self.cardFrame.videoDurationLabelFrame;
        self.videoDurationLabel.centerY = self.videoPlayImageView.centerY;
        
        NSInteger totalSeconds = card.duration;
        NSInteger seconds = totalSeconds % 60;
        NSInteger minutes = (totalSeconds / 60);
        
        self.videoDurationLabel.text =  [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
        self.videoDurationLabel.textColor = [UIColor whiteColor];
        
    } else {
        // 无图
        if(card.cardImages.count == 0) {
            // 无图
            self.noImageLabel.hidden = NO;
            self.noImageSourceLabel.hidden = NO;
            self.noImageSeperatorLine.hidden = NO;
            self.noImageCommentLabel.hidden = NO;
            
            // 单图
            self.titleLabel.hidden = YES;
            self.iconView.hidden = YES;
            self.singleSourceLabel.hidden = YES;
            self.singleSeperatorLine.hidden = YES;
            self.singleCommentLabel.hidden = YES;
            
            // 多图
            self.multipleImageLabel.hidden = YES;
            self.firstMutipleImageView.hidden = YES;
            self.secondMutipleImageView.hidden = YES;
            self.thirdMutipleImageView.hidden = YES;
            self.multipleSourceLabel.hidden = YES;
            self.mutipleSeperatorLine.hidden = YES;
            self.mutipleCommentLabel.hidden = YES;
            
            // 视频
            self.videoIconView.hidden = YES;
            self.videoTitleLabel.hidden = YES;
            self.videoSourceLabel.hidden = YES;
            self.videoCommentLabel.hidden = YES;
            self.videoSeperatorLine.hidden = YES;
            self.videoPlayImageView.hidden = YES;
            self.videoDurationLabel.hidden = YES;
            
            self.noImageLabel.frame = self.cardFrame.noImageLabelFrame;
            self.noImageLabel.attributedText = attributeTitle;
            
            CGRect noImageSourceLabelFrame = self.cardFrame.noImageSourceLabelFrame;
            self.noImageSourceLabel.frame = noImageSourceLabelFrame;
            self.noImageSourceLabel.text = source;
            
            self.noImageSeperatorLine.frame = self.cardFrame.noImageSeperatorLineFrame;
            self.noImageCommentLabel.frame = self.cardFrame.noImageCommentLabelFrame;
            
            
            self.noImageCommentLabel.hidden = commentLabelHidden;
            
            self.noImageCommentLabel.text = commentsCount;
            
            
        }  else if (card.cardImages.count == 1 || card.cardImages.count == 2) {
            NSString *imageURL = [card.cardImages firstObject];
            imageURL = [self scaleImageURL:imageURL];
            [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage oddityImage:@"单图小图占位图"]];
            
            self.noImageLabel.hidden = YES;
            self.noImageSourceLabel.hidden = YES;
            self.noImageSeperatorLine.hidden = YES;
            self.noImageCommentLabel.hidden = YES;
            
            
            self.titleLabel.hidden = NO;
            self.iconView.hidden = NO;
            self.singleSourceLabel.hidden = NO;
            self.singleSeperatorLine.hidden = NO;
            self.singleCommentLabel.hidden = NO;
            
            self.multipleImageLabel.hidden = YES;
            self.firstMutipleImageView.hidden = YES;
            self.secondMutipleImageView.hidden = YES;
            self.thirdMutipleImageView.hidden = YES;
            self.multipleSourceLabel.hidden = YES;
            self.mutipleSeperatorLine.hidden = YES;
            self.mutipleCommentLabel.hidden = YES;
            
            // 视频
            self.videoIconView.hidden = YES;
            self.videoTitleLabel.hidden = YES;
            self.videoSourceLabel.hidden = YES;
            self.videoCommentLabel.hidden = YES;
            self.videoSeperatorLine.hidden = YES;
            self.videoPlayImageView.hidden = YES;
            self.videoDurationLabel.hidden = YES;
            
            self.iconView.frame = self.cardFrame.singleImageImageViewFrame;
            self.titleLabel.frame = self.cardFrame.singleImageTitleLabelFrame;
            self.titleLabel.attributedText = attributeTitle;
            
            CGRect singleImageSourceLabelFrame = self.cardFrame.singleImageSourceLabelFrame;
            
            self.singleSourceLabel.text = source;
            self.singleSourceLabel.frame = singleImageSourceLabelFrame;
            
            
            
            self.singleSeperatorLine.frame = self.cardFrame.singleImageSeperatorLineFrame;
            self.singleCommentLabel.frame = self.cardFrame.singelImageCommentLabelFrame;
            self.singleCommentLabel.hidden = commentLabelHidden;
            
            self.singleCommentLabel.text = commentsCount;
            
            
            
        }   else if (card.cardImages.count >= 3) {
            self.noImageLabel.hidden = YES;
            self.noImageSourceLabel.hidden = YES;
            self.noImageSeperatorLine.hidden = YES;
            self.noImageCommentLabel.hidden = YES;
            
            
            self.titleLabel.hidden = YES;
            self.iconView.hidden = YES;
            self.singleSourceLabel.hidden = YES;
            self.singleSeperatorLine.hidden = YES;
            self.singleCommentLabel.hidden = YES;
            
            // 视频
            self.videoIconView.hidden = YES;
            self.videoTitleLabel.hidden = YES;
            self.videoSourceLabel.hidden = YES;
            self.videoCommentLabel.hidden = YES;
            self.videoSeperatorLine.hidden = YES;
            self.videoPlayImageView.hidden = YES;
            self.videoDurationLabel.hidden = YES;
            
            self.multipleImageLabel.hidden = NO;
            self.firstMutipleImageView.hidden = NO;
            self.secondMutipleImageView.hidden = NO;
            self.thirdMutipleImageView.hidden = NO;
            self.multipleSourceLabel.hidden = NO;
            self.mutipleSeperatorLine.hidden = NO;
            
            self.mutipleCommentLabel.hidden = NO;
            
            
            
            self.multipleImageLabel.attributedText = attributeTitle;
            self.multipleImageLabel.frame = self.cardFrame.multipleImageTitleLabelFrame;
            
            
            CGRect multipleImageSourceLabelFrame = self.cardFrame.multipleImageSourceLabelFrame;
            self.multipleSourceLabel.frame = multipleImageSourceLabelFrame;
            self.multipleSourceLabel.text = source;
            
            self.mutipleSeperatorLine.frame = self.cardFrame.mutipleImageSeperatorLineFrame;
            
            [self.firstMutipleImageView sd_setImageWithURL:[NSURL URLWithString:[self scaleImageURL:card.cardImages[0]]] placeholderImage:[UIImage oddityImage:@"单图小图占位图"]];
            [self.secondMutipleImageView sd_setImageWithURL:[NSURL URLWithString:[self scaleImageURL:card.cardImages[1]]] placeholderImage:[UIImage oddityImage:@"单图小图占位图"]];
            [self.thirdMutipleImageView sd_setImageWithURL:[NSURL URLWithString:[self scaleImageURL:card.cardImages[2]]] placeholderImage:[UIImage oddityImage:@"单图小图占位图"]];
            
            CGRect frame = self.cardFrame.multipleImageViewFrame;
            CGFloat x = frame.origin.x;
            CGFloat y = frame.origin.y;
            CGFloat w = (frame.size.width - 6) / 3 ;
            CGFloat h = frame.size.height;
            self.firstMutipleImageView.frame = CGRectMake(x, y, w, h);
            self.secondMutipleImageView.frame = CGRectMake(x + w + 3, y, w, h);
            self.thirdMutipleImageView.frame = CGRectMake(x + 2 * w + 6, y, w, h);
            
            self.mutipleCommentLabel.frame = self.cardFrame.mutipleImageCommentLabelFrame;
            self.mutipleCommentLabel.hidden = commentLabelHidden;
            self.mutipleCommentLabel.text = commentsCount;
        }

    }
}


- (void)setHighlighted:(BOOL)highlighted {
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

- (NSString *)scaleImageURL:(NSString *)imageURL {
    NSRange range = [imageURL rangeOfString:@"/" options:NSBackwardsSearch];
    NSString *substring = [imageURL substringFromIndex:range.location+1];
    NSString *scaleImageURL = [NSString stringWithFormat:@"http://pro-pic.deeporiginalx.com/%@@1e_1c_0o_0l_100sh_200h_300w_100q.src", substring];
    return scaleImageURL;
}

@end
