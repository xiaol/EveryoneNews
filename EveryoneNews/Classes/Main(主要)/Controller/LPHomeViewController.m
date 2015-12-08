//
//  LPHomeViewController.m
//  EveryoneNews
//
//  Created by dongdan on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPHomeViewController.h"
#import "LPPagingView.h"
#import "LPMenuView.h"
#import "LPPagingView.h"
#import "UIImageView+WebCache.h"
#import "LPChannelItemTool.h"
#import "LPChannelItem.h"
#import "LPMenuButton.h"
#import "LPSortCollectionViewCell.h"
#import "LPSortCollectionReusableView.h"
#import "LPChannelItemTool.h"

const static CGFloat cellPadding = 10;
static NSString *cellIdentifier = @"sortCollectionViewCell";
static NSString *reuseIdentifierFirst = @"reuseIdentifierFirst";
static NSString *reuseIdentifierSecond = @"reuseIdentifierSecond";

@interface LPHomeViewController () <LPPagingViewDataSource, LPPagingViewDelegate, LPMenuViewDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, LPSortCollectionReusableViewDelegate>

@property (nonatomic, strong) NSMutableArray *channelItemsArray;
@property (nonatomic, strong) LPPagingView *pagingView;
@property (nonatomic, strong) LPMenuView *menuView;
@property (nonatomic, assign) BOOL isSpread;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) NSMutableArray *optionalArray;
@property (nonatomic, assign) BOOL shouldRefresh;
@property (nonatomic, assign) NSInteger lastPageIndex;
// 记录上次分类是否已经删除
@property (nonatomic, assign) BOOL lastChannelIsDeleted;
@property (nonatomic, copy) NSString *lastChannelTitle;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL isSort;
@property (nonatomic, strong) UILabel *animationLabel;
@property (nonatomic, assign) BOOL lastLabelIsHidden;

@end

@implementation LPHomeViewController

