//
//  LPWaterfallView.m
//  WaterFlow
//
//  Created by apple on 15/4/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPWaterfallView.h"
#import "LPWaterfallViewCell.h"

#define LPWaterfallViewDefaultCellH 70
#define LPWaterfallViewDefaultMargin 8
#define LPWaterfallViewDefaultNumberOfColumns 2

@interface LPWaterfallView()
/**
 *  所有cell的frame数据（数组）
 */
@property (nonatomic, strong) NSMutableArray *cellFrames;
/**
 *  正在屏幕上展示的cell（字典）
 */
@property (nonatomic, strong) NSMutableDictionary *displayingCells;
/**
 *  缓存池（集合，存放离开屏幕的cell）
 */
@property (nonatomic, strong) NSMutableSet *reusableCells;

@end


@implementation LPWaterfallView

#pragma mark - 初始化
- (NSMutableArray *)cellFrames
{
    if (_cellFrames == nil) {
        self.cellFrames = [NSMutableArray array];
    }
    return _cellFrames;
}

- (NSMutableDictionary *)displayingCells
{
    if (_displayingCells == nil) {
        self.displayingCells = [NSMutableDictionary dictionary];
    }
    return _displayingCells;
}

- (NSSet *)reusableCells
{
    if (_reusableCells == nil) {
        self.reusableCells = [NSMutableSet set];
    }
    return _reusableCells;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview) {
        [self reloadData];
    }
}

#pragma mark - 私有方法

/**
 *  总列数
 */
- (NSUInteger)numberOfColumns
{
    if ([self.dataSource respondsToSelector:@selector(numberOfColumnsInWaterfallView:)]) {
        return [self.dataSource numberOfColumnsInWaterfallView:self];
    } else {
        return LPWaterfallViewDefaultNumberOfColumns;
    }
}

/**
 *  间距
 */
- (CGFloat)marginForType:(LPWaterfallViewMarginType)type
{
    if ([self.delegate respondsToSelector:@selector(waterfallView:marginForType:)]) {
        return [self.delegate waterfallView:self marginForType:type];
    } else {
        return LPWaterfallViewDefaultMargin;
    }
}

/**
 *  index位置对应的高度
 */
- (CGFloat)heightAtIndex:(NSUInteger)index
{
    if ([self.delegate respondsToSelector:@selector(waterfallView:heightAtIndex:)]) {
        return [self.delegate waterfallView:self heightAtIndex:index];
    } else {
        return LPWaterfallViewDefaultCellH;
    }
}
/**
 *  判断一个frame是否显示在屏幕上
 */
- (BOOL)isInScreen:(CGRect)frame
{
    
    
    return  ((CGRectGetMaxY(frame) > self.contentOffset.y && CGRectGetMinY(frame) < self.contentOffset.y + self.bounds.size.height));
    
    
}


#pragma mark - 公共接口
/**
 *  cell的宽度
 */
- (CGFloat)cellWidth
{
    // 总列数
    int numberOfColumns = [self numberOfColumns];
    CGFloat leftM = [self marginForType:LPWaterfallViewMarginTypeLeft];
    CGFloat rightM = [self marginForType:LPWaterfallViewMarginTypeRight];
    CGFloat columnM = [self marginForType:LPWaterfallViewMarginTypeColumn];
    return (self.bounds.size.width - leftM - rightM - (numberOfColumns - 1) * columnM) / numberOfColumns;
}

- (CGFloat)waterfallHeight
{
    return self.contentSize.height;
}


/**
 *  刷新数据
 *  1 计算每一个cell的frame
 */
