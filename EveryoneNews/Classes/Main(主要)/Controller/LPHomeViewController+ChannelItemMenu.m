//
//  LPHomeViewController+ChannelItemMenu.m
//  EveryoneNews
//
//  Created by dongdan on 15/12/26.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPHomeViewController+ChannelItemMenu.h"
#import "LPHomeViewController+PagingView.h"
#import "LPPagingView.h"
#import "LPMenuView.h"
#import "LPChannelItemTool.h"
#import "LPChannelItem.h"
#import "LPMenuButton.h"
#import "LPSortCollectionViewCell.h"
#import "LPMenuCollectionViewCell.h"
#import "LPPagingViewPage.h"

const static CGFloat cellPadding = 10;
static NSString *reuseIdentifierFirst = @"reuseIdentifierFirst";
static NSString *reuseIdentifierSecond = @"reuseIdentifierSecond";
static NSString *menuCellIdentifier = @"menuCollectionViewCell";
static NSString *cellIdentifier = @"sortCollectionViewCell";
static NSString *cardCellIdentifier = @"CardCellIdentifier";

@implementation LPHomeViewController (ChannelItemMenu)

#pragma mark - 初始化
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

#pragma mark - 默认选中第一个按钮
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

#pragma mark - 保存频道的plist文件
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self channelItemsDidSaved];
    
}

- (void)channelItemsDidSaved {
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
}
#pragma mark - 设置所有频道CellIdentifier
- (void)setCellIdentifierOfAllChannelItems {
    for (int i = 0; i < self.selectedArray.count; i++) {
        NSString *cellIdentifier = [NSString stringWithFormat:@"%@%d",cardCellIdentifier,i];
        [self.cardCellIdentifierDictionary setObject:cellIdentifier forKey:@(i)];
    }
}

#pragma mark - 初始化所有频道名称
- (void)initAllChannelItems {
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
}

#pragma mark -  设置频道和页码的映射关系
- (void)updatePageindexMapToChannelItemDictionary {
    [self.pageindexMapToChannelItemDictionary removeAllObjects];
    for (int i = 0; i < self.selectedArray.count; i++) {
        LPChannelItem *channelItem = self.selectedArray[i];
        [self.pageindexMapToChannelItemDictionary setObject:channelItem forKey:@(i)];
    }
}

#pragma mark - 长按切换到排序删除状态
- (void)longGesture:(UILongPressGestureRecognizer  *)longRecognizer {
    
    self.isSort = YES;
    [self.sortCollectionView reloadData];
    
}
#pragma mark - 单击跳转到指定频道
- (void)redirectToSelectedChanneItem:(int)index {
    NSIndexPath *menuIndexPath = [NSIndexPath indexPathForItem:index
                                                     inSection:0];
    [self.menuView selectItemAtIndexPath:menuIndexPath
                                animated:NO
                          scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    [self.pagingView setCurrentPageIndex:index animated:NO];
    // 此处缺少自动刷新机制
    [self loadMoreDataInPageAtPageIndex:index];
}

#pragma mark - 频道排序
- (void)sortChannelItem:(UIPanGestureRecognizer *)recognizer {
    LPSortCollectionViewCell *cell = (LPSortCollectionViewCell *)recognizer.view;
    NSIndexPath *cellIndexPath = [self.sortCollectionView indexPathForCell:cell];
    BOOL ischange = NO;
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            if (cellIndexPath == nil) {
                break;
            }
            // 获取所有cell的attributes
            [self.cellAttributesArray removeAllObjects];
            for (NSInteger i = 0 ; i < self.selectedArray.count; i++) {
                [self.cellAttributesArray addObject:[self.sortCollectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]]];
            }
            break;
        case UIGestureRecognizerStateChanged:
            if (cellIndexPath.item != 0) {
                // 移动的相对位置
                CGPoint point = [recognizer translationInView:self.sortCollectionView];
                cell.center = CGPointMake(cell.center.x + point.x, cell.center.y + point.y);
                // 移动以后的坐标
                [recognizer setTranslation:CGPointMake(0, 0) inView:self.sortCollectionView];
                for (UICollectionViewLayoutAttributes *attributes in self.cellAttributesArray) {
                    CGRect rect = CGRectMake(attributes.center.x - 12, attributes.center.y - 12, 25, 25);
                    // 判断重叠区域
                    if (CGRectContainsPoint(rect, CGPointMake(recognizer.view.center.x, recognizer.view.center.y)) && (cellIndexPath != attributes.indexPath) && attributes.indexPath.item != 0) {
                     
                        //后面跟前面交换
                        if (cellIndexPath.row > attributes.indexPath.row) {
                            //交替操作0 1 2 3 变成（3<->2 3<->1 3<->0）
                            for (NSInteger index = cellIndexPath.row; index > attributes.indexPath.row; index -- ) {
                                [self.selectedArray exchangeObjectAtIndex:index withObjectAtIndex:index - 1];
                                // 交换CellIdentifier
                                [self.cardCellIdentifierDictionary setObject:[NSString stringWithFormat:@"%@%d",cardCellIdentifier,index - 1] forKey:@(index)];
                                [self.cardCellIdentifierDictionary setObject:[NSString stringWithFormat:@"%@%d",cardCellIdentifier,index] forKey:@(index - 1)];
                            }
                        } else {
                            //前面跟后面交换
                            //交替操作0 1 2 3 变成（0<->1 0<->2 0<->3）
                            for (NSInteger index = cellIndexPath.row; index < attributes.indexPath.row; index ++ ) {
                                [self.selectedArray exchangeObjectAtIndex:index withObjectAtIndex:index + 1];
                                
                                [self.cardCellIdentifierDictionary setObject:[NSString stringWithFormat:@"%@%d",cardCellIdentifier,index + 1] forKey:@(index)];
                                [self.cardCellIdentifierDictionary setObject:[NSString stringWithFormat:@"%@%d",cardCellIdentifier,index] forKey:@(index + 1)];
                            }
                        }
                        ischange = YES;
                        [self.sortCollectionView moveItemAtIndexPath:cellIndexPath toIndexPath:attributes.indexPath];
                    } else {
                        ischange = NO;
                    }
                }
            }
            break;
        case UIGestureRecognizerStateEnded:
            if (!ischange) {
                cell.center = [self.sortCollectionView layoutAttributesForItemAtIndexPath:cellIndexPath].center;
                [self updatePageindexMapToChannelItemDictionary];
            }
            break;
        default:
            break;
    }
}

