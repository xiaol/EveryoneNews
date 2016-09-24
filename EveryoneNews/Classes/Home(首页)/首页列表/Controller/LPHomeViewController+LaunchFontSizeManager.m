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
#import "LPFontSize.h"

@implementation LPHomeViewController (LaunchFontSizeManager)

#pragma mark - LPChangeFontSizeView Delegate
- (void)changeFontSizeView:(LPChangeFontSizeView *)changeFontSizeView reloadTableViewWithFontSize:(NSInteger)fontSize fontSizeType:(NSString *)fontSizeType currentDetailContentFontSize:(NSInteger)currentDetailContentFontSize currentDetaiTitleFontSize:(NSInteger)currentDetaiTitleFontSize currentDetailCommentFontSize:(NSInteger)currentDetailCommentFontSize currentDetailRelatePointFontSize:(NSInteger)currentDetailRelatePointFontSize currentDetailSourceFontSize:(NSInteger)currentDetailSourceFontSize {
    
    LPFontSize *lpFontSize = [[LPFontSize alloc] init];
    lpFontSize.currentHomeViewFontSize = fontSize;
    lpFontSize.fontSizeType = fontSizeType;
    lpFontSize.currentDetailContentFontSize = currentDetailContentFontSize;
    lpFontSize.currentDetaiTitleFontSize = currentDetaiTitleFontSize;
    lpFontSize.currentDetailCommentFontSize = currentDetailCommentFontSize;
    lpFontSize.currentDetailRelatePointFontSize = currentDetailRelatePointFontSize;
    lpFontSize.currentDetailSourceFontSize = currentDetailSourceFontSize;

    [LPFontSizeManager sharedManager].lpFontSize = lpFontSize;
    
    [noteCenter postNotificationName:LPFontSizeChangedNotification object:nil];
}

- (void)finishButtonDidClick:(LPChangeFontSizeView *)changeFontSizeView {

    [self.homeBlackBlurView removeFromSuperview];    
    // 保存字体大小
    [[LPFontSizeManager sharedManager] saveHomeViewFontSizeAndType];
    
    

}
@end
