//
//  LPConcernViewCell.m
//  EveryoneNews
//
//  Created by dongdan on 16/7/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPConcernViewCell.h"
#import "Card+Create.h"
#import "TTTAttributedLabel.h"
#import "LPCardConcernFrame.h"
#import "Card.h"
#import "CardImage.h"
#import "CardConcern.h"
#import "UIImageView+WebCache.h"

@interface LPConcernViewCell ()

// 无图
@property (nonatomic, strong) TTTAttributedLabel *noImageLabel;
@property (nonatomic, strong) UILabel *noImageKeywordLabel;
@property (nonatomic, strong) UILabel *noImageSourceLabel;
@property (nonatomic, strong) UIView *noImageSeperatorLine;

// 单图
@property (nonatomic, strong) TTTAttributedLabel *singleImageTitleLabel;
@property (nonatomic, strong) UIImageView *singleImageView;
@property (nonatomic, strong) UILabel *singleImageKeywordLabel;
@property (nonatomic, strong) UILabel *singleSourceLabel;
@property (nonatomic, strong) UIView *singleImageSeperatorLine;

// 三图
@property (nonatomic, strong) TTTAttributedLabel *multipleImageLabel;
@property (nonatomic, strong) UILabel *mutipleImageKeywordLabel;
@property (nonatomic, strong) UIImageView *firstMutipleImageView;
@property (nonatomic, strong) UIImageView *secondMutipleImageView;
@property (nonatomic, strong) UIImageView *thirdMutipleImageView;
@property (nonatomic, strong) UILabel *multipleSourceLabel;
@property (nonatomic, strong) UIView *mutipleSeperatorLine;

@end

@implementation LPConcernViewCell

#pragma mark - initWithStyle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6"];
    CGFloat keywordFontSize = LPFont6;
    CGFloat sourceFontSize = LPFont7;
    
    if(self) {
        
        CGFloat keywordRadius = 4;
        // 无图
        TTTAttributedLabel *noImageLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
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
        
        UILabel *noImageSourceLabel = [[UILabel alloc] init];
        noImageSourceLabel.font = [UIFont systemFontOfSize:sourceFontSize];
        noImageSourceLabel.textColor = [UIColor colorFromHexString:LPColor4];
        [self.contentView addSubview:noImageSourceLabel];
        self.noImageSourceLabel = noImageSourceLabel;
        
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
        
        UILabel *singleSourceLabel = [[UILabel alloc] init];
        singleSourceLabel.font = [UIFont systemFontOfSize:sourceFontSize];
        singleSourceLabel.textColor = [UIColor colorFromHexString:LPColor4];
        [self.contentView addSubview:singleSourceLabel];
        self.singleSourceLabel= singleSourceLabel;
        
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
        
        UILabel *mutipleImageKeywordLabel = [[UILabel alloc] init];
        mutipleImageKeywordLabel.textAlignment = NSTextAlignmentCenter;
        mutipleImageKeywordLabel.layer.borderWidth = 0.5;
        mutipleImageKeywordLabel.layer.borderColor = [UIColor colorFromHexString:@"#f6f6f6"].CGColor;
        mutipleImageKeywordLabel.layer.masksToBounds = YES;
        mutipleImageKeywordLabel.layer.cornerRadius = keywordRadius;
        mutipleImageKeywordLabel.font = [UIFont systemFontOfSize:keywordFontSize];
        mutipleImageKeywordLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:mutipleImageKeywordLabel];
        self.mutipleImageKeywordLabel = mutipleImageKeywordLabel;
        
        UILabel *multipleSourceLabel = [[UILabel alloc] init];
        multipleSourceLabel.font = [UIFont systemFontOfSize:sourceFontSize];
        multipleSourceLabel.textColor = [UIColor colorFromHexString:LPColor4];
        [self.contentView addSubview:multipleSourceLabel];
        self.multipleSourceLabel = multipleSourceLabel;
        
        UIView *mutipleSeperatorLine = [[UIView alloc] init];
        mutipleSeperatorLine.backgroundColor = [UIColor colorFromHexString:@"e4e4e4"];
        [self.contentView addSubview:mutipleSeperatorLine];
        self.mutipleSeperatorLine = mutipleSeperatorLine;
        
    }
    return self;
}

