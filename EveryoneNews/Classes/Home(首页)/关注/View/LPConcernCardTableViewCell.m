//
//  LPConcernCardTableViewCell.m
//  EveryoneNews
//
//  Created by dongdan on 16/7/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPConcernCardTableViewCell.h"
#import "TTTAttributedLabel.h"
#import "LPConcernCardFrame.h"
#import "LPConcernCard.h"
#import "UIImageView+WebCache.h"
#import "Card+Create.h"
#import "CardImage.h"

@interface LPConcernCardTableViewCell ()

// 无图
@property (nonatomic, strong) TTTAttributedLabel *noImageLabel;
@property (nonatomic, strong) UILabel *noImagePublishTimeLabel;
@property (nonatomic, strong) UILabel *noImageCommentLabel;
@property (nonatomic, strong) UIView *noImageSeperatorLine;

// 单图
@property (nonatomic, strong) TTTAttributedLabel *singleImageTitleLabel;
@property (nonatomic, strong) UIImageView *singleImageView;
@property (nonatomic, strong) UILabel *singleImagePublishTimeLabel;
@property (nonatomic, strong) UILabel *singleCommentLabel;
@property (nonatomic, strong) UIView *singleImageSeperatorLine;

// 三图
@property (nonatomic, strong) TTTAttributedLabel *multipleImageLabel;
@property (nonatomic, strong) UILabel *mutipleImagePublishTimeLabel;
@property (nonatomic, strong) UIImageView *firstMutipleImageView;
@property (nonatomic, strong) UIImageView *secondMutipleImageView;
@property (nonatomic, strong) UIImageView *thirdMutipleImageView;
@property (nonatomic, strong) UILabel *multipleCommentLabel;
@property (nonatomic, strong) UIView *mutipleSeperatorLine;



@end


@implementation LPConcernCardTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor colorWithHexString:LPColor9];
        
        CGFloat commentFontSize = LPFont6;
        CGFloat publishTimeFontSize = LPFont6;
        
        // 无图
        TTTAttributedLabel *noImageLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        noImageLabel.textColor = [UIColor colorFromHexString:@"#1a1a1a"];
        noImageLabel.numberOfLines = 0;
        noImageLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:noImageLabel];
        self.noImageLabel = noImageLabel;
        
        UILabel *noImagePublishTimeLabel = [[UILabel alloc] init];
 
        noImagePublishTimeLabel.textAlignment = NSTextAlignmentCenter;
        noImagePublishTimeLabel.font = [UIFont systemFontOfSize:publishTimeFontSize];
        noImagePublishTimeLabel.textColor = [UIColor colorWithHexString:LPColor4];
        [self.contentView addSubview:noImagePublishTimeLabel];
        self.noImagePublishTimeLabel = noImagePublishTimeLabel;
        
        UILabel *noImageCommentLabel = [[UILabel alloc] init];
        noImageCommentLabel.font = [UIFont systemFontOfSize:commentFontSize];
        noImageCommentLabel.textColor = [UIColor colorFromHexString:LPColor4];
        [self.contentView addSubview:noImageCommentLabel];
        self.noImageCommentLabel = noImageCommentLabel;
        
        UIView *noImageSeperatorLine = [[UIView alloc] init];
        noImageSeperatorLine.backgroundColor = [UIColor colorFromHexString:@"e4e4e4"];
        [self.contentView addSubview:noImageSeperatorLine];
        self.noImageSeperatorLine = noImageSeperatorLine;
        
        // 单图
        UIImageView *singleImageView = [[UIImageView alloc] init];
        singleImageView.contentMode = UIViewContentModeScaleAspectFill;
        singleImageView.clipsToBounds = YES;
        [self.contentView addSubview:singleImageView];
        self.singleImageView = singleImageView;
        
        TTTAttributedLabel *singleImageTitleLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        singleImageTitleLabel.textColor =  [UIColor colorFromHexString:@"#1a1a1a"];
        singleImageTitleLabel.numberOfLines = 0;
        singleImageTitleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:singleImageTitleLabel];
        self.singleImageTitleLabel = singleImageTitleLabel;
        
        UILabel *singleImagePublishTimeLabel = [[UILabel alloc] init];
        singleImagePublishTimeLabel.textAlignment = NSTextAlignmentLeft;
        singleImagePublishTimeLabel.font = [UIFont systemFontOfSize:publishTimeFontSize];
        singleImagePublishTimeLabel.textColor = [UIColor colorFromHexString:LPColor4];
        [self.contentView addSubview:singleImagePublishTimeLabel];
        self.singleImagePublishTimeLabel = singleImagePublishTimeLabel;
        
        UILabel *singleCommentLabel = [[UILabel alloc] init];
        singleCommentLabel.font = [UIFont systemFontOfSize:commentFontSize];
        singleCommentLabel.textColor = [UIColor colorFromHexString:LPColor4];
        [self.contentView addSubview:singleCommentLabel];
        self.singleCommentLabel= singleCommentLabel;
        
        UIView *singleImageSeperatorLine = [[UIView alloc] init];
        singleImageSeperatorLine.backgroundColor = [UIColor colorFromHexString:@"e4e4e4"];
        [self.contentView addSubview:singleImageSeperatorLine];
        self.singleImageSeperatorLine = singleImageSeperatorLine;
        
        //  三图及其三图以上
        TTTAttributedLabel *multipleImageLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
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
        
        UILabel *mutipleImagePublishTimeLabel = [[UILabel alloc] init];
        mutipleImagePublishTimeLabel.textAlignment = NSTextAlignmentLeft;
        mutipleImagePublishTimeLabel.font = [UIFont systemFontOfSize:publishTimeFontSize];
        mutipleImagePublishTimeLabel.textColor = [UIColor colorWithHexString:LPColor4];
        [self.contentView addSubview:mutipleImagePublishTimeLabel];
        self.mutipleImagePublishTimeLabel = mutipleImagePublishTimeLabel;
        
        UILabel *multipleCommentLabel = [[UILabel alloc] init];
        multipleCommentLabel.font = [UIFont systemFontOfSize:commentFontSize];
        multipleCommentLabel.textColor = [UIColor colorFromHexString:LPColor4];
        [self.contentView addSubview:multipleCommentLabel];
        self.multipleCommentLabel = multipleCommentLabel;
        
        UIView *mutipleSeperatorLine = [[UIView alloc] init];
        mutipleSeperatorLine.backgroundColor = [UIColor colorFromHexString:@"e4e4e4"];
        [self.contentView addSubview:mutipleSeperatorLine];
        self.mutipleSeperatorLine = mutipleSeperatorLine;
    }
    return self;
}

