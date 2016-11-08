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
@property (nonatomic, strong) UILabel *noImageTitleLabel;
@property (nonatomic, strong) UIImageView *noImageSourceImageView;
@property (nonatomic, strong) UILabel *noImageSourceLabel;
@property (nonatomic, strong) UIButton *noImageDeleteButton;
@property (nonatomic, strong) UIButton *noImageTipButton;
@property (nonatomic, strong) UILabel *noImageNewsTypeLabel;
@property (nonatomic, strong) UIView *noImageSeperatorLine;
@property (nonatomic, strong) UILabel *noImageCommentsCountLabel;

// 单图
@property (nonatomic, strong) UILabel *singleImageTitleLabel;
@property (nonatomic, strong) UIImageView *singleImageSourceImageView;
@property (nonatomic, strong) UILabel *singleImageSourceLabel;
@property (nonatomic, strong) UIImageView *singleImageIcon;
@property (nonatomic, strong) UIView *singleImageSeperatorLine;
@property (nonatomic, strong) UIButton *singleImageDeleteButton;
@property (nonatomic, strong) UIButton *singleImageTipButton;
@property (nonatomic, strong) UILabel *singleImageNewsTypeLabel;
@property (nonatomic, strong) UILabel *singleImageCommentsCountLabel;

// 单图大图
@property (nonatomic, strong) UILabel *singleBigImageTitleLabel;
@property (nonatomic, strong) UIImageView *singleBigImageIcon;
@property (nonatomic, strong) UIImageView *singleBigImageSourceImageView;
@property (nonatomic, strong) UILabel *singleBigImageSourceLabel;
@property (nonatomic, strong) UIView *singleBigImageSeperatorLine;
@property (nonatomic, strong) UIButton *singleBigImageDeleteButton;
@property (nonatomic, strong) UIButton *singleBigImageTipButton;
@property (nonatomic, strong) UILabel *singleBigImageNewsTypeLabel;
@property (nonatomic, strong) UILabel *singleBigImageCommentsCountLabel;

// 三图
@property (nonatomic, strong) UILabel *multipleImageTitleLabel;
@property (nonatomic, strong) UIImageView *firstMultipleImageView;
@property (nonatomic, strong) UIImageView *secondMultipleImageView;
@property (nonatomic, strong) UIImageView *thirdMultipleImageView;
@property (nonatomic, strong) UIImageView *multipleImageSourceImageView;
@property (nonatomic, strong) UILabel *multipleImageSourceLabel;
@property (nonatomic, strong) UIView *multipleImageSeperatorLine;
@property (nonatomic, strong) UIButton *multipleImageDeleteButton;
@property (nonatomic, strong) UIButton *multipleImageTipButton;
@property (nonatomic, strong) UILabel *multipleImageNewsTypeLabel;
@property (nonatomic, strong) UILabel *multipleImageCommentsCountLabel;

// 专题
@property (nonatomic, strong) UIView *specailTopicOutsideView;
@property (nonatomic, strong) UIView *specialTopicInsideView;
@property (nonatomic, strong) UIImageView *specialTopicLogo;
@property (nonatomic, strong) UILabel *specialTopicTitleLabel;
@property (nonatomic, strong) UIButton *specialTopicTipButton;
@property (nonatomic, strong) UIButton *specialTopicDeleteButton;
@property (nonatomic, strong) UIImageView *specialTopicImageView;
@property (nonatomic, strong) UILabel *specialTopicCommentsCountLabel;

@end

