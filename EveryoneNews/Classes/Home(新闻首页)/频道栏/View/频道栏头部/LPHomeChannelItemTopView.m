//
//  LPHomeChannelItemTopView.m
//  EveryoneNews
//
//  Created by dongdan on 16/5/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPHomeChannelItemTopView.h"

@implementation LPHomeChannelItemTopView

#pragma mark - initWithFrame
- (instancetype)initWithFrame:(CGRect)frame {
    
    CGFloat topViewHeight = TabBarHeight + StatusBarHeight + 0.5;
    CGFloat padding = 12;
    
    CGFloat returnButtonWidth = 13;
    CGFloat returnButtonHeight = 22;
    
    if (iPhone6Plus) {
        returnButtonWidth = 12;
        returnButtonHeight = 21;
    }
    
    if (iPhone6) {
        topViewHeight = 72;
    }
    CGFloat returnButtonPaddingTop = (topViewHeight - returnButtonHeight + StatusBarHeight) / 2;
    
    self = [super initWithFrame:frame];
    if (self) {
        
        // 定义顶部视图
        self.frame = CGRectMake(0 , 0, ScreenWidth, topViewHeight);
        self.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6"];
        
        // 返回button
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(padding, returnButtonPaddingTop, returnButtonWidth, returnButtonHeight)];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"详情页返回"] forState:UIControlStateNormal];
        backBtn.enlargedEdge = 15;
        [backBtn addTarget:self action:@selector(topViewBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        
        // 标题名称
        NSString *title = @"频道管理";
        CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:LPFont8] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        
        CGFloat titleLabelW = titleSize.width;
        CGFloat titleLabelH = titleSize.height;
        CGFloat titleLabelX = (ScreenWidth - titleLabelW) / 2;
        CGFloat titleLabelY = (topViewHeight - titleLabelH + StatusBarHeight) / 2;
        
        UILabel *titelLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
        titelLabel.text = title;
        titelLabel.textColor = [UIColor colorFromHexString:LPColor7];
        titelLabel.font = [UIFont systemFontOfSize:LPFont8];
        
        [self addSubview:titelLabel];
        
        // 分割线
        UILabel *firstSeperatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, topViewHeight - 0.5, ScreenWidth, 0.5)];
        firstSeperatorLabel.backgroundColor = [UIColor colorFromHexString:LPColor5];
        [self addSubview:firstSeperatorLabel];
    }
    return self;
}


#pragma mark - 返回上一级
- (void)topViewBackBtnClick {
    if ([self.delegate respondsToSelector:@selector(backButtonDidClick:)]) {
        [self.delegate backButtonDidClick:self];
    }
}

@end
