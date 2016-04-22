//
//  LPChangeFontSize.h
//  EveryoneNews
//
//  Created by dongdan on 16/4/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPFontSizeManager : NSObject

// 首页字体大小
@property (nonatomic, assign) NSInteger currentHomeViewFontSize;

// 首页字体类型
@property (nonatomic, copy) NSString *currentHomeViewFontSizeType;

// 详情页标题字体大小
@property (nonatomic, assign) NSInteger currentDetaiTitleFontSize;

// 详情页来源字体大小
@property (nonatomic, assign) NSInteger currentDetailSourceFontSize;


// 详情页内容字体大小
@property (nonatomic, assign) NSInteger currentDetailContentFontSize;

// 详情页评论字体大小
@property (nonatomic, assign) NSInteger currentDetailCommentFontSize;

// 详情页相关观点字体大小
@property (nonatomic, assign) NSInteger currentDetailRelatePointFontSize;

+ (instancetype)sharedManager;

// 保存首页字体大小和字体类型
- (void)saveHomeViewFontSizeAndType;

@end
