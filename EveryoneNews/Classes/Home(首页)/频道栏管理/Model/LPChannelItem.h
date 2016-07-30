//
//  LPChannel.h
//  EveryoneNews
//
//  Created by dongdan on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPChannelItem : NSObject<NSCoding>

// 编号
@property (nonatomic, copy) NSString *channelID;
// 名称
@property (nonatomic, copy) NSString *channelName;
// 1  选中  0 未选中
@property (nonatomic, copy) NSString *channelIsSelected;
// 上次加载日期
@property (nonatomic, strong) NSDate *lastAccessDate;

// 初始化频道
- (instancetype)initWithChannelID:(NSString *)channelID channelName:(NSString *)channelName channelIsSelected:(NSString *)channelIsSelected;
@end
