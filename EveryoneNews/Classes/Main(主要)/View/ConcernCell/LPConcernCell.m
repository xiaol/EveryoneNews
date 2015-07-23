//
//  LPConcernCell.m
//  EveryoneNews
//
//  Created by apple on 15/7/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPConcernCell.h"
#import "LPConcern.h"
#import "UIImageView+WebCache.h"
#import "FBShimmering.h"
#import "FBShimmeringView.h"

@interface LPConcernCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) FBShimmeringView *titleShimmeringView;
@end

@implementation LPConcernCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorFromHexString:@"c3c3c3"];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
        
//        UILabel *titleLabel = [[UILabel alloc] init];
//        titleLabel.textAlignment = NSTextAlignmentCenter;
//        titleLabel.textColor = [UIColor whiteColor];
//        titleLabel.font = [UIFont systemFontOfSize:18];
//        [self.contentView addSubview:titleLabel];
//        self.titleLabel = titleLabel;
//        
        UILabel *subTitleLabel = [[UILabel alloc] init];
        subTitleLabel.textAlignment = NSTextAlignmentCenter;
        subTitleLabel.textColor = [UIColor colorFromHexString:@"afb2bb"];
        subTitleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:subTitleLabel];
        self.subTitleLabel = subTitleLabel;
        
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:18];
        self.titleLabel = titleLabel;
        
        FBShimmeringView *titleShimmeringView = [[FBShimmeringView alloc] init];
        titleShimmeringView.contentView = titleLabel;
        titleShimmeringView.shimmeringAnimationOpacity = 0.5;
        titleShimmeringView.shimmeringSpeed = 45;
        titleShimmeringView.shimmeringPauseDuration = 0.4;
        titleShimmeringView.shimmeringHighlightLength = 0.6;
        [self.contentView addSubview:titleShimmeringView];
        self.titleShimmeringView = titleShimmeringView;
    }
    return self;
}

- (void)setConcern:(LPConcern *)concern {
    _concern = concern;
    
    self.imageView.frame = self.bounds;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:concern.channel_ios_img] completed:nil];
    
//    self.titleLabel.x = 0;
//    self.titleLabel.width = self.width;
//    self.titleLabel.height = 20;
//    self.titleLabel.y = self.height / 2 - 20;
//    self.titleLabel.text = concern.channel_name;
//    

    
    CGSize titleSize = [concern.channel_name sizeWithFont:[UIFont systemFontOfSize:18] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];

    self.titleShimmeringView.frame = CGRectMake(0, self.height / 2 - 20, titleSize.width, titleSize.height);
    self.titleShimmeringView.centerX = self.centerX;
    self.titleLabel.frame = self.titleShimmeringView.bounds;
    self.titleLabel.text = concern.channel_name;
    
    self.shimmering = YES;
    
    self.subTitleLabel.x = 0;
    self.subTitleLabel.y = CGRectGetMaxY(self.titleShimmeringView.frame) + 10;
    self.subTitleLabel.width = self.width;
    self.subTitleLabel.height = [concern.channel_des heightForLineWithFont:[UIFont systemFontOfSize:12]];
    self.subTitleLabel.text = concern.channel_des;
}

- (void)setShimmering:(BOOL)shimmering {
    _shimmering = shimmering;
    self.titleShimmeringView.shimmering = shimmering;
}
@end
