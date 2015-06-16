//
//  LPTabBar.m
//  EveryoneNews
//
//  Created by apple on 15/5/26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPTabBar.h"


@interface LPTabBar ()



@end

@implementation LPTabBar

- (NSMutableArray *)tabBarButtons{
    if (_tabBarButtons == nil) {
        _tabBarButtons = [NSMutableArray array];
    }
    return _tabBarButtons;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *sliderView = [[UIView alloc] init];
        sliderView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:250/255.0 alpha:0.9];
        CGFloat sliderH = TabBarHeight / 11;
        sliderView.frame = CGRectMake(TabBarButtonWidth, TabBarHeight - sliderH, TabBarButtonWidth, sliderH);
        [self addSubview:sliderView];
        self.sliderView = sliderView;
    }
    return self;
}

- (void)addTabBarButtonWithItem:(UITabBarItem *)tabBarItem tag:(int)tag
{
    LPTabBarButton *btn = [[LPTabBarButton alloc] init];
    [self addSubview:btn];
    
    [self.tabBarButtons addObject:btn];
    
    btn.item = tabBarItem;
    
    btn.tag = tag;
    
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
#pragma mark - 当前有两个tabbarBtn条目，第2个是首页，默认选中
    if (tag == 1) {
        self.selectedButton = btn;
        btn.selected = YES;
    }
}

- (void)buttonClick:(LPTabBarButton *)btn
{
    // 通知代理
    int from = (int)self.selectedButton.tag;
    int to = (int)btn.tag;
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectButtonFrom:from to:to];
    }
    
    if (from != to) {
        // 设置按钮状态
        self.selectedButton = btn;
    }
}

- (void)setSelectedButton:(LPTabBarButton *)selectedButton
{
//    if (selectedButton.tag == _selectedButton.tag) return;
        
    _selectedButton.selected = NO;
    selectedButton.selected = YES;
    _selectedButton = selectedButton;
}

- (void)layoutSubviews
{
#pragma mark - tabbarBtn宽度待定
    CGFloat btnW = TabBarButtonWidth;
    CGFloat btnH = self.frame.size.height;
    CGFloat btnY = 0;
//    int k = 0;
//    for (int index = (int)self.tabBarButtons.count - 1; index >= 0; index--, k++) {
//        LPTabBarButton *btn = self.tabBarButtons[index];
//        CGFloat btnX = k * btnW;
//        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
//    }
    for (int index = 0; index < self.tabBarButtons.count; index++) {
        LPTabBarButton *btn = self.tabBarButtons[index];
        CGFloat btnX = index * btnW;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
}

@end
