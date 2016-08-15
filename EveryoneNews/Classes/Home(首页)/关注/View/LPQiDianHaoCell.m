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
@property (nonatomic, strong) UIButton *concernButton;
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
        
        UIButton *concernButton = [[UIButton alloc] init];
        concernButton.layer.borderColor = [UIColor colorFromHexString:@"#e71f19"].CGColor;
        concernButton.layer.borderWidth = 1.0f;
        concernButton.clipsToBounds = YES;
        concernButton.layer.cornerRadius = 5.0;
        [concernButton setTitle:@"关注" forState:UIControlStateNormal];
        [concernButton setTitleColor:[UIColor colorFromHexString:@"#e71f19"] forState:UIControlStateNormal];
        concernButton.titleLabel.font = [UIFont systemFontOfSize:LPFont4];
        [self.contentView addSubview:concernButton];
        [concernButton addTarget:self action:@selector(concernButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
        self.concernButton = concernButton;
        
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
    
    
    // 待调整
   if (![AccountTool account]) {
       [self.concernButton setTitle:@"关注" forState:UIControlStateNormal];
       [self.concernButton setTitleColor:[UIColor colorFromHexString:@"#e71f19"] forState:UIControlStateNormal];
       self.concernButton.layer.borderColor = [UIColor colorFromHexString:@"#e71f19"].CGColor;
   } else {
       if (qiDianHao.concernFlag == 0) {
           [self.concernButton setTitle:@"关注" forState:UIControlStateNormal];
           [self.concernButton setTitleColor:[UIColor colorFromHexString:@"#e71f19"] forState:UIControlStateNormal];
           self.concernButton.layer.borderColor = [UIColor colorFromHexString:@"#e71f19"].CGColor;
       } else {
           [self.concernButton setTitle:@"取消" forState:UIControlStateNormal];
           [self.concernButton setTitleColor:[UIColor colorWithHexString:LPColor4] forState:UIControlStateNormal];
           self.concernButton.layer.borderColor = [UIColor colorWithHexString:LPColor4].CGColor;
       }
   }
    
    

    self.concernImageView.frame = qiDianHaoFrame.concernImageViewF;
    
    NSInteger m = arc4random() % 4;
    NSString *imageName = [NSString stringWithFormat:@"r_q%d", (m + 1)];
    [self.concernImageView sd_setImageWithURL:[NSURL URLWithString:qiDianHao.imageViewURL] placeholderImage:[UIImage imageNamed:imageName]];

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
    
    self.concernButton.frame = qiDianHaoFrame.concernButtonF;
    self.concernButton.centerY = self.concernImageView.centerY;
    
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

@end
