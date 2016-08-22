//
//  LPHomeChannelItemController.m
//  EveryoneNews
//
//  Created by dongdan on 16/5/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPHomeChannelItemController.h"
#import "LPhomechannelItemTopView.h"
#import "LPChannelItemCollectionViewCell.h"
#import "LPChannelItemCollectionReusableView.h"
#import "LPChannelItem.h"
#import "LPHomeViewController.h"
#import "LPHomeViewController+ChannelItemMenu.h"
#import "LPHomeViewController+ContentView.h"
#import "LXReorderableCollectionViewFlowLayout.h"
#import "LPPagingView.h"
#import "LPPagingViewPage.h"

static NSString *reuseIdentifierFooter = @"reuseIdentifierFooter";
static NSString *reuseIdentifierHeader = @"reuseIdentifierHeader";
static NSString *cellIdentifier = @"sortCollectionViewCell";
//NSString * const cardCellIdentifier = @"CardCellIdentifier";

@interface LPHomeChannelItemController ()<LPHomeChannelItemTopViewDelegate, LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *sortCollectionView;
// 频道添加时动画标签
@property (nonatomic, strong) UILabel *animationLabel;
// 每个频道唯一标识
// 记录所有的样式，用于长按拖动
@property (nonatomic, strong) NSMutableArray *cellAttributesArray;

@property (nonatomic, copy) NSString *channelItemChanged;

@end

@implementation LPHomeChannelItemController


#pragma mark - 懒加载
- (NSMutableArray *)cellAttributesArray {
    if (_cellAttributesArray == nil) {
        _cellAttributesArray = [[NSMutableArray alloc] init];
    }
    return _cellAttributesArray;
}

#pragma mark - 初始化
- (instancetype)init {
    if(self = [super init]) {
        CGFloat fontSize = LPFont4;
        self.animationLabel = [[UILabel alloc] init];
        self.animationLabel.textAlignment = NSTextAlignmentCenter;
        self.animationLabel.font = [UIFont systemFontOfSize:fontSize];
        self.animationLabel.textColor = [UIColor colorFromHexString:LPColor3];
        self.animationLabel.layer.borderColor = [UIColor colorFromHexString:@"#e5e5e5"].CGColor;
        self.animationLabel.layer.borderWidth = 0.5f;
        self.animationLabel.backgroundColor = [UIColor whiteColor];
        self.animationLabel.clipsToBounds = YES;
        self.animationLabel.layer.cornerRadius = 7;
    }
    return self;
}

#pragma mark - ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6"];
    [self setupSubViews];
    self.channelItemChanged = @"0";
}

#pragma mark - ViewWillDidappear
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"selectedChannelTitle"] = self.selectedChannelTitle;
    dict[@"selectedArray"] = self.selectedArray;
    dict[@"optionalArray"] = self.optionalArray;
    dict[@"channelItemChanged"] = self.channelItemChanged;
    self.channelItemDidChangedBlock(dict);
}

#pragma mark - 创建视图
- (void)setupSubViews {
    
    // 顶部导航视图
    LPHomeChannelItemTopView *topView = [[LPHomeChannelItemTopView alloc] initWithFrame:self.view.bounds];
    topView.delegate = self;
    [self.view addSubview:topView];

    CGFloat topViewHeight = 64.5f;

    if (iPhone6) {
        topViewHeight = 72.5f;
    }
    
    
    // 自定义流水布局
    LXReorderableCollectionViewFlowLayout *layout = [[LXReorderableCollectionViewFlowLayout alloc] init];
    
    // 自带流水布局(9.0以上版本适用)
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    CGFloat sortCollectionViewX = 0;
    CGFloat sortCollectionViewY = topViewHeight;
    CGFloat sortCollectionViewW = ScreenWidth;
    CGFloat sortCollectionViewH = ScreenHeight - topViewHeight;

    // 频道栏管理
    UICollectionView *sortCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(sortCollectionViewX, sortCollectionViewY, sortCollectionViewW, sortCollectionViewH) collectionViewLayout:layout];
    
    // 9.0以上版本适用
//    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
//        //此处给其增加长按手势，用此手势触发cell移动效果
//        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(sortChannelItem:)];
//        longGesture.minimumPressDuration = 0.2;
//        [sortCollectionView addGestureRecognizer:longGesture];
//    }
    
    sortCollectionView.delegate = self;
    sortCollectionView.dataSource = self;
    sortCollectionView.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6"];
    sortCollectionView.showsVerticalScrollIndicator = NO;
    [sortCollectionView registerClass:[LPChannelItemCollectionViewCell class]
           forCellWithReuseIdentifier:cellIdentifier];
    [sortCollectionView registerClass:[LPChannelItemCollectionReusableView class]
           forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierHeader];
    [sortCollectionView registerClass:[UICollectionReusableView class]
           forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseIdentifierFooter];
    [self.view addSubview:sortCollectionView];
    self.sortCollectionView = sortCollectionView;
    
}

