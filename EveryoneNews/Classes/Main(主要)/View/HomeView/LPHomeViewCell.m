//
//  LPHomeViewCell.m
//  EveryoneNews
//
//  Created by dongdan on 15/12/16.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPHomeViewCell.h"
#import "UIImageView+WebCache.h"
#import "LPHomeViewFrame.h"
#import "Card.h"
#import "CardImage.h"

@interface LPHomeViewCell ()
// 无图
@property (nonatomic, strong) UILabel *noImageLabel;
// 单图
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;
// 三图
@property (nonatomic, strong) UILabel *multipleImageLabel;
@property (nonatomic, strong) UIImageView *firstMutipleImageView;
@property (nonatomic, strong) UIImageView *secondMutipleImageView;
@property (nonatomic, strong) UIImageView *thirdMutipleImageView;


@end

@implementation LPHomeViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"CardCellID";
    LPHomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil) {
        cell = [[LPHomeViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        // 无图
        UILabel *noImageLabel = [[UILabel alloc] init];
        self.noImageLabel = noImageLabel;
        
        // 单图
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.layer.cornerRadius = 2.0;
        iconView.contentMode = UIViewContentModeScaleAspectFill;
        iconView.clipsToBounds = YES;
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 0;
        titleLabel.font = [UIFont systemFontOfSize:ConcernPressTitleFontSize];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        //  三图及其三图以上
        
        UILabel *multipleImageLabel = [[UILabel alloc] init];
        multipleImageLabel.numberOfLines = 0;
        multipleImageLabel.font = [UIFont systemFontOfSize:ConcernPressTitleFontSize];
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
        
    }
    return self;
}

- (void)setHomeViewFrame:(LPHomeViewFrame *)homeViewFrame {
    _homeViewFrame = homeViewFrame;
    Card *card = self.homeViewFrame.card;
    if(card.cardImages.count == 0) {
        
        self.titleLabel.frame = self.homeViewFrame.noImageLabelF;
        self.titleLabel.text = card.title;
        
    } else if (card.cardImages.count == 1 || card.cardImages.count == 2) {
        
        NSMutableArray *imageArray = [[NSMutableArray alloc] init];
        for (CardImage * cardImage in card.cardImages) {
            [imageArray addObject:cardImage.imgUrl];
        }
       [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageArray[0]] placeholderImage:[UIImage imageNamed:@"占位图"]];
        self.titleLabel.text = card.title;
        self.iconView.frame = self.homeViewFrame.singleImageImageViewFrame;
        self.titleLabel.frame = self.homeViewFrame.singleImageTitleLabelFrame;
        
    } else if (card.cardImages.count >= 3) {
        self.multipleImageLabel.frame = self.homeViewFrame.multipleImageTitleLabelFrame;
        self.multipleImageLabel.text = card.title;
        
        NSMutableArray *imageArray = [[NSMutableArray alloc] init];
        for (CardImage * cardImage in card.cardImages) {
            [imageArray addObject:cardImage.imgUrl];
        }
        [self.firstMutipleImageView sd_setImageWithURL:[NSURL URLWithString:imageArray[0]] placeholderImage:[UIImage imageNamed:@"占位图"]];
        [self.secondMutipleImageView sd_setImageWithURL:[NSURL URLWithString:imageArray[1]] placeholderImage:[UIImage imageNamed:@"占位图"]];
        [self.thirdMutipleImageView sd_setImageWithURL:[NSURL URLWithString:imageArray[2]] placeholderImage:[UIImage imageNamed:@"占位图"]];
        
        CGRect frame = self.homeViewFrame.multipleImageViewFrame;
        CGFloat x = frame.origin.x;
        CGFloat y = frame.origin.y;
        CGFloat w = frame.size.width;
        CGFloat h = frame.size.height;
        self.firstMutipleImageView.frame = CGRectMake(x, y, w / 3, h);
        self.secondMutipleImageView.frame = CGRectMake(w / 3, y, w / 3, h);
        self.thirdMutipleImageView.frame = CGRectMake(2 * w / 3, y, w / 3, h);
       
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
