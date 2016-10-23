//
//  LPHomeViewCell.m
//  EveryoneNews
//
//  Created by dongdan on 15/12/16.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPHomeViewCell.h"
#import "UIImageView+WebCache.h"
#import "CardFrame.h"
#import "Card.h"
#import "CardImage.h"
#import "Card+Create.h"

@interface LPHomeViewCell ()
// 无图
@property (nonatomic, strong) UILabel *noImageLabel;

@property (nonatomic, strong) UILabel *noImageSourceLabel;
@property (nonatomic, strong) UILabel *noImageCommentLabel;
@property (nonatomic, strong) UIView *noImageSeperatorLine;
@property (nonatomic, strong) UIButton *noImageDeleteButton;
@property (nonatomic, strong) UIButton *noImageTipButton;
@property (nonatomic, strong) UILabel *noImageNewsTypeLabel;
@property (nonatomic, strong) CAShapeLayer *noImageNewsTypeShapeLayer;

// 单图
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *singleSourceLabel;
@property (nonatomic, strong) UILabel *singleCommentLabel;
@property (nonatomic, strong) UIView *singleSeperatorLine;
@property (nonatomic, strong) UIButton *singleDeleteButton;
@property (nonatomic, strong) UIButton *singleTipButton;
@property (nonatomic, strong) UILabel *singleNewsTypeLabel;
@property (nonatomic, strong) CAShapeLayer *singleNewsTypeShapeLayer;

// 单图大图
@property (nonatomic, strong) UILabel *bigImageTitleLabel;
@property (nonatomic, strong) UIImageView *bigImageIconView;
@property (nonatomic, strong) UILabel *singleBigImageSourceLabel;
@property (nonatomic, strong) UILabel *singleBigImageCommentLabel;
@property (nonatomic, strong) UIView *singleBigImageSeperatorLine;
@property (nonatomic, strong) UIButton *singleBigImageDeleteButton;
@property (nonatomic, strong) UIButton *singleBigImageTipButton;
@property (nonatomic, strong) UILabel *singleBigImageNewsTypeLabel;
@property (nonatomic, strong) CAShapeLayer *singleBigImageNewsTypeShapeLayer;

// 三图
@property (nonatomic, strong) UILabel *multipleImageLabel;
@property (nonatomic, strong) UILabel *mutipleCommentLabel;
@property (nonatomic, strong) UIImageView *firstMutipleImageView;
@property (nonatomic, strong) UIImageView *secondMutipleImageView;
@property (nonatomic, strong) UIImageView *thirdMutipleImageView;
@property (nonatomic, strong) UILabel *multipleSourceLabel;
@property (nonatomic, strong) UIView *mutipleSeperatorLine;
@property (nonatomic, strong) UIButton *mutipleDeleteButton;
@property (nonatomic, strong) UIButton *mutipleTipButton;
@property (nonatomic, strong) UILabel *multipleImageNewsTypeLabel;
@property (nonatomic, strong) CAShapeLayer *multipleImageNewsTypeShapeLayer;

@end

