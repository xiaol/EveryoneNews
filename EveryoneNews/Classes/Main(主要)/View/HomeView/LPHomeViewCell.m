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
@property (nonatomic, strong) UIButton *noImageDeleteButton;

// 单图
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *singleSourceLabel;
@property (nonatomic, strong) UIView *singleSeperatorLine;
@property (nonatomic, strong) UIButton *singleDeleteButton;

// 三图
@property (nonatomic, strong) UILabel *multipleImageLabel;
@property (nonatomic, strong) UIImageView *firstMutipleImageView;
@property (nonatomic, strong) UIImageView *secondMutipleImageView;
@property (nonatomic, strong) UIImageView *thirdMutipleImageView;
@property (nonatomic, strong) UILabel *multipleSourceLabel;
@property (nonatomic, strong) UIView *mutipleSeperatorLine;
@property (nonatomic, strong) UIButton *mutipleDeleteButton;

@end

@implementation LPHomeViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6"];
    
//    CGFloat titleFontSize = ConcernPressTitleFontSize;
    CGFloat sourceFontSize = 10;
    
    if (iPhone6) {
//        titleFontSize = 18;
        sourceFontSize = 12;
        
    } else if (iPhone6Plus) {
//        titleFontSize = 19;
        sourceFontSize = 13;
    }
    
    if(self) {
        // 无图
        UILabel *noImageLabel = [[UILabel alloc] init];
        noImageLabel.textColor = [UIColor colorFromHexString:@"#1a1a1a"];
//        noImageLabel.font = [UIFont fontWithName:OpinionFontName size:titleFontSize];
        noImageLabel.clipsToBounds = YES;
        noImageLabel.numberOfLines = 0;
        [self.contentView addSubview:noImageLabel];
        self.noImageLabel = noImageLabel;
        
        UILabel *noImageSourceLabel = [[UILabel alloc] init];
        noImageSourceLabel.font = [UIFont fontWithName:OpinionFontName size:sourceFontSize];
        noImageSourceLabel.textColor = [UIColor colorFromHexString:@"#999999"];
        [self.contentView addSubview:noImageSourceLabel];
        self.noImageSourceLabel = noImageSourceLabel;
        
        UIButton *noImageDeleteButton = [[UIButton alloc] init];
        noImageDeleteButton.userInteractionEnabled = YES;
        noImageDeleteButton.enlargedEdge = 10;
       // [noImageDeleteButton addTarget:self action:@selector(deleteCurrentCell:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:noImageDeleteButton];
        self.noImageDeleteButton = noImageDeleteButton;
        

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
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 0;
        titleLabel.textColor =  [UIColor colorFromHexString:@"#1a1a1a"];
//        titleLabel.font = [UIFont fontWithName:OpinionFontName size:titleFontSize];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UILabel *singleSourceLabel = [[UILabel alloc] init];
        singleSourceLabel.font = [UIFont fontWithName:OpinionFontName size:sourceFontSize];
        singleSourceLabel.textColor = [UIColor colorFromHexString:@"999999"];
        [self.contentView addSubview:singleSourceLabel];
        self.singleSourceLabel= singleSourceLabel;
        
        UIView *singleSeperatorLine = [[UIView alloc] init];
        singleSeperatorLine.backgroundColor = [UIColor colorFromHexString:@"e4e4e4"];
        [self.contentView addSubview:singleSeperatorLine];
        self.singleSeperatorLine = singleSeperatorLine;
        
        UIButton *singleDeleteButton = [[UIButton alloc] init];
        singleDeleteButton.userInteractionEnabled = YES;
        singleDeleteButton.enlargedEdge = 10;
        [self.contentView addSubview:singleDeleteButton];
      //  [singleDeleteButton addTarget:self action:@selector(deleteCurrentCell:) forControlEvents:UIControlEventTouchUpInside];
        self.singleDeleteButton = singleDeleteButton;
        
        
        //  三图及其三图以上
        UILabel *multipleImageLabel = [[UILabel alloc] init];
        multipleImageLabel.numberOfLines = 0;
//        multipleImageLabel.font = [UIFont fontWithName:OpinionFontName size:titleFontSize];
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
        multipleSourceLabel.font = [UIFont fontWithName:OpinionFontName size:sourceFontSize];
        multipleSourceLabel.textColor = [UIColor colorFromHexString:@"999999"];
        [self.contentView addSubview:multipleSourceLabel];
        self.multipleSourceLabel = multipleSourceLabel;
        
        UIButton *mutipleDeleteButton = [[UIButton alloc] init];
        mutipleDeleteButton.userInteractionEnabled = YES;
        mutipleDeleteButton.enlargedEdge = 10;
        [self.contentView addSubview:mutipleDeleteButton];
       // [mutipleDeleteButton addTarget:self action:@selector(deleteCurrentCell:) forControlEvents:UIControlEventTouchUpInside];

        self.mutipleDeleteButton = mutipleDeleteButton;
        
        
        UIView *mutipleSeperatorLine = [[UIView alloc] init];
        mutipleSeperatorLine.backgroundColor = [UIColor colorFromHexString:@"e4e4e4"];
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
    } else {
        publishTime = @" ";
    }