#pragma mark - LPHomeChannelItemTopViewDelegate
- (void)backButtonDidClick:(LPHomeChannelItemTopView *)homeChannelItemTopView {
 
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
 
    if(section == 0) {
        return self.selectedArray.count;
    } else {
        return  self.optionalArray.count;
    }

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LPChannelItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        [cell setCellWithArray:self.selectedArray indexPath:indexPath selectedTitle:self.selectedChannelTitle];
    } else {
        [cell setCellWithArray:self.optionalArray indexPath:indexPath selectedTitle:self.selectedChannelTitle];

    }
    return cell;
}


#pragma mark - LXReorderableCollectionViewDataSource

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath {
    
    id objc = [self.selectedArray objectAtIndex:fromIndexPath.item];
    //从资源数组中移除该数据
    [self.selectedArray removeObject:objc];
    //将数据插入到资源数组中的目标位置上
    [self.selectedArray insertObject:objc atIndex:toIndexPath.item];
    self.channelItemChanged = @"1";
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.item != 0) {
        return YES;
    }
    return NO;
    
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath {
    
    /* 判断两个indexPath参数的section属性, 是否在一个分区 */
    if (fromIndexPath.section != toIndexPath.section) {
        return NO;
    } else if (toIndexPath.section == 0 && toIndexPath.item == 0) {
        return NO;
    } else {
        return YES;
    }
    
    return YES;
}

#pragma mark - didSelectItemAtIndexPath
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LPChannelItemCollectionViewCell *startCell = (LPChannelItemCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    self.channelItemChanged = @"1";
    // 删除频道
    if (indexPath.section == 0) {
        [self.optionalArray addObject:self.selectedArray[indexPath.row]];
        [collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
        startCell.userInteractionEnabled = NO;
        //移动开始的attributes
        UICollectionViewLayoutAttributes *startAttributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath].copy;
        
        CGFloat deleteButtonW = 18;
        CGFloat deleteButtonH = 18;
        
        CGFloat labelX = startAttributes.frame.origin.x;
        CGFloat labelY = startAttributes.frame.origin.y + deleteButtonW / 2;
        CGFloat labelW = startAttributes.frame.size.width;
        CGFloat labelH = startAttributes.frame.size.height - deleteButtonH / 2;
        
        self.animationLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
        self.animationLabel.text = ((LPChannelItem *)(self.selectedArray[indexPath.row])).channelName;
        [collectionView addSubview:self.animationLabel];
        
        NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:self.optionalArray.count - 1 inSection:1];
        LPChannelItemCollectionViewCell *endCell = (LPChannelItemCollectionViewCell *)[collectionView cellForItemAtIndexPath:toIndexPath];
        endCell.hidden = YES;
        // 终点attributes
        UICollectionViewLayoutAttributes *endAttributes = [collectionView layoutAttributesForItemAtIndexPath:toIndexPath].copy;
        CGFloat endLabelX = endAttributes.frame.origin.x;
        CGFloat endLabelY = endAttributes.frame.origin.y + deleteButtonW / 2;
        CGFloat endLabelW = endAttributes.frame.size.width;
        CGFloat endLabelH = endAttributes.frame.size.height - deleteButtonH / 2;
        CGRect endFrame = CGRectMake(endLabelX, endLabelY, endLabelW, endLabelH);
        
        [self.selectedArray removeObjectAtIndex:indexPath.row];
        [collectionView deleteItemsAtIndexPaths:@[indexPath]];
        // 动画
        [UIView animateWithDuration:0.3 animations:^{
            self.animationLabel.frame = endFrame;
            startCell.channelItemLabel.alpha = 0.3f;
        } completion:^(BOOL finished) {
            endCell.hidden = NO;
            [self.animationLabel removeFromSuperview];
            startCell.userInteractionEnabled = YES;
            startCell.channelItemLabel.alpha = 1.0f;
        }];
        // 添加频道
    } else {
        
        [self.selectedArray addObject:self.optionalArray[indexPath.row]];
        [collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        startCell.userInteractionEnabled = NO;
        // 移动开始的attributes
        UICollectionViewLayoutAttributes *startAttributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath].copy;
        
        CGFloat deleteButtonW = 18;
        CGFloat deleteButtonH = 18;
        
        CGFloat labelX = startAttributes.frame.origin.x;
        CGFloat labelY = startAttributes.frame.origin.y + deleteButtonW / 2;
        CGFloat labelW = startAttributes.frame.size.width;
        CGFloat labelH = startAttributes.frame.size.height - deleteButtonH / 2;
        
        self.animationLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
        self.animationLabel.text = ((LPChannelItem *)(self.optionalArray[indexPath.row])).channelName;
        [collectionView addSubview:self.animationLabel];
        
        NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:self.selectedArray.count - 1 inSection:0];
        LPChannelItemCollectionViewCell *endCell = (LPChannelItemCollectionViewCell *)[collectionView cellForItemAtIndexPath:toIndexPath];
        endCell.hidden = YES;
        // 终点attributes
        UICollectionViewLayoutAttributes *endAttributes = [collectionView layoutAttributesForItemAtIndexPath:toIndexPath].copy;
        CGFloat endLabelX = endAttributes.frame.origin.x;
        CGFloat endLabelY = endAttributes.frame.origin.y + deleteButtonW / 2;
        CGFloat endLabelW = endAttributes.frame.size.width;
        CGFloat endLabelH = endAttributes.frame.size.height - deleteButtonH / 2;
        CGRect endFrame = CGRectMake(endLabelX, endLabelY, endLabelW, endLabelH);
        
        [self.optionalArray removeObjectAtIndex:indexPath.row];
                
        [collectionView deleteItemsAtIndexPaths:@[indexPath]];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.animationLabel.frame = endFrame;
            startCell.channelItemLabel.alpha = 0.f;
        } completion:^(BOOL finished) {
            self.selectedChannelTitle = self.animationLabel.text;
            [self.animationLabel removeFromSuperview];
            endCell.hidden = NO;
            startCell.channelItemLabel.alpha = 1.0f;
            startCell.userInteractionEnabled = YES;
        }];
    }
}

