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
    double topViewHeight = 64;
    
    double returnButtonWidth = 10;
    double returnButtonHeight = 17;
    double returnButtonPaddingTop = 33.5f;
    
    double commentButtonWidth = 50;
    double commentButtonHeight = 20;
    double commentButtonPaddingTop = 33.5;
    double commentButtonPaddingRight = 15;
    
    if(iPhone6Plus)
    {
        returnButtonWidth = 11;
        returnButtonHeight = 19;
        returnButtonPaddingTop = 30.5f;
    }

    self = [super initWithFrame:frame];
    if (self) {

        // 定义顶部视图
        self.frame = CGRectMake(0 , 0, ScreenWidth, topViewHeight);
        self.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6"];

        // 返回button
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, returnButtonPaddingTop, returnButtonWidth, returnButtonHeight)];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"详情页返回"] forState:UIControlStateNormal];
        backBtn.enlargedEdge = 15;
        [backBtn addTarget:self action:@selector(topViewBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
 
        // 评论数矩形框
        UIImage *image = [UIImage imageNamed:@"评论数矩形框"];
        
        // 设置端盖的值
        CGFloat top = image.size.height * 0.5;
        CGFloat left = image.size.width * 0.5;
        CGFloat bottom = image.size.height * 0.5;
        CGFloat right = image.size.width * 0.5;

        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
        
        // 拉伸图片
        UIImage *newImage = [image resizableImageWithCapInsets:edgeInsets];
        UIButton *commentsCountButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - commentButtonPaddingRight - commentButtonWidth, commentButtonPaddingTop, commentButtonWidth, commentButtonHeight)];
        [commentsCountButton setBackgroundImage:newImage forState:UIControlStateNormal];
        commentsCountButton.titleLabel.font = [UIFont systemFontOfSize:12];//title字体大小
        commentsCountButton.titleEdgeInsets = UIEdgeInsetsMake(-3, 0, 0, 0);
        [commentsCountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
        commentsCountButton.hidden = YES;
        [commentsCountButton addTarget:self action:@selector(fulltextCommentBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:commentsCountButton];
        self.commentsCountButton = commentsCountButton;
        
        
        // 分割线
        UILabel *seperatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, topViewHeight - 0.5, ScreenWidth, 0.5)];
        seperatorLabel.backgroundColor = [UIColor colorFromHexString:@"#cbcbcb"];
        [self addSubview:seperatorLabel];
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

// 评论
- (void)fulltextCommentBtnClick {
    if([self.delegate respondsToSelector:@selector(fulltextCommentDidClick:)]){
        [self.delegate fulltextCommentDidClick:self];
    }
}

// 判断评论数量是否为0
- (void) setBadgeNumber:(NSInteger)badgeNumber {
    _badgeNumber = badgeNumber;
    NSString *fulltextCommentCount = [NSString stringWithFormat:@"%d评论", _badgeNumber];

    double commentButtonWidth = 50;
    double commentButtonHeight = 20;
    double commentButtonPaddingTop = 33.5;
    double commentButtonPaddingRight = 15;
   
    if (_badgeNumber < 10 ) {
        commentButtonWidth = 50;
        self.commentsCountButton.frame = CGRectMake(ScreenWidth - commentButtonPaddingRight - commentButtonWidth, commentButtonPaddingTop, commentButtonWidth, commentButtonHeight);
    } else if (_badgeNumber < 100) {
        commentButtonWidth = 50;
        self.commentsCountButton.frame = CGRectMake(ScreenWidth - commentButtonPaddingRight - commentButtonWidth, commentButtonPaddingTop, commentButtonWidth, commentButtonHeight);
    } else if (_badgeNumber < 1000) {
        commentButtonWidth = 60;
        self.commentsCountButton.frame = CGRectMake(ScreenWidth - commentButtonPaddingRight - commentButtonWidth, commentButtonPaddingTop, commentButtonWidth, commentButtonHeight);
    } else if (_badgeNumber < 10000) {
        commentButtonWidth = 70;
        self.commentsCountButton.frame = CGRectMake(ScreenWidth - commentButtonPaddingRight - commentButtonWidth, commentButtonPaddingTop, commentButtonWidth, commentButtonHeight);
    } else {
        commentButtonWidth = 80;
        fulltextCommentCount = @"10000+评论";
        self.commentsCountButton.frame = CGRectMake(ScreenWidth - commentButtonPaddingRight - commentButtonWidth, commentButtonPaddingTop, commentButtonWidth, commentButtonHeight);
    }
    [self.commentsCountButton setTitle:fulltextCommentCount forState:UIControlStateNormal];
    if(_badgeNumber != 0 ) {
        self.commentsCountButton.hidden = NO;
    }
    else {
        self.commentsCountButton.hidden = YES;
    }
 
}
@end
