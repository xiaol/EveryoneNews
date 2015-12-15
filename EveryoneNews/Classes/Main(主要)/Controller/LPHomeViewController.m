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
#import "LPMenuCollectionViewCell.h"
#import "LPSortCollectionView.h"

const static CGFloat cellPadding = 10;
static NSString *cellIdentifier = @"sortCollectionViewCell";
static NSString *reuseIdentifierFirst = @"reuseIdentifierFirst";
static NSString *reuseIdentifierSecond = @"reuseIdentifierSecond";

static NSString *menuCellIdentifier = @"menuCollectionViewCell";
const static float topViewHeight = 60;
// 展开折叠图片宽度
const static float menuImageViewWidth= 40;

@interface LPHomeViewController () <LPPagingViewDataSource, LPPagingViewDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, LPSortCollectionReusableViewDelegate>

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
@property (nonatomic, copy) NSString *selectedChannelTitle;

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

- (BOOL)prefersStatusBarHidden {
    return  YES;
}

// 首次默认选中第一个菜单项
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0
                                                inSection:0];
    LPMenuButton *menuButton = ((LPMenuCollectionViewCell *)[self.menuView cellForItemAtIndexPath:indexPath]).menuButton;
    if(menuButton != nil) {
        self.selectedChannelTitle = menuButton.text;
    }
    [self.menuView selectItemAtIndexPath:indexPath
                                animated:NO
                          scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)setupSubViews {

    self.channelItemsArray =  [LPChannelItemTool getChannelItems];
    // 已选分类
    for (LPChannelItem *channelItem in self.channelItemsArray) {
        if([channelItem.channelIsSelected  isEqual: @"1"]) {
            [self.selectedArray addObject:channelItem];
        }
    }
    // 可选分类
    for (LPChannelItem *channelItem in self.channelItemsArray) {
        if([channelItem.channelIsSelected  isEqual: @"0"]) {
            [self.optionalArray addObject:channelItem];
        }
    }
    
    // 菜单栏
    UICollectionViewFlowLayout *menuViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    menuViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    menuViewFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
  
    LPMenuView *menuView = [[LPMenuView alloc] initWithFrame:CGRectMake(0, topViewHeight, ScreenWidth - menuImageViewWidth, TabBarHeight) collectionViewLayout:menuViewFlowLayout];
    menuView.backgroundColor = [UIColor whiteColor];
    menuView.showsHorizontalScrollIndicator = NO;
    menuView.delegate = self;
    menuView.dataSource = self;
    [menuView registerClass:[LPMenuCollectionViewCell class] forCellWithReuseIdentifier:menuCellIdentifier];
    menuView.alwaysBounceHorizontal = NO;
    menuView.allowsMultipleSelection = NO;
//    menuView.delaysContentTouches = NO;
//    menuView.canCancelContentTouches = NO;
    self.menuView = menuView;

    // 内容页面
    LPPagingView *pagingView = [[LPPagingView alloc] init];
    pagingView.frame = CGRectMake(0, 60 + TabBarHeight, ScreenWidth, ScreenHeight - 60 - TabBarHeight);
    pagingView.contentSize = CGSizeMake(self.selectedArray.count * pagingView.width, 0);
    pagingView.delegate = self;
    pagingView.dataSource = self;
    [self.view addSubview:pagingView];
    self.pagingView = pagingView;

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.sortCollectionView = [[LPSortCollectionView alloc] initWithFrame:CGRectMake(0, topViewHeight - ScreenHeight, ScreenWidth, ScreenHeight - topViewHeight) collectionViewLayout:layout];
    self.sortCollectionView.delegate = self;
    self.sortCollectionView.dataSource = self;
    self.sortCollectionView.backgroundColor = [UIColor whiteColor];
    self.sortCollectionView.alpha = 0.95;
    [self.sortCollectionView registerClass:[LPSortCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.sortCollectionView registerClass:[LPSortCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierFirst];
    [self.sortCollectionView registerClass:[LPSortCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierSecond];
    // 长按交换频道顺序
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
    [self.sortCollectionView addGestureRecognizer:longGesture];
    [self.view addSubview:self.sortCollectionView];
 

    // 添加菜单栏
    [self.view addSubview:menuView];

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



#pragma -mark 重新加载菜单项
- (void)manageChannelItems {
     UIImage *image = nil;
    __weak __typeof(self)weakSelf = self;
    // 展开频道栏
    if(self.isSpread == NO) {
        image = [UIImage imageNamed:@"向上箭头"];
        self.isSpread = YES;
        self.menuView.alpha = 0;
        // 选中某个按钮后需要刷新频道
        [self.sortCollectionView reloadData];
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.imageView.transform = CGAffineTransformMakeRotation(-3.14159);
            weakSelf.sortCollectionView.frame = CGRectMake(0, 60, ScreenWidth, ScreenHeight - 60);
        } completion:^(BOOL finished) {
        }];
    } else {
        image = [UIImage imageNamed:@"向下箭头"];
        self.isSpread = NO;
        self.menuView.alpha = 1;
        self.isSort = NO;
        // 当前选中频道索引值
        int index = 0;
        for (int i = 0; i < self.selectedArray.count; i++) {
            LPChannelItem *channelItem = self.channelItemsArray[i];
            if([channelItem.channelName isEqualToString:self.selectedChannelTitle]) {
                index = i;
                break;
            }
        
        }
        if(index == 0) {
            self.selectedChannelTitle = @"推荐";
        }
        NSIndexPath *menuIndexPath = [NSIndexPath indexPathForItem:index
                                                         inSection:0];
        [self.menuView selectItemAtIndexPath:menuIndexPath
                                    animated:NO
                              scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        [self.pagingView setCurrentPageIndex:index animated:NO];
       
         [UIView animateWithDuration:0.5 animations:^{
           weakSelf.imageView.transform = CGAffineTransformMakeRotation(0 * M_PI / 180);
           weakSelf.sortCollectionView.frame = CGRectMake(0, 60 - ScreenHeight, ScreenWidth, ScreenHeight - 60);
         } completion:^(BOOL finished) {
             
         }];
    }
}

#pragma -mark 分页
- (NSInteger)numberOfPagesInPagingView:(LPPagingView *)pagingView {

    return self.selectedArray.count;
}

- (UIView *)pagingView:(LPPagingView *)pagingView pageForPageIndex:(NSInteger)pageIndex {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50, 50, ScreenWidth, 20)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth, 20)];
    label.text = [NSString stringWithFormat:@"%d",pageIndex];
    label.textColor = [UIColor redColor];
    [view addSubview:label];
    return view;
}

