//
//  LPDetailTopView.m
//  EveryoneNews
//
//  Created by dongdan on 15/11/19.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPDetailTopView.h"

@interface LPDetailTopView ()

@property (nonatomic, strong) UIButton *commentsCountButton;
@end

@implementation LPDetailTopView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    // 分享，评论，添加按钮边距设置
    double topViewHeight = TabBarHeight + StatusBarHeight + 0.5;
    double padding = 15;
    
    double returnButtonWidth = 13;
    double returnButtonHeight = 22;
    
    if (iPhone6Plus) {
        returnButtonWidth = 12;
        returnButtonHeight = 21;
    }
   
    
    double shareButtonW = 25;
    double shareButtonH = 5;
    double shareButtonX = ScreenWidth - padding - shareButtonW;
    
    if (iPhone6) {
        topViewHeight = 72;
    }
    double returnButtonPaddingTop = (topViewHeight - returnButtonHeight + StatusBarHeight) / 2;

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
 
        // 详情页右上角分享
        UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(shareButtonX, 0 , shareButtonW, shareButtonH)];
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"详情页右上分享"] forState:UIControlStateNormal];
        shareBtn.centerY = backBtn.centerY;
        shareBtn.enlargedEdge = 15;
        [shareBtn addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shareBtn];
        self.shareButton = shareBtn;
        
        // 分割线
        UILabel *seperatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, topViewHeight - 0.5, ScreenWidth, 0.5)];
        seperatorLabel.backgroundColor = [UIColor colorFromHexString:@"#dddddd"];
        [self addSubview:seperatorLabel];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollsToTopTap)];
       // [self addGestureRecognizer:tapGesture];
    }
    return self;
}


#pragma mark - delegate
// 返回
- (void)topViewBackBtnClick {
    if([self.delegate respondsToSelector:@selector(backButtonDidClick:)]){
        [self.delegate backButtonDidClick:self];
    }
}

- (void)shareButtonClick {
    if ([self.delegate respondsToSelector:@selector(shareButtonDidClick:)]) {
        [self.delegate shareButtonDidClick:self];
    }
    
}

- (void)scrollsToTopTap {
    if ([self.delegate respondsToSelector:@selector(detailTopViewDidTap:)]) {
        [self.delegate detailTopViewDidTap:self];
    }
}
@end