@implementation LPHomeViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor whiteColor];
    
    // 来源字体大小
    CGFloat sourceFontSize = 13;
    // 来源字体颜色
    NSString *sourceColor = @"#837c78";
    
    NSString *tipString = @"刚刚看到这里，点击刷新";
    NSString *tipColor = LPColor15;
    NSString *seperatorColor = LPColor16;
    NSString *commentsColor = LPColor22;
    
    CGFloat newsTypeCornerRadius = 7.0f;
    
    CGFloat tipFontSize = LPFont5;
    CGFloat newsTypeFontSize = LPFont6;
    CGFloat commentsFontSize = LPFont11;
    CGFloat interval = 5.0f;
    CGFloat tipLabelTitleWidth = [tipString sizeWithFont:[UIFont systemFontOfSize:tipFontSize] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
    CGFloat tipImageViewWidth = 12.0f;
    
    if(self) {
        
        // --------------- 无图 ---------------
        UILabel *noImageTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        noImageTitleLabel.numberOfLines = 0;
        [self.contentView addSubview:noImageTitleLabel];
        self.noImageTitleLabel = noImageTitleLabel;
        
        // 来源图标
        UIImageView *noImageSourceImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:noImageSourceImageView];
        self.noImageSourceImageView = noImageSourceImageView;
        
        // 新闻来源
        UILabel *noImageSourceLabel = [[UILabel alloc] init];
        noImageSourceLabel.font = [UIFont systemFontOfSize:sourceFontSize];
        noImageSourceLabel.textColor = [UIColor colorFromHexString:sourceColor];
        [self.contentView addSubview:noImageSourceLabel];
        self.noImageSourceLabel = noImageSourceLabel;
        
        // 新闻类型
        UILabel *noImageNewsTypeLabel =  [[UILabel alloc] init];
        noImageNewsTypeLabel.textColor = [UIColor whiteColor];
        noImageNewsTypeLabel.font = [UIFont systemFontOfSize:newsTypeFontSize];
        noImageNewsTypeLabel.textAlignment = NSTextAlignmentCenter;
        noImageNewsTypeLabel.layer.cornerRadius = newsTypeCornerRadius;
        noImageNewsTypeLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:noImageNewsTypeLabel];
        self.noImageNewsTypeLabel = noImageNewsTypeLabel;
        
        UILabel *noImageCommentsCountLabel = [[UILabel alloc] init];
        noImageCommentsCountLabel.textColor = [UIColor colorFromHexString:commentsColor];
        noImageCommentsCountLabel.font = [UIFont systemFontOfSize:commentsFontSize];
        [self.contentView addSubview:noImageCommentsCountLabel];
        self.noImageCommentsCountLabel = noImageCommentsCountLabel;
        // 删除按钮
        UIButton *noImageDeleteButton = [[UIButton alloc] init];
        noImageDeleteButton.userInteractionEnabled = YES;
        noImageDeleteButton.enlargedEdge = 10;
        [noImageDeleteButton addTarget:self action:@selector(didClickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:noImageDeleteButton];
        self.noImageDeleteButton = noImageDeleteButton;
        
        // 分割线
        UIView *noImageSeperatorLine = [[UIView alloc] init];
        noImageSeperatorLine.backgroundColor = [UIColor colorFromHexString:seperatorColor];
        [self.contentView addSubview:noImageSeperatorLine];
        self.noImageSeperatorLine = noImageSeperatorLine;
        
        // 上次位置提示
        UIButton *noImageTipButton = [[UIButton alloc] init];
        noImageTipButton.userInteractionEnabled = YES;
        noImageTipButton.backgroundColor = [UIColor colorFromHexString:seperatorColor];
        [noImageTipButton setTitle:tipString forState:UIControlStateNormal];
        [noImageTipButton setTitleColor:[UIColor colorFromHexString:tipColor] forState:UIControlStateNormal];
        noImageTipButton.titleLabel.font = [UIFont systemFontOfSize:tipFontSize];
        [noImageTipButton addTarget:self action:@selector(didClickTipButton) forControlEvents:UIControlEventTouchUpInside];
        [noImageTipButton setImage:[UIImage imageNamed:@"上次位置刷新"] forState:UIControlStateNormal];
        noImageTipButton.imageEdgeInsets = UIEdgeInsetsMake(0,tipLabelTitleWidth + interval, 0, -(tipLabelTitleWidth + interval));
        noImageTipButton.titleEdgeInsets = UIEdgeInsetsMake(0, -(tipImageViewWidth + interval), 0, tipImageViewWidth + interval);
        
        [self.contentView addSubview:noImageTipButton];
        self.noImageTipButton = noImageTipButton;
        
        // ---------------  单图 （小图）-------------------
        // 来源图标
        UIImageView *singleImageSourceImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:singleImageSourceImageView];
        self.singleImageSourceImageView = singleImageSourceImageView;
        
        // 新闻来源
        UILabel *singleImageSourceLabel = [[UILabel alloc] init];
        singleImageSourceLabel.font = [UIFont systemFontOfSize:sourceFontSize];
        singleImageSourceLabel.textColor = [UIColor colorFromHexString:sourceColor];
        [self.contentView addSubview:singleImageSourceLabel];
        self.singleImageSourceLabel= singleImageSourceLabel;
        
        UILabel *singleImageCommentsCountLabel = [[UILabel alloc] init];
        singleImageCommentsCountLabel.textColor = [UIColor colorFromHexString:commentsColor];
        singleImageCommentsCountLabel.font = [UIFont systemFontOfSize:commentsFontSize];
        [self.contentView addSubview:singleImageCommentsCountLabel];
        self.singleImageCommentsCountLabel = singleImageCommentsCountLabel;
        
        UIButton *singleImageDeleteButton = [[UIButton alloc] init];
        singleImageDeleteButton.userInteractionEnabled = YES;
        singleImageDeleteButton.enlargedEdge = 10;
        [self.contentView addSubview:singleImageDeleteButton];
        [singleImageDeleteButton addTarget:self action:@selector(didClickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        self.singleImageDeleteButton = singleImageDeleteButton;
        
        UILabel *singleImageTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        singleImageTitleLabel.numberOfLines = 0;
        [self.contentView addSubview:singleImageTitleLabel];
        self.singleImageTitleLabel = singleImageTitleLabel;
        

        // 类型
        UILabel *singleImageNewsTypeLabel = [[UILabel alloc] init];
        singleImageNewsTypeLabel.textColor = [UIColor whiteColor];
        singleImageNewsTypeLabel.textAlignment = NSTextAlignmentCenter;
        singleImageNewsTypeLabel.font = [UIFont systemFontOfSize:newsTypeFontSize];
        singleImageNewsTypeLabel.layer.cornerRadius = newsTypeCornerRadius;
        singleImageNewsTypeLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:singleImageNewsTypeLabel];
        self.singleImageNewsTypeLabel = singleImageNewsTypeLabel;
        
        UIImageView *singleImageIcon = [[UIImageView alloc] init];
        singleImageIcon.contentMode = UIViewContentModeScaleAspectFill;
        singleImageIcon.clipsToBounds = YES;
        [self.contentView addSubview:singleImageIcon];
        self.singleImageIcon = singleImageIcon;
        
        UIView *singleImageSeperatorLine = [[UIView alloc] init];
        singleImageSeperatorLine.backgroundColor = [UIColor colorFromHexString:seperatorColor];
        [self.contentView addSubview:singleImageSeperatorLine];
        self.singleImageSeperatorLine = singleImageSeperatorLine;

        UIButton *singleImageTipButton = [[UIButton alloc] init];
        singleImageTipButton.userInteractionEnabled = YES;
        singleImageTipButton.backgroundColor = [UIColor colorFromHexString:seperatorColor];
        [singleImageTipButton setTitle:tipString forState:UIControlStateNormal];
        [singleImageTipButton setTitleColor:[UIColor colorFromHexString:tipColor] forState:UIControlStateNormal];
        singleImageTipButton.titleLabel.font = [UIFont systemFontOfSize:tipFontSize];
        [singleImageTipButton addTarget:self action:@selector(didClickTipButton) forControlEvents:UIControlEventTouchUpInside];
        [singleImageTipButton setImage:[UIImage imageNamed:@"上次位置刷新"] forState:UIControlStateNormal];
        singleImageTipButton.imageEdgeInsets = UIEdgeInsetsMake(0, tipLabelTitleWidth + interval, 0, -(tipLabelTitleWidth + interval));
        singleImageTipButton.titleEdgeInsets = UIEdgeInsetsMake(0, -(tipImageViewWidth + interval), 0, tipImageViewWidth + interval);
        [self.contentView addSubview:singleImageTipButton];
        self.singleImageTipButton = singleImageTipButton;
        
        // ------------------ 单图 （大图）----------------------
        UIImageView *singleBigImageSourceImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:singleBigImageSourceImageView];
        self.singleBigImageSourceImageView = singleBigImageSourceImageView;
        
        UILabel *singleBigImageSourceLabel = [[UILabel alloc] init];
        singleBigImageSourceLabel.font = [UIFont systemFontOfSize:sourceFontSize];
        singleBigImageSourceLabel.textColor = [UIColor colorFromHexString:sourceColor];
        [self.contentView addSubview:singleBigImageSourceLabel];
        self.singleBigImageSourceLabel= singleBigImageSourceLabel;
        
        
        UILabel *singleBigImageCommentsCountLabel = [[UILabel alloc] init];
        singleBigImageCommentsCountLabel.textColor = [UIColor colorFromHexString:commentsColor];
        singleBigImageCommentsCountLabel.font = [UIFont systemFontOfSize:commentsFontSize];
        [self.contentView addSubview:singleBigImageCommentsCountLabel];
        self.singleBigImageCommentsCountLabel = singleBigImageCommentsCountLabel;
        
        UIButton *singleBigImageDeleteButton = [[UIButton alloc] init];
        singleBigImageDeleteButton.userInteractionEnabled = YES;
        singleBigImageDeleteButton.enlargedEdge = 10;
        [self.contentView addSubview:singleBigImageDeleteButton];
        [singleBigImageDeleteButton addTarget:self action:@selector(didClickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        self.singleBigImageDeleteButton = singleBigImageDeleteButton;
        
        UILabel *singleBigImageTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        singleBigImageTitleLabel.textColor =  [UIColor colorFromHexString:@"#1a1a1a"];
        singleBigImageTitleLabel.numberOfLines = 0;
        [self.contentView addSubview:singleBigImageTitleLabel];
        self.singleBigImageTitleLabel = singleBigImageTitleLabel;
        
        UIImageView *singleBigImageIcon = [[UIImageView alloc] init];
        singleBigImageIcon.contentMode = UIViewContentModeScaleAspectFill;
        singleBigImageIcon.clipsToBounds = YES;
        [self.contentView addSubview:singleBigImageIcon];
        self.singleBigImageIcon = singleBigImageIcon;
        
        UIView *singleBigImageSeperatorLine = [[UIView alloc] init];
        singleBigImageSeperatorLine.backgroundColor = [UIColor colorFromHexString:seperatorColor];
        [self.contentView addSubview:singleBigImageSeperatorLine];
        self.singleBigImageSeperatorLine = singleBigImageSeperatorLine;
        
        UIButton *singleBigImageTipButton = [[UIButton alloc] init];
        singleBigImageTipButton.userInteractionEnabled = YES;
        singleBigImageTipButton.backgroundColor = [UIColor colorFromHexString:seperatorColor];
        [singleBigImageTipButton setTitle:tipString forState:UIControlStateNormal];
        [singleBigImageTipButton setTitleColor:[UIColor colorFromHexString:tipColor] forState:UIControlStateNormal];
        singleBigImageTipButton.titleLabel.font = [UIFont systemFontOfSize:tipFontSize];
        [singleBigImageTipButton addTarget:self action:@selector(didClickTipButton) forControlEvents:UIControlEventTouchUpInside];
        [singleBigImageTipButton setImage:[UIImage imageNamed:@"上次位置刷新"] forState:UIControlStateNormal];
        singleBigImageTipButton.imageEdgeInsets = UIEdgeInsetsMake(0, tipLabelTitleWidth + interval, 0, -(tipLabelTitleWidth + interval));
        singleBigImageTipButton.titleEdgeInsets = UIEdgeInsetsMake(0, -(tipImageViewWidth + interval), 0, tipImageViewWidth + interval);
        [self.contentView addSubview:singleBigImageTipButton];
        self.singleBigImageTipButton = singleBigImageTipButton;
        
        // 类型
        UILabel *singleBigImageNewsTypeLabel = [[UILabel alloc] init];
        singleBigImageNewsTypeLabel.textColor = [UIColor whiteColor];
        singleBigImageNewsTypeLabel.font = [UIFont systemFontOfSize:newsTypeFontSize];
        singleBigImageNewsTypeLabel.textAlignment = NSTextAlignmentCenter;
        singleBigImageNewsTypeLabel.layer.cornerRadius = newsTypeCornerRadius;
        singleBigImageNewsTypeLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:singleBigImageNewsTypeLabel];
        self.singleBigImageNewsTypeLabel = singleBigImageNewsTypeLabel;
    
        //  ---------------- 三图及其三图以上 ----------------------
        UIImageView *multipleImageSourceImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:multipleImageSourceImageView];
        self.multipleImageSourceImageView = multipleImageSourceImageView;
        
        UILabel *multipleImageSourceLabel = [[UILabel alloc] init];
        multipleImageSourceLabel.font = [UIFont systemFontOfSize:sourceFontSize];
        multipleImageSourceLabel.textColor = [UIColor colorFromHexString:sourceColor];
        [self.contentView addSubview:multipleImageSourceLabel];
        self.multipleImageSourceLabel = multipleImageSourceLabel;
        
        UILabel *multipleImageCommentsCountLabel = [[UILabel alloc] init];
        multipleImageCommentsCountLabel.textColor = [UIColor colorFromHexString:commentsColor];
        multipleImageCommentsCountLabel.font = [UIFont systemFontOfSize:commentsFontSize];
        [self.contentView addSubview:multipleImageCommentsCountLabel];
        self.multipleImageCommentsCountLabel = multipleImageCommentsCountLabel;
        
        UIButton *multipleImageDeleteButton = [[UIButton alloc] init];
        multipleImageDeleteButton.userInteractionEnabled = YES;
        multipleImageDeleteButton.enlargedEdge = 10;
        [self.contentView addSubview:multipleImageDeleteButton];
        [multipleImageDeleteButton addTarget:self action:@selector(didClickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        self.multipleImageDeleteButton = multipleImageDeleteButton;
        
        UILabel *multipleImageTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        multipleImageTitleLabel.numberOfLines = 0;
        [self.contentView addSubview:multipleImageTitleLabel];
        self.multipleImageTitleLabel = multipleImageTitleLabel;
        
        UIImageView *firstMultipleImageView = [[UIImageView alloc] init];
        firstMultipleImageView.contentMode = UIViewContentModeScaleAspectFill;
        firstMultipleImageView.clipsToBounds = YES;
        [self.contentView addSubview:firstMultipleImageView];
        self.firstMultipleImageView = firstMultipleImageView;
        
        UIImageView *secondMultipleImageView = [[UIImageView alloc] init];
        secondMultipleImageView.contentMode = UIViewContentModeScaleAspectFill;
        secondMultipleImageView.clipsToBounds = YES;
        [self.contentView addSubview:secondMultipleImageView];
        self.secondMultipleImageView = secondMultipleImageView;
        
        UIImageView *thirdMultipleImageView = [[UIImageView alloc] init];
        thirdMultipleImageView.contentMode = UIViewContentModeScaleAspectFill;
        thirdMultipleImageView.clipsToBounds = YES;
        [self.contentView addSubview:thirdMultipleImageView];
        self.thirdMultipleImageView = thirdMultipleImageView;
        
        UIButton *multipleImageTipButton = [[UIButton alloc] init];
        multipleImageTipButton.userInteractionEnabled = YES;
        multipleImageTipButton.backgroundColor = [UIColor colorFromHexString:seperatorColor];
        [multipleImageTipButton setTitle:tipString forState:UIControlStateNormal];
        [multipleImageTipButton setTitleColor:[UIColor colorFromHexString:tipColor] forState:UIControlStateNormal];
        multipleImageTipButton.titleLabel.font = [UIFont systemFontOfSize:tipFontSize];
        [multipleImageTipButton setImage:[UIImage imageNamed:@"上次位置刷新"] forState:UIControlStateNormal];
        multipleImageTipButton.imageEdgeInsets = UIEdgeInsetsMake(0,tipLabelTitleWidth + interval, 0, -(tipLabelTitleWidth + interval));
        multipleImageTipButton.titleEdgeInsets = UIEdgeInsetsMake(0, -(tipImageViewWidth + interval), 0, tipImageViewWidth + interval);
        [multipleImageTipButton addTarget:self action:@selector(didClickTipButton) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:multipleImageTipButton];
        self.multipleImageTipButton = multipleImageTipButton;
        
        UIView *multipleImageSeperatorLine = [[UIView alloc] init];
        multipleImageSeperatorLine.backgroundColor = [UIColor colorFromHexString:seperatorColor];
        [self.contentView addSubview:multipleImageSeperatorLine];
        self.multipleImageSeperatorLine = multipleImageSeperatorLine;
        
        // 类型
        UILabel *multipleImageNewsTypeLabel = [[UILabel alloc] init];
        multipleImageNewsTypeLabel.textColor = [UIColor whiteColor];
        multipleImageNewsTypeLabel.font = [UIFont systemFontOfSize:newsTypeFontSize];
        multipleImageNewsTypeLabel.textAlignment = NSTextAlignmentCenter;
        multipleImageNewsTypeLabel.layer.cornerRadius = newsTypeCornerRadius;
        multipleImageNewsTypeLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:multipleImageNewsTypeLabel];
        self.multipleImageNewsTypeLabel = multipleImageNewsTypeLabel;
        
        // ----------------- 专题 --------------------
        UIView *specailTopicOutsideView = [[UIView alloc] init];
        specailTopicOutsideView.backgroundColor = [UIColor colorFromHexString:seperatorColor];
        [self.contentView addSubview:specailTopicOutsideView];
        self.specailTopicOutsideView = specailTopicOutsideView;
        
        UIView *specialTopicInsideView = [[UIView alloc] init];
        specialTopicInsideView.layer.borderWidth = 0.5f;
        specialTopicInsideView.layer.borderColor = [UIColor colorFromHexString:@"#d2d2d2"].CGColor;
        specialTopicInsideView.layer.cornerRadius = 2.0f;
        specialTopicInsideView.backgroundColor = [UIColor whiteColor];
        [specailTopicOutsideView addSubview:specialTopicInsideView];
        self.specialTopicInsideView = specialTopicInsideView;
        
        UIImageView *specialTopicLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_zhuanti"]];
        [specialTopicInsideView addSubview:specialTopicLogo];
        self.specialTopicLogo = specialTopicLogo;
        
        UILabel *specialTopicTitleLabel = [[UILabel alloc] init];
        specialTopicTitleLabel.numberOfLines = 0;
        [specialTopicInsideView addSubview:specialTopicTitleLabel];
        self.specialTopicTitleLabel = specialTopicTitleLabel;
        
        UIButton *specialTopicTipButton = [[UIButton alloc] init];
        specialTopicTipButton.userInteractionEnabled = YES;
        specialTopicTipButton.backgroundColor = [UIColor colorFromHexString:seperatorColor];
        [specialTopicTipButton setTitle:tipString forState:UIControlStateNormal];
        [specialTopicTipButton setTitleColor:[UIColor colorFromHexString:tipColor] forState:UIControlStateNormal];
        specialTopicTipButton.titleLabel.font = [UIFont systemFontOfSize:tipFontSize];
        [specialTopicTipButton setImage:[UIImage imageNamed:@"上次位置刷新"] forState:UIControlStateNormal];
        specialTopicTipButton.imageEdgeInsets = UIEdgeInsetsMake(0,tipLabelTitleWidth + interval, 0, -(tipLabelTitleWidth + interval));
        specialTopicTipButton.titleEdgeInsets = UIEdgeInsetsMake(0, -(tipImageViewWidth + interval), 0, tipImageViewWidth + interval);
        [specialTopicTipButton addTarget:self action:@selector(didClickTipButton) forControlEvents:UIControlEventTouchUpInside];
        [specialTopicInsideView addSubview:specialTopicTipButton];
        self.specialTopicTipButton = specialTopicTipButton;
   
        UILabel *specialTopicCommentsCountLabel = [[UILabel alloc] init];
        specialTopicCommentsCountLabel.textColor = [UIColor colorFromHexString:commentsColor];
        specialTopicCommentsCountLabel.font = [UIFont systemFontOfSize:commentsFontSize];
        [specialTopicInsideView addSubview:specialTopicCommentsCountLabel];
        self.specialTopicCommentsCountLabel = specialTopicCommentsCountLabel;
        
        UIButton *specialTopicDeleteButton = [[UIButton alloc] init];
        specialTopicDeleteButton.userInteractionEnabled = YES;
        specialTopicDeleteButton.enlargedEdge = 10;
        [specialTopicInsideView addSubview:specialTopicDeleteButton];
        [specialTopicDeleteButton addTarget:self action:@selector(didClickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        self.specialTopicDeleteButton = specialTopicDeleteButton;
 
        UIImageView *specialTopicImageView = [[UIImageView alloc] init];
        [specialTopicInsideView addSubview:specialTopicImageView];
        self.specialTopicImageView = specialTopicImageView;
        
      
    }
    return self;
}

- (void)setCardFrame:(CardFrame *)cardFrame {
    
    _cardFrame = cardFrame;
    Card *card = cardFrame.card;
    CGFloat lineSpacing = 2.0;
    NSString *sourceSiteName = [card.sourceSiteName  isEqualToString: @""] ? @"未知来源": card.sourceSiteName;
    NSString *title = card.title;
    NSInteger rtype = [card.rtype intValue];
    CGFloat titleFontSize =  self.cardFrame.homeViewFontSize;
    NSString *fontSizeType = self.cardFrame.fontSizeType;
    CGFloat newsTypeFontSize = 12;
    // standard  superlarger  larger
    if ([fontSizeType isEqualToString:@"standard"]) {
        newsTypeFontSize = 12;
    } else if ([fontSizeType isEqualToString:@"larger"]) {
        newsTypeFontSize = 14;
    } else {
        newsTypeFontSize = 16;
    }
    
    self.noImageNewsTypeLabel.font = [UIFont systemFontOfSize:newsTypeFontSize];
    self.singleImageNewsTypeLabel.font = [UIFont systemFontOfSize:newsTypeFontSize];
    self.singleBigImageNewsTypeLabel.font = [UIFont systemFontOfSize:newsTypeFontSize];
    self.multipleImageNewsTypeLabel.font = [UIFont systemFontOfSize:newsTypeFontSize];
    
    // 评论数量
    NSInteger commentsCount = [card.commentsCount intValue];
    NSString *commentsStr = @"";
    
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
    
    switch (rtype) {
        case hotNewsType:case pushNewsType:case adNewsType:
            title = [NSString stringWithFormat:@"%@%@",newsType, title];
            break;
        default:
            break;
    }
    
    
    if (commentsCount > 0) {
        commentsStr = [NSString stringWithFormat:@"%d评",commentsCount];
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
    NSString *titleLabelColor = LPColor1;

    if (card.isRead) {
        self.noImageTitleLabel.textColor = [UIColor grayColor];
        self.singleImageTitleLabel.textColor = [UIColor grayColor];
        self.singleBigImageTitleLabel.textColor = [UIColor grayColor];
        self.multipleImageTitleLabel.textColor = [UIColor grayColor];
        self.specialTopicTitleLabel.textColor = [UIColor grayColor];
    } else {
        self.noImageTitleLabel.textColor = [UIColor colorFromHexString:titleLabelColor];
        self.singleImageTitleLabel.textColor = [UIColor colorFromHexString:titleLabelColor];
        self.singleBigImageTitleLabel.textColor = [UIColor colorFromHexString:titleLabelColor];
        self.multipleImageTitleLabel.textColor = [UIColor colorFromHexString:titleLabelColor];
        self.specialTopicTitleLabel.textColor = [UIColor colorFromHexString:titleLabelColor];
    }


    // 专题
    if ([card.rtype integerValue] == 4) {
        self.noImageTitleLabel.hidden = YES;
        self.noImageSourceImageView.hidden = YES;
        self.noImageSourceLabel.hidden = YES;
        self.noImageDeleteButton.hidden = YES;
        self.noImageTipButton.hidden = YES;
        self.noImageNewsTypeLabel.hidden = YES;
        self.noImageSeperatorLine.hidden = YES;
        self.noImageCommentsCountLabel.hidden = YES;
        
        // 单图
        self.singleImageTitleLabel.hidden = YES;
        self.singleImageSourceImageView.hidden = YES;
        self.singleImageSourceLabel.hidden = YES;
        self.singleImageIcon.hidden = YES;
        self.singleImageSeperatorLine.hidden = YES;
        self.singleImageDeleteButton.hidden = YES;
        self.singleImageTipButton.hidden = YES;
        self.singleImageNewsTypeLabel.hidden = YES;
        self.singleImageCommentsCountLabel.hidden = YES;
        
        // 单图大图
        self.singleBigImageTitleLabel.hidden = YES;
        self.singleBigImageIcon.hidden = YES;
        self.singleBigImageSourceImageView.hidden = YES;
        self.singleBigImageSourceLabel.hidden = YES;
        self.singleBigImageSeperatorLine.hidden = YES;
        self.singleBigImageDeleteButton.hidden = YES;
        self.singleBigImageTipButton.hidden = YES;
        self.singleBigImageNewsTypeLabel.hidden = YES;
        self.singleBigImageCommentsCountLabel.hidden = YES;
        
        // 三图
        self.multipleImageTitleLabel.hidden = YES;
        self.firstMultipleImageView.hidden = YES;
        self.secondMultipleImageView.hidden = YES;
        self.thirdMultipleImageView.hidden = YES;
        self.multipleImageSourceImageView.hidden = YES;
        self.multipleImageSourceLabel.hidden = YES;
        self.multipleImageSeperatorLine.hidden = YES;
        self.multipleImageDeleteButton.hidden = YES;
        self.multipleImageTipButton.hidden = YES;
        self.multipleImageNewsTypeLabel.hidden = YES;
        self.multipleImageCommentsCountLabel.hidden = YES;
        
        // 专题
        self.specialTopicTitleLabel.hidden = NO;
        self.specialTopicInsideView.hidden = NO;
        self.specialTopicLogo.hidden = NO;
        self.specialTopicImageView.hidden = NO;
        self.specialTopicTipButton.hidden = NO;
        self.specailTopicOutsideView.hidden = NO;
        self.specialTopicDeleteButton.hidden = NO;
        self.specialTopicCommentsCountLabel.hidden = NO;
        
        self.specialTopicTitleLabel.attributedText = attributeTitle;
        self.specialTopicTitleLabel.frame = self.cardFrame.specialTopicTitleLabelFrame;
        
        CardImage * cardImage = [card.cardImages firstObject];
        self.specialTopicImageView.frame = self.cardFrame.specialTopicImageViewFrame;
        NSString *imageURL = [self scaleSpecialTopicImageURL:cardImage.imgUrl];
        
        [self.specialTopicImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"单图大图占位图"]];
        
        [self.specialTopicDeleteButton setBackgroundImage:[UIImage imageNamed:@"home_delete"] forState:UIControlStateNormal];
        self.specialTopicDeleteButton.frame = self.cardFrame.specialTopicDeleteButtonFrame;
        
        self.specailTopicOutsideView.frame = self.cardFrame.specialTopicOutsideViewFrame;
        self.specialTopicInsideView.frame = self.cardFrame.specialTopicInsideViewFrame;
        self.specialTopicTipButton.frame = self.cardFrame.specialTopicTipButtonFrame;
        
        self.specialTopicLogo.frame = self.cardFrame.specialTopicLogoFrame;
        self.specialTopicTipButton.hidden = self.cardFrame.isTipButtonHidden;
        
        // 评论
        self.specialTopicCommentsCountLabel.text = commentsStr;
        self.specialTopicCommentsCountLabel.frame = self.cardFrame.specialTopicCommentsCountLabelFrame;
        self.specialTopicCommentsCountLabel.centerY = self.specialTopicDeleteButton.centerY;
        
        

    } else {
        
        if([card.type integerValue] == imageStyleZero) {
    
            self.noImageTitleLabel.hidden = NO;
            self.noImageSourceImageView.hidden = NO;
            self.noImageSourceLabel.hidden = NO;
            self.noImageDeleteButton.hidden = NO;
            self.noImageTipButton.hidden = NO;
            self.noImageNewsTypeLabel.hidden = NO;
            self.noImageSeperatorLine.hidden = NO;
            self.noImageCommentsCountLabel.hidden = NO;
            
            // 单图
            self.singleImageTitleLabel.hidden = YES;
            self.singleImageSourceImageView.hidden = YES;
            self.singleImageSourceLabel.hidden = YES;
            self.singleImageIcon.hidden = YES;
            self.singleImageSeperatorLine.hidden = YES;
            self.singleImageDeleteButton.hidden = YES;
            self.singleImageTipButton.hidden = YES;
            self.singleImageNewsTypeLabel.hidden = YES;
            self.singleImageCommentsCountLabel.hidden = YES;
            
            // 单图大图
            self.singleBigImageTitleLabel.hidden = YES;
            self.singleBigImageIcon.hidden = YES;
            self.singleBigImageSourceImageView.hidden = YES;
            self.singleBigImageSourceLabel.hidden = YES;
            self.singleBigImageSeperatorLine.hidden = YES;
            self.singleBigImageDeleteButton.hidden = YES;
            self.singleBigImageTipButton.hidden = YES;
            self.singleBigImageNewsTypeLabel.hidden = YES;
            self.singleBigImageCommentsCountLabel.hidden = YES;
            
            // 三图
            self.multipleImageTitleLabel.hidden = YES;
            self.firstMultipleImageView.hidden = YES;
            self.secondMultipleImageView.hidden = YES;
            self.thirdMultipleImageView.hidden = YES;
            self.multipleImageSourceImageView.hidden = YES;
            self.multipleImageSourceLabel.hidden = YES;
            self.multipleImageSeperatorLine.hidden = YES;
            self.multipleImageDeleteButton.hidden = YES;
            self.multipleImageTipButton.hidden = YES;
            self.multipleImageNewsTypeLabel.hidden = YES;
            self.multipleImageCommentsCountLabel.hidden = YES;
            
            // 专题
            self.specialTopicTitleLabel.hidden = YES;
            self.specialTopicInsideView.hidden = YES;
            self.specialTopicLogo.hidden = YES;
            self.specialTopicImageView.hidden = YES;
            self.specialTopicTipButton.hidden = YES;
            self.specailTopicOutsideView.hidden = YES;
            self.specialTopicDeleteButton.hidden = YES;
            self.specialTopicCommentsCountLabel.hidden = YES;
    
            self.noImageTitleLabel.frame = self.cardFrame.noImageTitleLabelFrame;
            self.noImageTitleLabel.attributedText = attributeTitle;
 
            self.noImageSourceImageView.image = [UIImage imageNamed:@"home_source"];
            self.noImageSourceImageView.frame = self.cardFrame.noImageSourceImageViewFrame;
            
            self.noImageSourceLabel.frame = self.cardFrame.noImageSourceLabelFrame;
            self.noImageSourceLabel.text = sourceSiteName;
            
            self.noImageNewsTypeLabel.frame = self.cardFrame.noImageNewsTypeLabelFrame;
            self.noImageSeperatorLine.frame = self.cardFrame.noImageSeperatorLineFrame;
            
            [self.noImageDeleteButton setBackgroundImage:[UIImage imageNamed:@"home_delete"] forState:UIControlStateNormal];
            self.noImageDeleteButton.frame = self.cardFrame.noImageDeleteButtonFrame;
            
            self.noImageTipButton.frame = self.cardFrame.noImageTipButtonFrame;
            self.noImageTipButton.hidden = self.cardFrame.isTipButtonHidden;
            
            // 类型
            self.noImageNewsTypeLabel.layer.backgroundColor = [UIColor colorFromHexString:newsTypeColor].CGColor;
            self.noImageNewsTypeLabel.text = newsType;
            self.noImageNewsTypeLabel.frame = self.cardFrame.noImageNewsTypeLabelFrame;
            
            self.noImageCommentsCountLabel.frame = self.cardFrame.noImageCommentsCountLabelFrame;
            self.noImageCommentsCountLabel.text = commentsStr;
            
            self.noImageCommentsCountLabel.centerY = self.noImageDeleteButton.centerY;
            
        }   else if ([card.type integerValue] == imageStyleOne || [card.type integerValue] == imageStyleTwo) {

            self.noImageTitleLabel.hidden = YES;
            self.noImageSourceImageView.hidden = YES;
            self.noImageSourceLabel.hidden = YES;
            self.noImageDeleteButton.hidden = YES;
            self.noImageTipButton.hidden = YES;
            self.noImageNewsTypeLabel.hidden = YES;
            self.noImageSeperatorLine.hidden = YES;
            self.noImageCommentsCountLabel.hidden = YES;
            
            // 单图
            self.singleImageTitleLabel.hidden = NO;
            self.singleImageSourceImageView.hidden = NO;
            self.singleImageSourceLabel.hidden = NO;
            self.singleImageIcon.hidden = NO;
            self.singleImageSeperatorLine.hidden = NO;
            self.singleImageDeleteButton.hidden = NO;
            self.singleImageTipButton.hidden = NO;
            self.singleImageNewsTypeLabel.hidden = NO;
            self.singleImageCommentsCountLabel.hidden = NO;
            
            // 单图大图
            self.singleBigImageTitleLabel.hidden = YES;
            self.singleBigImageIcon.hidden = YES;
            self.singleBigImageSourceImageView.hidden = YES;
            self.singleBigImageSourceLabel.hidden = YES;
            self.singleBigImageSeperatorLine.hidden = YES;
            self.singleBigImageDeleteButton.hidden = YES;
            self.singleBigImageTipButton.hidden = YES;
            self.singleBigImageNewsTypeLabel.hidden = YES;
            self.singleBigImageCommentsCountLabel.hidden = YES;
            
            // 三图
            self.multipleImageTitleLabel.hidden = YES;
            self.firstMultipleImageView.hidden = YES;
            self.secondMultipleImageView.hidden = YES;
            self.thirdMultipleImageView.hidden = YES;
            self.multipleImageSourceImageView.hidden = YES;
            self.multipleImageSourceLabel.hidden = YES;
            self.multipleImageSeperatorLine.hidden = YES;
            self.multipleImageDeleteButton.hidden = YES;
            self.multipleImageTipButton.hidden = YES;
            self.multipleImageNewsTypeLabel.hidden = YES;
            self.multipleImageCommentsCountLabel.hidden = YES;
            
            // 专题
            self.specialTopicTitleLabel.hidden = YES;
            self.specialTopicInsideView.hidden = YES;
            self.specialTopicLogo.hidden = YES;
            self.specialTopicImageView.hidden = YES;
            self.specialTopicTipButton.hidden = YES;
            self.specailTopicOutsideView.hidden = YES;
            self.specialTopicDeleteButton.hidden = YES;
            self.specialTopicCommentsCountLabel.hidden = YES;
            
            CardImage * cardImage = [card.cardImages firstObject];
            NSString *imageURL = [self scaleImageURL:cardImage.imgUrl];
            
            self.singleImageTipButton.frame = self.cardFrame.singleImageTipButtonFrame;
            self.singleImageTipButton.hidden = self.cardFrame.isTipButtonHidden;
            
            self.singleImageSourceImageView.image = [UIImage imageNamed:@"home_source"];
            self.singleImageSourceImageView.frame = self.cardFrame.singleImageSourceImageViewFrame;
            
            self.singleImageSourceLabel.text = sourceSiteName;
            self.singleImageSourceLabel.frame = self.cardFrame.singleImageSourceLabelFrame;
            
            [self.singleImageDeleteButton setBackgroundImage:[UIImage imageNamed:@"home_delete"] forState:UIControlStateNormal];
            self.singleImageDeleteButton.frame = self.cardFrame.singleImageDeleteButtonFrame;
            
            [self.singleImageIcon sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"单图小图占位图"]];
            self.singleImageIcon.frame = self.cardFrame.singleImageImageViewFrame;
        
            self.singleImageTitleLabel.frame = self.cardFrame.singleImageTitleLabelFrame;
            self.singleImageTitleLabel.attributedText =  attributeTitle;

            self.singleImageSeperatorLine.frame = self.cardFrame.singleImageSeperatorLineFrame;
            self.singleImageNewsTypeLabel.frame = self.cardFrame.singleImageNewsTypeLabelFrame;
            
            // 类型
            self.singleImageNewsTypeLabel.layer.backgroundColor = [UIColor colorFromHexString:newsTypeColor].CGColor;
            self.singleImageNewsTypeLabel.frame = self.cardFrame.singleImageNewsTypeLabelFrame;
            self.singleImageNewsTypeLabel.text = newsType;
            
            self.singleImageCommentsCountLabel.frame = self.cardFrame.singleImageCommentsCountLabelFrame;
            self.singleImageCommentsCountLabel.text = commentsStr;
            self.singleImageCommentsCountLabel.centerY = self.singleImageDeleteButton.centerY;
            
                
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
            self.noImageTitleLabel.hidden = YES;
            self.noImageSourceImageView.hidden = YES;
            self.noImageSourceLabel.hidden = YES;
            self.noImageDeleteButton.hidden = YES;
            self.noImageTipButton.hidden = YES;
            self.noImageNewsTypeLabel.hidden = YES;
            self.noImageSeperatorLine.hidden = YES;
            self.noImageCommentsCountLabel.hidden = YES;
            
            
            // 单图
            self.singleImageTitleLabel.hidden = YES;
            self.singleImageSourceImageView.hidden = YES;
            self.singleImageSourceLabel.hidden = YES;
            self.singleImageIcon.hidden = YES;
            self.singleImageSeperatorLine.hidden = YES;
            self.singleImageDeleteButton.hidden = YES;
            self.singleImageTipButton.hidden = YES;
            self.singleImageNewsTypeLabel.hidden = YES;
            self.singleImageCommentsCountLabel.hidden = YES;
            
            // 单图大图
            self.singleBigImageTitleLabel.hidden = NO;
            self.singleBigImageIcon.hidden = NO;
            self.singleBigImageSourceImageView.hidden = NO;
            self.singleBigImageSourceLabel.hidden = NO;
            self.singleBigImageSeperatorLine.hidden = NO;
            self.singleBigImageDeleteButton.hidden = NO;
            self.singleBigImageTipButton.hidden = NO;
            self.singleBigImageNewsTypeLabel.hidden = NO;
            self.singleBigImageCommentsCountLabel.hidden = NO;
            
            // 三图
            self.multipleImageTitleLabel.hidden = YES;
            self.firstMultipleImageView.hidden = YES;
            self.secondMultipleImageView.hidden = YES;
            self.thirdMultipleImageView.hidden = YES;
            self.multipleImageSourceImageView.hidden = YES;
            self.multipleImageSourceLabel.hidden = YES;
            self.multipleImageSeperatorLine.hidden = YES;
            self.multipleImageDeleteButton.hidden = YES;
            self.multipleImageTipButton.hidden = YES;
            self.multipleImageNewsTypeLabel.hidden = YES;
            self.multipleImageCommentsCountLabel.hidden = YES;
            
            // 专题
            self.specialTopicTitleLabel.hidden = YES;
            self.specialTopicInsideView.hidden = YES;
            self.specialTopicLogo.hidden = YES;
            self.specialTopicImageView.hidden = YES;
            self.specialTopicTipButton.hidden = YES;
            self.specailTopicOutsideView.hidden = YES;
            self.specialTopicDeleteButton.hidden = YES;
            self.specialTopicCommentsCountLabel.hidden = YES;
            
            // 上次加载位置
            self.singleBigImageTipButton.frame = self.cardFrame.singleBigImageTipButtonFrame;
            self.singleBigImageTipButton.hidden = self.cardFrame.isTipButtonHidden;
            
            // 来源
            self.singleBigImageSourceImageView.image = [UIImage imageNamed:@"home_source"];
            self.singleBigImageSourceImageView.frame = self.cardFrame.singleBigImageSourceImageViewFrame;
            
            self.singleBigImageSourceLabel.text = sourceSiteName;
            self.singleBigImageSourceLabel.frame = self.cardFrame.singleBigImageSourceLabelFrame;
            // 删除
            [self.singleBigImageDeleteButton setBackgroundImage:[UIImage imageNamed:@"home_delete"] forState:UIControlStateNormal];
            self.singleBigImageDeleteButton.frame = self.cardFrame.singleBigImageDeleteButtonFrame;
            
            // 标题
            self.singleBigImageTitleLabel.attributedText = attributeTitle;
            self.singleBigImageTitleLabel.frame = self.cardFrame.singleBigImageTitleLabelFrame;
            
            // 图片
            NSString *imageURL = [self scaleBigImageURL:cardImage.imgUrl];
            [self.singleBigImageIcon sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"单图大图占位图"]];
            self.singleBigImageIcon.frame = self.cardFrame.singleBigImageImageViewFrame;
            // 分割线
            self.singleBigImageSeperatorLine.frame = self.cardFrame.singleBigImageSeperatorLineFrame;
            // 背景
            self.singleBigImageNewsTypeLabel.frame = self.cardFrame.singleBigImageNewsTypeLabelFrame;
            
            
            self.singleBigImageNewsTypeLabel.layer.backgroundColor = [UIColor colorFromHexString:newsTypeColor].CGColor;
            self.singleBigImageNewsTypeLabel.frame = self.cardFrame.singleBigImageNewsTypeLabelFrame;
            self.singleBigImageNewsTypeLabel.text = newsType;
            
            self.singleBigImageCommentsCountLabel.text = commentsStr;
            self.singleBigImageCommentsCountLabel.frame = self.cardFrame.singleBigImageCommentsCountLabelFrame;
            self.singleBigImageCommentsCountLabel.centerY = self.singleBigImageDeleteButton.centerY;

        
        }    else if ([card.type integerValue] == imageStyleThree) {
        
            self.noImageTitleLabel.hidden = YES;
            self.noImageSourceImageView.hidden = YES;
            self.noImageSourceLabel.hidden = YES;
            self.noImageDeleteButton.hidden = YES;
            self.noImageTipButton.hidden = YES;
            self.noImageNewsTypeLabel.hidden = YES;
            self.noImageSeperatorLine.hidden = YES;
            self.noImageCommentsCountLabel.hidden = YES;
            
            
            // 单图
            self.singleImageTitleLabel.hidden = YES;
            self.singleImageSourceImageView.hidden = YES;
            self.singleImageSourceLabel.hidden = YES;
            self.singleImageIcon.hidden = YES;
            self.singleImageSeperatorLine.hidden = YES;
            self.singleImageDeleteButton.hidden = YES;
            self.singleImageTipButton.hidden = YES;
            self.singleImageNewsTypeLabel.hidden = YES;
            self.singleImageCommentsCountLabel.hidden = YES;
            
            // 单图大图
            self.singleBigImageTitleLabel.hidden = YES;
            self.singleBigImageIcon.hidden = YES;
            self.singleBigImageSourceImageView.hidden = YES;
            self.singleBigImageSourceLabel.hidden = YES;
            self.singleBigImageSeperatorLine.hidden = YES;
            self.singleBigImageDeleteButton.hidden = YES;
            self.singleBigImageTipButton.hidden = YES;
            self.singleBigImageNewsTypeLabel.hidden = YES;
            self.singleBigImageCommentsCountLabel.hidden = YES;
            
            // 三图
            self.multipleImageTitleLabel.hidden = NO;
            self.firstMultipleImageView.hidden = NO;
            self.secondMultipleImageView.hidden = NO;
            self.thirdMultipleImageView.hidden = NO;
            self.multipleImageSourceImageView.hidden = NO;
            self.multipleImageSourceLabel.hidden = NO;
            self.multipleImageSeperatorLine.hidden = NO;
            self.multipleImageDeleteButton.hidden = NO;
            self.multipleImageTipButton.hidden = NO;
            self.multipleImageNewsTypeLabel.hidden = NO;
            self.multipleImageCommentsCountLabel.hidden = NO;
            
            // 专题
            self.specialTopicTitleLabel.hidden = YES;
            self.specialTopicInsideView.hidden = YES;
            self.specialTopicLogo.hidden = YES;
            self.specialTopicImageView.hidden = YES;
            self.specialTopicTipButton.hidden = YES;
            self.specailTopicOutsideView.hidden = YES;
            self.specialTopicDeleteButton.hidden = YES;
            self.specialTopicCommentsCountLabel.hidden = YES;
        
            // 上次加载位置
            self.multipleImageTipButton.frame = self.cardFrame.multipleImageTipButtonFrame;
            self.multipleImageTipButton.hidden = self.cardFrame.isTipButtonHidden;
            
            // 来源
            self.multipleImageSourceImageView.image = [UIImage imageNamed:@"home_source"];
            self.multipleImageSourceImageView.frame = self.cardFrame.multipleImageSourceImageViewFrame;
            
            self.multipleImageSourceLabel.text = sourceSiteName;
            self.multipleImageSourceLabel.frame = self.cardFrame.multipleImageSourceLabelFrame;
            // 删除
            [self.multipleImageDeleteButton setBackgroundImage:[UIImage imageNamed:@"home_delete"] forState:UIControlStateNormal];
            self.multipleImageDeleteButton.frame = self.cardFrame.multipleImageDeleteButtonFrame;
            
            // 标题
            self.multipleImageTitleLabel.frame = self.cardFrame.multipleImageTitleLabelFrame;
            self.multipleImageTitleLabel.attributedText =  attributeTitle;
            
            CGRect frame = self.cardFrame.multipleImageViewFrame;
            CGFloat x = frame.origin.x;
            CGFloat y = frame.origin.y;
            CGFloat w = (frame.size.width - 3) / 3 ;
            CGFloat h = frame.size.height;

            NSString *firstImageURL = [card.cardImages objectAtIndex:0].imgUrl;
            NSString *secondImageURL = [card.cardImages objectAtIndex:1].imgUrl;
            NSString *thirdImageURL = [card.cardImages objectAtIndex:2].imgUrl;

            [self.firstMultipleImageView sd_setImageWithURL:[NSURL URLWithString:firstImageURL] placeholderImage:[UIImage imageNamed:@"单图小图占位图"]];
            [self.secondMultipleImageView sd_setImageWithURL:[NSURL URLWithString:secondImageURL] placeholderImage:[UIImage imageNamed:@"单图小图占位图"]];
            [self.thirdMultipleImageView sd_setImageWithURL:[NSURL URLWithString:thirdImageURL] placeholderImage:[UIImage imageNamed:@"单图小图占位图"]];

            self.firstMultipleImageView.frame = CGRectMake(x, y, w, h);
            self.secondMultipleImageView.frame = CGRectMake(x + w + 3, y, w, h);
            self.thirdMultipleImageView.frame = CGRectMake(x + 2 * w + 6, y, w, h);
            
            // 分割线
            self.multipleImageSeperatorLine.frame = self.cardFrame.multipleImageSeperatorLineFrame;
            
            self.multipleImageNewsTypeLabel.layer.backgroundColor = [UIColor colorFromHexString:newsTypeColor].CGColor;
            self.multipleImageNewsTypeLabel.frame = self.cardFrame.multipleImageNewsTypeLabelFrame;
            self.multipleImageNewsTypeLabel.text = newsType;
            
            self.multipleImageCommentsCountLabel.text = commentsStr;
            self.multipleImageCommentsCountLabel.frame = self.cardFrame.multipleImageCommentsCountLabelFrame;
            self.multipleImageCommentsCountLabel.centerY = self.multipleImageDeleteButton.centerY;
  
        }
    }
  }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}


//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
//    [super setHighlighted:highlighted animated:animated];
//    
//}

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

#pragma mark - 专题图片处理
- (NSString *)scaleSpecialTopicImageURL:(NSString *)imageURL {
    NSRange range = [imageURL rangeOfString:@"/" options:NSBackwardsSearch];
    NSString *substring = [imageURL substringFromIndex:range.location+1];
    NSString *scaleImageURL = [NSString stringWithFormat:@"http://pro-pic.deeporiginalx.com/%@@1e_1c_0o_0l_100sh_200h_600w_100q.src", substring];
    return scaleImageURL;
}


@end

