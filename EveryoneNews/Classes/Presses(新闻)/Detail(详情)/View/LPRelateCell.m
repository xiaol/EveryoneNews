//
//  LPRelateCell.m
//  EveryoneNews
//
//  Created by apple on 15/6/12.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPRelateCell.h"
#import "LPWaterfallView.h"
#import "LPRelatePoint.h"
#import "UIImageView+WebCache.h"

@interface LPRelateCell()
@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UILabel *titleLabel;
@end


@implementation LPRelateCell

+ (instancetype)cellWithWaterfallView:(LPWaterfallView *)waterfallView
{
    static NSString *ID = @"RELATE";
    LPRelateCell *cell = [waterfallView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LPRelateCell alloc] init];
        cell.identifier = ID;
    }
    return cell;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        self.imageView = imageView;
        
        UILabel *titleLabel = [[UILabel alloc] init];
#pragma mark - 颜色需设置
        titleLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.24];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.numberOfLines = 2;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    
    CGFloat titleW = self.bounds.size.width;
    CGFloat titleH = 28;
    CGFloat titleX = 0;
    CGFloat titleY = self.bounds.size.height - titleH;
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
}

- (void)setRelatePoint:(LPRelatePoint *)relatePoint
{
    _relatePoint = relatePoint;
    
    self.titleLabel.text = relatePoint.title;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:relatePoint.img] placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

@end


