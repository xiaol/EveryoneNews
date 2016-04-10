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
    [MBProgressHUD showSuccess:@"分享成功"];
}

-(void)shareFailure {
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

@end
