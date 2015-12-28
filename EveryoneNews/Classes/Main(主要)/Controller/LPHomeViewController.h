//
//  LPHomeViewController.h
//  EveryoneNews
//
//  Created by dongdan on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//


#import "LPSortCollectionView.h"
#import "LPBaseViewController.h"
#import "LPPagingView.h"
#import "LPMenuView.h"
#import "LPMenuCollectionViewCell.h"

 
@interface LPHomeViewController : LPBaseViewController

@property (nonatomic, strong) UIView *backgroundView;
// 所有频道集合
@property (nonatomic, strong) NSMutableArray *channelItemsArray;
// 内容页面
@property (nonatomic, strong) LPPagingView *pagingView;
// 菜单栏
@property (nonatomic, strong) LPMenuView *menuView;
// 已选频道
@property (nonatomic, strong) NSMutableArray *selectedArray;
// 可选频道
@property (nonatomic, strong) NSMutableArray *optionalArray;

@property (nonatomic, strong) UIImageView *imageView;
// 频道栏
@property (nonatomic, strong) LPSortCollectionView *sortCollectionView;
// 频道添加时
@property (nonatomic, strong) UILabel *animationLabel;
@property (nonatomic, assign) BOOL lastLabelIsHidden;
// 频道栏是否展开
@property (nonatomic, assign) BOOL isSpread;
@property (nonatomic, assign) BOOL isSort;
@property (nonatomic, strong) LPMenuCollectionViewCell *firstCell;
// 记录选中菜单栏名称
@property (nonatomic, copy) NSString *selectedChannelTitle;
// 记录所有的样式，用于长按拖动
@property (nonatomic, strong) NSMutableArray *cellAttributesArray;
// 存储所有的模型数据
@property (nonatomic, strong) NSMutableDictionary *channelItemDictionary;

@property (nonatomic, strong) NSMutableDictionary *pageindexMapToChannelItemDictionary;

@property (nonatomic, strong) NSUserDefaults *userDefault;

@property (nonatomic, strong) NSMutableDictionary *cardCellIdentifierDictionary;

@property (nonatomic, strong) NSMutableDictionary *contentOffsetDictionary;

@end
