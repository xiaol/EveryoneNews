//
//  LPNewsSettingCell.m
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPNewsSettingCell.h"

NS_ASSUME_NONNULL_BEGIN

#define kTextFont [UIFont systemFontOfSize:16.f]

@implementation LPNewsSettingCell{
    
    UIImageView *leftImageView;
    UILabel *textLabel;
    UIImageView *rightImageView;
    UILabel *signOutLabel;
    
}

- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
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
        
        signOutLabel = [[UILabel alloc] init];
        [self.contentView addSubview:signOutLabel];
        signOutLabel.font = [UIFont systemFontOfSize:20.f];
        signOutLabel.textColor = [UIColor colorWithDesignIndex:2];
        signOutLabel.backgroundColor = self.backgroundColor;
        signOutLabel.textAlignment = NSTextAlignmentCenter;
        
        
        CGRect lineLayerRect = CGRectMake(0.f, kSetingCellHeight-1.f, kApplecationScreenWidth, 1.f);
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

- (void)setModel:(nonnull id)model IndexPath:(NSIndexPath *)indexPath {
    
    if (model && [model isKindOfClass:[NSDictionary class]]) {
        __weak __typeof(self)weakSelf = self;
        __weak __typeof(leftImageView)weakLeftImageView = leftImageView;
        NSDictionary *dict = (NSDictionary *)model;
        NSString *keyStr = [dict.allKeys objectAtIndex:0];
        if (indexPath.section != 3) {
            leftImageView.image = [LPNewsAssistant imageWithContentsOfFile:[NSString stringWithFormat:@"%@",keyStr]];
            textLabel.text = [dict.allValues objectAtIndex:0];
        
            [leftImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                __strong __typeof(weakLeftImageView)strongLeftImageView = weakLeftImageView;
                make.centerY.equalTo(strongSelf.mas_centerY);
                make.left.mas_equalTo(@(kLeftMargin));
                make.size.mas_equalTo(strongLeftImageView.image.size);
            }];
        }else{
            signOutLabel.text = [dict.allValues objectAtIndex:0];
            [signOutLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                make.center.equalTo(strongSelf.contentView);
                make.size.mas_equalTo(CGSizeMake(180.f, [UIFont systemFontOfSize:20.f].lineHeight));
            }];
        }
        
        if (indexPath.section == 2) {
            __weak __typeof(rightImageView)weakRightImageView = rightImageView;
            rightImageView.image = [LPNewsAssistant imageWithContentsOfFile:@"DoubleArrow"];
            [rightImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                __strong __typeof(weakRightImageView)strongRightImageView = weakRightImageView;
                make.centerY.equalTo(strongSelf.mas_centerY);
                make.right.mas_equalTo(@(-14));
                make.size.mas_equalTo(strongRightImageView.image.size);
            }];
        }
            
        [textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            __strong __typeof(weakLeftImageView)strongLeftImageView = weakLeftImageView;
            make.centerY.equalTo(strongSelf.mas_centerY);
            make.left.equalTo(strongLeftImageView.mas_right).with.mas_offset(@20);
            make.size.mas_equalTo(CGSizeMake(180.f, (kTextFont).lineHeight));
        }];
    }
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
}






@end
NS_ASSUME_NONNULL_END