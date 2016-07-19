//
//  LPSearchResultViewCell.m
//  EveryoneNews
//
//  Created by dongdan on 16/6/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPSearchResultViewCell.h"
#import "UIImageView+WebCache.h"
#import "LPSearchCardFrame.h"
#import "LPSearchCard.h"
#import "LPUITextView.h"
#import "TTTAttributedLabel.h"
#import "Card+Create.h"


@interface LPSearchResultViewCell ()
// 无图
@property (nonatomic, strong) TTTAttributedLabel *noImageLabel;
@property (nonatomic, strong) UILabel *noImageSourceLabel;
@property (nonatomic, strong) UILabel *noImageCommentLabel;
@property (nonatomic, strong) UIView *noImageSeperatorLine;

// 单图
@property (nonatomic, strong) TTTAttributedLabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *singleSourceLabel;
@property (nonatomic, strong) UILabel *singleCommentLabel;
@property (nonatomic, strong) UIView *singleSeperatorLine;

// 三图
@property (nonatomic, strong) TTTAttributedLabel *multipleImageLabel;
@property (nonatomic, strong) UILabel *mutipleCommentLabel;
@property (nonatomic, strong) UIImageView *firstMutipleImageView;
@property (nonatomic, strong) UIImageView *secondMutipleImageView;
@property (nonatomic, strong) UIImageView *thirdMutipleImageView;
@property (nonatomic, strong) UILabel *multipleSourceLabel;
@property (nonatomic, strong) UIView *mutipleSeperatorLine;

@end

@implementation LPSearchResultViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6"];
    CGFloat sourceFontSize = 9;
    if (iPhone6Plus) {
        sourceFontSize = 10;
    } else if(iPhone6) {
        sourceFontSize = 9;
    }
    if(self) {
        // 无图
        TTTAttributedLabel *noImageLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
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
        
        TTTAttributedLabel *titleLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
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
        
        // 三图及其三图以上
        TTTAttributedLabel *multipleImageLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        multipleImageLabel.numberOfLines = 0;
        multipleImageLabel.backgroundColor = [UIColor clearColor];
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
        
    }
    return self;
}

- (void)setCardFrame:(LPSearchCardFrame *)cardFrame {
    
     _cardFrame = cardFrame;
    LPSearchCard *card = _cardFrame.card;
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
    NSMutableAttributedString *titleHtml = [Card titleHtmlString:card.title];
    
    if(card.cardImages.count == 0) {
        self.noImageLabel.hidden = NO;
        self.noImageSourceLabel.hidden = NO;
        self.noImageSeperatorLine.hidden = NO;
        self.noImageCommentLabel.hidden = NO;
        
        self.titleLabel.hidden = YES;
        self.iconView.hidden = YES;
        self.singleSourceLabel.hidden = YES;
        self.singleSeperatorLine.hidden = YES;
        self.singleCommentLabel.hidden = YES;
        
        self.multipleImageLabel.hidden = YES;
        self.firstMutipleImageView.hidden = YES;
        self.secondMutipleImageView.hidden = YES;
        self.thirdMutipleImageView.hidden = YES;
        self.multipleSourceLabel.hidden = YES;
        self.mutipleSeperatorLine.hidden = YES;
        
        self.mutipleCommentLabel.hidden = YES;
        
        self.noImageLabel.frame = self.cardFrame.noImageLabelFrame;
        self.noImageLabel.text = titleHtml;
    
        self.noImageSourceLabel.frame = self.cardFrame.noImageSourceLabelFrame;
        self.noImageSourceLabel.text = source;
        
        self.noImageSeperatorLine.frame = self.cardFrame.noImageSeperatorLineFrame;
        
        self.noImageCommentLabel.frame = self.cardFrame.noImageCommentLabelFrame;
        self.noImageCommentLabel.hidden = commentLabelHidden;
        self.noImageCommentLabel.text = commentsCount;
    } else if (card.cardImages.count == 1 || card.cardImages.count == 2) {
        
        NSString *imageURL = [card.cardImages firstObject];
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"单图小图占位图"]];
        
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
        self.titleLabel.text =   titleHtml;
        
        self.iconView.frame = self.cardFrame.singleImageImageViewFrame;
        self.titleLabel.frame = self.cardFrame.singleImageTitleLabelFrame;
        
        self.singleSourceLabel.text = source;
        self.singleSourceLabel.frame = self.cardFrame.singleImageSourceLabelFrame;
    
        self.singleSeperatorLine.frame = self.cardFrame.singleImageSeperatorLineFrame;
        self.singleCommentLabel.frame = self.cardFrame.singelImageCommentLabelFrame;
        self.singleCommentLabel.hidden = commentLabelHidden;
        
        self.singleCommentLabel.text = commentsCount;
        
    } else if (card.cardImages.count >= 3) {
        self.noImageLabel.hidden = YES;
        self.noImageSourceLabel.hidden = YES;
        self.noImageSeperatorLine.hidden = YES;
        
        self.titleLabel.hidden = YES;
        self.iconView.hidden = YES;
        self.singleSourceLabel.hidden = YES;
        self.singleSeperatorLine.hidden = YES;
        
        self.multipleSourceLabel.hidden = NO;
        self.multipleImageLabel.hidden = NO;
        self.firstMutipleImageView.hidden = NO;
        self.secondMutipleImageView.hidden = NO;
        self.thirdMutipleImageView.hidden = NO;
        self.mutipleSeperatorLine.hidden = NO;
    
        self.multipleImageLabel.text =   titleHtml;
        self.multipleImageLabel.frame = self.cardFrame.multipleImageTitleLabelFrame;
   
        
        self.noImageCommentLabel.hidden = YES;
        self.singleCommentLabel.hidden = YES;
        self.mutipleCommentLabel.hidden = NO;
        
        self.multipleSourceLabel.frame = self.cardFrame.multipleImageSourceLabelFrame;
        self.multipleSourceLabel.text = source;
        
        self.mutipleSeperatorLine.frame = self.cardFrame.mutipleImageSeperatorLineFrame;
        
        [self.firstMutipleImageView sd_setImageWithURL:[NSURL URLWithString:card.cardImages[0]] placeholderImage:[UIImage imageNamed:@"单图小图占位图"]];
        [self.secondMutipleImageView sd_setImageWithURL:[NSURL URLWithString:card.cardImages[1]] placeholderImage:[UIImage imageNamed:@"单图小图占位图"]];
        [self.thirdMutipleImageView sd_setImageWithURL:[NSURL URLWithString:card.cardImages[2]] placeholderImage:[UIImage imageNamed:@"单图小图占位图"]];
        
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

//- (void)tapTextView {
//    
//    if ([self.delegate respondsToSelector:@selector(cell:didSelectedCardFrame:)]) {
//        [self.delegate cell:self didSelectedCardFrame:self.cardFrame];
//    }
//}
//


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

@end
