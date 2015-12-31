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
 

@interface LPHomeViewCell ()
// 无图
@property (nonatomic, strong) UILabel *noImageLabel;
@property (nonatomic, strong) UILabel *noImageSourceLabel;
@property (nonatomic, strong) UIView *noImageSeperatorLine;

// 单图
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *singleSourceLabel;
@property (nonatomic, strong) UIView *singleSeperatorLine;

// 三图
@property (nonatomic, strong) UILabel *multipleImageLabel;
@property (nonatomic, strong) UIImageView *firstMutipleImageView;
@property (nonatomic, strong) UIImageView *secondMutipleImageView;
@property (nonatomic, strong) UIImageView *thirdMutipleImageView;
@property (nonatomic, strong) UILabel *multipleSourceLabel;
@property (nonatomic, strong) UIView *mutipleSeperatorLine;


@end

@implementation LPHomeViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        // 无图
        UILabel *noImageLabel = [[UILabel alloc] init];
        noImageLabel.textColor = LPColor(43, 43 ,43);
        noImageLabel.font = [UIFont fontWithName:OpinionFontName size:ConcernPressTitleFontSize];
        noImageLabel.clipsToBounds = YES;
        noImageLabel.numberOfLines = 0;
        [self.contentView addSubview:noImageLabel];
        self.noImageLabel = noImageLabel;
        
        UILabel *noImageSourceLabel = [[UILabel alloc] init];
        noImageSourceLabel.font = [UIFont fontWithName:OpinionFontName size:10];
        noImageSourceLabel.textColor = [UIColor colorFromHexString:@"7c7c7c"];
        [self.contentView addSubview:noImageSourceLabel];
        self.noImageSourceLabel= noImageSourceLabel;

        UIView *noImageSeperatorLine = [[UIView alloc] init];
        noImageSeperatorLine.backgroundColor = [UIColor colorFromHexString:@"dadada"];
        [self.contentView addSubview:noImageSeperatorLine];
        self.noImageSeperatorLine = noImageSeperatorLine;
        
        // 单图
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.layer.cornerRadius = 2.0;
        iconView.contentMode = UIViewContentModeScaleAspectFill;
        iconView.clipsToBounds = YES;
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = LPColor(43, 43 ,43);
        titleLabel.font = [UIFont fontWithName:OpinionFontName size:ConcernPressTitleFontSize];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UILabel *singleSourceLabel = [[UILabel alloc] init];
        singleSourceLabel.font = [UIFont fontWithName:OpinionFontName size:10];
        singleSourceLabel.textColor = [UIColor colorFromHexString:@"7c7c7c"];
        [self.contentView addSubview:singleSourceLabel];
        self.singleSourceLabel= singleSourceLabel;
        
        UIView *singleSeperatorLine = [[UIView alloc] init];
        singleSeperatorLine.backgroundColor = [UIColor colorFromHexString:@"dadada"];
        [self.contentView addSubview:singleSeperatorLine];
        self.singleSeperatorLine = singleSeperatorLine;
        
        //  三图及其三图以上
        UILabel *multipleImageLabel = [[UILabel alloc] init];
        multipleImageLabel.numberOfLines = 0;
        multipleImageLabel.font = [UIFont fontWithName:OpinionFontName size:ConcernPressTitleFontSize];
        multipleImageLabel.textColor = LPColor(43, 43 ,43);
        [self.contentView addSubview:multipleImageLabel];
        self.multipleImageLabel = multipleImageLabel;
        
        UIImageView *firstMutipleImageView = [[UIImageView alloc] init];
        firstMutipleImageView.layer.cornerRadius = 2.0;
        firstMutipleImageView.contentMode = UIViewContentModeScaleAspectFill;
        firstMutipleImageView.clipsToBounds = YES;
        [self.contentView addSubview:firstMutipleImageView];
        self.firstMutipleImageView = firstMutipleImageView;
        
        UIImageView *secondMutipleImageView = [[UIImageView alloc] init];
        secondMutipleImageView.layer.cornerRadius = 2.0;
        secondMutipleImageView.contentMode = UIViewContentModeScaleAspectFill;
        secondMutipleImageView.clipsToBounds = YES;
        [self.contentView addSubview:secondMutipleImageView];
        self.secondMutipleImageView = secondMutipleImageView;
        
        UIImageView *thirdMutipleImageView = [[UIImageView alloc] init];
        thirdMutipleImageView.layer.cornerRadius = 2.0;
        thirdMutipleImageView.contentMode = UIViewContentModeScaleAspectFill;
        thirdMutipleImageView.clipsToBounds = YES;
        [self.contentView addSubview:thirdMutipleImageView];
        self.thirdMutipleImageView = thirdMutipleImageView;
        
        UILabel *multipleSourceLabel = [[UILabel alloc] init];
        multipleSourceLabel.font = [UIFont fontWithName:OpinionFontName size:10];
        multipleSourceLabel.textColor = [UIColor colorFromHexString:@"7c7c7c"];
        [self.contentView addSubview:multipleSourceLabel];
        self.multipleSourceLabel = multipleSourceLabel;
        
        
        UIView *mutipleSeperatorLine = [[UIView alloc] init];
        mutipleSeperatorLine.backgroundColor = [UIColor colorFromHexString:@"dadada"];
        [self.contentView addSubview:mutipleSeperatorLine];
        self.mutipleSeperatorLine = mutipleSeperatorLine;
        
    }
    return self;
}