#pragma mark - UICollectionView Header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    // 头部
    UICollectionReusableView *resuableView = nil;
    if(kind == UICollectionElementKindSectionHeader) {
        LPChannelItemCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierHeader forIndexPath:indexPath];
        if(indexPath.section == 0) {
            headerView.titleLabel.text = @"我的频道 (拖动调整顺序)";
        } else {
            headerView.titleLabel.text = @"热门频道 (点击添加更多)";
        }
        resuableView = headerView;
    }
    // 尾部
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseIdentifierFooter forIndexPath:indexPath];
        if (indexPath.section == 0) {
            footerView.backgroundColor = [UIColor colorFromHexString:@"#f0f0f0"];
            
        } else {
            footerView.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6"];
        }
        resuableView = footerView;
    }
    return resuableView;
}

#pragma mark - UICollectionView Style
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat paddingLeft = 12;
    if (iPhone6Plus) {
        paddingLeft = 13;
    }
    
    CGFloat cellPadding = 18;
    CGFloat channelItemLabelW = (ScreenWidth - 2 * paddingLeft - 2 * cellPadding) / 3;
    CGFloat channelItemLabelH = 35;
    CGFloat imageViewH = 18;
    
    return CGSizeMake(channelItemLabelW, channelItemLabelH + imageViewH / 2);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    CGFloat paddingLeft = 12;
    CGFloat paddingTop = 15;
    CGFloat paddingBottom = 23;
    CGFloat paddingRight = 12;
    
    return UIEdgeInsetsMake(paddingTop, paddingLeft, paddingBottom, paddingRight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 18;
    
}

// 设置header高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(ScreenWidth, 38.0);
}

// 设置footer高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(ScreenWidth, 9);
}


#pragma mark - 9.0以上版本适用以下方法 (保留代码)
//- (void)sortChannelItem:(UILongPressGestureRecognizer *)recognizer {
//    //判断手势状态
//    switch (recognizer.state) {
//        case UIGestureRecognizerStateBegan:{
//            //判断手势落点位置是否在路径上
//            NSIndexPath *indexPath = [self.sortCollectionView  indexPathForItemAtPoint:[recognizer locationInView:self.sortCollectionView ]];
//            if (indexPath == nil) {
//                break;
//            }
//            //在路径上则开始移动该路径上的cell
//            [self.sortCollectionView  beginInteractiveMovementForItemAtIndexPath:indexPath];
//        }
//            break;
//        case UIGestureRecognizerStateChanged:
//            //移动过程当中随时更新cell位置
//            [self.sortCollectionView  updateInteractiveMovementTargetPosition:[recognizer locationInView:self.sortCollectionView ]];
//            break;
//        case UIGestureRecognizerStateEnded:
//            //移动结束后关闭cell移动
//            [self.sortCollectionView  endInteractiveMovement];
//            break;
//        default:
//            [self.sortCollectionView  cancelInteractiveMovement];
//            break;
//    }
//}
//
//- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    if (indexPath.section == 0 && indexPath.item != 0) {
//           return YES;
//    }
//    return NO;
//}
//
//- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath  {
//    /* 判断两个indexPath参数的section属性, 是否在一个分区 */
//    if (originalIndexPath.section != proposedIndexPath.section) {
//        return originalIndexPath;
//    } else if (proposedIndexPath.section == 0 && proposedIndexPath.item == 0) {
//        return originalIndexPath;
//    } else {
//        return proposedIndexPath;
//    }
//}
//
//
//
//- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
//    id objc = [self.selectedArray objectAtIndex:sourceIndexPath.item];
//    //从资源数组中移除该数据
//    [self.selectedArray removeObject:objc];
//    //将数据插入到资源数组中的目标位置上
//    [self.selectedArray insertObject:objc atIndex:destinationIndexPath.item];
//}






@end
