//
//  LPDetailViewController+Share.m
//  EveryoneNews
//
//  Created by dongdan on 16/4/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPDetailViewController+Share.h"
#import "MBProgressHUD+MJ.h"
#import <UMSocialCore/UMSocialCore.h>


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

#pragma mark - 分享网页
- (void)shareWithPlatform:(UMSocialPlatformType)type {
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    
    
    if (type == UMSocialPlatformType_Sina) {
        //设置文本
        messageObject.text = [NSString stringWithFormat:@"%@ %@", self.shareTitle, self.shareURL];        //创建图片内容对象
        
        if (self.shareImageURL) {
            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
            //如果有缩略图，则设置缩略图
            [shareObject setShareImage:self.shareImageURL];
            
            messageObject.shareObject = shareObject;
        }
    } else if(type == UMSocialPlatformType_Sms) {
        
        UMShareSmsObject *shareObject = [[UMShareSmsObject alloc] init];
        shareObject.smsContent = [NSString stringWithFormat:@"%@ %@", self.shareTitle, self.shareURL];
      
        messageObject.shareObject = shareObject;
        
        
    } else if(type == UMSocialPlatformType_Email){
        
        messageObject.text = self.shareTitle;
        //创建网页内容对象
        UMShareWebpageObject *shareObject = nil;
      if (self.shareImageURL) {
          shareObject = [UMShareWebpageObject shareObjectWithTitle:self.shareTitle descr:self.shareTitle thumImage:self.shareImageURL];
      } else {
          shareObject = [UMShareWebpageObject shareObjectWithTitle:self.shareTitle descr:self.shareTitle thumImage:[UIImage imageNamed:@"个人中心奇点资讯"]];
      }
        shareObject.webpageUrl = self.shareURL;
        messageObject.shareObject = shareObject;
    }
    else {
        //创建网页内容对象
        UMShareWebpageObject *shareObject = nil;
        
        if (self.shareImageURL) {
            shareObject = [UMShareWebpageObject shareObjectWithTitle:self.shareTitle descr:self.shareTitle thumImage:self.shareImageURL];
        } else {
            shareObject = [UMShareWebpageObject shareObjectWithTitle:self.shareTitle descr:self.shareTitle thumImage:[UIImage imageNamed:@"个人中心奇点资讯"]];
        }
        
        shareObject.webpageUrl = self.shareURL;
        messageObject.shareObject = shareObject;
  
    }
    [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (!error) {
           [self shareSucess];
        } else {
           [self shareFailure];
        }
    }];
}


// 朋友圈按钮
- (void)shareToWechatTimelineBtnClick {
    [self shareWithPlatform:UMSocialPlatformType_WechatTimeLine];

}

// 微信好友
- (void)shareToWechatSessionBtnClick {
    [self shareWithPlatform:UMSocialPlatformType_WechatSession];
}

// qq 好友
- (void)shareToQQBtnClick {
  [self shareWithPlatform:UMSocialPlatformType_QQ];
}

// 新浪微博
- (void)shareToSinaBtnClick {
  [self shareWithPlatform:UMSocialPlatformType_Sina];

}

// 短信分享
- (void)shareToSmsBtnClick {
  [self shareWithPlatform:UMSocialPlatformType_Sms];
}

// 邮件分享
- (void)shareToEmailBtnClick {
     [self shareWithPlatform:UMSocialPlatformType_Email];
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
