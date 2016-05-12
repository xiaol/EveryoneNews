//
//  LPChannel.h
//  EveryoneNews
//
//  Created by dongdan on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPChannelItem : NSObject<NSCoding>

@property (nonatomic, copy) NSString *channelID;
@property (nonatomic, copy) NSString *channelName;
// 1  选中  0 未选中
@property (nonatomic, copy) NSString *channelIsSelected;

@property (nonatomic, strong) NSDate *lastAccessDate;

@end
