//
//  LPDetailTopView.m
//  EveryoneNews
//
//  Created by dongdan on 15/11/19.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPDetailTopView.h"

@interface LPDetailTopView ()
@property (nonatomic, strong) UIView *commentCountView;
@property (nonatomic, strong) UILabel *commentLabel;
@end

@implementation LPDetailTopView

- (instancetype)initWithFrame:(CGRect)frame {
    // 分享，评论，添加按钮边距设置
    double topViewHeight = 64;
    
    double returnButtonWidth = 10;
    double returnButtonHeight = 17;
    double returnButtonPaddingTop = 33.5f;
    
    double shareButtonWidth = 17;
    double shareButtonHeight = 17;
    double shareButtonPaddingTop = 33.5f;
    double shareButtonPaddingRight = 15;
   
    if(iPhone6Plus)
    {
        topViewHeight = 64;
        
        returnButtonWidth = 11;
        returnButtonHeight = 19;
        returnButtonPaddingTop = 30.5f;
        
        shareButtonWidth = 17;
        shareButtonHeight = 19;
        shareButtonPaddingTop = 30.5f;
    }
    
  
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
//        // 定义顶部视图
//        self.frame = CGRectMake(0 , 0, ScreenWidth, topViewHeight);
//        self.backgroundColor = [UIColor whiteColor];
//        
//        UIButton *popBtn = [[UIButton alloc] initWithFrame:CGRectMake(DetailCellPadding, DetailCellPadding * 2, 34, 34)];
//        popBtn.enlargedEdge = 5;
//        [popBtn setImage:[UIImage resizedImageWithName:@"back"] forState:UIControlStateNormal];
//        popBtn.backgroundColor = [UIColor clearColor];
//        popBtn.alpha = 0.8;
//        [popBtn addTarget:self action:@selector(topViewBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:popBtn];
        
        // 定义顶部视图
        self.frame = CGRectMake(0 , 0, ScreenWidth, topViewHeight);
        [self setBackgroundColor:[UIColor whiteColor]];
        
        // 返回button
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, returnButtonPaddingTop, returnButtonWidth, returnButtonHeight)];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"详情页返回"] forState:UIControlStateNormal];
        backBtn.enlargedEdge = 15;
        [backBtn addTarget:self action:@selector(topViewBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
//        
//        // 添加分享按钮
//        UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth  - shareButtonPaddingRight - shareButtonWidth, shareButtonPaddingTop, shareButtonWidth, shareButtonHeight)];
//        [shareBtn setBackgroundImage:[UIImage imageNamed:@"详情页分享"]  forState:UIControlStateNormal];
//        shareBtn.enlargedEdge = 15;
//        [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:shareBtn];
        
        // 分割线
        UILabel *seperatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, topViewHeight - 0.5, ScreenWidth, 0.5)];
        seperatorLabel.backgroundColor = [UIColor colorFromHexString:@"#cbcbcb"];
        [self addSubview:seperatorLabel];
    }
    return self;
}
//  返回
- (void)topViewBackBtnClick {
    if([self.delegate respondsToSelector:@selector(topViewBackBtnClick)]){
        [self.delegate topViewBackBtnClick];
    }
}
// 分享
- (void)shareBtnClick {
    if([self.delegate respondsToSelector:@selector(shareBtnClick)]){
        [self.delegate shareBtnClick];
    }
}
// 评论
- (void)fulltextCommentBtnClick {
    if([self.delegate respondsToSelector:@selector(fulltextCommentBtnClick)]){
        [self.delegate fulltextCommentBtnClick];
    }
}
// 判断评论数量是否为0

- (void) setBadgeNumber:(NSInteger)badgeNumber {
    _badgeNumber = badgeNumber;
    double btnWidth = 17.5;
    double marginRight = 25;
    double spacing = 35;
    double paddingLeft = 0;
    double commentViewWidth = 0;
    double commentViewHeight = 0;
    if(iPhone6Plus)
    {
        btnWidth = 19;
        marginRight = 25;
        spacing = 35;
    }
    if(badgeNumber < 10){
        paddingLeft = 12;
        commentViewWidth = 16;
        commentViewHeight = 10;
    }
    else if(badgeNumber < 100){
        paddingLeft = 12;
        commentViewWidth = 20;
        commentViewHeight = 10;
    }
    else if(badgeNumber < 1000){
        paddingLeft = 9;
        commentViewWidth = 30;
        commentViewHeight = 10;
    }
    else{
        paddingLeft = 5;
        commentViewWidth = 32;
        commentViewHeight = 10;
    }
    NSString *fulltextCount = [NSString stringWithFormat:@"%ld", badgeNumber];
    if(badgeNumber > 999){
        fulltextCount = @"999+";
    }
    // 评论条数
    self.commentCountView.frame = CGRectMake(ScreenWidth - marginRight - 3*btnWidth - 2*spacing + paddingLeft, 10, commentViewWidth, commentViewHeight);
    self.commentLabel.frame = CGRectMake(0, 0, commentViewWidth, commentViewHeight);
    NSMutableAttributedString *commentString = [fulltextCount attributedStringWithFont:[UIFont systemFontOfSize:10] color:[UIColor whiteColor] lineSpacing:0];
    self.commentLabel.attributedText = commentString;
    self.commentLabel.textAlignment = NSTextAlignmentCenter;
    if(badgeNumber != 0 ) {
        self.commentCountView.hidden = NO;
    }
    else {
        self.commentCountView.hidden = YES;
    }
}
@end
