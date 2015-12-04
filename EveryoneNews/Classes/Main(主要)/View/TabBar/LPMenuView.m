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
    UIScrollView *menuScrollView = [[UIScrollView alloc] init];
    menuScrollView.showsHorizontalScrollIndicator = NO;
    menuScrollView.showsVerticalScrollIndicator = NO;
    menuScrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:menuScrollView];
    // 加载标题
    for (int i = 0; i < titles.count; i++) {
        LPMenuButton *menuButton = [[LPMenuButton alloc] initTitlesWithIndex:titles index:i];
        menuButton.fontName = @"Arial";
        menuButton.fontSize = 14;
        menuButton.tag = i;
        menuButton.titleLabel.textColor = menuButton.normalColor;
        [menuButton addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [menuScrollView addSubview:menuButton];
    }
    self.menuScrollView = menuScrollView;
    // 计算滚动条宽度
    LPMenuButton *currentButton = [[LPMenuButton alloc] init];
    LPMenuButton *oldButton = [[LPMenuButton alloc] init];
    CGFloat totalWidth;
    for (int i = 0; i < self.menuScrollView.subviews.count; i++) {
        currentButton = self.menuScrollView.subviews[i];
        if(i >= 1) {
            oldButton = self.menuScrollView.subviews[i - 1];
        }
        
        UIFont *titleFont = currentButton.titleLabel.font;
        CGSize buttonSize = [currentButton.titleLabel.text sizeWithFont:titleFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        CGFloat buttonW = buttonSize.width + 2 * buttonPadding;
        CGFloat buttonX = oldButton.x + oldButton.width + buttonPadding;
        CGFloat buttonY = 0;
        CGFloat buttonH = self.height - 2;
        
        currentButton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        totalWidth += currentButton.width;
        if(currentButton == [self.menuScrollView.subviews lastObject]) {
            CGFloat width = self.bounds.size.width;
            CGFloat height = self.bounds.size.height;
            self.menuScrollView.size = CGSizeMake(width, height);
            self.menuScrollView.contentSize = CGSizeMake(currentButton.x + buttonW + buttonPadding, 0);
            self.menuScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        // 默认设置第一个按钮选中
        if(i == 0) {
            currentButton.selected = YES;
            [currentButton changeSelectedColorWithRate:0.1];
            self.selectedButton = currentButton;
        }
        currentButton = nil;
        oldButton = nil;
    }
    self.totalWidth = totalWidth;
    // 处理按钮较少时的情况
    if(self.menuScrollView.contentSize.width < self.width) {
        CGFloat margin = (ScreenWidth - self.totalWidth)/(self.menuScrollView.subviews.count + 1);
        for (int i = 0; i < self.menuScrollView.subviews.count; i++){
            currentButton= self.menuScrollView.subviews[i];
            if (i >= 1) {
                oldButton = self.menuScrollView.subviews[i-1];
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
    self.selectedButton.selected = NO;
    button.selected = YES;
    [self selectedButtonMoveToCenterWithIndex:(int)button.tag];
    // 按钮选中取消动画
    [button selectedItemAnimation];
    [self.selectedButton unSelectedItemAnimation];
     self.selectedButton = button;
    if([self.delegate respondsToSelector:@selector(menuViewDelegate:index:)]) {
        [self.delegate menuViewDelegate:self index:(int)button.tag];
    }
  
}

/**
 *  菜单栏按钮被遮挡自动移动到屏幕中间
 *
 *  @param index 选中按钮索引
 */

- (void)selectedButtonMoveToCenterWithIndex:(NSInteger)index {
    LPMenuButton *button = self.menuScrollView.subviews[index];
    CGFloat itemOriginX = button.frame.origin.x;
    CGFloat width = self.menuScrollView.size.width;
    CGSize contentSize = self.menuScrollView.contentSize;
    CGFloat contentOffsetX = self.menuScrollView.contentOffset.x;
    int count = (int)self.menuScrollView.subviews.count;

    if (index > count - 1) {
        return;
    }
    if (itemOriginX < width / 2 && contentOffsetX == 0) {
        return;
    }
    if(contentOffsetX !=0 && itemOriginX <= width / 2) {
     [self.menuScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        return;
    }
    if (contentSize.width - itemOriginX <= width * 0.5 && contentOffsetX != contentSize.width - width) {
        [self.menuScrollView setContentOffset:CGPointMake(contentSize.width - width, 0) animated:YES];
        return;
    }
    if (itemOriginX > width / 2) {
       
        CGFloat targetX = itemOriginX - width * 0.5 + button.width * 0.5;
        [self.menuScrollView setContentOffset:CGPointMake(targetX, 0) animated:YES];
    }
}

/**
 *  pagingView滚动时菜单栏按钮缩放
 *
 *  @param index 目标按钮索引
 *  @param rate  缩放系数
 */
- (void)changeSelectedButtonRateWithIndex:(int)index rate:(CGFloat) rate {
    if(index >= (self.menuScrollView.subviews.count -1)) {
        return;
    }
    self.selectedButton = NO;
    LPMenuButton *currentButton = self.menuScrollView.subviews[index];
    LPMenuButton *nextButton = self.menuScrollView.subviews[index + 1];
    [currentButton changeSelectedColorWithRate:rate];
    [nextButton changeSelectedColorWithRate:(1 - rate)];
    self.selectedButton = self.menuScrollView.subviews[index];
    self.selectedButton.selected = YES;
}

/**
 *  选中按钮颜色字体变化，非选中按钮恢复到以前状态
 *
 *  @param index      选中按钮索引
 *  @param otherIndex 选中之前按钮索引
 */
- (void)selectedButtonWithIndex:(int)index otherIndex:(int)otherIndex {
    self.selectedButton = self.menuScrollView.subviews[index];
    LPMenuButton *otherButton = self.menuScrollView.subviews[otherIndex];
    self.selectedButton.selected = YES;
    otherButton.selected = NO;

}
@end
