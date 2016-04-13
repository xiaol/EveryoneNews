//
//  QDNewsMineViewCell.m
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPNewsMineViewCell.h"

#define kTextFont [UIFont systemFontOfSize:20.f]

@implementation LPNewsMineViewCell{
    UIImageView *leftImageView;
    UILabel *textLabel;
    UIImageView *rightImageView;
}

- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithDesignIndex:0];
        leftImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:leftImageView];
        rightImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:rightImageView];
        
        textLabel = [[UILabel alloc] init];
        [self.contentView addSubview:textLabel];
        textLabel.font = kTextFont;
        textLabel.textColor = [UIColor colorWithDesignIndex:1];
        textLabel.highlightedTextColor = [UIColor colorWithDesignIndex:1];
        self.contentView.backgroundColor = self.backgroundColor;
        textLabel.backgroundColor = self.backgroundColor;
        [self.contentView addSubview:textLabel];
        
        CGRect lineLayerRect = CGRectMake(0.f, kMineViewCellHeight-1.f, kApplecationScreenWidth, 1.f);
        CALayer *lineLayer = [CALayer layer];
        lineLayer.frame = lineLayerRect;
        lineLayer.backgroundColor = [[UIColor colorWithDesignIndex:5] CGColor];
        [self.contentView.layer addSublayer:lineLayer];
        
        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = self.backgroundColor;
        self.backgroundView = backgroundView;
        
        UIView *selectedBackgroundView = [[UIView alloc] init];
        selectedBackgroundView.backgroundColor = [UIColor colorWithDesignIndex:5];
        self.selectedBackgroundView = selectedBackgroundView;
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
}


static const CGFloat kLeftMargin = 23.f;

- (void)setModel:(nonnull id)model IndexPath:(NSIndexPath *)indexPath{
    if (model && [model isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)model;
        NSString *keyStr = [dict.allKeys objectAtIndex:0];
        leftImageView.image = [LPNewsAssistant imageWithContentsOfFile:[NSString stringWithFormat:@"%@",keyStr]];
        textLabel.text = [dict.allValues objectAtIndex:0];
        __weak __typeof(self)weakSelf = self;
        __weak __typeof(leftImageView)weakLeftImageView = leftImageView;
        
        [leftImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            __strong __typeof(weakLeftImageView)strongLeftImageView = weakLeftImageView;
            make.centerY.equalTo(strongSelf.mas_centerY);
            make.left.mas_equalTo(@(kLeftMargin));
            make.size.mas_equalTo(strongLeftImageView.image.size);
        }];
        
        __weak __typeof(rightImageView)weakRightImageView = rightImageView;
        rightImageView.image = [LPNewsAssistant imageWithContentsOfFile:@"User_singleArrow"];
        [rightImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            __strong __typeof(weakRightImageView)strongRightImageView = weakRightImageView;
            make.centerY.equalTo(strongSelf.mas_centerY);
            make.right.mas_equalTo(@(-kLeftMargin));
            make.size.mas_equalTo(strongRightImageView.image.size);
        }];
        
        [textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            __strong __typeof(weakLeftImageView)strongLeftImageView = weakLeftImageView;
            make.centerY.equalTo(strongSelf.mas_centerY);
            make.left.equalTo(strongLeftImageView.mas_right).with.mas_offset(@23);
            make.size.mas_equalTo(CGSizeMake(180.f, (kTextFont).lineHeight));
        }];
    }
    
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
}

@end