- (void)pagingView:(LPPagingView *)pagingView didScrollWithRatio:(CGFloat)ratio {
    int index = floor(ratio);
    CGFloat rate = ratio - index;
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForItem:index
                                                     inSection:0];
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:index + 1
                                                        inSection:0];
    LPMenuCollectionViewCell *currentCell = (LPMenuCollectionViewCell *)[self.menuView cellForItemAtIndexPath:currentIndexPath];
    LPMenuCollectionViewCell *nextCell = (LPMenuCollectionViewCell *)[self.menuView cellForItemAtIndexPath:nextIndexPath];
    LPMenuButton *currentButton = currentCell.menuButton;
    LPMenuButton *nextButton = nextCell.menuButton;
    [currentButton titleSizeAndColorDidChangedWithRate:rate];
    [nextButton titleSizeAndColorDidChangedWithRate:(1 - rate)];
}



- (void)pagingView:(LPPagingView *)pagingView didScrollToPageIndex:(NSInteger)pageIndex {
    for (int i = 0; i < self.selectedArray.count; i++) {
        LPChannelItem *channelItem = self.selectedArray[i];
        if(i == pageIndex) {
            self.selectedChannelTitle = channelItem.channelName;
            break;
        }
    }
    // 改变菜单栏按钮选中取消状态
    [self buttonSelectedStatusChangedWithIndex:pageIndex];
}

- (void)buttonSelectedStatusChangedWithIndex:(int)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index
                                                 inSection:0];
    [self.menuView selectItemAtIndexPath:indexPath
                                animated:YES
                          scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}
#pragma 菜单栏选中某个按钮代理方法
- (void)menuView:(LPMenuView *)menuView didSelectedButtonAtIndex:(int)index {
     [self.pagingView setCurrentPageIndex:index animated:NO];
    
    
}

#pragma - mark UICollectionView 数据源

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
     if([collectionView isKindOfClass:[LPMenuView class]]) {
         return 1;
     } else {
         if(self.isSort) {
             return 1;
         } else {
             return 2;
         }
     }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if([collectionView isKindOfClass:[LPMenuView class]]) {
        return self.selectedArray.count;
    } else {
        if(section == 0) {
            return self.selectedArray.count;
        } else {
            return  self.optionalArray.count;
        }
    }
}

