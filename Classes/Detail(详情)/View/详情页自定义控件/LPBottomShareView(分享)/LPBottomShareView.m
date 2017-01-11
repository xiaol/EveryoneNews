//
//  LPBottomShareView.m
//  EveryoneNews
//
//  Created by dongdan on 16/4/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPBottomShareView.h"




@implementation LPBottomShareView

- (instancetype)initWithFrame:(CGRect)frame {
    
    CGFloat controlPadding = 19;
    CGFloat controlW = 66;
    CGFloat padding1 = 30;
    CGFloat padding2 = 32;
    CGFloat padding3 = 50.5;
    CGFloat cancelButtonH = 47;
    CGFloat padding4 = 10;

    if (iPhone5) {
        padding1 = 26;
        controlW = 57;
        padding2 = 27;
        cancelButtonH = 40;
        padding3 = 48.5;
        padding4 = 8;
    }
    
    CGSize fontSize = [@"微信" sizeWithFont:[UIFont systemFontOfSize:LPFont6] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    
    
    CGFloat controlH = controlW + padding4 + fontSize.height;
    CGFloat frameH = controlH * 2 + padding1 + padding2 + padding3 + cancelButtonH;
    
    
    
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, frameH);
        
        self.backgroundColor = [UIColor colorFromHexString:LPColor9];
        
        [self addIconName:@"详情页微信朋友圈" title:@"微信朋友圈" index: -1 controlY: padding1];
        [self addIconName:@"详情页微信好友" title:@"微信好友" index: -2 controlY: padding1];
        [self addIconName:@"详情页QQ好友" title:@"QQ好友" index: -3 controlY: padding1];
        [self addIconName:@"详情页新浪微博" title:@"新浪微博" index: -4 controlY: padding1];
        [self addIconName:@"详情页短信" title:@"短信" index: -5 controlY: padding1 + controlH + padding3];
        [self addIconName:@"详情页邮件" title:@"邮件" index: -6 controlY: padding1 + controlH + padding3];
        [self addIconName:@"详情页转发链接" title:@"转发链接" index: -7 controlY: padding1 + controlH + padding3];
        [self addIconName:@"详情页字体大小" title:@"字体大小" index: -8 controlY: padding1 + controlH + padding3];
        
        
        
        UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(controlPadding, padding1 + controlH + padding2, ScreenWidth - controlPadding * 2, 0.5)];
        seperatorView.backgroundColor = [UIColor colorFromHexString:LPColor5];
        
        [self addSubview:seperatorView];
        
        CGFloat cancelButtonY = padding1 + controlH * 2 + 50.5 + padding2;
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, cancelButtonY, ScreenWidth, cancelButtonH)];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorFromHexString:LPColor3] forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:LPFont3]];
        cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        cancelButton.backgroundColor = [UIColor colorFromHexString:LPColor11];
        [cancelButton addTarget:self action:@selector(cancelButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        
        
    }
    return self;
}


- (void)addIconName:(NSString *)iconName title:(NSString *)title index:(NSInteger) index controlY:(CGFloat)controlY {
    
    CGFloat controlPadding = 19;
    CGFloat controlW = 66;
    if (iPhone5) {

        controlW = 57;
    }
    
    CGSize fontSize = [@"微信" sizeWithFont:[UIFont systemFontOfSize:LPFont6] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    CGFloat controlH = controlW + 10 + fontSize.height;
    
    //CGFloat controlH = padding1 + (controlW + 10 + fontSize.height) * 2 + padding2 * 2 + 18 + cancelButtonH;
    
    UIControl *customerControl = [[UIControl alloc] init];
    customerControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    customerControl.tag = index;
    
    CGFloat gap = (ScreenWidth - controlPadding * 2 - controlW * 4) / 3;

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage oddityImage:iconName]];
    imageView.frame = CGRectMake(0, 0, controlW, controlW);
    [customerControl addSubview:imageView];
    
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:LPFont6] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:LPFont6];
    titleLabel.textColor = [UIColor colorFromHexString:LPColor3];
    titleLabel.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame) + 10, titleSize.width + 10, titleSize.height);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.centerX = imageView.centerX;
    
    [customerControl addSubview:titleLabel];

    switch (index) {
        case -1:
            customerControl.frame = CGRectMake(controlPadding, controlY, controlW, controlH);
            break;
        case -2:
            customerControl.frame = CGRectMake(controlPadding + controlW + gap, controlY, controlW, controlH);
            break;
        case -3:
            customerControl.frame = CGRectMake(controlPadding + controlW * 2 + gap * 2, controlY, controlW, controlH);
            break;
        case -4:
            customerControl.frame = CGRectMake(controlPadding + controlW * 3 + gap * 3, controlY, controlW, controlH);
            break;
        case -5:
            customerControl.frame = CGRectMake(controlPadding, controlY, controlW, controlH);
            break;
        case -6:
            customerControl.frame = CGRectMake(controlPadding + controlW + gap, controlY, controlW, controlH);
            break;
        case -7:
            customerControl.frame = CGRectMake(controlPadding + controlW * 2 + gap * 2, controlY, controlW, controlH);
            break;
        case -8:
            customerControl.frame = CGRectMake(controlPadding + controlW * 3 + gap * 3, controlY, controlW, controlH);
            break;
            
    }
    
    [customerControl addTarget:self action:@selector(customerControlDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:customerControl];
}

- (void)cancelButtonDidClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(shareView:cancelButtonDidClick:)]) {
        [self.delegate shareView:self cancelButtonDidClick:button];
    }
}

- (void)customerControlDidClick:(UIControl *)customerControl {
    if ([self.delegate respondsToSelector:@selector(shareView:index:)]) {
        [self.delegate shareView:self index:customerControl.tag];
    }
}
@end