- (instancetype)init {
    if(self = [super init]) {
        self.animationLabel = [[UILabel alloc] init];
        self.animationLabel.textAlignment = NSTextAlignmentCenter;
        self.animationLabel.font = [UIFont systemFontOfSize:15];
        self.animationLabel.numberOfLines = 1;
        self.animationLabel.adjustsFontSizeToFitWidth = YES;
        self.animationLabel.minimumScaleFactor = 0.1;
        self.animationLabel.textColor = [UIColor grayColor];
        self.animationLabel.layer.masksToBounds = YES;
        self.animationLabel.layer.borderColor = [UIColor grayColor].CGColor;
        self.animationLabel.layer.borderWidth = 0.45;
        self.animationLabel.layer.cornerRadius = 10;
        self.animationLabel.layer.masksToBounds = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubViews];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    if(self.shouldRefresh == YES) {
//        // 频道选择后重新刷新数据
//        [self.menuView removeFromSuperview];
//        [self.selectedArray removeAllObjects];
//        [self.optionalArray removeAllObjects];
//        self.channelItemsArray =  [self getChannelItems];
//        // 已选分类
//        for (LPChannelItem *channelItem in self.channelItemsArray) {
//            if([channelItem.channelIsSelected  isEqual: @"1"]) {
//                [self.selectedArray addObject:channelItem.channelName];
//            }
//        }
//        // 可选分类
//        for (LPChannelItem *channelItem in self.channelItemsArray) {
//            if([channelItem.channelIsSelected  isEqual: @"0"]) {
//                [self.optionalArray addObject:channelItem.channelName];
//            }
//        }
//        self.menuView = [[LPMenuView alloc] initWithFrame:CGRectMake(0, 60, ScreenWidth - 40, TabBarHeight)];
//        self.menuView.menuViewDelegate = self;
//        [self.menuView reloadMenuViewTitles:self.selectedArray selectedTitle:self.lastChannelTitle];
//        NSLog(@"%d", self.selectedArray.count);
//        [self.view addSubview:self.menuView];
//        self.pagingView.contentSize =  CGSizeMake(self.selectedArray.count * self.pagingView.width, 0);
//        [self.pagingView reloadData];
//        NSLog(@"%f", self.pagingView.contentSize.width);
//    }
}



- (BOOL)prefersStatusBarHidden {
    return  YES;
}

- (void)setupSubViews {


    UIView *transparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, ScreenHeight, 30)];
    UITapGestureRecognizer *transparentViewGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideChannelItems)];
    transparentViewGesture.delegate = self;
    [transparentView addGestureRecognizer:transparentViewGesture];
    [self.view addSubview:transparentView];
    
    self.channelItemsArray =  [self getChannelItems];
    self.menuView = [[LPMenuView alloc] initWithFrame:CGRectMake(0, 60, ScreenWidth - 40, TabBarHeight)];
    self.menuView.menuViewDelegate = self;
    
    // 已选分类
    for (LPChannelItem *channelItem in self.channelItemsArray) {
        if([channelItem.channelIsSelected  isEqual: @"1"]) {
            [self.selectedArray addObject:channelItem.channelName];
        }
    }
    // 可选分类
    for (LPChannelItem *channelItem in self.channelItemsArray) {
        if([channelItem.channelIsSelected  isEqual: @"0"]) {
            [self.optionalArray addObject:channelItem.channelName];
        }
    }
    [self.menuView loadMenuViewTitles:self.selectedArray];

    
    LPPagingView *pagingView = [[LPPagingView alloc] init];
    pagingView.frame = CGRectMake(0, 60 + TabBarHeight, ScreenWidth, ScreenHeight - 60 -TabBarHeight);
    pagingView.contentSize = CGSizeMake(self.selectedArray.count * pagingView.width, 0);
    pagingView.delegate = self;
    pagingView.dataSource = self;
    [self.view addSubview:pagingView];
    self.pagingView = pagingView;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 60 - ScreenHeight, ScreenWidth, ScreenHeight - 60) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alpha = 0.95;
    [self.collectionView registerClass:[LPSortCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.collectionView registerClass:[LPSortCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierFirst];
    [self.collectionView registerClass:[LPSortCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierSecond];
    [self.collectionView reloadData];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.menuView];

    // 添加箭头
    UIImage *image = [UIImage imageNamed:@"向下箭头"];
    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.contentMode = UIViewContentModeCenter;
    self.imageView.userInteractionEnabled = YES;
    self.imageView.frame = CGRectMake(ScreenWidth - 40, 67, 40, 30);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(manageChannelItems)];
    tapGesture.delegate = self;
    [self.imageView addGestureRecognizer:tapGesture];
    self.isSpread = NO;
    [self.view addSubview:self.imageView];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    topView.backgroundColor = [UIColor redColor];
    [self.view addSubview:topView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    titleLabel.center = CGPointMake(topView.center.x, topView.center.y);
    titleLabel.text = @"头条百家";
    titleLabel.font = [UIFont fontWithName:@"Arial" size:20];
    titleLabel.textColor = [UIColor whiteColor];
    [topView addSubview:titleLabel];



}

- (NSMutableArray *)getChannelItems {
    NSMutableArray *channelItems = [LPChannelItemTool getChannelItems];
    if(channelItems == nil) {
        channelItems = [[NSMutableArray alloc] init];
        LPChannelItem *item0 = [[LPChannelItem alloc] init];
        LPChannelItem *item1 = [[LPChannelItem alloc] init];
        LPChannelItem *item2 = [[LPChannelItem alloc] init];
        LPChannelItem *item3 = [[LPChannelItem alloc] init];
        LPChannelItem *item4 = [[LPChannelItem alloc] init];
        LPChannelItem *item5 = [[LPChannelItem alloc] init];
        LPChannelItem *item6 = [[LPChannelItem alloc] init];
        LPChannelItem *item7 = [[LPChannelItem alloc] init];
        LPChannelItem *item8 = [[LPChannelItem alloc] init];
        LPChannelItem *item9 = [[LPChannelItem alloc] init];
        LPChannelItem *item10 = [[LPChannelItem alloc] init];
        LPChannelItem *item11 = [[LPChannelItem alloc] init];
        LPChannelItem *item12 = [[LPChannelItem alloc] init];
        LPChannelItem *item13 = [[LPChannelItem alloc] init];
        LPChannelItem *item14 = [[LPChannelItem alloc] init];
        LPChannelItem *item15 = [[LPChannelItem alloc] init];
        
        item0.channelID = @"TJ0001";
        item0.channelName = @"推荐";
        item0.channelIsSelected = @"1";
        
        item1.channelID = @"RD0002";
        item1.channelName = @"热点";
        item1.channelIsSelected = @"1";
        
        item2.channelID = @"JX0003";
        item2.channelName = @"精选";
        item2.channelIsSelected = @"1";
        
        item3.channelID = @"SH0004";
        item3.channelName = @"社会";
        item3.channelIsSelected = @"1";
        
        item4.channelID = @"WM0005";
        item4.channelName = @"外媒";
        item4.channelIsSelected = @"1";
        
        item5.channelID = @"YL0006";
        item5.channelName = @"娱乐";
        item5.channelIsSelected = @"1";
        
        item6.channelID = @"KJ0007";
        item6.channelName = @"科技";
        item6.channelIsSelected = @"1";
        
        item7.channelID = @"TY0008";
        item7.channelName = @"体育";
        item7.channelIsSelected = @"1";
        
        item8.channelID = @"CJ0009";
        item8.channelName = @"财经";
        item8.channelIsSelected = @"1";
        
        item9.channelID = @"SS0010";
        item9.channelName = @"时尚";
        item9.channelIsSelected = @"1";
        
        item10.channelID = @"GX0011";
        item10.channelName = @"搞笑";
        item10.channelIsSelected = @"1";
        
        item11.channelID = @"YS0012";
        item11.channelName = @"影视";
        item11.channelIsSelected = @"0";
        
        item12.channelID = @"YY0013";
        item12.channelName = @"音乐";
        item12.channelIsSelected = @"0";
        
        item13.channelID = @"ZKW0014";
        item13.channelName = @"重口味";
        item13.channelIsSelected = @"0";
        
        item14.channelID = @"MC0015";
        item14.channelName = @"萌宠";
        item14.channelIsSelected = @"0";
        
        item15.channelID = @"ECY0016";
        item15.channelName = @"二次元";
        item15.channelIsSelected = @"0";
        
        [channelItems addObject:item0];
        [channelItems addObject:item1];
        [channelItems addObject:item2];
        [channelItems addObject:item3];
        [channelItems addObject:item4];
        [channelItems addObject:item5];
        [channelItems addObject:item6];
        [channelItems addObject:item7];
        [channelItems addObject:item8];
        [channelItems addObject:item9];
        [channelItems addObject:item10];
        [channelItems addObject:item11];
        [channelItems addObject:item12];
        [channelItems addObject:item13];
        [channelItems addObject:item14];
        [channelItems addObject:item15];
        [LPChannelItemTool saveChannelItems:channelItems];
    }
    return channelItems;
}

- (void)manageChannelItems {
    UIImage *image = nil;
    __weak __typeof(self)weakSelf = self;
    if(self.isSpread == NO) {
        image = [UIImage imageNamed:@"向上箭头"];
        self.isSpread = YES;
        self.menuView.alpha = 0;
        [UIView animateWithDuration:0.5 animations:^{
          [weakSelf.imageView  setImage:image];
            weakSelf.collectionView.frame = CGRectMake(0, 60, ScreenWidth, ScreenHeight - 60);
        } completion:^(BOOL finished) {
            
        }];
    } else {
        image = [UIImage imageNamed:@"向下箭头"];
        self.isSpread = NO;
        self.menuView.alpha = 1;
         [UIView animateWithDuration:0.5 animations:^{
             [weakSelf.imageView  setImage:image];
             weakSelf.collectionView.frame = CGRectMake(0, 60 - ScreenHeight, ScreenWidth, ScreenHeight - 60);
         } completion:^(BOOL finished) {
//              weakSelf.menuView.alpha = 1;
         }];
    
    }

}

- (void)hideChannelItems {
    self.collectionView.frame = CGRectMake(0, 60, ScreenWidth, 0);
    self.menuView.alpha = 1;
    UIImage *image = [UIImage imageNamed:@"向下箭头"];
    [self.imageView setImage:image];
    
    
}
#pragma 分页
- (NSInteger)numberOfPagesInPagingView:(LPPagingView *)pagingView {
    return self.selectedArray.count;
}

- (UIView *)pagingView:(LPPagingView *)pagingView pageForPageIndex:(NSInteger)pageIndex {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50, 50, ScreenWidth, 20)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    label.text = [NSString stringWithFormat:@"%d",pageIndex];
    label.textColor = [UIColor redColor];
    [view addSubview:label];
    return view;
}

