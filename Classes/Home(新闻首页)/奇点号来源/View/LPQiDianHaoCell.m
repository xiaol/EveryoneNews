//
//  LPQiDianHaoCell.m
//  EveryoneNews
//
//  Created by dongdan on 16/7/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPQiDianHaoCell.h"
#import "LPQiDianHaoFrame.h"
#import "LPQiDianHao.h"
#import "UIImageView+WebCache.h"
#import "AccountTool.h"


@interface LPQiDianHaoCell()

@property (nonatomic, strong) UIImageView *concernImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *concernCountLabel;
@property (nonatomic, strong) UIView *seperatorView;
@property (nonatomic, copy) NSString *concernState;


@end

@implementation LPQiDianHaoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
        UIImageView *concernImageView = [[UIImageView alloc] init];
        concernImageView.layer.cornerRadius = 5;
        concernImageView.clipsToBounds = YES;
        [self.contentView addSubview:concernImageView];
        self.concernImageView = concernImageView;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:LPFont2];
        titleLabel.textColor = [UIColor colorFromHexString:LPColor3];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UILabel *concernCountLabel = [[UILabel alloc] init];
        concernCountLabel.font = [UIFont systemFontOfSize:LPFont5];
        concernCountLabel.textColor = [UIColor colorFromHexString:LPColor4];
        [self.contentView addSubview:concernCountLabel];
        self.concernCountLabel = concernCountLabel;
        
        UIView *seperatorView = [[UIView alloc] init];
        seperatorView.backgroundColor = [UIColor colorFromHexString:LPColor5];
        [self.contentView addSubview:seperatorView];
        self.seperatorView = seperatorView;

    }
    return self;
}

- (void)setQiDianHaoFrame:(LPQiDianHaoFrame *)qiDianHaoFrame {
    _qiDianHaoFrame = qiDianHaoFrame;
    LPQiDianHao *qiDianHao = qiDianHaoFrame.qiDianHao;
    
    self.concernState = [NSString stringWithFormat:@"%ld", qiDianHao.concernFlag];
    
    
 

    self.concernImageView.frame = qiDianHaoFrame.concernImageViewF;
    
    NSInteger m = arc4random() % 4;
    NSString *imageName = [NSString stringWithFormat:@"r_q%d", (m + 1)];
    [self.concernImageView sd_setImageWithURL:[NSURL URLWithString:qiDianHao.imageViewURL] placeholderImage:[UIImage oddityImage:imageName]];

    self.titleLabel.frame = qiDianHaoFrame.titleLabelF;
    self.titleLabel.text = qiDianHao.name;
    
    self.concernCountLabel.frame = qiDianHaoFrame.concernCountLabelF;
    
    NSString *concernStr = @"";
    if (qiDianHao.concernCount > 10000) {
        concernStr = [NSString stringWithFormat:@"%.1f万", (qiDianHao.concernCount / 10000.00f)];
    } else {
        concernStr = [NSString stringWithFormat:@"%d", qiDianHao.concernCount];
    }
    
    
    self.concernCountLabel.hidden = (qiDianHao.concernCount > 0) ? NO : YES;
    
    NSString *concernCount = [NSString stringWithFormat:@"%@人关注",concernStr] ;
    self.concernCountLabel.text = concernCount;
    

    
    self.seperatorView.frame = qiDianHaoFrame.seperatorLineF;
    
    
}

/**
 *  点击关注按钮
 */
- (void)concernButtonDidClick {
    if ([self.delegate respondsToSelector:@selector(cell:didClickConcernButtonWithConcernState:sourceName:qiDianHaoFrame:)]) {
        [self.delegate cell:self didClickConcernButtonWithConcernState:self.concernState sourceName:self.titleLabel.text qiDianHaoFrame:self.qiDianHaoFrame];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

@end