#pragma mark - UICollectionView DataSource
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
            if (self.isSort) {
                cell.contentLabel.textColor = [UIColor grayColor];
                // 防止手势冲突先删除所有手势
                for (UIGestureRecognizer *gesture in cell.gestureRecognizers) {
                    [cell removeGestureRecognizer:gesture];
                }
                // 拖动排序
                UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sortChannelItem:)];
                panGesture.delegate = self;
                [cell addGestureRecognizer:panGesture];
                
            } else {
                for (UIGestureRecognizer *gesture in cell.gestureRecognizers) {
                    [cell removeGestureRecognizer:gesture];
                }
                // 长按需要变换状态
                UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesture:)];
                longGesture.delegate = self;
                [cell addGestureRecognizer:longGesture];
            }
            if (indexPath.row == 0) {
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

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if([collectionView isKindOfClass:[LPMenuView class]]) {
        LPMenuCollectionViewCell *currentCell = (LPMenuCollectionViewCell *)[self.menuView cellForItemAtIndexPath:indexPath];
        LPMenuButton *currentButton = currentCell.menuButton;
        self.selectedChannelTitle = currentButton.text;
        [self.pagingView setCurrentPageIndex:indexPath.item animated:NO];
        // 超过5分钟自动刷新 第一次调用则加载
        LPChannelItem *channelItem = [currentCell channelItem];
        NSDate *currentDate = [NSDate date];
        NSDate *lastAccessDate = channelItem.lastAccessDate;
        if (lastAccessDate == nil) {
            [self loadMoreDataInPageAtPageIndex:indexPath.item];
            channelItem.lastAccessDate = currentDate;
        } else {
            int interval = (int)[currentDate timeIntervalSinceDate: lastAccessDate] / 60 ;
            // 每5分钟做一次刷新操作
            if (interval > 5) {
                LPPagingViewPage *page = (LPPagingViewPage *)[self.pagingView currentPage];
                [page autotomaticLoadNewData];
                channelItem.lastAccessDate = currentDate;
            }
        }
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
                        [self.cardCellIdentifierDictionary removeObjectForKey:@(indexPath.row)];
                      
                        [self.sortCollectionView performBatchUpdates:^{
                            [self.sortCollectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
                        } completion:^(BOOL finished) {
                            [self updatePageindexMapToChannelItemDictionary];
                        }];
                    }
                }
            }
            else {
                // 跳转到指定频道
                __weak typeof(self) weakSelf = self;
                self.isSpread = NO;
                self.menuView.alpha = 1;
                self.isSort = NO;
                // 回到主界面时跳转到单击的选项
                [self.menuView reloadData];
                [self.pagingView reloadData];
                self.selectedChannelTitle = currentCell.contentLabel.text;
                [self redirectToSelectedChanneItem:(int)indexPath.item];
                [UIView animateWithDuration:0.2 animations:^{
                    weakSelf.blurView.frame = CGRectMake(0, - ScreenHeight, ScreenWidth, ScreenHeight);
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
            
            [self.cardCellIdentifierDictionary setObject:[NSString stringWithFormat:@"%@%d",cardCellIdentifier,indexPath.row] forKey:@(indexPath.row)];
            
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
                weakSelf.sortCollectionView.userInteractionEnabled = YES;
                [weakSelf updatePageindexMapToChannelItemDictionary];
            }];
        }
        
    }
    
}

#pragma mark - UICollectionView Header
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

#pragma mark - UICollectionView Style
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if([collectionView isKindOfClass:[LPMenuView class]]) {
        return CGSizeMake(50, 30);
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
        } else {
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