#pragma  数据绑定
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if([collectionView isKindOfClass:[LPMenuView class]]) {
        LPMenuCollectionViewCell *cell = (LPMenuCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:menuCellIdentifier forIndexPath:indexPath];
        LPChannelItem *channelItem = [self.selectedArray objectAtIndex:indexPath.item];
        cell.channelItem = channelItem;
        return cell;
    } else {
        LPSortCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        if(indexPath.section == 0) {
            [cell setCellWithArray:self.selectedArray indexPath:indexPath selectedTitle:self.selectedChannelTitle];
           
            // 删除状态时显示灰色
            if(self.isSort) {
                 cell.contentLabel.textColor = [UIColor grayColor];
            }
            if(indexPath.row == 0) {
                cell.deleteButton.hidden = YES;
                
            } else {
                cell.deleteButton.hidden = !self.isSort;
                // 添加频道时先隐藏label
                if(indexPath.row == self.selectedArray.count -1 ) {
                    cell.contentLabel.hidden = self.lastLabelIsHidden;
                }
                
            }
        } else {
            [cell setCellWithArray:self.optionalArray indexPath:indexPath selectedTitle:self.selectedChannelTitle];
             cell.deleteButton.hidden = YES;
             cell.contentLabel.textColor = [UIColor grayColor];
        }
        return cell;
    }
  
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if([collectionView isKindOfClass:[LPMenuView class]]) {
        return nil;
    } else {
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
                    [weakSelf.sortCollectionView reloadData];
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
   
}

#pragma  长按交换频道
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if([collectionView isKindOfClass:[LPMenuView class]]) {
        
    } else {
        if(destinationIndexPath.row != 0) {
            LPChannelItem *sourceItem = [self.selectedArray objectAtIndex:sourceIndexPath.row];
            LPChannelItem *destinationItem = [self.selectedArray objectAtIndex:destinationIndexPath.row];
            [self.selectedArray removeObjectAtIndex:sourceIndexPath.row];
            [self.selectedArray insertObject:destinationItem atIndex:sourceIndexPath.row];
            [self.selectedArray removeObjectAtIndex:destinationIndexPath.row];
            [self.selectedArray insertObject:sourceItem atIndex:destinationIndexPath.row];
            [self reloadChannelItems];
        }
    }
}

- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    //判断手势落点位置是否在路径上
    NSIndexPath *indexPath = [self.sortCollectionView indexPathForItemAtPoint:[longGesture locationInView:self.sortCollectionView]];
    // 栏目按钮显示完成状态
    if(self.isSort && indexPath.section == 0) {
        //判断手势状态
        switch (longGesture.state) {
            case UIGestureRecognizerStateBegan:{
                if (indexPath == nil) {
                    break;
                }
                //在路径上则开始移动该路径上的cell
                [self.sortCollectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            }
                break;
            case UIGestureRecognizerStateChanged:
                if(indexPath.item != 0) {
                    [self.sortCollectionView updateInteractiveMovementTargetPosition:[longGesture locationInView:self.sortCollectionView]];
                }
                
                break;
            case UIGestureRecognizerStateEnded:
                //移动结束后关闭cell移动
                [self.sortCollectionView endInteractiveMovement];
                
                break;
            default:
                [self.sortCollectionView cancelInteractiveMovement];
                
                break;
        }
    }
}
#pragma  添加频道动画效果
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if([collectionView isKindOfClass:[LPMenuView class]]) {
        LPMenuCollectionViewCell *currentCell = (LPMenuCollectionViewCell *)[self.menuView cellForItemAtIndexPath:indexPath];
        LPMenuButton *currentButton = currentCell.menuButton;
        self.selectedChannelTitle = currentButton.text;
        [self.pagingView setCurrentPageIndex:indexPath.item animated:NO];
        
    } else {
     // 删除频道
     if (indexPath.section == 0) {
            LPSortCollectionViewCell *currentCell =  (LPSortCollectionViewCell *)[self.sortCollectionView cellForItemAtIndexPath:indexPath];
            // 删除频道
            if(self.isSort) {
                if (indexPath != nil) {
                    if(indexPath.item !=0 ) {
                        [self.optionalArray insertObject:[self.selectedArray objectAtIndex:indexPath.row] atIndex:0];
                        [self.selectedArray removeObjectAtIndex:indexPath.row];
                        [self.sortCollectionView performBatchUpdates:^{
                                [self.sortCollectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
                            } completion:^(BOOL finished) {
                                 [self reloadChannelItems];
                        }];
                    } else {
                        
                    }
                }
            } else {
                // 跳转到指定频道
                UIImage *image = [UIImage imageNamed:@"向下箭头"];
                __weak typeof(self) weakSelf = self;
                self.isSpread = NO;
                self.menuView.alpha = 1;
                self.isSort = NO;
                // 回到主界面时跳转到单击的选项
                [self.menuView reloadData];
                self.selectedChannelTitle = currentCell.contentLabel.text;
                [self redirectToChannel:indexPath.item];
                [UIView animateWithDuration:0.2 animations:^{
                    [weakSelf.imageView  setImage:image];
                    weakSelf.sortCollectionView.frame = CGRectMake(0, 60 - ScreenHeight, ScreenWidth, ScreenHeight - 60);
                } completion:^(BOOL finished) {
                   
                }];
            }
        }
        // 添加频道
        else if (indexPath.section == 1) {
             self.sortCollectionView.userInteractionEnabled = NO;
             LPSortCollectionViewCell *startCell = (LPSortCollectionViewCell *)[self.sortCollectionView cellForItemAtIndexPath:indexPath];
             startCell.contentLabel.hidden = YES;
             self.lastLabelIsHidden = YES;
             [self.selectedArray addObject:[self.optionalArray objectAtIndex:indexPath.row]];
             [self.sortCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
             //移动开始的attributes
             UICollectionViewLayoutAttributes *startAttributes = [self.sortCollectionView layoutAttributesForItemAtIndexPath:indexPath].copy;
             self.animationLabel.frame = CGRectMake(startAttributes.frame.origin.x, startAttributes.frame.origin.y, startAttributes.frame.size.width , startAttributes.frame.size.height);
             self.animationLabel.text = ((LPChannelItem *)[self.optionalArray objectAtIndex:indexPath.row]).channelName;
             [self.sortCollectionView addSubview:self.animationLabel];
             NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:self.selectedArray.count - 1 inSection:0];
             // 终点attributes
             UICollectionViewLayoutAttributes *endAttributes = [self.sortCollectionView layoutAttributesForItemAtIndexPath:toIndexPath].copy;
             typeof(self) __weak weakSelf = self;
             // 动画
             [UIView animateWithDuration:0.4 animations:^{
                 weakSelf.animationLabel.center = endAttributes.center;
             } completion:^(BOOL finished) {
                 //展示最后一个cell的contentLabel
                 LPSortCollectionViewCell *endCell = (LPSortCollectionViewCell *)[weakSelf.sortCollectionView cellForItemAtIndexPath:toIndexPath];
                 endCell.contentLabel.hidden = NO;
                 weakSelf.lastLabelIsHidden = NO;
                 [weakSelf.animationLabel removeFromSuperview];
                 [weakSelf.optionalArray removeObjectAtIndex:indexPath.row];
                 [weakSelf.sortCollectionView deleteItemsAtIndexPaths:@[indexPath]];
                 [weakSelf reloadChannelItems];
                 weakSelf.sortCollectionView.userInteractionEnabled = YES;
             }];
        }
        
    }

}