- (void)setCardFrame:(LPCardConcernFrame *)cardFrame {
    _cardFrame = cardFrame;
    Card *card = cardFrame.card;
    CardConcern *concern = card.cardConcern;
    NSString *source = [card.sourceSiteName  isEqualToString: @""] ? @"未知来源": card.sourceSiteName;
    NSMutableAttributedString *titleHtml = [Card titleHtmlString:card.title isRead:card.isRead];
//    NSString *keyword = concern.keyword;
    NSString *keyword = @"关键字";
  
    if(card.cardImages.count == 0) {
        
        self.noImageLabel.hidden = NO;
        self.noImageSourceLabel.hidden = NO;
        self.noImageSeperatorLine.hidden = NO;
        self.noImageKeywordLabel.hidden = NO;
        
        self.singleImageTitleLabel.hidden = YES;
        self.singleImageView.hidden = YES;
        self.singleImageKeywordLabel.hidden = YES;
        self.singleSourceLabel.hidden = YES;
        self.singleImageSeperatorLine.hidden = YES;
        
        self.multipleImageLabel.hidden = YES;
        self.firstMutipleImageView.hidden = YES;
        self.secondMutipleImageView.hidden = YES;
        self.thirdMutipleImageView.hidden = YES;
        self.multipleSourceLabel.hidden = YES;
        self.mutipleImageKeywordLabel.hidden = YES;
        self.mutipleSeperatorLine.hidden = YES;
        
        self.noImageLabel.frame = self.cardFrame.noImageTitleLabelFrame;
        self.noImageLabel.text = titleHtml;
        
        self.noImageKeywordLabel.frame = self.cardFrame.noImageKeywordLabelFrame;
        self.noImageKeywordLabel.text = keyword;
//        self.noImageKeywordLabel.backgroundColor = [UIColor colorFromHexString:concern.keywordColor];
        
        self.noImageKeywordLabel.backgroundColor = [UIColor colorFromHexString:@"#FF7F50"];
        
        self.noImageSourceLabel.frame = self.cardFrame.noImageSourceLabelFrame;
        self.noImageSourceLabel.centerY = self.noImageKeywordLabel.centerY;
        self.noImageSourceLabel.text = source;
        
        self.noImageSeperatorLine.frame = self.cardFrame.noImageSeperatorLineFrame;
    } else if (card.cardImages.count == 1 || card.cardImages.count == 2) {
        
        CardImage * cardImage = card.cardImages.anyObject;
        NSInteger w = floor(self.cardFrame.singleImageImageViewFrame.size.width);
        NSInteger h = floor(self.cardFrame.singleImageImageViewFrame.size.height);
        
        self.noImageLabel.hidden = YES;
        self.noImageSourceLabel.hidden = YES;
        self.noImageSeperatorLine.hidden = YES;
        self.noImageKeywordLabel.hidden = YES;
        
        self.singleImageTitleLabel.hidden = NO;
        self.singleImageView.hidden = NO;
        self.singleImageKeywordLabel.hidden = NO;
        self.singleSourceLabel.hidden = NO;
        self.singleImageSeperatorLine.hidden = NO;
        
        self.multipleImageLabel.hidden = YES;
        self.firstMutipleImageView.hidden = YES;
        self.secondMutipleImageView.hidden = YES;
        self.thirdMutipleImageView.hidden = YES;
        self.multipleSourceLabel.hidden = YES;
        self.mutipleImageKeywordLabel.hidden = YES;
        self.mutipleSeperatorLine.hidden = YES;
        
        
        self.singleImageTitleLabel.text =  titleHtml;
        self.singleImageTitleLabel.frame = self.cardFrame.singleImageTitleLabelFrame;
        
        self.singleImageView.frame = self.cardFrame.singleImageImageViewFrame;
        NSString *imageURL = [self scaleImageURL:cardImage.imgUrl];
        [self.singleImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"单图小图占位图"]];
        
        self.singleImageKeywordLabel.frame = self.cardFrame.singleImageKeywordFrame;
        self.singleImageKeywordLabel.text = keyword;
//        self.singleImageKeywordLabel.backgroundColor = [UIColor colorFromHexString:concern.keywordColor];
        self.singleImageKeywordLabel.backgroundColor = [UIColor colorFromHexString:@"#FF7F50"];

        self.singleSourceLabel.text = source;
        self.singleSourceLabel.frame = self.cardFrame.singleImageSourceLabelFrame;
        self.singleSourceLabel.centerY = self.singleImageKeywordLabel.centerY;
        
        self.singleImageSeperatorLine.frame = self.cardFrame.singleImageSeperatorLineFrame;
        
    } else if (card.cardImages.count >= 3) {
        
        self.noImageLabel.hidden = YES;
        self.noImageSourceLabel.hidden = YES;
        self.noImageSeperatorLine.hidden = YES;
        self.noImageKeywordLabel.hidden = YES;
        
        self.singleImageTitleLabel.hidden = YES;
        self.singleImageView.hidden = YES;
        self.singleImageKeywordLabel.hidden = YES;
        self.singleSourceLabel.hidden = YES;
        self.singleImageSeperatorLine.hidden = YES;
        
        self.multipleImageLabel.hidden = NO;
        self.firstMutipleImageView.hidden = NO;
        self.secondMutipleImageView.hidden = NO;
        self.thirdMutipleImageView.hidden = NO;
        self.multipleSourceLabel.hidden = NO;
        self.mutipleImageKeywordLabel.hidden = NO;
        self.mutipleSeperatorLine.hidden = NO;
        
        self.multipleImageLabel.text = titleHtml;
        self.multipleImageLabel.frame = self.cardFrame.multipleImageTitleLabelFrame;
    
        self.mutipleImageKeywordLabel.frame = self.cardFrame.multipleImageKeywordFrame;
        self.mutipleImageKeywordLabel.text = keyword;
//        self.mutipleImageKeywordLabel.backgroundColor = [UIColor colorFromHexString:concern.keywordColor];
        self.mutipleImageKeywordLabel.backgroundColor = [UIColor colorFromHexString:@"#FF7F50"];
     
        self.multipleSourceLabel.frame = self.cardFrame.multipleImageSourceLabelFrame;
        self.multipleSourceLabel.text = source;
        self.multipleSourceLabel.centerY = self.mutipleImageKeywordLabel.centerY;
        
        self.mutipleSeperatorLine.frame = self.cardFrame.mutipleImageSeperatorLineFrame;
        
        CGRect frame = self.cardFrame.multipleImageViewFrame;
        CGFloat x = frame.origin.x;
        CGFloat y = frame.origin.y;
        CGFloat w = (frame.size.width - 6) / 3 ;
        CGFloat h = frame.size.height;
        
        NSInteger width = floor(w);
        NSInteger height = floor(h);
        NSMutableArray *imageArray = [[NSMutableArray alloc] init];
        for (CardImage * cardImage in card.cardImages.allObjects) {
            NSString *imageURL = [self scaleImageURL:cardImage.imgUrl];
            [imageArray addObject:imageURL];
        }
        
        [self.firstMutipleImageView sd_setImageWithURL:[NSURL URLWithString:imageArray[0]] placeholderImage:[UIImage imageNamed:@"单图小图占位图"]];
        [self.secondMutipleImageView sd_setImageWithURL:[NSURL URLWithString:imageArray[1]] placeholderImage:[UIImage imageNamed:@"单图小图占位图"]];
        [self.thirdMutipleImageView sd_setImageWithURL:[NSURL URLWithString:imageArray[2]] placeholderImage:[UIImage imageNamed:@"单图小图占位图"]];
        
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

#pragma mark - 图片缩放处理
- (NSString *)scaleImageURL:(NSString *)imageURL width:(NSInteger)width height:(NSInteger)height {
    NSRange range = [imageURL rangeOfString:@"/" options:NSBackwardsSearch];
    NSString *substring = [imageURL substringFromIndex:range.location+1];
    NSString *scaleImageURL = [NSString stringWithFormat:@"http://pro-pic.deeporiginalx.com/%@@1e_1c_0o_0l_100sh_%ldh_%ldw_100q.src", substring, height, width];
    return scaleImageURL;
}

- (NSString *)scaleImageURL:(NSString *)imageURL {
    NSRange range = [imageURL rangeOfString:@"/" options:NSBackwardsSearch];
    NSString *substring = [imageURL substringFromIndex:range.location+1];
    NSString *scaleImageURL = [NSString stringWithFormat:@"http://pro-pic.deeporiginalx.com/%@@1e_1c_0o_0l_100sh_200h_300w_100q.src", substring];
    return scaleImageURL;
}

@end
