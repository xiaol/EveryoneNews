//
//  LPConcernViewCell.m
//  EveryoneNews
//
//  Created by dongdan on 16/7/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPConcernViewCell.h"
#import "Card+Create.h"
#import "LPCardConcernFrame.h"
#import "Card.h"
#import "CardImage.h"
#import "CardConcern.h"
#import "UIImageView+WebCache.h"

@interface LPConcernViewCell ()

// 无图
@property (nonatomic, strong) UILabel *noImageLabel;
@property (nonatomic, strong) UILabel *noImageKeywordLabel;
@property (nonatomic, strong) UIView *noImageSeperatorLine;
@property (nonatomic, strong) UIView *noImageSourceListView;

// 单图
@property (nonatomic, strong) UILabel *singleImageTitleLabel;
@property (nonatomic, strong) UIImageView *singleImageView;
@property (nonatomic, strong) UILabel *singleImageKeywordLabel;
@property (nonatomic, strong) UIView *singleImageSeperatorLine;
@property (nonatomic, strong) UIView *singleImageSourceListView;

// 三图
@property (nonatomic, strong) UILabel *multipleImageLabel;
@property (nonatomic, strong) UILabel *multipleImageKeywordLabel;
@property (nonatomic, strong) UIImageView *firstMutipleImageView;
@property (nonatomic, strong) UIImageView *secondMutipleImageView;
@property (nonatomic, strong) UIImageView *thirdMutipleImageView;
@property (nonatomic, strong) UIView *multipleSeperatorLine;
@property (nonatomic, strong) UIView *multipleImageSourceListView;

// 来源
@property (nonatomic, copy) NSString *sourceName;

@end

@implementation LPConcernViewCell

#pragma mark - initWithStyle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor whiteColor];
    CGFloat keywordFontSize = LPFont6;

    if(self) {
        
        CGFloat keywordRadius = 4;
        // 无图
        UILabel *noImageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        noImageLabel.textColor = [UIColor colorFromHexString:@"#1a1a1a"];
        noImageLabel.numberOfLines = 0;
        noImageLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:noImageLabel];
        self.noImageLabel = noImageLabel;
        
        UILabel *noImageKeywordLabel = [[UILabel alloc] init];
        noImageKeywordLabel.layer.cornerRadius = keywordRadius;
        noImageKeywordLabel.layer.masksToBounds = YES;
        noImageKeywordLabel.layer.borderWidth = 0.5;
        noImageKeywordLabel.layer.borderColor = [UIColor colorFromHexString:@"#f6f6f6"].CGColor;
        noImageKeywordLabel.textAlignment = NSTextAlignmentCenter;
        noImageKeywordLabel.font = [UIFont systemFontOfSize:keywordFontSize];
        noImageKeywordLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:noImageKeywordLabel];
        self.noImageKeywordLabel = noImageKeywordLabel;
        
        // 来源View
        UIView *noImageSourceListView = [[UIView alloc] init];
        noImageSourceListView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:noImageSourceListView];
        self.noImageSourceListView = noImageSourceListView;
        
        UITapGestureRecognizer *noImageSoureListViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newsSourceList)];
        noImageSourceListView.userInteractionEnabled = YES;
        [noImageSourceListView addGestureRecognizer:noImageSoureListViewGesture];
        
        
        UIView *noImageSeperatorLine = [[UIView alloc] init];
        noImageSeperatorLine.backgroundColor = [UIColor colorFromHexString:LPColor16];
        [self.contentView addSubview:noImageSeperatorLine];
        self.noImageSeperatorLine = noImageSeperatorLine;
        
        // 单图
        UIImageView *singleImageView = [[UIImageView alloc] init];
        singleImageView.contentMode = UIViewContentModeScaleAspectFill;
        singleImageView.clipsToBounds = YES;
        [self.contentView addSubview:singleImageView];
        self.singleImageView = singleImageView;
        
        UILabel *singleImageTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        singleImageTitleLabel.textColor =  [UIColor colorFromHexString:@"#1a1a1a"];
        singleImageTitleLabel.numberOfLines = 0;
        singleImageTitleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:singleImageTitleLabel];
        self.singleImageTitleLabel = singleImageTitleLabel;
        
        UILabel *singleImageKeywordLabel = [[UILabel alloc] init];
        singleImageKeywordLabel.textAlignment = NSTextAlignmentCenter;
        singleImageKeywordLabel.layer.cornerRadius = keywordRadius;
        singleImageKeywordLabel.layer.borderWidth = 0.5;
        singleImageKeywordLabel.layer.borderColor = [UIColor colorFromHexString:@"#f6f6f6"].CGColor;
        singleImageKeywordLabel.layer.masksToBounds = YES;
        singleImageKeywordLabel.font = [UIFont systemFontOfSize:keywordFontSize];
        singleImageKeywordLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:singleImageKeywordLabel];
        self.singleImageKeywordLabel = singleImageKeywordLabel;
        
        UIView *singleImageSourceListView = [[UIView alloc] init];
        singleImageSourceListView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:singleImageSourceListView];
        self.singleImageSourceListView = singleImageSourceListView;
        
        UITapGestureRecognizer *singleImageSourceListViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newsSourceList)];
        singleImageSourceListView.userInteractionEnabled = YES;
        [singleImageSourceListView addGestureRecognizer:singleImageSourceListViewGesture];
        
        UIView *singleImageSeperatorLine = [[UIView alloc] init];
        singleImageSeperatorLine.backgroundColor = [UIColor colorFromHexString:LPColor16];
        [self.contentView addSubview:singleImageSeperatorLine];
        self.singleImageSeperatorLine = singleImageSeperatorLine;
        
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
        
        UILabel *multipleImageKeywordLabel = [[UILabel alloc] init];
        multipleImageKeywordLabel.textAlignment = NSTextAlignmentCenter;
        multipleImageKeywordLabel.layer.borderWidth = 0.5;
        multipleImageKeywordLabel.layer.borderColor = [UIColor colorFromHexString:@"#f6f6f6"].CGColor;
        multipleImageKeywordLabel.layer.masksToBounds = YES;
        multipleImageKeywordLabel.layer.cornerRadius = keywordRadius;
        multipleImageKeywordLabel.font = [UIFont systemFontOfSize:keywordFontSize];
        multipleImageKeywordLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:multipleImageKeywordLabel];
        self.multipleImageKeywordLabel = multipleImageKeywordLabel;
        
        // 来源View
        UIView *multipleImageSourceListView = [[UIView alloc] init];
        multipleImageSourceListView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:multipleImageSourceListView];
        self.multipleImageSourceListView = multipleImageSourceListView;
        
        UITapGestureRecognizer *multipleImageSourceListViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newsSourceList)];
        multipleImageSourceListView.userInteractionEnabled = YES;
        [multipleImageSourceListView addGestureRecognizer:multipleImageSourceListViewGesture];

        
        UIView *multipleSeperatorLine = [[UIView alloc] init];
        multipleSeperatorLine.backgroundColor = [UIColor colorFromHexString:LPColor16];
        [self.contentView addSubview:multipleSeperatorLine];
        self.multipleSeperatorLine = multipleSeperatorLine;
        
    }
    return self;
}

