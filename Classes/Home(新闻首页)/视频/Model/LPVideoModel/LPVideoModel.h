//
//  LPVideoModel.h
//  AVPlayerDemo
//
//  Created by dongdan on 2016/12/6.
//  Copyright © 2016年 dongdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPVideoModel : NSObject

// 标题
@property (nonatomic, copy) NSString *title;
// 来源
@property (nonatomic, copy) NSString *sourceName;
// 封面图
@property (nonatomic, copy) NSString *thumbnail;
// 视频地址
@property (nonatomic, copy) NSString *videoURL;
// 播放时长
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, copy) NSString *nid;

- (NSMutableAttributedString *)titleString;
- (NSMutableAttributedString *)sourceString;
- (NSMutableAttributedString *)titleHtmlString;


@end
