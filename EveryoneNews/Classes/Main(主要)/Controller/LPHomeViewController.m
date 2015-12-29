//
//  LPHomeViewController.m
//  EveryoneNews
//
//  Created by dongdan on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPHomeViewController.h"
#import "LPMenuView.h"
#import "LPPagingView.h"
#import "UIImageView+WebCache.h"
//#import "LPChannelItemTool.h"
#import "LPChannelItem.h"
//#import "LPMenuButton.h"
#import "LPSortCollectionViewCell.h"
#import "LPSortCollectionReusableView.h"
#import "LPChannelItemTool.h"
#import "LPMenuCollectionViewCell.h"
#import "LPSortCollectionView.h"
//#import "CardTool.h"
//#import "CardParam.h"
//#import "Card+CoreDataProperties.h"
#import "LPHomeViewCell.h"
//#import "CardFrame.h"
#import "LPPagingViewPage.h"
#import "LPHomeViewController+ChannelItemMenu.h"
#import "LPHomeViewController+PagingView.h"

const static CGFloat menuViewHeight = 44;
const static CGFloat statusBarHeight = 20;
static NSString *cellIdentifier = @"sortCollectionViewCell";
static NSString *reuseIdentifierFirst = @"reuseIdentifierFirst";
static NSString *reuseIdentifierSecond = @"reuseIdentifierSecond";
static NSString *menuCellIdentifier = @"menuCollectionViewCell";
static NSString *reusePageID = @"reusePageID";
static NSString *firstChannelName = @"社会";

// 展开折叠图片宽度
const static float menuImageViewWidth= 44;

@interface LPHomeViewController ()

@property (assign, nonatomic) UIStatusBarStyle statusBarStyle;
@end

@implementation LPHomeViewController

#pragma mark - ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubViews];
    if ([userDefaults objectForKey:@"isFirstLoadMark"]) {
        [self  setInitialChannelItemDictionary];
    }
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark - 懒加载
- (NSMutableDictionary *)channelItemDictionary {
    if (_channelItemDictionary == nil) {
        _channelItemDictionary = [[NSMutableDictionary alloc] init];
    }
    return _channelItemDictionary;
}

- (NSMutableArray *)channelItemsArray {
    if(_channelItemsArray == nil) {
        _channelItemsArray = [[NSMutableArray alloc] init];
    }
    return _channelItemsArray;
}

- (NSMutableArray *)selectedArray {
    if(_selectedArray == nil) {
        _selectedArray = [[NSMutableArray alloc] init];
    }
    return  _selectedArray;
}

- (NSMutableArray *)optionalArray {
    if(_optionalArray == nil) {
        _optionalArray = [[NSMutableArray alloc] init];
    }
    return _optionalArray;
}

- (NSMutableArray *)cellAttributesArray {
    if (_cellAttributesArray == nil) {
        _cellAttributesArray = [[NSMutableArray alloc] init];
    }
    return _cellAttributesArray;
}

- (NSMutableDictionary *)pageindexMapToChannelItemDictionary {
    if (_pageindexMapToChannelItemDictionary == nil) {
        _pageindexMapToChannelItemDictionary = [[NSMutableDictionary alloc] init];
    }
    return _pageindexMapToChannelItemDictionary;
}

- (NSMutableDictionary *)cardCellIdentifierDictionary {
    if (_cardCellIdentifierDictionary == nil) {
        _cardCellIdentifierDictionary = [[NSMutableDictionary alloc] init];
    }
    
    return _cardCellIdentifierDictionary;
}

- (NSMutableDictionary *)contentOffsetDictionary {
    if (_contentOffsetDictionary == nil) {
        _contentOffsetDictionary = [[NSMutableDictionary alloc] init];
    }
    return _contentOffsetDictionary;
}


