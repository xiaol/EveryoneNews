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
#import "LPLaunchLoginView.h"
#import "LPChangeFontSizeView.h"
#import "CoreDataHelper.h"
#import "LPPagingViewPage.h"
#import "LPHttpTool.h"



@class LPPagingViewPage;
@class CardFrame;
@interface LPHomeViewController:LPBaseViewController

// 首页登录按钮
@property (nonatomic,strong) UIButton *loginBtn;
// 已选频道
@property (nonatomic, strong) NSMutableArray *selectedArray;
// 可选频道
@property (nonatomic, strong) NSMutableArray *optionalArray;
// 菜单栏
@property (nonatomic, strong) LPMenuView *menuView;
// 内容页面
@property (nonatomic, strong) LPPagingView *pagingView;
// 频道栏和页码对应关系
@property (nonatomic, strong) NSMutableDictionary *pageindexMapToChannelItemDictionary;
// 每个频道唯一标识
@property (nonatomic, strong) NSMutableDictionary *cardCellIdentifierDictionary;
// 所有频道名称
@property (nonatomic, strong) NSMutableArray *channelItemsArray;
// 记录选中菜单栏名称
@property (nonatomic, copy) NSString *selectedChannelTitle;
// 存储所有的模型数据
@property (nonatomic, strong) NSMutableDictionary *channelItemDictionary;
// 记录所有的样式，用于长按拖动
@property (nonatomic, strong) NSMutableArray *cellAttributesArray;
// 菜单背景蓝色
@property (nonatomic, strong) UIView *menuBackgroundView;
// 频道添加时动画标签
@property (nonatomic, strong) UILabel *animationLabel;
// 频道栏
@property (nonatomic, strong) LPSortCollectionView *sortCollectionView;
// 是否完成频道切换
@property (nonatomic, assign) BOOL isSort;
@property (nonatomic, assign) BOOL lastLabelIsHidden;
// 频道栏蒙层
@property (nonatomic , strong) UIView *blurView;
// 频道栏向上箭头
@property (nonatomic, strong) UIButton *hideChannelItemButton;

// Launch View
@property (nonatomic, strong) LPLaunchLoginView *loginView;
// 首页第一次进入遮罩层
@property (nonatomic, strong) UIView *homeBlackBlurView;
// 有新频道提示框
@property (nonatomic, strong) UIImageView *channelBarImageView;
// 调整文字提示框
@property (nonatomic, strong) UIImageView *changeFontSizeTipImageView;
// 底部调整文字大小视图
@property (nonatomic, strong) LPChangeFontSizeView *changeFontSizeView;
// 删除时黑色背景
@property (nonatomic, strong) UIView *blackBackgroundView;

// 删除时传递参数
@property (nonatomic, strong) LPPagingViewPage *currentPage;
@property (nonatomic, strong) CardFrame *currentCardFrame;

@property (nonatomic, strong) UIWindow *statusWindow;

@property (nonatomic, assign) BOOL isTourist;

@property (nonatomic, strong) LPHttpTool *http;


 
@end
