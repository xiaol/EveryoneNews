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
    double topViewHeight = 44;
    double btnReturnWidth = 10;
    double btnReturnHeight = 18;
    double btnCommentWidth = 18;
    double btnCommentHeight = 18;
    double btnWidth = 17.5;
    double btnHeight = 17;
    double marginRight = 25;
    double padding = 13;
    double spacing = 35;
    if(iPhone6Plus)
    {
        topViewHeight = 44;
        btnCommentWidth = 20;
        btnCommentHeight = 20;
        btnWidth = 19;
        btnHeight = 19;
        padding = 18;
        marginRight = 25;
        spacing = 35;
    }
    self = [super initWithFrame:frame];
    if (self) {
        // 定义顶部视图
        self.frame = CGRectMake(0 , 0, ScreenWidth, topViewHeight);
        [self setBackgroundColor:[UIColor colorFromHexString:@"#f6f6f7"]];
        // 返回button
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, btnReturnWidth, btnReturnHeight)];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"详情页返回"] forState:UIControlStateNormal];
        [backBtn setEnlargedEdgeWithTop:20 left:10 bottom:10 right:20];
        
        backBtn.centerY = self.centerY;
        [backBtn addTarget:self action:@selector(topViewBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        
        // 添加按钮
        UIButton *addBtn=[[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-btnWidth-marginRight, 0, btnWidth, btnHeight)];
        [addBtn setBackgroundImage:[UIImage imageNamed:@"详情页专辑"] forState:UIControlStateNormal];
        [addBtn setEnlargedEdgeWithTop:20 left:10 bottom:10 right:20];
        addBtn.centerY = self.centerY;
        [self addSubview:addBtn];
        
        // 添加分享按钮
        UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-marginRight-2*btnWidth-spacing, 0, btnWidth, btnHeight)];
        [shareBtn setImage:[UIImage imageNamed:@"详情页分享"]  forState:UIControlStateNormal];
        [shareBtn setEnlargedEdgeWithTop:20 left:10 bottom:10 right:20];
        shareBtn.centerY = self.centerY;
        [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shareBtn];
        
        // 评论按钮
        UIButton *commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - marginRight - 3*btnWidth - 2*spacing, 0, btnCommentWidth, btnCommentHeight)];
        
        [commentBtn setImage:[UIImage imageNamed:@"详情页评论"]   forState:UIControlStateNormal];
        [commentBtn setEnlargedEdgeWithTop:20 left:10 bottom:10 right:20];
        commentBtn.centerY = self.centerY + 1;
        [commentBtn addTarget:self action:@selector(fulltextCommentBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:commentBtn];
        
        // 分割线
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, ScreenWidth, 1)];
        label.backgroundColor = [UIColor colorFromHexString:@"#cacaca"];
        [self addSubview:label];
        
        // 评论条数
        self.commentCountView = [[UIView alloc] init];
        self.commentCountView.backgroundColor = [UIColor colorFromHexString:@"#ff5454"];
        self.commentCountView.layer.cornerRadius = 5.0;
        
        self.commentLabel = [[UILabel alloc] init];
        self.commentCountView.hidden = YES;
        [self.commentCountView addSubview:self.commentLabel];
        [self addSubview:self.commentCountView];
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
    NSString *fulltextCount = [NSString stringWithFormat:@"%d", badgeNumber];
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
