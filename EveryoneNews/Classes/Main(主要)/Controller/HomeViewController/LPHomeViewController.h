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
#import "LPTabBar.h"
@class GenieTransition;

@interface LPHomeViewController : LPBaseViewController

@property (nonatomic, strong) UIView *topBackgroundView;
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
// 蒙层
@property (nonatomic , strong) UIView *blurView;
// 频道栏
@property (nonatomic, strong) LPSortCollectionView *sortCollectionView;
// 频道添加时
@property (nonatomic, strong) UILabel *animationLabel;
@property (nonatomic, assign) BOOL lastLabelIsHidden;
// 频道栏是否展开
//@property (nonatomic, assign) BOOL isSpread;
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

@property (nonatomic, strong) NSMutableDictionary *pageContentOffsetDictionary;

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIActivityIndicatorView *indictorView;

// 网络出错
@property (nonatomic, strong) UILabel *loadLabel;

@property (nonatomic, strong) UIImageView *loadImageView;

@property (nonatomic, strong) UILabel *noDataLabel;

@property (nonatomic, strong) UIImageView *backgroundImageView;


//@property (nonatomic, strong) UIScrollView *featureScrollView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIView *featureBlurView;

@property (nonatomic, strong) UIView *featureView;

@property (nonatomic, strong) UIImageView *closeImageView;

// 登录 挖掘机
@property (nonatomic, strong) UIImageView *frontImageView;
@property (nonatomic, assign) BOOL shouldPush;
@property (nonatomic, strong) UIImage *userIcon;
@property (nonatomic, strong) GenieTransition *genieTransition;

@end
