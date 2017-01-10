//
//  LPHomeVideoFrame.h
//  AVPlayerDemo
//
//  Created by dongdan on 2016/12/6.
//  Copyright © 2016年 dongdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Card;

@interface LPHomeVideoFrame : NSObject

// 标题
@property (nonatomic, assign, readonly) CGRect titleF;
// 播放器图片
@property (nonatomic, assign, readonly) CGRect coverImageF;

// 播放器按钮
@property (nonatomic, assign, readonly) CGRect playButtonF;

// 底部视图
@property (nonatomic, assign, readonly) CGRect bottomViewF;
// 评论图标
@property (nonatomic, assign, readonly) CGRect commentImageViewF;
// 评论数
@property (nonatomic, assign, readonly) CGRect commentLabelF;
// 分享
@property (nonatomic, assign, readonly) CGRect shareButtonF;
// 分割线
@property (nonatomic, assign, readonly) CGRect seperatorViewF;
// 高度
@property (nonatomic, assign, readonly) CGFloat cellHeight;

@property (nonatomic, strong) Card *card;

@property (nonatomic, copy) NSString *fontSizeType;

@property (nonatomic, assign) NSInteger homeViewFontSize;

@end
