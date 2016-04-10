//
//  LPShareViewController.m
//  EveryoneNews
//
//  Created by dongdan on 15/11/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPShareViewController.h"
#import "MBProgressHUD+MJ.h"
#import "UMSocial.h"
#import "MainNavigationController.h"
#import "UIImage+LP.h"


static const CGFloat MenuViewImageHeight= 45;
static const CGFloat MenuViewTitleHeight =10;
static const CGFloat MenuViewVerticalPadding =57;
static const CGFloat MenuViewHorizontalMargin =20;
static const CGFloat MenuViewHorizontalMargin1= 50;
static const CGFloat MenuViewAnimationTime =0.36;
static const CGFloat MenuViewAnimationInterval= (MenuViewAnimationTime / 6);

@interface LPShareViewController()<UIGestureRecognizerDelegate>
@end

@implementation LPShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 创建视图
    MainNavigationController *nav = (MainNavigationController *)self.navigationController;
    nav.popRecognizer.enabled = NO;
    [self setupSubViews];

}

-(void)viewWillAppear:(BOOL)animated
{
    self.view.userInteractionEnabled=NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 移除视图
    [[self.view viewWithTag:-1] removeFromSuperview];
    [[self.view viewWithTag:-2] removeFromSuperview];
    MainNavigationController *nav = (MainNavigationController *)self.navigationController;
    nav.popRecognizer.enabled = YES;
}

-(void)setupSubViews
{
    [self.view addSubview:self.blurImageView];
    // 添加遮罩层
    UIView *overlay = [[UIView alloc] initWithFrame:self.view.bounds];
    overlay.tag = -2;
    // 添加弹出按钮动画
    [self createMenuView:overlay title:@"朋友圈" icon:@"朋友圈分享" index:0];
    [self createMenuView:overlay title:@"微信好友" icon:@"微信好友分享" index:1];
    [self createMenuView:overlay title:@"QQ好友" icon:@"qq好友分享" index:2];
    [self createMenuView:overlay title:@"新浪微博" icon:@"新浪分享" index:3];
    [self createMenuView:overlay title:@"短信" icon:@"短信分享" index:4];
    [self createMenuView:overlay title:@"邮件" icon:@"邮件分享" index:5];
    [self createMenuView:overlay title:@"转发链接" icon:@"转发链接分享" index:6];
    [self.view addSubview:overlay];
 
    // 分享按钮移除动画
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(overlayTouchUpInside)];
    tapGesture.delegate = self;
    [overlay addGestureRecognizer:tapGesture];
}
// 创建自定义分享菜单
- (void)createMenuView:(UIView *)overlay title:(NSString*)title icon:(NSString *)icon index:(NSUInteger)index
{
    UIFont *labelFont=[UIFont systemFontOfSize:10];
    UIColor* labelColor =[UIColor colorFromHexString:@"#3e3e3e"];
    UIControl *viewWithButtonLabel=[[UIControl alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MenuViewImageHeight, MenuViewImageHeight)];
    imageView.image = [UIImage imageNamed:icon];
    [[imageView layer] setShadowOffset:CGSizeMake(0, 0)]; // 阴影的范围
    [[imageView layer] setShadowRadius:1]; // 阴影扩散的范围控制
    [[imageView layer] setShadowOpacity:1]; // 阴影透明度
    [[imageView layer] setShadowColor:[UIColor lightGrayColor].CGColor]; // 阴影的颜色

    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, MenuViewImageHeight+10, MenuViewImageHeight, MenuViewTitleHeight)];
    titleLabel.text = title;
    titleLabel.textColor = labelColor;
    titleLabel.font=labelFont;
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [viewWithButtonLabel addSubview:imageView];
    [viewWithButtonLabel addSubview:titleLabel];
    // 设置开始位置
    CGRect viewFrame=[self frameForButtonAtIndex:overlay  index:index];
    viewWithButtonLabel.frame = CGRectMake(overlay.bounds.size.width/2-MenuViewImageHeight/2,overlay.bounds.size.height, MenuViewImageHeight, (MenuViewImageHeight+MenuViewTitleHeight));
    [overlay addSubview: viewWithButtonLabel];
    [UIView animateWithDuration:index * MenuViewAnimationInterval animations:^{
        viewWithButtonLabel.frame = viewFrame;
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled = YES;
        viewWithButtonLabel.frame = viewFrame;
        viewWithButtonLabel.tag = index;
        [viewWithButtonLabel addTarget:self action:@selector(shareControlClick:) forControlEvents:UIControlEventTouchUpInside];
        [overlay addSubview:viewWithButtonLabel];
    }];
    
}