@implementation LPHomeViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6"];
    CGFloat sourceFontSize = 9;
    if (iPhone6Plus) {
        sourceFontSize = 10;
    } else if(iPhone6) {
       sourceFontSize = 9;
    }
    
    NSString *tipString = @"刚刚看到这里，点击刷新";
    CGFloat tipFontSize = LPFont5;
    CGFloat newsTypeCornerRadius = 2;
    NSString *newTypeBoundsColor = LPColor13;
    
    CGFloat interval = 5.0f;
    CGFloat tipLabelTitleWidth = [tipString sizeWithFont:[UIFont systemFontOfSize:tipFontSize] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
    CGFloat tipImageViewWidth = 12.0f;
    
    if(self) {
        // 无图
        UILabel *noImageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        noImageLabel.textColor = [UIColor colorFromHexString:@"#1a1a1a"];
        noImageLabel.numberOfLines = 0;
        [self.contentView addSubview:noImageLabel];
        self.noImageLabel = noImageLabel;
        
        UILabel *noImageSourceLabel = [[UILabel alloc] init];
        noImageSourceLabel.font = [UIFont systemFontOfSize:sourceFontSize];
        noImageSourceLabel.textColor = [UIColor colorFromHexString:@"#999999"];
        [self.contentView addSubview:noImageSourceLabel];
        self.noImageSourceLabel = noImageSourceLabel;
        
        
        UILabel *noImageNewsTypeLabel = [[UILabel alloc] init];
        noImageNewsTypeLabel.font = [UIFont systemFontOfSize:sourceFontSize];
        noImageNewsTypeLabel.textColor = [UIColor colorFromHexString:newTypeBoundsColor];
        noImageNewsTypeLabel.textAlignment = NSTextAlignmentCenter;
        
        
        CAShapeLayer *noImageNewsTypeShapeLayer = [CAShapeLayer layer];
        noImageNewsTypeShapeLayer.cornerRadius = newsTypeCornerRadius;
        noImageNewsTypeShapeLayer.borderColor = [UIColor colorFromHexString:newTypeBoundsColor].CGColor;
        noImageNewsTypeShapeLayer.borderWidth = 0.5f;
        [noImageNewsTypeLabel.layer addSublayer:noImageNewsTypeShapeLayer];
        self.noImageNewsTypeShapeLayer = noImageNewsTypeShapeLayer;
        
        [self.contentView addSubview:noImageNewsTypeLabel];
        self.noImageNewsTypeLabel = noImageNewsTypeLabel;
        
        UILabel *noImageCommentLabel = [[UILabel alloc] init];
        noImageCommentLabel.font = [UIFont systemFontOfSize:sourceFontSize];
        noImageCommentLabel.textColor = [UIColor colorFromHexString:@"#999999"];
        noImageCommentLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:noImageCommentLabel];
        self.noImageCommentLabel = noImageCommentLabel;
        
        UIButton *noImageDeleteButton = [[UIButton alloc] init];
        noImageDeleteButton.userInteractionEnabled = YES;
        noImageDeleteButton.enlargedEdge = 10;
  
        [noImageDeleteButton addTarget:self action:@selector(didClickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:noImageDeleteButton];
        self.noImageDeleteButton = noImageDeleteButton;
        
        UIView *noImageSeperatorLine = [[UIView alloc] init];
        noImageSeperatorLine.backgroundColor = [UIColor colorFromHexString:@"e4e4e4"];
        [self.contentView addSubview:noImageSeperatorLine];
        self.noImageSeperatorLine = noImageSeperatorLine;
        
        UIButton *noImageTipButton = [[UIButton alloc] init];
        noImageTipButton.userInteractionEnabled = YES;
        noImageTipButton.backgroundColor = [UIColor colorFromHexString:@"#e4e4e4"];
        [noImageTipButton setTitle:tipString forState:UIControlStateNormal];
        [noImageTipButton setTitleColor:[UIColor colorFromHexString:@"0091fa"] forState:UIControlStateNormal];
        noImageTipButton.titleLabel.font = [UIFont systemFontOfSize:tipFontSize];
        [noImageTipButton addTarget:self action:@selector(didClickTipButton) forControlEvents:UIControlEventTouchUpInside];
        [noImageTipButton setImage:[UIImage imageNamed:@"上次位置刷新"] forState:UIControlStateNormal];
        noImageTipButton.imageEdgeInsets = UIEdgeInsetsMake(0,tipLabelTitleWidth + interval, 0, -(tipLabelTitleWidth + interval));
        noImageTipButton.titleEdgeInsets = UIEdgeInsetsMake(0, -(tipImageViewWidth + interval), 0, tipImageViewWidth + interval);
        
        [self.contentView addSubview:noImageTipButton];
        self.noImageTipButton = noImageTipButton;
        
        // 单图 （小图）
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.contentMode = UIViewContentModeScaleAspectFill;
        iconView.clipsToBounds = YES;
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.numberOfLines = 0;
        titleLabel.textColor =  [UIColor colorFromHexString:@"#1a1a1a"];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        
        UILabel *singleNewsTypeLabel = [[UILabel alloc] init];
        singleNewsTypeLabel.textAlignment = NSTextAlignmentCenter;
        singleNewsTypeLabel.font = [UIFont systemFontOfSize:sourceFontSize];
        singleNewsTypeLabel.textColor = [UIColor colorFromHexString:newTypeBoundsColor];
        
        CAShapeLayer *singleNewsTypeShapeLayer = [CAShapeLayer layer];
        singleNewsTypeShapeLayer.cornerRadius = newsTypeCornerRadius;
        singleNewsTypeShapeLayer.borderColor = [UIColor colorFromHexString:newTypeBoundsColor].CGColor;
        singleNewsTypeShapeLayer.borderWidth = 0.5f;
        [singleNewsTypeLabel.layer addSublayer:singleNewsTypeShapeLayer];
        self.singleNewsTypeShapeLayer = singleNewsTypeShapeLayer;
        
        [self.contentView addSubview:singleNewsTypeLabel];
        self.singleNewsTypeLabel = singleNewsTypeLabel;
        
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
        
        UIButton *singleDeleteButton = [[UIButton alloc] init];
        singleDeleteButton.userInteractionEnabled = YES;
        singleDeleteButton.enlargedEdge = 10;
        [self.contentView addSubview:singleDeleteButton];
        [singleDeleteButton addTarget:self action:@selector(didClickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        self.singleDeleteButton = singleDeleteButton;
        
        
        UIButton *singleTipButton = [[UIButton alloc] init];
        singleTipButton.userInteractionEnabled = YES;
        singleTipButton.backgroundColor = [UIColor colorFromHexString:@"#e4e4e4"];
        [singleTipButton setTitle:tipString forState:UIControlStateNormal];
        [singleTipButton setTitleColor:[UIColor colorFromHexString:@"0091fa"] forState:UIControlStateNormal];
        singleTipButton.titleLabel.font = [UIFont systemFontOfSize:tipFontSize];
        [singleTipButton addTarget:self action:@selector(didClickTipButton) forControlEvents:UIControlEventTouchUpInside];
        [singleTipButton setImage:[UIImage imageNamed:@"上次位置刷新"] forState:UIControlStateNormal];
        singleTipButton.imageEdgeInsets = UIEdgeInsetsMake(0, tipLabelTitleWidth + interval, 0, -(tipLabelTitleWidth + interval));
        singleTipButton.titleEdgeInsets = UIEdgeInsetsMake(0, -(tipImageViewWidth + interval), 0, tipImageViewWidth + interval);
        [self.contentView addSubview:singleTipButton];
        self.singleTipButton = singleTipButton;

        // 单图 （大图）
        UIImageView *bigImageIconView = [[UIImageView alloc] init];
        bigImageIconView.contentMode = UIViewContentModeScaleAspectFill;
        bigImageIconView.clipsToBounds = YES;
        [self.contentView addSubview:bigImageIconView];
        self.bigImageIconView = bigImageIconView;
        
        UILabel *bigImageTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        bigImageTitleLabel.textColor =  [UIColor colorFromHexString:@"#1a1a1a"];
        bigImageTitleLabel.numberOfLines = 0;
        [self.contentView addSubview:bigImageTitleLabel];
        self.bigImageTitleLabel = bigImageTitleLabel;
        
        
        UILabel *singleBigImageNewsTypeLabel = [[UILabel alloc] init];
        singleBigImageNewsTypeLabel.textAlignment = NSTextAlignmentCenter;
        singleBigImageNewsTypeLabel.font = [UIFont systemFontOfSize:sourceFontSize];
        singleBigImageNewsTypeLabel.textColor = [UIColor colorFromHexString:newTypeBoundsColor];
        
        CAShapeLayer *singleBigImageNewsTypeShapeLayer = [CAShapeLayer layer];
        singleBigImageNewsTypeShapeLayer.cornerRadius = newsTypeCornerRadius;
        singleBigImageNewsTypeShapeLayer.borderColor = [UIColor colorFromHexString:newTypeBoundsColor].CGColor;
        singleBigImageNewsTypeShapeLayer.borderWidth = 0.5f;
        [singleBigImageNewsTypeLabel.layer addSublayer:singleBigImageNewsTypeShapeLayer];
        self.singleBigImageNewsTypeShapeLayer = singleBigImageNewsTypeShapeLayer;
        
        [self.contentView addSubview:singleBigImageNewsTypeLabel];
        self.singleBigImageNewsTypeLabel = singleBigImageNewsTypeLabel;
        
        
        UILabel *singleBigImageSourceLabel = [[UILabel alloc] init];
        singleBigImageSourceLabel.font = [UIFont systemFontOfSize:sourceFontSize];
        singleBigImageSourceLabel.textColor = [UIColor colorFromHexString:@"999999"];
        [self.contentView addSubview:singleBigImageSourceLabel];
        self.singleBigImageSourceLabel= singleBigImageSourceLabel;
        
        
        UILabel *singleBigImageCommentLabel = [[UILabel alloc] init];
        singleBigImageCommentLabel.font = [UIFont systemFontOfSize:sourceFontSize];
        singleBigImageCommentLabel.textColor = [UIColor colorFromHexString:@"999999"];
        singleBigImageCommentLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:singleBigImageCommentLabel];
        self.singleBigImageCommentLabel= singleBigImageCommentLabel;
        
        UIView *singleBigImageSeperatorLine = [[UIView alloc] init];
        singleBigImageSeperatorLine.backgroundColor = [UIColor colorFromHexString:@"e4e4e4"];
        [self.contentView addSubview:singleBigImageSeperatorLine];
        self.singleBigImageSeperatorLine = singleBigImageSeperatorLine;
        
        UIButton *singleBigImageDeleteButton = [[UIButton alloc] init];
        singleBigImageDeleteButton.userInteractionEnabled = YES;
        singleBigImageDeleteButton.enlargedEdge = 10;
        [self.contentView addSubview:singleBigImageDeleteButton];
        [singleBigImageDeleteButton addTarget:self action:@selector(didClickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        self.singleBigImageDeleteButton = singleBigImageDeleteButton;
        
        
        UIButton *singleBigImageTipButton = [[UIButton alloc] init];
        singleBigImageTipButton.userInteractionEnabled = YES;
        singleBigImageTipButton.backgroundColor = [UIColor colorFromHexString:@"#e4e4e4"];
        [singleBigImageTipButton setTitle:tipString forState:UIControlStateNormal];
        [singleBigImageTipButton setTitleColor:[UIColor colorFromHexString:@"0091fa"] forState:UIControlStateNormal];
        singleBigImageTipButton.titleLabel.font = [UIFont systemFontOfSize:tipFontSize];
        [singleBigImageTipButton addTarget:self action:@selector(didClickTipButton) forControlEvents:UIControlEventTouchUpInside];
        [singleBigImageTipButton setImage:[UIImage imageNamed:@"上次位置刷新"] forState:UIControlStateNormal];
        singleBigImageTipButton.imageEdgeInsets = UIEdgeInsetsMake(0, tipLabelTitleWidth + interval, 0, -(tipLabelTitleWidth + interval));
        singleBigImageTipButton.titleEdgeInsets = UIEdgeInsetsMake(0, -(tipImageViewWidth + interval), 0, tipImageViewWidth + interval);
        [self.contentView addSubview:singleBigImageTipButton];
        self.singleBigImageTipButton = singleBigImageTipButton;
        
        //  三图及其三图以上
        UILabel *multipleImageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        multipleImageLabel.numberOfLines = 0;
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
        
        UILabel *multipleImageNewsTypeLabel = [[UILabel alloc] init];
        multipleImageNewsTypeLabel.textAlignment = NSTextAlignmentCenter;
        multipleImageNewsTypeLabel.font = [UIFont systemFontOfSize:sourceFontSize];
        multipleImageNewsTypeLabel.textColor = [UIColor colorFromHexString:newTypeBoundsColor];
        
        CAShapeLayer *multipleImageNewsTypeShapeLayer = [CAShapeLayer layer];
        multipleImageNewsTypeShapeLayer.cornerRadius = newsTypeCornerRadius;
        multipleImageNewsTypeShapeLayer.borderColor = [UIColor colorFromHexString:newTypeBoundsColor].CGColor;
        multipleImageNewsTypeShapeLayer.borderWidth = 0.5f;
        [multipleImageNewsTypeLabel.layer addSublayer:multipleImageNewsTypeShapeLayer];
        self.multipleImageNewsTypeShapeLayer = multipleImageNewsTypeShapeLayer;
        
        [self.contentView addSubview:multipleImageNewsTypeLabel];
        self.multipleImageNewsTypeLabel = multipleImageNewsTypeLabel;
        
        
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
        
        
        UIButton *mutipleDeleteButton = [[UIButton alloc] init];
        mutipleDeleteButton.userInteractionEnabled = YES;
        mutipleDeleteButton.enlargedEdge = 10;
        [self.contentView addSubview:mutipleDeleteButton];
        [mutipleDeleteButton addTarget:self action:@selector(didClickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        self.mutipleDeleteButton = mutipleDeleteButton;
        
        UIButton *mutipleTipButton = [[UIButton alloc] init];
        mutipleTipButton.userInteractionEnabled = YES;
        mutipleTipButton.backgroundColor = [UIColor colorFromHexString:@"#e4e4e4"];
        [mutipleTipButton setTitle:tipString forState:UIControlStateNormal];
        [mutipleTipButton setTitleColor:[UIColor colorFromHexString:@"0091fa"] forState:UIControlStateNormal];
        mutipleTipButton.titleLabel.font = [UIFont systemFontOfSize:tipFontSize];
        [mutipleTipButton setImage:[UIImage imageNamed:@"上次位置刷新"] forState:UIControlStateNormal];
        mutipleTipButton.imageEdgeInsets = UIEdgeInsetsMake(0,tipLabelTitleWidth + interval, 0, -(tipLabelTitleWidth + interval));
        mutipleTipButton.titleEdgeInsets = UIEdgeInsetsMake(0, -(tipImageViewWidth + interval), 0, tipImageViewWidth + interval);

        [mutipleTipButton addTarget:self action:@selector(didClickTipButton) forControlEvents:UIControlEventTouchUpInside];

        [self.contentView addSubview:mutipleTipButton];
        self.mutipleTipButton = mutipleTipButton;
        
        
        UIView *mutipleSeperatorLine = [[UIView alloc] init];
        mutipleSeperatorLine.backgroundColor = [UIColor colorFromHexString:@"e4e4e4"];
        [self.contentView addSubview:mutipleSeperatorLine];
        self.mutipleSeperatorLine = mutipleSeperatorLine;
        
    }
    return self;
}

- (void)setCardFrame:(CardFrame *)cardFrame {
    
    _cardFrame = cardFrame;
    Card *card = cardFrame.card;
    CGFloat lineSpacing = 2.0;
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
    
    NSAttributedString *attributeTitle =  [card.title truncatingTailAttributedStringWithFont:[UIFont systemFontOfSize:self.cardFrame.homeViewFontSize] lineSpacing:lineSpacing];
    
    
    if (card.isRead) {
        self.noImageLabel.textColor = [UIColor grayColor];
        self.titleLabel.textColor = [UIColor grayColor];
        self.bigImageTitleLabel.textColor = [UIColor grayColor];
        self.multipleImageLabel.textColor = [UIColor grayColor];
    } else {
        self.noImageLabel.textColor = [UIColor colorFromHexString:@"#1a1a1a"];
        self.titleLabel.textColor = [UIColor colorFromHexString:@"#1a1a1a"];
        self.bigImageTitleLabel.textColor = [UIColor colorFromHexString:@"#1a1a1a"];
        self.multipleImageLabel.textColor = [UIColor colorFromHexString:@"#1a1a1a"];
    }
    
    
    
    NSString *newsType = @"";
    NSString *newsTypeColor = LPColor2;
    switch ([card.rtype integerValue]) {
        case 1:
            newsType = @"热点";
            newsTypeColor = LPColor13;
            break;
        case 2:
            newsType = @"推送";
            newsTypeColor = LPColor2;
            break;
        case 4:
            newsType = @"专题";
            newsTypeColor = LPColor2;
            break;
        default:
            break;
    }
    CGFloat newsTypeLayerPadding = 1.0f;
    CGFloat newsTypeLayerFixPadding = 0.2f;

    if([card.type integerValue] == imageStyleZero) {
        
        self.noImageLabel.hidden = NO;
        self.noImageSourceLabel.hidden = NO;
        self.noImageSeperatorLine.hidden = NO;
        self.noImageCommentLabel.hidden = NO;
        self.noImageDeleteButton.hidden = NO;
        self.noImageNewsTypeLabel.hidden = NO;
    
        self.titleLabel.hidden = YES;
        self.iconView.hidden = YES;
        self.singleSourceLabel.hidden = YES;
        self.singleSeperatorLine.hidden = YES;
        self.singleCommentLabel.hidden = YES;
        self.singleDeleteButton.hidden = YES;
        self.singleTipButton.hidden = YES;
        self.singleNewsTypeLabel.hidden = YES;
        
        self.bigImageTitleLabel.hidden = YES;
        self.bigImageIconView.hidden = YES;
        self.singleBigImageSourceLabel.hidden = YES;
        self.singleBigImageSeperatorLine.hidden = YES;
        self.singleBigImageCommentLabel.hidden = YES;
        self.singleBigImageDeleteButton.hidden = YES;
        self.singleBigImageTipButton.hidden = YES;
        self.singleBigImageNewsTypeLabel.hidden = YES;
      
        self.multipleImageLabel.hidden = YES;
        self.firstMutipleImageView.hidden = YES;
        self.secondMutipleImageView.hidden = YES;
        self.thirdMutipleImageView.hidden = YES;
        self.multipleSourceLabel.hidden = YES;
        self.mutipleSeperatorLine.hidden = YES;
        self.mutipleDeleteButton.hidden = YES;
        self.mutipleCommentLabel.hidden = YES;
        self.mutipleTipButton.hidden = YES;
        self.multipleImageNewsTypeLabel.hidden = YES;
        
        self.noImageLabel.frame = self.cardFrame.noImageLabelFrame;
        
        self.noImageLabel.attributedText = attributeTitle;
        
        self.noImageNewsTypeLabel.frame = self.cardFrame.noImageNewsTypeLabelFrame;
        self.noImageNewsTypeLabel.text = newsType;
        self.noImageNewsTypeLabel.textColor = [UIColor colorFromHexString:newsTypeColor];
        
        CGFloat newsTypeShapeLayerH = self.noImageNewsTypeLabel.bounds.size.height  - newsTypeLayerPadding;
        CGFloat newsTypeShapeLayerY = newsTypeLayerPadding / 2 + newsTypeLayerFixPadding;
        CGFloat newsTypeShapeLayerW = self.noImageNewsTypeLabel.bounds.size.width;
        self.noImageNewsTypeShapeLayer.frame = CGRectMake(0, newsTypeShapeLayerY, newsTypeShapeLayerW, newsTypeShapeLayerH);
        self.noImageNewsTypeShapeLayer.borderColor = [UIColor colorFromHexString:newsTypeColor].CGColor;
    
        self.noImageSourceLabel.frame = self.cardFrame.noImageSourceLabelFrame;
        self.noImageSourceLabel.text = source;
        
        self.noImageSeperatorLine.frame = self.cardFrame.noImageSeperatorLineFrame;
        
        [self.noImageDeleteButton setBackgroundImage:[UIImage imageNamed:@"不感兴趣叉号"] forState:UIControlStateNormal];
        self.noImageDeleteButton.frame = self.cardFrame.noImageDeleteButtonFrame;
        self.noImageCommentLabel.frame = self.cardFrame.noImageCommentLabelFrame;
        self.noImageCommentLabel.hidden = commentLabelHidden;
        
        self.noImageCommentLabel.text = commentsCount;
        
        self.noImageTipButton.frame = self.cardFrame.noImageTipButtonFrame;
        self.noImageTipButton.hidden = self.cardFrame.isTipButtonHidden;
      
      
        
    } else if ([card.type integerValue] == imageStyleOne || [card.type integerValue] == imageStyleTwo) {
        CardImage * cardImage = [card.cardImages firstObject];
        NSString *imageURL = [self scaleImageURL:cardImage.imgUrl];
        
       [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"单图小图占位图"]];
        
        self.noImageLabel.hidden = YES;
        self.noImageSourceLabel.hidden = YES;
        self.noImageSeperatorLine.hidden = YES;
        self.noImageCommentLabel.hidden = YES;
        self.noImageDeleteButton.hidden = YES;
        self.noImageTipButton.hidden = YES;
        self.noImageNewsTypeLabel.hidden = YES;
        
        self.titleLabel.hidden = NO;
        self.iconView.hidden = NO;
        self.singleSourceLabel.hidden = NO;
        self.singleSeperatorLine.hidden = NO;
        self.singleCommentLabel.hidden = NO;
        self.singleDeleteButton.hidden = NO;
        self.singleTipButton.hidden = NO;
        self.singleNewsTypeLabel.hidden = NO;
        
        self.bigImageTitleLabel.hidden = YES;
        self.bigImageIconView.hidden = YES;
        self.singleBigImageSourceLabel.hidden = YES;
        self.singleBigImageSeperatorLine.hidden = YES;
        self.singleBigImageCommentLabel.hidden = YES;
        self.singleBigImageDeleteButton.hidden = YES;
        self.singleBigImageTipButton.hidden = YES;
        self.singleBigImageNewsTypeLabel.hidden = YES;
        
        self.multipleImageLabel.hidden = YES;
        self.firstMutipleImageView.hidden = YES;
        self.secondMutipleImageView.hidden = YES;
        self.thirdMutipleImageView.hidden = YES;
        self.multipleSourceLabel.hidden = YES;
        self.mutipleSeperatorLine.hidden = YES;
        self.mutipleDeleteButton.hidden = YES;
        self.mutipleCommentLabel.hidden = YES;
        self.mutipleTipButton.hidden = YES;
        self.multipleImageNewsTypeLabel.hidden = YES;
    
        self.iconView.frame = self.cardFrame.singleImageImageViewFrame;
        self.titleLabel.frame = self.cardFrame.singleImageTitleLabelFrame;
        self.titleLabel.attributedText =  attributeTitle;
        
        self.singleSourceLabel.text = source;
        self.singleSourceLabel.frame = self.cardFrame.singleImageSourceLabelFrame;
        
        self.singleNewsTypeLabel.frame = self.cardFrame.singleNewsTypeLabelFrame;
        self.singleNewsTypeLabel.text = newsType;
        self.singleNewsTypeLabel.textColor = [UIColor colorFromHexString:newsTypeColor];
        
        CGFloat newsTypeShapeLayerH = self.singleNewsTypeLabel.bounds.size.height  - newsTypeLayerPadding;
        CGFloat newsTypeShapeLayerY = newsTypeLayerPadding / 2 + newsTypeLayerFixPadding;
        CGFloat newsTypeShapeLayerW = self.singleNewsTypeLabel.bounds.size.width;
        self.singleNewsTypeShapeLayer.frame = CGRectMake(0, newsTypeShapeLayerY, newsTypeShapeLayerW, newsTypeShapeLayerH);
        self.singleNewsTypeShapeLayer.borderColor = [UIColor colorFromHexString:newsTypeColor].CGColor;
        
        [self.singleDeleteButton setBackgroundImage:[UIImage imageNamed:@"不感兴趣叉号"] forState:UIControlStateNormal];
        self.singleDeleteButton.frame = self.cardFrame.singleImageDeleteButtonFrame;
        
        self.singleSeperatorLine.frame = self.cardFrame.singleImageSeperatorLineFrame;
        self.singleCommentLabel.frame = self.cardFrame.singelImageCommentLabelFrame;
        self.singleCommentLabel.hidden = commentLabelHidden;
        
        self.singleCommentLabel.text = commentsCount;
        
        self.singleTipButton.frame = self.cardFrame.singleTipButtonFrame;
        self.singleTipButton.hidden = self.cardFrame.isTipButtonHidden;
  
        
    } else if ([card.type integerValue] == imageStyleEleven || [card.type integerValue] == imageStyleTwelve || [card.type integerValue] == imageStyleThirteen) {
        CardImage * cardImage = nil;
        switch ([card.type integerValue]) {
            case imageStyleEleven:
                cardImage = [card.cardImages objectAtIndex:0];
                break;
            case imageStyleTwelve:
                cardImage =  [card.cardImages objectAtIndex:1];
                break;
            case imageStyleThirteen:
                cardImage = [card.cardImages objectAtIndex:2];
                break;
            default:
                break;
        }
        
        NSString *imageURL = [self scaleBigImageURL:cardImage.imgUrl];
        
        [self.bigImageIconView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"单图大图占位图"]];
        
        self.noImageLabel.hidden = YES;
        self.noImageSourceLabel.hidden = YES;
        self.noImageSeperatorLine.hidden = YES;
        self.noImageCommentLabel.hidden = YES;
        self.noImageDeleteButton.hidden = YES;
        self.noImageTipButton.hidden = YES;
        self.noImageNewsTypeLabel.hidden = YES;
        
        self.titleLabel.hidden = YES;
        self.iconView.hidden = YES;
        self.singleSourceLabel.hidden = YES;
        self.singleSeperatorLine.hidden = YES;
        self.singleCommentLabel.hidden = YES;
        self.singleDeleteButton.hidden = YES;
        self.singleTipButton.hidden = YES;
        self.singleNewsTypeLabel.hidden = YES;
        
        self.bigImageTitleLabel.hidden = NO;
        self.bigImageIconView.hidden = NO;
        self.singleBigImageSourceLabel.hidden = NO;
        self.singleBigImageSeperatorLine.hidden = NO;
        self.singleBigImageCommentLabel.hidden = NO;
        self.singleBigImageDeleteButton.hidden = NO;
        self.singleBigImageTipButton.hidden = NO;
        self.singleBigImageNewsTypeLabel.hidden = NO;
        
        self.multipleImageLabel.hidden = YES;
        self.firstMutipleImageView.hidden = YES;
        self.secondMutipleImageView.hidden = YES;
        self.thirdMutipleImageView.hidden = YES;
        self.multipleSourceLabel.hidden = YES;
        self.mutipleSeperatorLine.hidden = YES;
        self.mutipleDeleteButton.hidden = YES;
        self.mutipleCommentLabel.hidden = YES;
        self.mutipleTipButton.hidden = YES;
        self.multipleImageNewsTypeLabel.hidden = YES;
        
        
        self.bigImageTitleLabel.attributedText =  attributeTitle;
        
        self.bigImageIconView.frame = self.cardFrame.singleBigImageImageViewFrame;
        self.bigImageTitleLabel.frame = self.cardFrame.singleBigImageTitleLabelFrame;
        
        self.singleBigImageNewsTypeLabel.frame = self.cardFrame.singleBigImageNewsTyeLabelFrame;
        self.singleBigImageNewsTypeLabel.text = newsType;
        self.singleBigImageNewsTypeLabel.textColor = [UIColor colorFromHexString:newsTypeColor];
        
        CGFloat newsTypeShapeLayerH = self.singleBigImageNewsTypeLabel.bounds.size.height  - newsTypeLayerPadding;
        CGFloat newsTypeShapeLayerY = newsTypeLayerPadding / 2 + newsTypeLayerFixPadding;
        CGFloat newsTypeShapeLayerW = self.singleBigImageNewsTypeLabel.bounds.size.width;
        self.singleBigImageNewsTypeShapeLayer.frame = CGRectMake(0, newsTypeShapeLayerY, newsTypeShapeLayerW, newsTypeShapeLayerH);
        
        self.singleBigImageNewsTypeShapeLayer.borderColor = [UIColor colorFromHexString:newsTypeColor].CGColor;
        
        
        self.singleBigImageSourceLabel.text = source;
        self.singleBigImageSourceLabel.frame = self.cardFrame.singleBigImageSourceLabelFrame;
        
        [self.singleBigImageDeleteButton setBackgroundImage:[UIImage imageNamed:@"不感兴趣叉号"] forState:UIControlStateNormal];
        self.singleBigImageDeleteButton.frame = self.cardFrame.singleBigImageDeleteButtonFrame;
        
        self.singleBigImageSeperatorLine.frame = self.cardFrame.singleBigImageSeperatorLineFrame;
        self.singleBigImageCommentLabel.frame = self.cardFrame.singelBigImageCommentLabelFrame;
        self.singleBigImageCommentLabel.hidden = commentLabelHidden;
        
        self.singleBigImageCommentLabel.text = commentsCount;
        
        self.singleBigImageTipButton.frame = self.cardFrame.singleBigTipButtonFrame;
        self.singleBigImageTipButton.hidden = self.cardFrame.isTipButtonHidden;
  
        
        
    }
    else if ([card.type integerValue] == imageStyleThree) {
        
        self.noImageLabel.hidden = YES;
        self.noImageSourceLabel.hidden = YES;
        self.noImageSeperatorLine.hidden = YES;
        self.noImageCommentLabel.hidden = YES;
        self.noImageDeleteButton.hidden = YES;
        self.noImageTipButton.hidden = YES;
        self.noImageNewsTypeLabel.hidden = YES;
    
        self.titleLabel.hidden = YES;
        self.iconView.hidden = YES;
        self.singleSourceLabel.hidden = YES;
        self.singleSeperatorLine.hidden = YES;
        self.singleCommentLabel.hidden = YES;
        self.singleDeleteButton.hidden = YES;
        self.singleTipButton.hidden = YES;
        self.singleNewsTypeLabel.hidden = YES;
        
        self.bigImageTitleLabel.hidden = YES;
        self.bigImageIconView.hidden = YES;
        self.singleBigImageSourceLabel.hidden = YES;
        self.singleBigImageSeperatorLine.hidden = YES;
        self.singleBigImageCommentLabel.hidden = YES;
        self.singleBigImageDeleteButton.hidden = YES;
        self.singleBigImageTipButton.hidden = YES;
        self.singleBigImageNewsTypeLabel.hidden = YES;
        
        self.multipleImageLabel.hidden = NO;
        self.firstMutipleImageView.hidden = NO;
        self.secondMutipleImageView.hidden = NO;
        self.thirdMutipleImageView.hidden = NO;
        self.multipleSourceLabel.hidden = NO;
        self.mutipleSeperatorLine.hidden = NO;
        self.mutipleDeleteButton.hidden = NO;
        self.mutipleCommentLabel.hidden = NO;
        self.mutipleTipButton.hidden = NO;
        self.multipleImageNewsTypeLabel.hidden = NO;
  
        
        self.multipleImageLabel.frame = self.cardFrame.multipleImageTitleLabelFrame;
        self.multipleImageLabel.attributedText =  attributeTitle;
        
        self.multipleImageNewsTypeLabel.frame = self.cardFrame.multipleImageNewsTypeLabelFrame;
        self.multipleImageNewsTypeLabel.text = newsType;
        self.multipleImageNewsTypeLabel.textColor = [UIColor colorFromHexString:newsTypeColor];
        
        CGFloat newsTypeShapeLayerH = self.multipleImageNewsTypeLabel.bounds.size.height  - newsTypeLayerPadding;
        CGFloat newsTypeShapeLayerY = newsTypeLayerPadding / 2 + newsTypeLayerFixPadding;
        CGFloat newsTypeShapeLayerW = self.multipleImageNewsTypeLabel.bounds.size.width;
        self.multipleImageNewsTypeShapeLayer.frame = CGRectMake(0, newsTypeShapeLayerY, newsTypeShapeLayerW, newsTypeShapeLayerH);
        
        self.multipleImageNewsTypeShapeLayer.borderColor = [UIColor colorFromHexString:newsTypeColor].CGColor;
        
        self.multipleSourceLabel.frame = self.cardFrame.multipleImageSourceLabelFrame;
        self.multipleSourceLabel.text = source;
        
        self.mutipleSeperatorLine.frame = self.cardFrame.mutipleImageSeperatorLineFrame;
        
        CGRect frame = self.cardFrame.multipleImageViewFrame;
        CGFloat x = frame.origin.x;
        CGFloat y = frame.origin.y;
        CGFloat w = (frame.size.width - 6) / 3 ;
        CGFloat h = frame.size.height;
        
        NSString *firstImageURL = [card.cardImages objectAtIndex:0].imgUrl;
        NSString *secondImageURL = [card.cardImages objectAtIndex:1].imgUrl;
        NSString *thirdImageURL = [card.cardImages objectAtIndex:2].imgUrl;
     
        [self.firstMutipleImageView sd_setImageWithURL:[NSURL URLWithString:firstImageURL] placeholderImage:[UIImage imageNamed:@"单图小图占位图"]];
        [self.secondMutipleImageView sd_setImageWithURL:[NSURL URLWithString:secondImageURL] placeholderImage:[UIImage imageNamed:@"单图小图占位图"]];
        [self.thirdMutipleImageView sd_setImageWithURL:[NSURL URLWithString:thirdImageURL] placeholderImage:[UIImage imageNamed:@"单图小图占位图"]];
        

        self.firstMutipleImageView.frame = CGRectMake(x, y, w, h);
        self.secondMutipleImageView.frame = CGRectMake(x + w + 3, y, w, h);
        self.thirdMutipleImageView.frame = CGRectMake(x + 2 * w + 6, y, w, h);
        
        [self.mutipleDeleteButton setBackgroundImage:[UIImage imageNamed:@"不感兴趣叉号"] forState:UIControlStateNormal];
        self.mutipleDeleteButton.frame = self.cardFrame.mutipleImageDeleteButtonFrame;
        self.mutipleCommentLabel.frame = self.cardFrame.mutipleImageCommentLabelFrame;
        self.mutipleCommentLabel.hidden = commentLabelHidden;
        self.mutipleCommentLabel.text = commentsCount;
        
        self.mutipleTipButton.frame = self.cardFrame.mutipleTipButtonFrame;
        self.mutipleTipButton.hidden = self.cardFrame.isTipButtonHidden;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
}

#pragma mark - 首页删除功能
- (void)didClickDeleteButton:(UIButton *)deleteButton {
    if (self.didClickDeleteBlock) {
        self.didClickDeleteBlock(deleteButton);
    }
}

- (void)didClickDeleteButtonBlock:(didClickDeleteButtonBlock)didClickDeleteButtonBlock {
    self.didClickDeleteBlock = didClickDeleteButtonBlock;
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


#pragma mark - 大图缩放处理
- (NSString *)scaleBigImageURL:(NSString *)imageURL {
    NSRange range = [imageURL rangeOfString:@"/" options:NSBackwardsSearch];
    NSString *substring = [imageURL substringFromIndex:range.location+1];
    NSString *scaleImageURL = [NSString stringWithFormat:@"http://pro-pic.deeporiginalx.com/%@@1e_1c_0o_0l_100sh_400h_600w_100q.src", substring];
    return scaleImageURL;
}

#pragma mark - 小图缩放处理
- (NSString *)scaleImageURL:(NSString *)imageURL {
    NSRange range = [imageURL rangeOfString:@"/" options:NSBackwardsSearch];
    NSString *substring = [imageURL substringFromIndex:range.location + 1];
    NSString *scaleImageURL = [NSString stringWithFormat:@"http://pro-pic.deeporiginalx.com/%@@1e_1c_0o_0l_100sh_200h_300w_100q.src", substring];
    return scaleImageURL;
}

@end
