//
//  LPChangeFontSize.m
//  EveryoneNews
//
//  Created by dongdan on 16/4/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPFontSizeManager.h"
#import "LPFontSize.h"


@implementation LPFontSizeManager

+ (instancetype)sharedManager {
    static dispatch_once_t once;
    static LPFontSizeManager *manager = nil;
    dispatch_once(&once, ^{
        manager = [[LPFontSizeManager alloc] init];
    });
    return manager;
}

#pragma mark - 获取当前版本字体大小
- (id)init {
    self = [super init];
    if (self) {
        // 本地首页字体大小是否存在
        if (![userDefaults objectForKey:@"homeViewFontSize"]) {
            self.lpFontSize = [[LPFontSize alloc] initWithFontSizeType:@"standard"];
            
        } else {
            LPFontSize *lpFontSize = [[LPFontSize alloc] init];
            lpFontSize.currentHomeViewFontSize = [[userDefaults objectForKey:@"homeViewFontSize"] intValue];
            lpFontSize.currentDetailContentFontSize = [[userDefaults objectForKey:@"currentDetailContentFontSize"] intValue];
            lpFontSize.currentDetaiTitleFontSize = [[userDefaults objectForKey:@"currentDetaiTitleFontSize"] intValue];
            lpFontSize.currentDetailCommentFontSize = [[userDefaults objectForKey:@"currentDetailCommentFontSize"] intValue];
            lpFontSize.currentDetailRelatePointFontSize =  [[userDefaults objectForKey:@"currentDetailRelatePointFontSize"] intValue];
            lpFontSize.currentDetailSourceFontSize = [[userDefaults objectForKey:@"currentDetailSourceFontSize"] intValue];
            // 字体标准   standard / larger/ superlarger
            lpFontSize.fontSizeType = (NSString *)[userDefaults objectForKey:@"homeViewFontSizeType"];
            
            self.lpFontSize = lpFontSize;
        }
    }
    return self;
}

#pragma mark - 字体大小保存
- (void)saveHomeViewFontSizeAndType {
    
    LPFontSize *lpFontSize = [LPFontSizeManager sharedManager].lpFontSize;
    
    NSInteger homeViewFontSize = lpFontSize.currentHomeViewFontSize;
    [userDefaults setObject:[NSString stringWithFormat:@"%d",homeViewFontSize] forKey:@"homeViewFontSize"];
    
    NSInteger currentDetailContentFontSize = lpFontSize.currentDetailContentFontSize;
    [userDefaults setObject:[NSString stringWithFormat:@"%d",currentDetailContentFontSize] forKey:@"currentDetailContentFontSize"];
    
    NSInteger currentDetaiTitleFontSize = lpFontSize.currentDetaiTitleFontSize;
    [userDefaults setObject:[NSString stringWithFormat:@"%d",currentDetaiTitleFontSize] forKey:@"currentDetaiTitleFontSize"];
    
    NSInteger currentDetailCommentFontSize = lpFontSize.currentDetailCommentFontSize;
    [userDefaults setObject:[NSString stringWithFormat:@"%d",currentDetailCommentFontSize] forKey:@"currentDetailCommentFontSize"];
    
    NSInteger currentDetailRelatePointFontSize = lpFontSize.currentDetailRelatePointFontSize;
    [userDefaults setObject:[NSString stringWithFormat:@"%d",currentDetailRelatePointFontSize] forKey:@"currentDetailRelatePointFontSize"];
    
    NSInteger currentDetailSourceFontSize = lpFontSize.currentDetailSourceFontSize;
    [userDefaults setObject:[NSString stringWithFormat:@"%d",currentDetailSourceFontSize] forKey:@"currentDetailSourceFontSize"];
    
    NSString *homeViewFontSizeType = lpFontSize.fontSizeType;
    [userDefaults setObject:homeViewFontSizeType forKey:@"homeViewFontSizeType"];
    
    // 强制立即将数据写入磁盘
    [userDefaults synchronize];
}
@end
