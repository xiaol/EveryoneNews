//
//  LPHomeChannelItemController.h
//  EveryoneNews
//
//  Created by dongdan on 16/5/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPBaseViewController.h"


typedef void(^channelItemDidChangedBlock)(NSDictionary *dict);

@interface LPHomeChannelItemController : LPBaseViewController

// 已选频道
@property (nonatomic, strong) NSMutableArray *selectedArray;
// 可选频道
@property (nonatomic, strong) NSMutableArray *optionalArray;
// 记录选中菜单栏名称
@property (nonatomic, copy) NSString *selectedChannelTitle;
@property (nonatomic, copy) channelItemDidChangedBlock channelItemDidChangedBlock;

@end
