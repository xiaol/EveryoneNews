//
//  LPHomeViewController+LaunchFontSizeManager.m
//  EveryoneNews
//
//  Created by dongdan on 16/4/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPHomeViewController+LaunchFontSizeManager.h"
#import "LPFontSizeManager.h"
#import "LPHomeViewController+ContentView.h"
#import "LPHomeRowManager.h"

@implementation LPHomeViewController (LaunchFontSizeManager)

#pragma mark - LPChangeFontSizeView Delegate
- (void)changeFontSizeView:(LPChangeFontSizeView *)changeFontSizeView reloadTableViewWithFontSize:(NSInteger)fontSize fontSizeType:(NSString *)fontSizeType currentDetailContentFontSize:(NSInteger)currentDetailContentFontSize currentDetaiTitleFontSize:(NSInteger)currentDetaiTitleFontSize currentDetailCommentFontSize:(NSInteger)currentDetailCommentFontSize currentDetailRelatePointFontSize:(NSInteger)currentDetailRelatePointFontSize currentDetailSourceFontSize:(NSInteger)currentDetailSourceFontSize {
    
    [LPFontSizeManager sharedManager].currentHomeViewFontSize = fontSize;
    [LPFontSizeManager sharedManager].currentHomeViewFontSizeType = fontSizeType;
    [LPFontSizeManager sharedManager].currentDetailContentFontSize = currentDetailContentFontSize;
    [LPFontSizeManager sharedManager].currentDetaiTitleFontSize = currentDetaiTitleFontSize;
    [LPFontSizeManager sharedManager].currentDetailCommentFontSize = currentDetailCommentFontSize;
    [LPFontSizeManager sharedManager].currentDetailRelatePointFontSize = currentDetailRelatePointFontSize;
    [LPFontSizeManager sharedManager].currentDetailSourceFontSize = currentDetailSourceFontSize;

    [noteCenter postNotificationName:LPFontSizeChangedNotification object:nil];
}

- (void)finishButtonDidClick:(LPChangeFontSizeView *)changeFontSizeView {

    [self.homeBlackBlurView removeFromSuperview];    
    // 保存字体大小
    [[LPFontSizeManager sharedManager] saveHomeViewFontSizeAndType];
    
    

}
@end
