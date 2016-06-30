//
//  LPChangeFontSize.m
//  EveryoneNews
//
//  Created by dongdan on 16/4/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPFontSizeManager.h"


@implementation LPFontSizeManager

+ (instancetype)sharedManager {
    static dispatch_once_t once;
    static LPFontSizeManager *manager = nil;
    dispatch_once(&once, ^{
        manager = [[LPFontSizeManager alloc] init];
    });
    return manager;
}

- (id)init {
    self = [super init];
    if (self) {
        // 本地首页字体大小是否存在
        if (![userDefaults objectForKey:@"homeViewFontSize"]) {
        if (iPhone6Plus) {
                _currentHomeViewFontSize = iPhone6PlusHomeTitleSizeStandard;
                _currentDetailContentFontSize = iPhone6PlusDetailContentSizeStandard;
                _currentDetaiTitleFontSize = iPhone6PlusDetailTitleSizeStandard;
                _currentDetailCommentFontSize = iPhone6PlusDetailCommentSizeStandard;
                _currentDetailRelatePointFontSize = iPhone6PlusDetailRelateSizeStandard;
                _currentDetailSourceFontSize = iPhone6PlusDetailSourceSizeStandard;
            
            } else if(iPhone5){
                _currentHomeViewFontSize = iPhone5HomeTitleSizeStandard;
                _currentDetailContentFontSize = iPhone5DetailContentSizeStandard;
                _currentDetaiTitleFontSize = iPhone5DetailTitleSizeStandard;
                _currentDetailCommentFontSize = iPhone5DetailCommentSizeStandard;
                _currentDetailRelatePointFontSize = iPhone5DetailRelateSizeStandard;
                _currentDetailSourceFontSize = iPhone5DetailSourceSizeStandard;
            } else if (iPhone6) {
                _currentHomeViewFontSize = iPhone6HomeTitleSizeStandard;
                _currentDetailContentFontSize = iPhone6DetailContentSizeStandard;
                _currentDetaiTitleFontSize = iPhone6DetailTitleSizeStandard;
                _currentDetailCommentFontSize = iPhone6DetailCommentSizeStandard;
                _currentDetailRelatePointFontSize = iPhone6DetailRelateSizeStandard;
                _currentDetailSourceFontSize = iPhone6DetailSourceSizeStandard;
            } else {
                _currentHomeViewFontSize = iPhone5HomeTitleSizeStandard;
                _currentDetailContentFontSize = iPhone5DetailContentSizeStandard;
                _currentDetaiTitleFontSize = iPhone5DetailTitleSizeStandard;
                _currentDetailCommentFontSize = iPhone5DetailCommentSizeStandard;
                _currentDetailRelatePointFontSize = iPhone5DetailRelateSizeStandard;
                _currentDetailSourceFontSize = iPhone5DetailSourceSizeStandard;
            }
            _currentHomeViewFontSizeType = @"standard";
            
        } else {
            
            _currentHomeViewFontSize = [[userDefaults objectForKey:@"homeViewFontSize"] intValue];
            _currentDetailContentFontSize = [[userDefaults objectForKey:@"currentDetailContentFontSize"] intValue];
            _currentDetaiTitleFontSize = [[userDefaults objectForKey:@"currentDetaiTitleFontSize"] intValue];
            _currentDetailCommentFontSize = [[userDefaults objectForKey:@"currentDetailCommentFontSize"] intValue];
            _currentDetailRelatePointFontSize =  [[userDefaults objectForKey:@"currentDetailRelatePointFontSize"] intValue];
            _currentDetailSourceFontSize = [[userDefaults objectForKey:@"currentDetailSourceFontSize"] intValue];
            // 字体标准   standard / larger/ superlarger
            _currentHomeViewFontSizeType = (NSString *)[userDefaults objectForKey:@"homeViewFontSizeType"];
        }
    }
    return self;
}

- (void)saveHomeViewFontSizeAndType {
    
    NSInteger homeViewFontSize = [LPFontSizeManager sharedManager].currentHomeViewFontSize;
    [userDefaults setObject:[NSString stringWithFormat:@"%d",homeViewFontSize] forKey:@"homeViewFontSize"];
    
    NSInteger currentDetailContentFontSize = [LPFontSizeManager sharedManager].currentDetailContentFontSize;
    [userDefaults setObject:[NSString stringWithFormat:@"%d",currentDetailContentFontSize] forKey:@"currentDetailContentFontSize"];
    
    NSInteger currentDetaiTitleFontSize = [LPFontSizeManager sharedManager].currentDetaiTitleFontSize;
    [userDefaults setObject:[NSString stringWithFormat:@"%d",currentDetaiTitleFontSize] forKey:@"currentDetaiTitleFontSize"];
    
    NSInteger currentDetailCommentFontSize = [LPFontSizeManager sharedManager].currentDetailCommentFontSize;
    [userDefaults setObject:[NSString stringWithFormat:@"%d",currentDetailCommentFontSize] forKey:@"currentDetailCommentFontSize"];
    
    NSInteger currentDetailRelatePointFontSize = [LPFontSizeManager sharedManager].currentDetailRelatePointFontSize;
    [userDefaults setObject:[NSString stringWithFormat:@"%d",currentDetailRelatePointFontSize] forKey:@"currentDetailRelatePointFontSize"];
    
    NSInteger currentDetailSourceFontSize = [LPFontSizeManager sharedManager].currentDetailSourceFontSize;
    [userDefaults setObject:[NSString stringWithFormat:@"%d",currentDetailSourceFontSize] forKey:@"currentDetailSourceFontSize"];
    
    NSString *homeViewFontSizeType = [LPFontSizeManager sharedManager].currentHomeViewFontSizeType;
    [userDefaults setObject:homeViewFontSizeType forKey:@"homeViewFontSizeType"];
    
    // 强制立即将数据写入磁盘
    [userDefaults synchronize];
}
@end
