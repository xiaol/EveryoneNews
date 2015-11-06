//
//  LPFeatureFrame.m
//  EveryoneNews
//
//  Created by apple on 15/7/30.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPFeatureFrame.h"
#import "LPFeature.h"
#import "LPZhihuView.h"
#import "LPContentFrame.h"

@implementation LPFeatureFrame

- (NSArray *)itemFrames {
    if (_itemFrames == nil) {
        _itemFrames = [NSArray array];
    }
    return _itemFrames;
}

- (NSMutableArray *)contentFrames {
    if (_contentFrames == nil) {
        _contentFrames = [NSMutableArray array];
    }
    return _contentFrames;
}

- (void)setFeature:(LPFeature *)feature {
    _feature = feature;
    
    _headerF = CGRectMake(0, 0, ScreenWidth, TableHeaderViewH);
    _headerImageViewF = CGRectMake(0, 0, ScreenWidth, TableHeaderImageViewH);
    _maskLayerF = CGRectMake(0, 0, ScreenWidth, TableHeaderImageViewH);
    CGFloat hudH = TableHeaderViewH * 0.4;
    CGFloat hudY = CGRectGetMaxY(_headerImageViewF) - hudH;
    _hudF = CGRectMake(0, hudY, ScreenWidth, hudH);
    _filterViewF = CGRectMake(0, 0, ScreenWidth, TableHeaderImageViewH);
    NSMutableAttributedString *titleString = feature.titleString;
    CGFloat titleX = 20;
    CGFloat titleW = ScreenWidth - titleX * 2;
    CGFloat titleH = [titleString heightWithConstraintWidth:titleW];
    CGFloat titleY = TableHeaderViewH - 9 - titleH;
    _titleLabelF = CGRectMake(titleX, titleY, titleW, titleH);
    
    NSMutableArray *itemFrameArray = [NSMutableArray array];
    CGFloat itemX = DetailCellBilateralBorder;
    CGFloat itemW = ScreenWidth - 2 * itemX;
//    [_contentFrames enumerateObjectsUsingBlock:^(LPContentFrame *contentFrame, NSUInteger idx, BOOL *stop) {
//        NSLog(@"%ld", idx);
//        CGFloat itemY = 0;
//        CGFloat itemH = 0;
//        if (idx > 0) {
//            CGRect lastItemF = [itemFrameArray[idx] CGRectValue];
//            itemY = CGRectGetMaxY(lastItemF) + DetailCellHeightBorder;
//        } else {
//            itemY = TableHeaderViewH;
//        }
//        itemH = contentFrame.cellHeight - DetailCellHeightBorder;
//        CGRect itemF = CGRectMake(itemX, itemY, itemW, itemH);
//        [itemFrameArray addObject:[NSValue valueWithCGRect:itemF]];
//        
//        //*stop = (idx == _contentFrames.count - 1) || (_contentFrames.count == 0);
//    }];
    for (int i = 0; i < _contentFrames.count; i++) {
        LPContentFrame *contentFrame = _contentFrames[i];
        CGFloat itemY = 0;
        CGFloat itemH = 0;
        if (i > 0) {
            CGRect lastItemF = [itemFrameArray[i - 1] CGRectValue];
            itemY = CGRectGetMaxY(lastItemF) + DetailCellHeightBorder;
        } else {
            itemY = TableHeaderViewH;
        }
        itemH = contentFrame.cellHeight - DetailCellHeightBorder;
        CGRect itemF = CGRectMake(itemX, itemY, itemW, itemH);
        [itemFrameArray addObject:[NSValue valueWithCGRect:itemF]];
    }
    
    _itemFrames = [NSArray arrayWithArray:itemFrameArray];
    
    CGFloat maxItemY = CGRectGetMaxY([itemFrameArray[_contentFrames.count - 1] CGRectValue]);
    _viewSize = CGSizeMake(ScreenWidth, MAX(ScreenHeight, maxItemY));
    
    NSArray *zhihuArray = feature.zhihuPoints;

    if (zhihuArray.count && zhihuArray) {
        _zhihuViewF = CGRectMake(DetailCellPadding, maxItemY + DetailCellHeightBorder, DetailCellWidth, [[[LPZhihuView alloc] init] heightWithPointsArray:zhihuArray]);
        _viewSize = CGSizeMake(ScreenWidth, MAX(ScreenHeight, CGRectGetMaxY(_zhihuViewF)));
    }
}

@end
