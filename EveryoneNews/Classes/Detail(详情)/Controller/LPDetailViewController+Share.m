//
//  LPDetailViewController+Share.m
//  EveryoneNews
//
//  Created by dongdan on 16/4/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPDetailViewController+Share.h"
#import "MBProgressHUD+MJ.h"
#import "UMSocial.h"


@implementation LPDetailViewController (Share)

// 提示信息
-(void)shareSucess {
    [self removeBackgroundView];
    [MBProgressHUD showSuccess:@"分享成功"];
}

-(void)shareFailure {
    [self removeBackgroundView];
    [MBProgressHUD showError:@"分享失败"];
}


// 朋友圈按钮
- (void)shareToWechatTimelineBtnClick {
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url: self.shareImageURL];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb ;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.shareURL;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.shareTitle image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            [self shareSucess];
        }
        else {
            [self shareFailure];
        }
    }];
}

// 微信好友
- (void)shareToWechatSessionBtnClick {
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url: self.shareImageURL];
    [UMSocialData defaultData].extConfig.wxMessageType=UMSocialYXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.shareURL;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.shareTitle image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            [self shareSucess];
            
        }
    }];
}

// qq 好友
- (void)shareToQQBtnClick {
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:[NSString stringWithFormat:@"%@ %@", self.shareTitle, self.shareURL] image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            [self shareSucess];
        }
    }];
}

// 新浪微博
- (void)shareToSinaBtnClick {
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url: self.shareImageURL];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"%@ %@", self.shareTitle, self.shareURL] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
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
    NSString *url = [NSString stringWithFormat:@"%@ %@", self.shareTitle, self.shareURL];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSms] content:url image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            [self shareSucess];
        }
    }];
}

// 邮件分享
- (void)shareToEmailBtnClick {
    NSString *url = self.shareURL;
    [UMSocialData defaultData].extConfig.title =[NSString stringWithFormat:@"【奇点资讯】%@",self.shareTitle];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToEmail] content:url image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            [self shareSucess];
        }
    }];
}

// 转发链接
- (void)shareToLinkBtn {
    NSString *url = [NSString stringWithFormat:@"%@ %@", self.shareTitle, self.shareURL] ;
    UIPasteboard *gpBoard = [UIPasteboard generalPasteboard];
    gpBoard.string=url;
    [self removeBackgroundView];
    [MBProgressHUD showSuccess:@"复制成功"];
}




@end
