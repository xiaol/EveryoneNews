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
@interface LPMenuView ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *menuScrollView;
@property (nonatomic, weak) LPMenuButton *selectedButton;
@property (nonatomic, assign) CGFloat totalWidth;

@end

@implementation LPMenuView


- (void)loadMenuViewTitles:(NSArray *)titles {
    UIScrollView *menuScrollView = [[UIScrollView alloc] init];
    menuScrollView.showsHorizontalScrollIndicator = NO;
    menuScrollView.showsVerticalScrollIndicator = NO;
    menuScrollView.backgroundColor = [UIColor whiteColor];
//    menuScrollView.delegate = self;
    self.menuScrollView = menuScrollView;
    [self addSubview:self.menuScrollView];
    // 加载标题
    for (int i = 0; i < titles.count; i++) {
        LPMenuButton *menuButton = [[LPMenuButton alloc] initTitlesWithIndex:titles index:i];
        menuButton.fontName = @"Arial";
        menuButton.fontSize = 16;
        menuButton.tag = i;
        menuButton.titleLabel.textColor = menuButton.normalColor;
        [menuButton addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.menuScrollView addSubview:menuButton];
       
    }
}

- (void)layoutSubviews {
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
            self.menuScrollView.contentSize = CGSizeMake(currentButton.x + buttonW +buttonPadding, 0);
            self.menuScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        if(i == 0) {
            currentButton.selected = YES;
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

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    LPMenuButton *button = [self.menuScrollView.subviews firstObject];
    [button changeSelectedColorWithRate:0.1];
}

- (void)menuButtonClick:(LPMenuButton *)button {
    if(self.selectedButton == button) {
        return;
    }
    if([self.delegate respondsToSelector:@selector(MenuViewDelegate:index:)]) {
        [self.delegate MenuViewDelegate:self index:button.tag];
    }
    self.selectedButton.selected = NO;
    button.selected = YES;
    [self selectedButtonMoveToCenterWithIndex:(int)button.tag];
    // 按钮选中取消动画
    [button selectedItemAnimation];
    [self.selectedButton unSelectedItemAnimation];
    self.selectedButton = button;
}

// 选中按钮移动到scrollView中间
- (void)selectedButtonMoveToCenterWithIndex:(int)index {
    LPMenuButton *button = self.menuScrollView.subviews[index];
    CGRect buttonFrame = [button convertRect:self.bounds toView:nil];
    CGFloat distance = buttonFrame.origin.x - self.centerX;
    CGFloat contentOffsetX = self.menuScrollView.contentOffset.x;
    int count = self.menuScrollView.subviews.count;
    if (index > count - 1) {
        return;
    }
    NSLog(@"%f",distance);
//    NSLog(@"%d", index);
//    NSLog(@"%f", self.centerX);
//    NSLog(@"offset---- %f", self.menuScrollView.contentOffset.x);
//    NSLog(@"%f", button.x);
    if (self.menuScrollView.contentOffset.x + button.x > self.centerX) {
        [self.menuScrollView setContentOffset:CGPointMake(contentOffsetX + distance + button.width, 0) animated:YES];
    } else {
        [self.menuScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView.contentOffset.x <= 0) {
//        
//        [scrollView setContentOffset:CGPointMake(0 , 0)];
//    } else if (scrollView.contentOffset.x + self.width >= scrollView.contentSize.width){
//        
//        [scrollView setContentOffset:CGPointMake(scrollView.contentSize.width - self.width, 0)];
//    }
//}
@end