// - (void)reloadData
- (void)reloadData
{
    // 清空之前的所有数据
    [self.displayingCells.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.displayingCells removeAllObjects];
    [self.cellFrames removeAllObjects];
    [self.reusableCells removeAllObjects];
    
    int numberOfCells = [self.dataSource numberOfCellsInWaterfallView:self];
    int numberOfColumns = [self numberOfColumns];
    
    CGFloat topM = [self marginForType:LPWaterfallViewMarginTypeTop];
    CGFloat bottomM = [self marginForType:LPWaterfallViewMarginTypeBottom];
    CGFloat leftM = [self marginForType:LPWaterfallViewMarginTypeLeft];
    CGFloat columnM = [self marginForType:LPWaterfallViewMarginTypeColumn];
    CGFloat rowM = [self marginForType:LPWaterfallViewMarginTypeRow];
    
    CGFloat cellW = [self cellWidth];
    
    // 用数组maxYOfColumns存放所有列的最大Y值
    CGFloat maxYOfColumns[numberOfColumns];
    for (int i = 0; i<numberOfColumns; i++) {
        maxYOfColumns[i] = 0.0;
    }
    
    // 计算所有cell的frame
    for (int i = 0; i < numberOfCells; i++) {
        // cell处在最短的一列, minMaxYOfCellColumn记录各列最大Y值中的最小值, cellColumn表示该列序号
        NSUInteger cellColumn = 0;
        CGFloat minMaxYOfCellColumn = maxYOfColumns[cellColumn];
        for (int j = 1; j < numberOfColumns; j++) {
            if (maxYOfColumns[j] < minMaxYOfCellColumn) {
                cellColumn = j;
                minMaxYOfCellColumn = maxYOfColumns[j];
            }
        }
        
        CGFloat cellH = [self heightAtIndex:i];
        CGFloat cellX = leftM + cellColumn * (cellW + columnM);
        CGFloat cellY = 0;
        if (minMaxYOfCellColumn == 0.0) {
            cellY = topM;
        } else {
            cellY = minMaxYOfCellColumn + rowM;
        }
        // 添加frame到数组中
        CGRect cellFrame = CGRectMake(cellX, cellY, cellW, cellH);
        [self.cellFrames addObject:[NSValue valueWithCGRect:cellFrame]];
        
        // 更新最短那一列的最大Y值
        maxYOfColumns[cellColumn] = CGRectGetMaxY(cellFrame);
    }
    
    // 设置contentSize
    CGFloat contentH = maxYOfColumns[0];
    for (int j = 1; j<numberOfColumns; j++) {
        if (maxYOfColumns[j] > contentH) {
            contentH = maxYOfColumns[j];
        }
    }
    contentH += bottomM;
    self.contentSize = CGSizeMake(0, contentH);
}



/**
 *  当scrollView滚动时调用该方法
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 向数据源索要显示在屏幕上的cell
    NSUInteger numOfCells = self.cellFrames.count;
    for (int i = 0; i < numOfCells; i++) {
        CGRect cellFrame = [self.cellFrames[i] CGRectValue];
        // 优先从字典中取出i位置的cell
        LPWaterfallViewCell *cell = self.displayingCells[@(i)];
        
//        if (CGRectGetMinY(cellFrame) < self.contentOffset.y + self.bounds.size.height)
//        {
//            NSLog(@"", );
//        }
        
        if ([self isInScreen:cellFrame]) { // 在屏幕上
            if (cell == nil) { // 未曾显示过，从数据源获取
                cell = [self.dataSource waterfallView:self cellAtIndex:i];
                cell.frame = cellFrame;
                [self addSubview:cell];
                // 存放到字典中
                self.displayingCells[@(i)] = cell;
            }
        } else { // 不在屏幕上
            if (cell) { // 存在且不在屏幕上，应该从scrollView和字典中移除
                [cell removeFromSuperview];
                [self.displayingCells removeObjectForKey:@(i)];
                // 存进缓存池
                [self.reusableCells addObject:cell];
            }
        }
    }
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    __block LPWaterfallViewCell *reusableCell = nil;
    [self.reusableCells enumerateObjectsUsingBlock:^(LPWaterfallViewCell *cell, BOOL *stop) {
        if ([cell.identifier isEqualToString:identifier]) {
            reusableCell = cell;
            *stop = YES;
        }
    }];
    if (reusableCell) {
        [self.reusableCells removeObject:reusableCell];
    }
    return reusableCell;
}

#pragma mark - 事件处理
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self.delegate respondsToSelector:@selector(waterfallView:didSelectAtIndex:)]) {
        return;
    }
    // 获得触摸点
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    __block NSNumber *selectIndex = nil;
    [self.displayingCells enumerateKeysAndObjectsUsingBlock:^(id key, LPWaterfallViewCell *cell, BOOL *stop) {
        if (CGRectContainsPoint(cell.frame, point)) {
            selectIndex = key;
            *stop = YES;
        }
    }];
    if (selectIndex) {
        [self.delegate waterfallView:self didSelectAtIndex:selectIndex.unsignedIntegerValue];
    }
}



@end
