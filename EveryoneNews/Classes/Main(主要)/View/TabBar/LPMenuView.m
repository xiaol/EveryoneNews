//
//  LPMenuView.m
//  EveryoneNews
//
//  Created by dongdan on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPMenuView.h"
#import "LPMenuButton.h"
#import "NSString+LP.h"

const static CGFloat buttonPadding = 8;
@interface LPMenuView ()

@property (nonatomic, strong) LPMenuButton *selectedButton;
@property (nonatomic, assign) CGFloat totalWidth;

@end

@implementation LPMenuView

/**
 *  初始化菜单栏标题
 *
 *  @param titles 标题内容
 */
- (void)loadMenuViewTitles:(NSArray *)titles {
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.backgroundColor = [UIColor whiteColor];
    // 加载标题
    for (int i = 0; i < titles.count; i++) {
        LPMenuButton *menuButton = [[LPMenuButton alloc] initWithTitle:titles[i]];
        menuButton.tag = i;
        [menuButton addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:menuButton];
    }
    // 计算滚动条宽度
    LPMenuButton *currentButton = [[LPMenuButton alloc] init];
    LPMenuButton *oldButton = [[LPMenuButton alloc] init];
    CGFloat totalWidth;
    for (int i = 0; i < self.subviews.count; i++) {
        currentButton = self.subviews[i];
        if(i >= 1) {
            oldButton = self.subviews[i - 1];
        }
        UIFont *titleFont = currentButton.titleLabel.font;
        CGSize buttonSize = [currentButton.titleLabel.text sizeWithFont:titleFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        CGFloat buttonW = buttonSize.width + 2 * buttonPadding;
        CGFloat buttonX = oldButton.x + oldButton.width + buttonPadding;
        CGFloat buttonY = 0;
        CGFloat buttonH = self.height - 2;
        
        currentButton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        totalWidth += currentButton.width;
        if(currentButton == [self.subviews lastObject]) {
            CGFloat width = self.bounds.size.width;
            CGFloat height = self.bounds.size.height;
            self.size = CGSizeMake(width, height);
            self.contentSize = CGSizeMake(currentButton.x + buttonW + buttonPadding, 0);
            self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        // 默认设置第一个按钮选中
        if(i == 0) {
            currentButton.selected = YES;
            self.selectedButton = currentButton;
            currentButton.transform = CGAffineTransformMakeScale(1.15, 1.15);
        }
        currentButton = nil;
        oldButton = nil;
    }
    self.totalWidth = totalWidth;
    // 处理按钮较少时的情况
    if(self.contentSize.width < self.width) {
        CGFloat margin = (ScreenWidth - self.totalWidth)/(self.subviews.count + 1);
        for (int i = 0; i < self.subviews.count; i++){
            currentButton= self.subviews[i];
            if (i >= 1) {
                oldButton = self.subviews[i-1];
            }
            currentButton.x = oldButton.x + oldButton.width + margin;
            
        }
    }
}

/**
 *  点击菜单栏按钮调用
 *
 *  @param button 选中的按钮
 */
- (void)menuButtonClick:(LPMenuButton *)button {
    if(self.selectedButton == button) {
        return;
    }
    [self.selectedButton buttonDidDeSelectedWithAnimation];
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    [button buttonDidSelectedWithAnimation];

    [self selectedButtonMoveToCenterWithIndex:(int)button.tag];
//    if([self.menuViewDelegate respondsToSelector:@selector(menuView:didSelectedButtonAtIndex:)]) {
//        [self.menuViewDelegate menuView:self didSelectedButtonAtIndex:(int)button.tag];
//    }
}

/**
 *  菜单栏按钮被遮挡自动移动到屏幕中间
 *
 *  @param index 选中按钮索引
 */
- (void)selectedButtonMoveToCenterWithIndex:(int)index {
    LPMenuButton *button = self.subviews[index];
    CGFloat itemOriginX = button.frame.origin.x;
    CGFloat width = self.size.width;
    CGSize contentSize = self.contentSize;
    CGFloat contentOffsetX = self.contentOffset.x;
    int count = (int)self.subviews.count;

    if (index > count - 1) {
        return;
    }
    if (itemOriginX < width / 2 && contentOffsetX == 0) {
        return;
    }
    if(contentOffsetX !=0 && itemOriginX <= width / 2) {
     [self setContentOffset:CGPointMake(0, 0) animated:YES];
        return;
    }
    if (contentSize.width - itemOriginX <= width * 0.5 && contentOffsetX != contentSize.width - width) {
        [self setContentOffset:CGPointMake(contentSize.width - width, 0) animated:YES];
        return;
    }
    if (itemOriginX > width / 2) {
       
        CGFloat targetX = itemOriginX - width * 0.5 + button.width * 0.5;
        [self setContentOffset:CGPointMake(targetX, 0) animated:YES];
    }
}

/**
 *  pagingView滚动时菜单栏按钮缩放
 *
 *  @param index 目标按钮索引
 *  @param rate  缩放系数
 */
- (void)selectedButtonScaleWithRate:(int)index rate:(CGFloat) rate {
    if(index >= (self.subviews.count -1)) {
        return;
    }
    self.selectedButton.selected = NO;
    LPMenuButton *currentButton = self.subviews[index];
    LPMenuButton *nextButton = self.subviews[index + 1];
    [currentButton titleSizeAndColorDidChangedWithRate:rate];
    [nextButton titleSizeAndColorDidChangedWithRate:(1 - rate)];
}

- (void)buttonSelectedStatusChangedWithIndex:(int)index {
    self.selectedButton.selected = NO;
    self.selectedButton = self.subviews[index];
    self.selectedButton.selected = YES;
}

@end