// 计算自定义视图的位置
- (CGRect)frameForButtonAtIndex:(UIView *)view index:(NSUInteger)index
{
    NSUInteger columnCount = 4;
    NSUInteger columnIndex = 0;
    CGFloat offsetX = MenuViewHorizontalMargin;
    CGFloat offsetY = 0;
    CGFloat itemHeight = (MenuViewImageHeight +MenuViewTitleHeight);
    CGFloat horizontalPadding = 0;
    columnIndex = index%columnCount;
    // 第一行
    if(index<4)
    {
        horizontalPadding=(view.bounds.size.width-MenuViewHorizontalMargin*2-MenuViewImageHeight*4)/3.0;
        offsetX = MenuViewHorizontalMargin;
        offsetX += (MenuViewImageHeight+horizontalPadding) * columnIndex;
        offsetY += (view.bounds.size.height-itemHeight) / 2.0;
    }
    // 第二行
    else
    {
        horizontalPadding = (view.bounds.size.width-MenuViewHorizontalMargin1*2-MenuViewImageHeight*3)/2.0;
        offsetX = MenuViewHorizontalMargin1;
        offsetX += (MenuViewImageHeight+horizontalPadding)*columnIndex;
        offsetY += (view.bounds.size.height-itemHeight) / 2.0+ (itemHeight + MenuViewVerticalPadding) ;
    }
    CGRect frame = CGRectMake(offsetX, offsetY, MenuViewImageHeight, (MenuViewImageHeight+MenuViewTitleHeight));
    return frame;
}

// 分享按钮移除动画
- (void)overlayTouchUpInside
{
    for (UIControl *view in [self.view viewWithTag:-2].subviews) {
        CGRect viewFrame = view.frame;
        viewFrame.origin.y = viewFrame.origin.y+ self.view.height;
        NSInteger index = view.tag;
        double delayInSeconds = 0;
        if(index > 3) {
            delayInSeconds = 0.3;
        }
        else {
            delayInSeconds = 0.6;
        }
        [UIView animateWithDuration:delayInSeconds animations:^{
            view.frame = viewFrame;
        } completion:^(BOOL finished) {
            // 移除视图
            [self.navigationController popViewControllerAnimated:NO];
        }];
    }
}

// 分享按钮点击事件
- (void) shareControlClick:(UIControl *)viewWithButtonLabel
{
    NSInteger index = viewWithButtonLabel.tag;
    switch (index) {
        case 0:
            [self shareToWechatTimelineBtnClick];
            break;
        case 1:
            [self shareToWechatSessionBtnClick];
            break;
        case 2:
            [self shareToQQBtnClick];
            break;
        case 3:
            [self shareToSinaBtnClick];
            break;
        case 4:
            [self shareToSmsBtnClick];
            break;
        case 5:
            [self shareToEmailBtnClick];
            break;
        case 6:
            [self shareToLinkBtn];
            break;
    }
}

// 提示信息
-(void)shareSucess
{
    [MBProgressHUD showSuccess:@"分享成功"];
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)shareFailure
{
    [MBProgressHUD showError:@"分享失败"];
    [self.navigationController popViewControllerAnimated:NO];
}


// 朋友圈按钮
- (void)shareToWechatTimelineBtnClick
{
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url: self.detailImageUrl];
    [UMSocialData defaultData].extConfig.wxMessageType =UMSocialWXMessageTypeWeb ;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url =self.detailUrl;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.detailTitle image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            [self shareSucess];
        }
        else {
            [self shareFailure];
        }
    }];
}

// 微信好友
- (void)shareToWechatSessionBtnClick
{
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url: self.detailImageUrl];
    NSString *url =self.detailUrl;
    [UMSocialData defaultData].extConfig.wxMessageType=UMSocialYXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatSessionData.url =url;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.detailTitle image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            [self shareSucess];
            
        }
    }];
}

// qq 好友
- (void)shareToQQBtnClick
{
    NSString *url =self.detailTitleWithUrl;
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    [UMSocialData defaultData].extConfig.qqData.qqMessageType=UMSocialQQMessageTypeDefault;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:url image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            [self shareSucess];
        }
    }];
}

// 新浪微博
- (void)shareToSinaBtnClick
{
    
    NSString *url =self.detailTitleWithUrl;
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url: self.detailImageUrl];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:url image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            [self shareSucess];
        }
        else {
            [self shareFailure];
        }
        
    }];
}

// 短信分享
- (void)shareToSmsBtnClick {
    NSString *url =self.detailTitleWithUrl;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSms] content:url image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            [self shareSucess];
        }
    }];
}

// 邮件分享
- (void)shareToEmailBtnClick {
    NSString *url =self.detailTitleWithUrl;
    [UMSocialData defaultData].extConfig.title =[NSString stringWithFormat:@"【奇点资讯】%@",self.detailTitle];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToEmail] content:url image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            [self shareSucess];
        }
    }];
}

// 转发链接
- (void)shareToLinkBtn {
    NSString *url =self.detailTitleWithUrl;
    UIPasteboard *gpBoard = [UIPasteboard generalPasteboard];
    gpBoard.string=url;
    [MBProgressHUD showSuccess:@"复制成功"];
    [self.navigationController popViewControllerAnimated:NO];
 
}

// 判断手势是否有效
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIControl class]]) {
        return NO;
    }else{
        return YES;
    }
}

-(void)dealloc {
//    NSLog(@"分享测试dealloc");
}
@end