- (void)pagingView:(LPPagingView *)pagingView didScrollWithRatio:(CGFloat)ratio {
    int pageIndex = floor(ratio);
    CGFloat rate = ratio - pageIndex;
    [self.menuView selectedButtonScaleWithRate:pageIndex rate:rate];
}

- (void)pagingView:(LPPagingView *)pagingView didScrollToPageIndex:(NSInteger)pageIndex {
    // 改变菜单栏按钮选中取消状态
    [self.menuView buttonSelectedStatusChangedWithIndex:pageIndex];
    // 按钮自动居中
    [self.menuView selectedButtonMoveToCenterWithIndex:pageIndex];
}

#pragma 菜单栏选中某个按钮代理方法
- (void)menuView:(LPMenuView *)menuView didSelectedButtonAtIndex:(int)index {
     [self.pagingView setCurrentPageIndex:index animated:NO];
}


#pragma mark - cell 排序删除
- (void)cellDidDelete:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint initialPinchPoint = [sender locationInView:self.collectionView];
        NSIndexPath* indexPath = [self.collectionView indexPathForItemAtPoint:initialPinchPoint];
        if (indexPath != nil)
        {
            [self.optionalArray insertObject:[self.selectedArray objectAtIndex:indexPath.row] atIndex:0];
            [self.selectedArray removeObjectAtIndex:indexPath.row];
            [self.collectionView performBatchUpdates:^{
                [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
            } completion:^(BOOL finished) {
                LPSortCollectionViewCell *cell = (LPSortCollectionViewCell*)sender.view;
                for (UITapGestureRecognizer *tapGesture in cell.gestureRecognizers) {
                    [cell removeGestureRecognizer:tapGesture];
                }
                [LPChannelItemTool updateChannelIsSelectedWithTitle:@"0" title:cell.contentLabel.text];
            }];
            
        }
    }
}