- (void)setCardFrame:(LPConcernCardFrame *)cardFrame {
    _cardFrame = cardFrame;
    LPConcernCard *card = cardFrame.card;
    NSDate *currentDate = [NSDate date];
    NSDate *updateTime = [NSDate dateWithTimeIntervalSince1970:card.updateTime.longLongValue / 1000.0];
    NSString *publishTime = nil;
    int interval = (int)[currentDate timeIntervalSinceDate: updateTime] / 60;
    if (interval > 0 && interval < 60) {
        publishTime = [NSString stringWithFormat:@"%d分钟前",interval];
    } else if (interval == 0) {
        publishTime = @"3秒前";
    } else if(interval > 60 && interval < 60 * 12) {
        publishTime = [NSString stringWithFormat:@"%d小时前",interval / 60];
    } else {
        publishTime = [NSString stringFromDate:updateTime];
    }
    
    NSString *commentsCount = [NSString stringWithFormat:@"%@评", card.commentsCount != nil ? card.commentsCount: @"0"];
    NSMutableAttributedString *titleHtml = [Card titleHtmlString:card.title];
    
    BOOL commentLabelHidden = [commentsCount isEqualToString:@"0评"] ? YES : NO;
    
    if(card.cardImages.count == 0) {
        
        self.noImageLabel.hidden = NO;
        self.noImagePublishTimeLabel.hidden = NO;
        self.noImageSeperatorLine.hidden = NO;
        
        self.singleImageTitleLabel.hidden = YES;
        self.singleImageView.hidden = YES;
        self.singleImagePublishTimeLabel.hidden = YES;
        self.singleCommentLabel.hidden = YES;
        self.singleImageSeperatorLine.hidden = YES;
        
        self.multipleImageLabel.hidden = YES;
        self.firstMutipleImageView.hidden = YES;
        self.secondMutipleImageView.hidden = YES;
        self.thirdMutipleImageView.hidden = YES;
        self.mutipleImagePublishTimeLabel.hidden = YES;
        self.multipleCommentLabel.hidden = YES;
        self.mutipleSeperatorLine.hidden = YES;
        
        self.noImageLabel.frame = self.cardFrame.noImageTitleLabelFrame;
        self.noImageLabel.text = titleHtml;
        
        self.noImageCommentLabel.frame = self.cardFrame.noImageCommentLabelFrame;
        self.noImageCommentLabel.text = commentsCount;
        self.noImageCommentLabel.hidden = commentLabelHidden;
        
        
        self.noImagePublishTimeLabel.frame = self.cardFrame.noImagePublishTimeLabelFrame;
        self.noImagePublishTimeLabel.text = publishTime;
        self.noImageSeperatorLine.frame = self.cardFrame.noImageSeperatorLineFrame;
        
        
        
        
    } else if (card.cardImages.count == 1 || card.cardImages.count == 2) {
        
        NSString *cardImageURL = [card.cardImages firstObject];

        self.noImageLabel.hidden = YES;
        self.noImagePublishTimeLabel.hidden = YES;
        self.noImageSeperatorLine.hidden = YES;
        self.noImageCommentLabel.hidden = YES;
        
        self.singleImageTitleLabel.hidden = NO;
        self.singleImageView.hidden = NO;
        self.singleImagePublishTimeLabel.hidden = NO;
        self.singleImageSeperatorLine.hidden = NO;
        
        self.multipleImageLabel.hidden = YES;
        self.firstMutipleImageView.hidden = YES;
        self.secondMutipleImageView.hidden = YES;
        self.thirdMutipleImageView.hidden = YES;
        self.mutipleImagePublishTimeLabel.hidden = YES;
        self.multipleCommentLabel.hidden = YES;
        self.mutipleSeperatorLine.hidden = YES;
        
        self.singleImageTitleLabel.text =  titleHtml;
        self.singleImageTitleLabel.frame = self.cardFrame.singleImageTitleLabelFrame;
        
        self.singleImageView.frame = self.cardFrame.singleImageImageViewFrame;
        NSString *imageURL = [self scaleImageURL:cardImageURL];
        [self.singleImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"单图小图占位图"]];
        
        self.singleImagePublishTimeLabel.frame = self.cardFrame.singleImagePublishTimeLabelFrame;
        self.singleImagePublishTimeLabel.text = publishTime;
        
        self.singleCommentLabel.text = commentsCount;
        self.singleCommentLabel.frame = self.cardFrame.singleImageCommentLabelFrame;
        self.singleCommentLabel.hidden = commentLabelHidden;
 
        self.singleImageSeperatorLine.frame = self.cardFrame.singleImageSeperatorLineFrame;
        
    } else if (card.cardImages.count >= 3) {
        
        self.noImageLabel.hidden = YES;
        self.noImagePublishTimeLabel.hidden = YES;
        self.noImageSeperatorLine.hidden = YES;
        self.noImageCommentLabel.hidden = YES;
        
        self.singleImageTitleLabel.hidden = YES;
        self.singleImageView.hidden = YES;
        self.singleImagePublishTimeLabel.hidden = YES;
        self.singleCommentLabel.hidden = YES;
        self.singleImageSeperatorLine.hidden = YES;
        
        self.multipleImageLabel.hidden = NO;
        self.firstMutipleImageView.hidden = NO;
        self.secondMutipleImageView.hidden = NO;
        self.thirdMutipleImageView.hidden = NO;
        self.mutipleImagePublishTimeLabel.hidden = NO;
        self.multipleCommentLabel.hidden = commentLabelHidden;
        self.mutipleSeperatorLine.hidden = NO;
        
        self.multipleImageLabel.text = titleHtml;
        self.multipleImageLabel.frame = self.cardFrame.multipleImageTitleLabelFrame;
        
        self.mutipleImagePublishTimeLabel.frame = self.cardFrame.multipleImagePublishTimeLabelFrame;
        self.mutipleImagePublishTimeLabel.text = publishTime;
     
        
        self.multipleCommentLabel.frame = self.cardFrame.multipleImageCommentLabelFrame;
        self.multipleCommentLabel.text = commentsCount;
        
        
        self.mutipleSeperatorLine.frame = self.cardFrame.mutipleImageSeperatorLineFrame;
        
        CGRect frame = self.cardFrame.multipleImageViewFrame;
        CGFloat x = frame.origin.x;
        CGFloat y = frame.origin.y;
        CGFloat w = (frame.size.width - 6) / 3 ;
        CGFloat h = frame.size.height;
   
        [self.firstMutipleImageView sd_setImageWithURL:[NSURL URLWithString:card.cardImages[0]] placeholderImage:[UIImage imageNamed:@"单图小图占位图"]];
        [self.secondMutipleImageView sd_setImageWithURL:[NSURL URLWithString:card.cardImages[1]] placeholderImage:[UIImage imageNamed:@"单图小图占位图"]];
        [self.thirdMutipleImageView sd_setImageWithURL:[NSURL URLWithString:card.cardImages[2]] placeholderImage:[UIImage imageNamed:@"单图小图占位图"]];
        
        self.firstMutipleImageView.frame = CGRectMake(x, y, w, h);
        self.secondMutipleImageView.frame = CGRectMake(x + w + 3, y, w, h);
        self.thirdMutipleImageView.frame = CGRectMake(x + 2 * w + 6, y, w, h);
        
    }
 
}

#pragma mark - 图片缩放处理
- (NSString *)scaleImageURL:(NSString *)imageURL {
    NSRange range = [imageURL rangeOfString:@"/" options:NSBackwardsSearch];
    NSString *substring = [imageURL substringFromIndex:range.location+1];
    NSString *scaleImageURL = [NSString stringWithFormat:@"http://pro-pic.deeporiginalx.com/%@@1e_1c_0o_0l_100sh_200h_300w_100q.src", substring];
    return scaleImageURL;
}

@end
