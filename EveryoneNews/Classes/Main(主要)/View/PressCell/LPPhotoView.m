//
//  LPPhotoView.m
//  EveryoneNews
//
//  Created by apple on 15/6/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPPhotoView.h"
#import "LPPress.h"
#import "LPPressFrame.h"
#import "UIImageView+WebCache.h"

@interface LPPhotoView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *titleBgImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *categoryLabel;
@end

@implementation LPPhotoView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self addSubview:imageView];
        self.imageView = imageView;
        
        UIImageView *titleBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toum"]];
        titleBgImageView.alpha = 0.68;
        [self addSubview:titleBgImageView];
        self.titleBgImageView = titleBgImageView;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont fontWithName:@"Noto Sans S Chinese" size:20];
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UILabel *categoryLabel = [[UILabel alloc] init];
        categoryLabel.font = [UIFont systemFontOfSize:14];
        categoryLabel.textAlignment = NSTextAlignmentCenter;
        categoryLabel.textColor = [UIColor whiteColor];
        categoryLabel.numberOfLines = 0;
        categoryLabel.alpha = 0.81;
        [self addSubview:categoryLabel];
        self.categoryLabel = categoryLabel;
    }
    return self;
}

- (void)setPressFrame:(LPPressFrame *)pressFrame
{
    _pressFrame = pressFrame;
    LPPress *press = pressFrame.press;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:press.imgUrl]];
    self.imageView.frame = self.pressFrame.bgImageViewF;
    
    self.titleBgImageView.frame = self.pressFrame.titleBgViewF;
    
    self.titleLabel.text = press.title;
    self.titleLabel.frame = self.pressFrame.titleLabelF;
    
    NSString *category = [NSString stringWithFormat:@"%@\n%@", [press.category substringWithRange:NSMakeRange(0, 1)], [press.category substringFromIndex:1]];
    self.categoryLabel.text = category;
    self.categoryLabel.frame = self.pressFrame.categoryLabelF;
    self.categoryLabel.backgroundColor = [UIColor colorFromCategory:press.category];
}

@end