- (void)redirectToChannel:(int)index {
    
    NSIndexPath *menuIndexPath = [NSIndexPath indexPathForItem:index
                                                     inSection:0];
    [self.menuView selectItemAtIndexPath:menuIndexPath
                                animated:NO
                          scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    [self.pagingView setCurrentPageIndex:index animated:NO];
}

#pragma 更新plist文件中所有频道
- (void)reloadChannelItems {
    [self.channelItemsArray removeAllObjects];
    for (LPChannelItem *channelItem in self.selectedArray) {
        channelItem.channelIsSelected = @"1";
        [self.channelItemsArray addObject:channelItem];
    }
    for (LPChannelItem *channelItem in self.optionalArray) {
        channelItem.channelIsSelected = @"0";
        [self.channelItemsArray addObject:channelItem];
    }
    [LPChannelItemTool saveChannelItems:self.channelItemsArray];
    [self.menuView reloadData];
//    for (int i=0; i < self.selectedArray.count; i++) {
//        [self.menuView  deselectItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES];
//    }
    // 重新加载分页数据
    [self.pagingView reloadData];
}

#pragma mark - collectionView Style
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if([collectionView isKindOfClass:[LPMenuView class]]) {
        return CGSizeMake(50, TabBarHeight - 10);
    } else {
        return CGSizeMake((ScreenWidth - 5 * cellPadding) / 4.0, 30);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if([collectionView isKindOfClass:[LPMenuView class]]) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    } else {
        return UIEdgeInsetsMake(cellPadding, cellPadding, cellPadding, cellPadding);
    }
   
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return cellPadding;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return cellPadding;
}

// 设置header高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if([collectionView isKindOfClass:[LPMenuView class]]) {
        return CGSizeMake(0, 0);
    } else {
        if (section == 0) {
            return CGSizeMake(ScreenWidth, 40.0);
        }
        else{
            return CGSizeMake(ScreenWidth, 30.0);
        }
    }
    
}

// 设置footer高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if([collectionView isKindOfClass:[LPMenuView class]]) {
        return CGSizeMake(0, 0);
    } else {
        return  CGSizeMake(ScreenWidth, 0.0);
    }
}


@end