#pragma mark - collectionView dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if(self.isSort) {
        return 1;
    } else {
        return 2;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(section == 0) {
        return self.selectedArray.count;
    } else {
        return  self.optionalArray.count;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LPSortCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if(indexPath.section == 0) {
        [cell setCellWithArray:self.selectedArray indexPath:indexPath];
        if(indexPath.row == 0) {
            cell.userInteractionEnabled = NO;
            cell.deleteButton.hidden = YES;
        } else {
            cell.deleteButton.hidden = !self.isSort;
            if(self.isSort) {
                cell.userInteractionEnabled = YES;
                UITapGestureRecognizer *cellTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellDidDelete:)];
                [cell addGestureRecognizer:cellTap];
            } else {
                cell.userInteractionEnabled = NO;
            }
            // 添加频道时先隐藏label
            if(indexPath.row == self.selectedArray.count -1 ) {
                cell.contentLabel.hidden = self.lastLabelIsHidden;
            }
        }
    } else {
        cell.userInteractionEnabled = YES;
        [cell setCellWithArray:self.optionalArray indexPath:indexPath];
        cell.deleteButton.hidden = YES;
    }
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    LPSortCollectionReusableView *resuableView = nil;
    if([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if(indexPath.section == 0) {
            resuableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierFirst forIndexPath:indexPath];
            resuableView.sortButton.selected = self.isSort;
            resuableView.backgroundColor = [UIColor whiteColor];
            resuableView.delegate = self;
            typeof(self) __weak weakSelf = self;
            [resuableView sortButtonDidClick:^(SortButtonState state) {
                // 排序删除
                if(state == DeleteState) {
                    weakSelf.isSort = YES;
                } else {
                    // 完成
                    weakSelf.isSort = NO;
                }
                [weakSelf.collectionView reloadData];
                
            }];
            resuableView.titleLabel.text = @"切换栏目";
        } else {
            resuableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierSecond forIndexPath:indexPath];
            resuableView.backgroundColor = [UIColor whiteColor];
            resuableView.titleLabel.text = @"点击添加更多栏目";
            resuableView.sortButton.hidden = YES;
            resuableView.upImageView.hidden = YES;
        }
    }
    return resuableView;
}

#pragma -mark 添加频道动画效果
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        LPSortCollectionViewCell *startCell = (LPSortCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        startCell.contentLabel.hidden = YES;
        
        NSString *title = [self.optionalArray objectAtIndex:indexPath.row];
        self.lastLabelIsHidden = YES;
        [self.selectedArray addObject:[self.optionalArray objectAtIndex:indexPath.row]];
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        //移动开始的attributes
        UICollectionViewLayoutAttributes *startAttributes = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
        
        self.animationLabel.frame = CGRectMake(startAttributes.frame.origin.x, startAttributes.frame.origin.y, startAttributes.frame.size.width , startAttributes.frame.size.height);
        self.animationLabel.text = [self.optionalArray objectAtIndex:indexPath.row];
        [self.collectionView addSubview:self.animationLabel];
        NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:self.selectedArray.count-1 inSection:0];
        //移动终点的attributes
        UICollectionViewLayoutAttributes *endAttributes = [self.collectionView layoutAttributesForItemAtIndexPath:toIndexPath];
        typeof(self) __weak weakSelf = self;
        //移动动画
        [UIView animateWithDuration:0.4 animations:^{
            weakSelf.animationLabel.center = endAttributes.center;
        } completion:^(BOOL finished) {
            //展示最后一个cell的contentLabel
            LPSortCollectionViewCell *endCell = (LPSortCollectionViewCell *)[weakSelf.collectionView cellForItemAtIndexPath:toIndexPath];
            endCell.contentLabel.hidden = NO;
            weakSelf.lastLabelIsHidden = NO;
            [weakSelf.animationLabel removeFromSuperview];
            [weakSelf.optionalArray removeObjectAtIndex:indexPath.row];
            [weakSelf.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            [LPChannelItemTool updateChannelIsSelectedWithTitle:@"1" title:title];
        }];
    }
}

#pragma mark - collectionView Style
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((ScreenWidth - 5 * cellPadding) / 4.0, 30);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(cellPadding, cellPadding, cellPadding, cellPadding);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return cellPadding;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return cellPadding;
}

// 设置header高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(ScreenWidth, 40.0);
    }
    else{
        return CGSizeMake(ScreenWidth, 30.0);
    }
    
}

// 设置footer高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return  CGSizeMake(ScreenWidth, 0.0);
}
@end
