//
//  LPHomeViewController+HomeViewLoginManager.h
//  EveryoneNews
//
//  Created by dongdan on 16/4/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPHomeViewController.h"
#import "UMSocialSnsPlatformManager.h"

@interface LPHomeViewController (LaunchLoginManager)<UMSocialUIDelegate>

// 设置首页登录按钮
- (void)setupHomeViewLoginButton;

@end