- (void)setCardFrame:(LPCardConcernFrame *)cardFrame {
    _cardFrame = cardFrame;
    Card *card = cardFrame.card;
    
    CGFloat lineSpacing = 2.0;
    NSAttributedString *attributeTitle =  [card.title attributedStringWithFont:[UIFont systemFontOfSize:self.cardFrame.homeViewFontSize] lineSpacing:lineSpacing];
  
    
    NSString *keyword = [card.keyword isEqualToString: @""] ? @"未知来源": card.keyword;
    
    self.sourceName = keyword;
    
    if(card.cardImages.count == 0) {
        self.noImageLabel.hidden = NO;
        self.noImageSeperatorLine.hidden = NO;
        self.noImageKeywordLabel.hidden = NO;
        self.noImageSourceListView.hidden = NO;
        
        self.singleImageTitleLabel.hidden = YES;
        self.singleImageView.hidden = YES;
        self.singleImageKeywordLabel.hidden = YES;
        self.singleImageSeperatorLine.hidden = YES;
        self.singleImageSourceListView.hidden = YES;
        
        
        self.multipleImageLabel.hidden = YES;
        self.firstMutipleImageView.hidden = YES;
        self.secondMutipleImageView.hidden = YES;
        self.thirdMutipleImageView.hidden = YES;
        self.multipleImageKeywordLabel.hidden = YES;
        self.multipleSeperatorLine.hidden = YES;
        self.multipleImageSourceListView.hidden = YES;
        
        self.noImageLabel.frame = self.cardFrame.noImageTitleLabelFrame;
        self.noImageLabel.attributedText = attributeTitle;
        
        self.noImageKeywordLabel.frame = self.cardFrame.noImageKeywordLabelFrame;
        self.noImageKeywordLabel.text = keyword;
        self.noImageKeywordLabel.backgroundColor = [UIColor colorFromHexString:card.keywordColor];
        
        self.noImageSourceListView.frame = self.cardFrame.noImageSourceListViewFrame;
        self.noImageSeperatorLine.frame = self.cardFrame.noImageSeperatorLineFrame;
    } else if (card.cardImages.count == 1 || card.cardImages.count == 2) {
        
        CardImage * cardImage = [card.cardImages firstObject];
        
        self.noImageLabel.hidden = YES;
        self.noImageSeperatorLine.hidden = YES;
        self.noImageKeywordLabel.hidden = YES;
        self.noImageSourceListView.hidden = YES;
        
        self.singleImageTitleLabel.hidden = NO;
        self.singleImageView.hidden = NO;
        self.singleImageKeywordLabel.hidden = NO;
        self.singleImageSeperatorLine.hidden = NO;
        self.singleImageSourceListView.hidden = NO;
        
        self.multipleImageLabel.hidden = YES;
        self.firstMutipleImageView.hidden = YES;
        self.secondMutipleImageView.hidden = YES;
        self.thirdMutipleImageView.hidden = YES;
        self.multipleImageKeywordLabel.hidden = YES;
        self.multipleSeperatorLine.hidden = YES;
        self.multipleImageSourceListView.hidden = YES;
        
        
        self.singleImageTitleLabel.attributedText = attributeTitle;
        self.singleImageTitleLabel.frame = self.cardFrame.singleImageTitleLabelFrame;
        
        self.singleImageView.frame = self.cardFrame.singleImageImageViewFrame;
        NSString *imageURL = [self scaleImageURL:cardImage.imgUrl];
        [self.singleImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"单图小图占位图"]];
        
        self.singleImageKeywordLabel.frame = self.cardFrame.singleImageKeywordFrame;
        self.singleImageKeywordLabel.text = keyword;
        self.singleImageKeywordLabel.backgroundColor = [UIColor colorFromHexString:card.keywordColor];
 
        self.singleImageSourceListView.frame = self.cardFrame.singleImageSourceListViewFrame;
        self.singleImageSeperatorLine.frame = self.cardFrame.singleImageSeperatorLineFrame;
        
    } else if (card.cardImages.count >= 3) {
        self.noImageLabel.hidden = YES;
        self.noImageSeperatorLine.hidden = YES;
        self.noImageKeywordLabel.hidden = YES;
        self.noImageSourceListView.hidden = YES;
        
        self.singleImageTitleLabel.hidden = YES;
        self.singleImageView.hidden = YES;
        self.singleImageKeywordLabel.hidden = YES;
        self.singleImageSeperatorLine.hidden = YES;
        self.singleImageSourceListView.hidden = YES;
        
        self.multipleImageLabel.hidden = NO;
        self.firstMutipleImageView.hidden = NO;
        self.secondMutipleImageView.hidden = NO;
        self.thirdMutipleImageView.hidden = NO;
        self.multipleImageKeywordLabel.hidden = NO;
        self.multipleSeperatorLine.hidden = NO;
        self.multipleImageSourceListView.hidden = NO;
        
        self.multipleImageLabel.attributedText = attributeTitle;
        self.multipleImageLabel.frame = self.cardFrame.multipleImageTitleLabelFrame;
    
        self.multipleImageKeywordLabel.frame = self.cardFrame.multipleImageKeywordFrame;
        self.multipleImageKeywordLabel.text = keyword;
        self.multipleImageKeywordLabel.backgroundColor = [UIColor colorFromHexString:card.keywordColor];
        self.multipleSeperatorLine.frame = self.cardFrame.multipleImageSeperatorLineFrame;
        self.multipleImageSourceListView.frame = self.cardFrame.multipleImageSourceListFrame;
        
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
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
}

#pragma mark - 新闻源列表
- (void)newsSourceList {
    if (![self.sourceName isEqualToString:@"未知来源"]) {
        if (self.didTapSourceListBlock) {
            self.didTapSourceListBlock(self.sourceName);
        }
    }
}

- (void)didTapSourceListViewBlock:(didTapSourceListViewBlock)didTapSourceListViewBlock {
    self.didTapSourceListBlock = didTapSourceListViewBlock;
}


#pragma mark - 图片缩放处理
- (NSString *)scaleImageURL:(NSString *)imageURL {
    NSRange range = [imageURL rangeOfString:@"/" options:NSBackwardsSearch];
    NSString *substring = [imageURL substringFromIndex:range.location+1];
    NSString *scaleImageURL = [NSString stringWithFormat:@"http://pro-pic.deeporiginalx.com/%@@1e_1c_0o_0l_100sh_200h_300w_100q.src", substring];
    return scaleImageURL;
}

@end
