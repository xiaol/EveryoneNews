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
@property (nonatomic, strong) UILabel *noImageCommentLabel;
@property (nonatomic, strong) UIView *noImageSeperatorLine;
@property (nonatomic, strong) UIButton *noImageDeleteButton;
@property (nonatomic, strong) UIButton *noImageTipButton;

// 单图
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *singleSourceLabel;
@property (nonatomic, strong) UILabel *singleCommentLabel;
@property (nonatomic, strong) UIView *singleSeperatorLine;
@property (nonatomic, strong) UIButton *singleDeleteButton;
@property (nonatomic, strong) UIButton *singleTipButton;

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
    
    NSString *tipString = @"刚刚看到这里，点击加载更多";
    CGFloat tipFontSize = 16;
    if(self) {
        // 无图
        UILabel *noImageLabel = [[UILabel alloc] init];
        noImageLabel.textColor = [UIColor colorFromHexString:@"#1a1a1a"];
        noImageLabel.clipsToBounds = YES;
        noImageLabel.numberOfLines = 0;
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
        [self.contentView addSubview:noImageTipButton];
        self.noImageTipButton = noImageTipButton;
        
        // 单图
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.contentMode = UIViewContentModeScaleAspectFill;
        iconView.clipsToBounds = YES;
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 0;
        titleLabel.textColor =  [UIColor colorFromHexString:@"#1a1a1a"];
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
        [self.contentView addSubview:singleTipButton];
        self.singleTipButton = singleTipButton;
        
        
        //  三图及其三图以上
        UILabel *multipleImageLabel = [[UILabel alloc] init];
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
    CGFloat lineSpacing = 2.0;
    Card *card = _cardFrame.card;
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
    
    NSString *commentsCount = [NSString stringWithFormat:@"%@评", card.commentsCount != nil ? card.commentsCount: @"0"];
    BOOL commentLabelHidden = [commentsCount isEqualToString:@"0评"] ? YES :NO;
    NSString *source = [NSString stringWithFormat:@"%@    %@",sourceSiteName, publishTime];
    
    if (card.isRead) {
        self.noImageLabel.textColor = [UIColor grayColor];
        self.titleLabel.textColor = [UIColor grayColor];
        self.multipleImageLabel.textColor = [UIColor grayColor];
    } else {
        self.noImageLabel.textColor = [UIColor colorFromHexString:@"#1a1a1a"];
        self.titleLabel.textColor = [UIColor colorFromHexString:@"#1a1a1a"];
        self.multipleImageLabel.textColor = [UIColor colorFromHexString:@"#1a1a1a"];
    }
    
    
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
        
        self.singleDeleteButton.hidden = YES;
        self.mutipleDeleteButton.hidden = YES;
        self.noImageDeleteButton.hidden = NO;
        self.mutipleCommentLabel.hidden = YES;
        
        self.noImageLabel.frame = self.cardFrame.noImageLabelFrame;
             self.noImageLabel.attributedText =   [card.title attributedStringWithFont:[UIFont systemFontOfSize:self.cardFrame.homeViewFontSize] lineSpacing:lineSpacing];
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
        self.singleTipButton.hidden = YES;
        self.mutipleTipButton.hidden = YES;
        
    } else if (card.cardImages.count == 1 || card.cardImages.count == 2) {
        CardImage * cardImage = card.cardImages.anyObject;
       [self.iconView sd_setImageWithURL:[NSURL URLWithString:cardImage.imgUrl] placeholderImage:[UIImage imageNamed:@"单图小图占位图"]];
        
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
        
        self.noImageDeleteButton.hidden = YES;
        self.mutipleDeleteButton.hidden = YES;
        self.singleDeleteButton.hidden = NO;
        
        
        self.titleLabel.attributedText =   [card.title attributedStringWithFont:[UIFont systemFontOfSize:self.cardFrame.homeViewFontSize] lineSpacing:lineSpacing];
        
        self.iconView.frame = self.cardFrame.singleImageImageViewFrame;
        self.titleLabel.frame = self.cardFrame.singleImageTitleLabelFrame;
        
        self.singleSourceLabel.text = source;
        self.singleSourceLabel.frame = self.cardFrame.singleImageSourceLabelFrame;
        
        [self.singleDeleteButton setBackgroundImage:[UIImage imageNamed:@"不感兴趣叉号"] forState:UIControlStateNormal];
        self.singleDeleteButton.frame = self.cardFrame.singleImageDeleteButtonFrame;
        
        self.singleSeperatorLine.frame = self.cardFrame.singleImageSeperatorLineFrame;
        self.singleCommentLabel.frame = self.cardFrame.singelImageCommentLabelFrame;
        self.singleCommentLabel.hidden = commentLabelHidden;
        
        self.singleCommentLabel.text = commentsCount;
        
        self.singleTipButton.frame = self.cardFrame.singleTipButtonFrame;
        self.singleTipButton.hidden = self.cardFrame.isTipButtonHidden;
        self.noImageTipButton.hidden = YES;
        self.mutipleTipButton.hidden = YES;
        
        
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
         self.multipleImageLabel.attributedText =   [card.title attributedStringWithFont:[UIFont systemFontOfSize:self.cardFrame.homeViewFontSize] lineSpacing:lineSpacing];
        
        self.noImageCommentLabel.hidden = YES;
        self.singleCommentLabel.hidden = YES;
        self.mutipleCommentLabel.hidden = NO;
        
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
        self.mutipleCommentLabel.frame = self.cardFrame.mutipleImageCommentLabelFrame;
        self.mutipleCommentLabel.hidden = commentLabelHidden;
        self.mutipleCommentLabel.text = commentsCount;
        
        self.mutipleTipButton.frame = self.cardFrame.mutipleTipButtonFrame;
        self.mutipleTipButton.hidden = self.cardFrame.isTipButtonHidden;
        self.noImageTipButton.hidden = YES;
        self.singleTipButton.hidden = YES;
        
      
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

}

- (void)setHighlighted:(BOOL)highlighted {
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
 
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

@end
