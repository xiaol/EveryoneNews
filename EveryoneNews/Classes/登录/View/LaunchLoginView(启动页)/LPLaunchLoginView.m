//
//  LPFirstInstallationView.m
//  EveryoneNews
//
//  Created by dongdan on 16/4/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPLaunchLoginView.h"
#import "LPHttpTool.h"

@implementation LPLaunchLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 20, ScreenWidth, ScreenHeight - 20);
        
        CGFloat labelPaddingTop = 130;
        if (iPhone6Plus) {
            labelPaddingTop = 151;
        }
        CGFloat firstLabelHeight = [@"您好" heightForLineWithFont:[UIFont systemFontOfSize:20]];
        UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, labelPaddingTop, ScreenWidth, firstLabelHeight)];
        firstLabel.textAlignment = NSTextAlignmentCenter;
        firstLabel.font = [UIFont systemFontOfSize:20];
        firstLabel.textColor = [UIColor colorFromHexString:@"#1a1a1a"];
        firstLabel.text = @"智能推荐您喜欢的文章";
        [self addSubview: firstLabel];
        
        
        CGFloat secondLabelHeight = [@"您好" heightForLineWithFont:[UIFont systemFontOfSize:16]];
        UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(firstLabel.frame) + 16, ScreenWidth, secondLabelHeight)];
        secondLabel.textAlignment = NSTextAlignmentCenter;
        secondLabel.font = [UIFont systemFontOfSize:16];
        secondLabel.textColor = [UIColor colorFromHexString:@"#1a1a1a"];
        secondLabel.text = @"只需一键登录";
        [self addSubview: secondLabel];
        
        CGFloat casualLookButtonHeight = [@"您好" heightForLineWithFont:[UIFont systemFontOfSize:18]];
        UIButton *casualLookButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(secondLabel.frame) + 32, ScreenWidth, casualLookButtonHeight)];
        [casualLookButton setEnlargedEdgeWithTop:20 left:0 bottom:20 right:0];
        [casualLookButton setTitle:@"先随便看看 >" forState:UIControlStateNormal];
        [casualLookButton setTitleColor:[UIColor colorFromHexString:@"#999999"] forState:UIControlStateNormal];
        [casualLookButton addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: casualLookButton];
        
        
        CGFloat weixingPaddingLeft = 60;
        if (iPhone6Plus) {
            weixingPaddingLeft = 74;
        }
        
        UIButton *weixinBtn = [[UIButton alloc] init];
        [weixinBtn setBackgroundImage:[UIImage imageNamed:@"微信登录"] forState:UIControlStateNormal];
        weixinBtn.frame = CGRectMake(weixingPaddingLeft, CGRectGetMaxY(casualLookButton.frame) + 113, 75, 75);
        [weixinBtn addTarget:self action:@selector(weixinLogin) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:weixinBtn];
        
        CGFloat weixinLabelHeight = [@"您好" heightForLineWithFont:[UIFont systemFontOfSize:14]];
        UILabel *weixinLabel = [[UILabel alloc] initWithFrame:CGRectMake(weixingPaddingLeft, CGRectGetMaxY(weixinBtn.frame) + 12 , 75, weixinLabelHeight)];
        weixinLabel.textAlignment = NSTextAlignmentCenter;
        weixinLabel.text = @"微信登录";
        weixinLabel.font = [UIFont systemFontOfSize:14];
        weixinLabel.textColor = [UIColor colorFromHexString:@"#1a1a1a"];
        [self addSubview:weixinLabel];
        
        
        UIButton *weiboBtn = [[UIButton alloc] init];
        [weiboBtn setBackgroundImage:[UIImage imageNamed:@"微博登录"] forState:UIControlStateNormal];
        weiboBtn.frame = CGRectMake(ScreenWidth - weixingPaddingLeft - 75,CGRectGetMaxY(casualLookButton.frame) + 113, 75, 75);
        [weiboBtn addTarget:self action:@selector(weiboLogin) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:weiboBtn];
        
        UILabel *weiboLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - weixingPaddingLeft - 75, CGRectGetMaxY(weixinBtn.frame) + 12 , 75, weixinLabelHeight)];
        weiboLabel.text = @"微博登录";
        weiboLabel.font = [UIFont systemFontOfSize:14];
        weiboLabel.textColor = [UIColor colorFromHexString:@"#1a1a1a"];
        weiboLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:weiboLabel];
    }
    return self;
}

- (void)closeBtnClick {
    if ([self.delegate respondsToSelector:@selector(didCloseLoginView:)]) {
        [self.delegate didCloseLoginView:self];
    }
}

- (void)weixinLogin {
    if ([self.delegate respondsToSelector:@selector(didWeixinLoginWithLoginView:)]) {
        [self.delegate didWeixinLoginWithLoginView:self];
    }
}

- (void)weiboLogin {
    if ([self.delegate respondsToSelector:@selector(didSinaLoginWithLoginView:)]) {
        [self.delegate didSinaLoginWithLoginView:self];
    }
}


@end
