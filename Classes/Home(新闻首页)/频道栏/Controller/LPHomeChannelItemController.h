//
//  LPHomeChannelItemController.h
//  EveryoneNews
//
//  Created by dongdan on 16/5/23.
//  Copyright © 2016年 apple. All rights reserved.
//
@class LPPagingView;
@class LPChannelItem;

#import "LPBaseViewController.h"

// 返回上一层回调处理
typedef void(^ChannelItemDidChangedBlock)(NSDictionary *dict);

// 添加频道
typedef void(^AddChannelItemBlock)(NSString *channelName, NSInteger insertIndex, NSMutableArray *selectedArray, NSMutableArray *optionalArray);

// 删除频道
typedef void(^RemoveChannelItemBlock)(NSString *channelName, NSInteger removeIndex, NSMutableArray *selectedArray, NSMutableArray *optionalArray);

// 移动频道
typedef void (^MoveChannelItemBlock)(NSInteger fromIndex, NSInteger toIndex, NSMutableArray *selectedArray, NSMutableArray *optionalArray);

@interface LPHomeChannelItemController : LPBaseViewController
// 已选频道
@property (nonatomic, strong) NSMutableArray *selectedArray;
// 可选频道
@property (nonatomic, strong) NSMutableArray *optionalArray;
// 记录选中菜单栏名称
@property (nonatomic, copy) NSString *selectedChannelTitle;
@property (nonatomic, copy) ChannelItemDidChangedBlock channelItemDidChangedBlock;
@property (nonatomic, copy) AddChannelItemBlock addChannelItemBlock;
@property (nonatomic, copy) RemoveChannelItemBlock removeChannelItemBlock;
@property (nonatomic, copy) MoveChannelItemBlock moveChannelItemBlock;

// 所有频道名称
@property (nonatomic, strong) NSMutableArray *channelItemsArray;


@end
