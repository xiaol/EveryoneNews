//
//  LPShareView.m
//  EveryoneNews
//
//  Created by dongdan on 16/3/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPShareView.h"
#import "NSString+LP.h"

const static CGFloat padding = 13;
const static CGFloat controlPadding = 40;
const static CGFloat controlW = 50;
const static CGFloat controlH = 70;

@interface LPShareView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *seperatorView;

@end

@implementation LPShareView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = CGRectMake(0, 0, ScreenWidth - padding * 2, 170);
        UIView *seperatorView = [[UIView alloc] init];
        seperatorView.backgroundColor = [UIColor colorFromHexString:@"#dddddd"];
        [self addSubview:seperatorView];
        self.seperatorView = seperatorView;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor colorFromHexString:@"#909090"];
        titleLabel.text = @"分享到";
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        self.seperatorView.frame = CGRectMake(padding, 40, ScreenWidth - padding * 2, 0.5);
        CGSize titleLabelSize = [self.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        self.titleLabel.frame = CGRectMake(0, 0, titleLabelSize.width + 40, titleLabelSize.height);
        self.titleLabel.center = self.seperatorView.center;
        
        [self addIconName:@"微信好友" title:@"微信好友" index:-1];
        [self addIconName:@"微信朋友圈" title:@"微信朋友圈" index:-2];
        [self addIconName:@"QQ好友" title:@"QQ好友" index:-3];
        [self addIconName:@"新浪微博" title:@"新浪微博" index:-4];
    }
    return self;
    
}

- (void)addIconName:(NSString *)iconName title:(NSString *)title index:(NSInteger) index {
    UIControl *customerControl = [[UIControl alloc] init];
    customerControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    customerControl.tag = index;

    
    CGFloat controlY = CGRectGetMaxY(self.titleLabel.frame) + 20;
    CGFloat gap = (ScreenWidth - controlPadding * 2 - 164) / 3;
    switch (index) {
        case -1:
            customerControl.frame = CGRectMake(controlPadding, controlY, controlW, controlH);
            break;
        case -2:
            customerControl.frame = CGRectMake(controlPadding + 41 + gap, controlY, controlW, controlH);
            break;
        case -3:
            customerControl.frame = CGRectMake(controlPadding + 41 * 2 + gap * 2, controlY, controlW, controlH);
            break;
        case -4:
            customerControl.frame = CGRectMake(controlPadding + 41 * 3 + gap * 3, controlY, controlW, controlH);
            break;
       
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    imageView.frame = CGRectMake(0, 0, 41, 41);
    [customerControl addSubview:imageView];
    
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textColor = [UIColor colorFromHexString:@"#9e9e9e"];
    titleLabel.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame) + 11, titleSize.width + 10, titleSize.height);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.centerX = imageView.centerX;

    [customerControl addSubview:titleLabel];
    [customerControl addTarget:self action:@selector(customerControlDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:customerControl];
}

- (void)customerControlDidClick:(UIControl *)customerControl {
    
    if ([self.delegate respondsToSelector:@selector(view:didClickAtIndex:)]) {
        [self.delegate view:self didClickAtIndex:customerControl.tag];
    }
}


@end
