//
//  LPNewsSettingCell.h
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPNewsBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

//static const CGFloat kSetingCellHeight = 51.f;

@interface LPNewsSettingCell : LPNewsBaseTableViewCell

@property (nonatomic, strong)UISegmentedControl *fontSizeCtrBtn;
@property (nonatomic, strong)UISwitch *infoPushSwitchBtn;

@property (nonatomic, assign) NSInteger homeViewFontSize;

// 详情页内容字体大小
@property (nonatomic, assign) NSInteger currentDetailContentFontSize;
// 详情页标题字体大小
@property (nonatomic, assign) NSInteger currentDetaiTitleFontSize;
// 详情页来源字体大小
@property (nonatomic, assign) NSInteger currentDetailSourceFontSize;
// 详情页评论字体大小
@property (nonatomic, assign) NSInteger currentDetailCommentFontSize;

@property (nonatomic, assign) NSInteger currentDetailRelatePointFontSize;
@property (nonatomic, copy) NSString *fontSizeType;


@end
NS_ASSUME_NONNULL_END