//    else if (interval < 1440) {
//        publishTime = [NSString stringWithFormat:@"%d小时前",interval / 60];
//    } else {
//        // 1.创建一个时间格式化对象
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        
//        // 2.设置时间格式化对象的样式
//        formatter.dateFormat = @"MM-dd HH:mm";
//        
//        // 3.利用时间格式化对象对时间进行格式化
//        publishTime = [formatter stringFromDate:updateTime];
//    }
    
//    NSString *commentsCount = [NSString stringWithFormat:@"%@评论", card.commentsCount != nil ? card.commentsCount: @"0"];
//    NSString *source = [NSString stringWithFormat:@"%@    %@    %@",sourceSiteName, commentsCount, publishTime];
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
        
        self.singleDeleteButton.hidden = YES;
        self.mutipleDeleteButton.hidden = YES;
        self.noImageDeleteButton.hidden = NO;
        
        self.noImageLabel.frame = self.cardFrame.noImageLabelFrame;
        self.noImageLabel.text = card.title;
        // 设置字体大小
        self.noImageLabel.font = [UIFont fontWithName:OpinionFontName size:self.cardFrame.homeViewFontSize];
        
        self.noImageSourceLabel.frame = self.cardFrame.noImageSourceLabelFrame;
        self.noImageSourceLabel.text = source;
        
        self.noImageSeperatorLine.frame = self.cardFrame.noImageSeperatorLineFrame;
        
        [self.noImageDeleteButton setBackgroundImage:[UIImage imageNamed:@"不感兴趣叉号"] forState:UIControlStateNormal];
        self.noImageDeleteButton.frame = self.cardFrame.noImageDeleteButtonFrame;
        
    } else if (card.cardImages.count == 1 || card.cardImages.count == 2) {
        CardImage * cardImage = card.cardImages.anyObject;
       [self.iconView sd_setImageWithURL:[NSURL URLWithString:cardImage.imgUrl] placeholderImage:[UIImage imageNamed:@"单图小图占位图"]];
        
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
        
        self.noImageDeleteButton.hidden = YES;
        self.mutipleDeleteButton.hidden = YES;
        self.singleDeleteButton.hidden = NO;
        
        self.titleLabel.text = card.title;
        self.titleLabel.font = [UIFont fontWithName:OpinionFontName size:self.cardFrame.homeViewFontSize];
        
        self.iconView.frame = self.cardFrame.singleImageImageViewFrame;
        self.titleLabel.frame = self.cardFrame.singleImageTitleLabelFrame;
        
        self.singleSourceLabel.text = source;
        self.singleSourceLabel.frame = self.cardFrame.singleImageSourceLabelFrame;
        
     
        
        
        [self.singleDeleteButton setBackgroundImage:[UIImage imageNamed:@"不感兴趣叉号"] forState:UIControlStateNormal];
        self.singleDeleteButton.frame = self.cardFrame.singleImageDeleteButtonFrame;
        
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
        
        self.mutipleDeleteButton.hidden = NO;
        self.singleDeleteButton.hidden = YES;
        self.noImageDeleteButton.hidden = YES;
        
        self.multipleImageLabel.frame = self.cardFrame.multipleImageTitleLabelFrame;
        self.multipleImageLabel.text = card.title;
        self.multipleImageLabel.font = [UIFont fontWithName:OpinionFontName size:self.cardFrame.homeViewFontSize];
        
        
        
        self.multipleSourceLabel.frame = self.cardFrame.multipleImageSourceLabelFrame;
        self.multipleSourceLabel.text = source;
        
        self.mutipleSeperatorLine.frame = self.cardFrame.mutipleImageSeperatorLineFrame;
        
        NSMutableArray *imageArray = [[NSMutableArray alloc] init];
        for (CardImage * cardImage in card.cardImages.allObjects) {
            [imageArray addObject:cardImage.imgUrl];
        }
        [self.firstMutipleImageView sd_setImageWithURL:[NSURL URLWithString:imageArray[0]] placeholderImage:[UIImage imageNamed:@"单图小图占位图"]];
        [self.secondMutipleImageView sd_setImageWithURL:[NSURL URLWithString:imageArray[1]] placeholderImage:[UIImage imageNamed:@"单图小图占位图"]];
        [self.thirdMutipleImageView sd_setImageWithURL:[NSURL URLWithString:imageArray[2]] placeholderImage:[UIImage imageNamed:@"单图小图占位图"]];
        
        CGRect frame = self.cardFrame.multipleImageViewFrame;
        CGFloat x = frame.origin.x;
        CGFloat y = frame.origin.y;
        CGFloat w = (frame.size.width - 6) / 3 ;
        CGFloat h = frame.size.height;
        self.firstMutipleImageView.frame = CGRectMake(x, y, w, h);
        self.secondMutipleImageView.frame = CGRectMake(x + w + 3, y, w, h);
        self.thirdMutipleImageView.frame = CGRectMake(x + 2 * w + 6, y, w, h);
        
        
        
        [self.mutipleDeleteButton setBackgroundImage:[UIImage imageNamed:@"不感兴趣叉号"] forState:UIControlStateNormal];
        self.mutipleDeleteButton.frame = self.cardFrame.mutipleImageDeleteButtonFrame;
        
      
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:NO];
//    self.noImageLabel.textColor = [UIColor redColor];
    
}

- (void)setHighlighted:(BOOL)highlighted {
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
//    self.multipleImageLabel.textColor = [UIColor redColor];
//    self.noImageLabel.textColor = [UIColor redColor];
//    self.titleLabel.textColor = [UIColor redColor];
}

//- (void)deleteCurrentCell:(UIButton *)button {
//    
//    if ([self.delegate respondsToSelector:@selector(homeViewCell:button:)]) {
//        [self. delegate homeViewCell:self button:button];
//    }
//    
////    if (self.didClickBlock) {
////        
////        self.didClickBlock(button);
////    }
////    NSLog(@"%@", button.superview);
////     NSLog(@"%@", button.superview.superview); //LPHomeViewCell
////     NSLog(@"%@", button.superview.superview.superview.superview); // UITableView
////    
////    LPHomeViewCell* cell = (LPHomeViewCell*)button.superview.superview;
////    UITableView *tableView = (UITableView*)cell.superview.superview;
////    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
////    
////    [tableView beginUpdates];
////
////    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation: UITableViewRowAnimationBottom];
////    [tableView endUpdates];
////    
//
// 
//}

@end
