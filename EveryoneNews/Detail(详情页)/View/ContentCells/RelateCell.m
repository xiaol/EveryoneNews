//
//  RelateCell.m
//  WaterFlow
//
//  Created by apple on 15/5/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "RelateCell.h"
#import "LPWaterfallView.h"
#import "Relate.h"
#import "UIImageView+WebCache.h"

@interface RelateCell()
@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UILabel *titleLabel;
@end


@implementation RelateCell

+ (instancetype)cellWithWaterfallView:(LPWaterfallView *)waterfallView
{
    static NSString *ID = @"RELATE";
    RelateCell *cell = [waterfallView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[RelateCell alloc] init];
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
        titleLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.26];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.numberOfLines = 2;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont fontWithName:kFont size:11];
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
    CGFloat titleH = 25;
    CGFloat titleX = 0;
    CGFloat titleY = self.bounds.size.height - titleH;
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
}

- (void)setRelate:(Relate *)relate
{
    _relate = relate;
    
    self.titleLabel.text = relate.title;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:relate.img] placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

@end

