//
//  LPNewsSettingCell.h
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPNewsBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

static const CGFloat kSetingCellHeight = 51.f;

@interface LPNewsSettingCell : LPNewsBaseTableViewCell

@property (nonatomic, strong)UISegmentedControl *fontSizeCtrBtn;
@property (nonatomic, strong)UISwitch *infoPushSwitchBtn;

@end
NS_ASSUME_NONNULL_END