- (void)setCardFrame:(CardFrame *)cardFrame {
    _cardFrame = cardFrame;
    Card *card = self.cardFrame.card;
    NSString *sourceSiteName = [card.sourceSiteName  isEqualToString: @""] ? @"未知来源": card.sourceSiteName;
    NSDate *currentDate = [NSDate date];
    NSDate *updateTime = [NSDate dateWithTimeIntervalSince1970:card.updateTime.longLongValue / 1000.0];
    NSString *publishTime = nil;
    int interval = (int)[currentDate timeIntervalSinceDate: updateTime] / 60;
    
    if (interval < 60) {
        publishTime = [NSString stringWithFormat:@"%d分钟前",interval];
    } else if (interval < 1440) {
        publishTime = [NSString stringWithFormat:@"%d小时前",interval / 60];
    } else {
        // 1.创建一个时间格式化对象
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        // 2.设置时间格式化对象的样式
        formatter.dateFormat = @"MM-dd HH:mm";
        
        // 3.利用时间格式化对象对时间进行格式化
        publishTime = [formatter stringFromDate:updateTime];
    }
    
    NSString *source = [NSString stringWithFormat:@"%@    %@",sourceSiteName, publishTime];

    if(card.cardImages.count == 0) {
        self.noImageLabel.hidden = NO;
        self.noImageSourceLabel.hidden = NO;
        self.noImageSeperatorLine.hidden = NO;
        
        self.titleLabel.hidden = YES;
        self.iconView.hidden = YES;
        self.singleSourceLabel.hidden = YES;
        self.singleSeperatorLine.hidden = YES;
      
        self.multipleImageLabel.hidden = YES;
        self.firstMutipleImageView.hidden = YES;
        self.secondMutipleImageView.hidden = YES;
        self.thirdMutipleImageView.hidden = YES;
        self.multipleSourceLabel.hidden = YES;
        self.mutipleSeperatorLine.hidden = YES;
        
        self.noImageLabel.frame = self.cardFrame.noImageLabelFrame;
        self.noImageLabel.text = card.title;
        
        self.noImageSourceLabel.frame = self.cardFrame.noImageSourceLabelFrame;
        self.noImageSourceLabel.text = source;
        
        self.noImageSeperatorLine.frame = self.cardFrame.noImageSeperatorLineFrame;
        
    } else if (card.cardImages.count == 1 || card.cardImages.count == 2) {
        NSMutableArray *imageArray = [[NSMutableArray alloc] init];
        for (CardImage * cardImage in card.cardImages) {
            [imageArray addObject:cardImage.imgUrl];
        }
       [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageArray[0]] placeholderImage:[UIImage imageNamed:@"占位图"]];
        
        self.noImageLabel.hidden = YES;
        self.noImageSourceLabel.hidden = YES;
        self.noImageSeperatorLine.hidden = YES;
        
        self.titleLabel.hidden = NO;
        self.iconView.hidden = NO;
        self.singleSourceLabel.hidden = NO;
        self.singleSeperatorLine.hidden = NO;
    
        self.multipleImageLabel.hidden = YES;
        self.firstMutipleImageView.hidden = YES;
        self.secondMutipleImageView.hidden = YES;
        self.thirdMutipleImageView.hidden = YES;
        self.multipleSourceLabel.hidden = YES;
        self.mutipleSeperatorLine.hidden = YES;
        
        self.titleLabel.text = card.title;
        self.iconView.frame = self.cardFrame.singleImageImageViewFrame;
        self.titleLabel.frame = self.cardFrame.singleImageTitleLabelFrame;
        
        self.singleSourceLabel.text = source;
        self.singleSourceLabel.frame = self.cardFrame.singleImageSourceLabelFrame;
        
        self.singleSeperatorLine.frame = self.cardFrame.singleImageSeperatorLineFrame;
        
        
        
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
        
        self.multipleImageLabel.frame = self.cardFrame.multipleImageTitleLabelFrame;
        self.multipleImageLabel.text = card.title;
        
        self.multipleSourceLabel.frame = self.cardFrame.multipleImageSourceLabelFrame;
        self.multipleSourceLabel.text = source;
        
        self.mutipleSeperatorLine.frame = self.cardFrame.mutipleImageSeperatorLineFrame;
        
        NSMutableArray *imageArray = [[NSMutableArray alloc] init];
        for (CardImage * cardImage in card.cardImages) {
            [imageArray addObject:cardImage.imgUrl];
        }
        [self.firstMutipleImageView sd_setImageWithURL:[NSURL URLWithString:imageArray[0]] placeholderImage:[UIImage imageNamed:@"占位图"]];
        [self.secondMutipleImageView sd_setImageWithURL:[NSURL URLWithString:imageArray[1]] placeholderImage:[UIImage imageNamed:@"占位图"]];
        [self.thirdMutipleImageView sd_setImageWithURL:[NSURL URLWithString:imageArray[2]] placeholderImage:[UIImage imageNamed:@"占位图"]];
        
        CGRect frame = self.cardFrame.multipleImageViewFrame;
        CGFloat x = frame.origin.x;
        CGFloat y = frame.origin.y;
        CGFloat w = (frame.size.width - 6) / 3 ;
        CGFloat h = frame.size.height;
        self.firstMutipleImageView.frame = CGRectMake(x, y, w, h);
        self.secondMutipleImageView.frame = CGRectMake(x + w + 3, y, w, h);
        self.thirdMutipleImageView.frame = CGRectMake(x + 2 * w + 6, y, w, h);
    }
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

- (void)setHighlighted:(BOOL)highlighted {
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

@end
