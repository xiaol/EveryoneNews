//
//  LPChangeFontSize.h
//  EveryoneNews
//
//  Created by dongdan on 16/4/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPFontSize;

@interface LPFontSizeManager : NSObject

@property (nonatomic, strong) LPFontSize *lpFontSize;

+ (instancetype)sharedManager;

// 保存首页字体大小和字体类型
- (void)saveHomeViewFontSizeAndType;

@end