#pragma mark - 初始化界面
- (void)setupSubViews {
    [self initAllChannelItems];
    [self setCellIdentifierOfAllChannelItems];
    [self updatePageindexMapToChannelItemDictionary];
    
    
    // 菜单栏
    UICollectionViewFlowLayout *menuViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    menuViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    menuViewFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    LPMenuView *menuView = [[LPMenuView alloc] initWithFrame:CGRectMake(0, statusBarHeight , ScreenWidth - menuImageViewWidth, menuViewHeight) collectionViewLayout:menuViewFlowLayout];
    menuView.backgroundColor = [UIColor colorFromHexString:@"0087d1"];
    menuView.showsHorizontalScrollIndicator = NO;
    menuView.delegate = self;
    menuView.dataSource = self;
    [menuView registerClass:[LPMenuCollectionViewCell class] forCellWithReuseIdentifier:menuCellIdentifier];
    self.menuView = menuView;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, menuViewHeight + statusBarHeight)];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    
    
    // 内容页面
    LPPagingView *pagingView = [[LPPagingView alloc] init];
    pagingView.frame = CGRectMake(0, statusBarHeight + menuViewHeight, ScreenWidth, ScreenHeight - statusBarHeight - menuViewHeight);
    pagingView.contentSize = CGSizeMake(self.selectedArray.count * pagingView.width, 0);
    pagingView.alwaysBounceVertical = NO;
    pagingView.alwaysBounceHorizontal = NO;
    pagingView.delegate = self;
    pagingView.dataSource = self;
    [pagingView registerClass:[LPPagingViewPage class] forPageWithReuseIdentifier:reusePageID];
    [self.view addSubview:pagingView];
    
    self.pagingView = pagingView;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.sortCollectionView = [[LPSortCollectionView alloc] initWithFrame:CGRectMake(0, statusBarHeight + menuViewHeight - ScreenHeight, ScreenWidth, ScreenHeight - statusBarHeight- menuViewHeight) collectionViewLayout:layout];
    self.sortCollectionView.delegate = self;
    self.sortCollectionView.dataSource = self;
    self.sortCollectionView.backgroundColor = [UIColor whiteColor];
    self.sortCollectionView.alpha = 0.95;
    [self.sortCollectionView registerClass:[LPSortCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.sortCollectionView registerClass:[LPSortCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierFirst];
    [self.sortCollectionView registerClass:[LPSortCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierSecond];
    [self.view addSubview:self.sortCollectionView];
    
    
    // 添加菜单栏
    [self.view addSubview:menuView];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, statusBarHeight)];
    topView.backgroundColor = [UIColor colorFromHexString:@"0087d1"];
    [self.view addSubview:topView];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, statusBarHeight, ScreenHeight, menuViewHeight)];
    backgroundView.backgroundColor = [UIColor colorFromHexString:@"0087d1"];
    [self.view addSubview:backgroundView];
    backgroundView.alpha = 0;
    self.backgroundView = backgroundView;
    
    
    UIView *imageBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth - menuImageViewWidth, statusBarHeight, menuImageViewWidth, menuViewHeight)];
    imageBackgroundView.backgroundColor = [UIColor colorFromHexString:@"0087d1"];
    [self.view addSubview:imageBackgroundView];
    
    // 添加箭头
    UIImage *image = [UIImage imageNamed:@"向下箭头"];
    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.contentMode = UIViewContentModeCenter;
    self.imageView.userInteractionEnabled = YES;
    self.imageView.frame = CGRectMake(ScreenWidth - menuImageViewWidth, statusBarHeight, menuImageViewWidth, menuImageViewWidth);
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapArrowView)];
    tapGesture.delegate = self;
    [self.imageView addGestureRecognizer:tapGesture];
    self.isSpread = NO;
    [self.view addSubview:self.imageView];
    
   
}

#pragma -mark 频道栏展开和折叠
- (void)tapArrowView {
    UIImage *image = nil;
    __weak __typeof(self)weakSelf = self;
    // 展开频道栏
    if(self.isSpread == NO) {
        image = [UIImage imageNamed:@"向上箭头"];
        self.isSpread = YES;
        self.menuView.alpha = 0;
        self.backgroundView.alpha = 1;
        // 选中某个按钮后需要刷新频道
        [self.sortCollectionView reloadData];
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.imageView.transform = CGAffineTransformMakeRotation(-3.14159);
            weakSelf.sortCollectionView.frame = CGRectMake(0, menuViewHeight + statusBarHeight, ScreenWidth, ScreenHeight - menuViewHeight -statusBarHeight);
        } completion:^(BOOL finished) {
        }];
    } else {
        image = [UIImage imageNamed:@"向下箭头"];
        self.isSpread = NO;
        self.menuView.alpha = 1;
        self.backgroundView.alpha = 0;
        self.isSort = NO;
        [self.menuView reloadData];
        // 当前选中频道索引值
        int index = 0;
        for (int i = 0; i < self.selectedArray.count; i++) {
            LPChannelItem *channelItem = self.selectedArray[i];
            if([channelItem.channelName isEqualToString:self.selectedChannelTitle]) {
                index = i;
                break;
            }
        }
        if(index == 0) {
            self.selectedChannelTitle = firstChannelName;
        }
        NSIndexPath *menuIndexPath = [NSIndexPath indexPathForItem:index
                                                         inSection:0];
        [self.menuView selectItemAtIndexPath:menuIndexPath
                                    animated:NO
                              scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        [self.pagingView reloadData];
        [self.pagingView setCurrentPageIndex:index animated:NO];
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.imageView.transform = CGAffineTransformMakeRotation(0 * M_PI / 180);
            weakSelf.sortCollectionView.frame = CGRectMake(0, statusBarHeight + menuViewHeight - ScreenHeight, ScreenWidth, ScreenHeight - menuViewHeight - statusBarHeight);
        } completion:^(BOOL finished) {
            
        }];
    }
}

@end
