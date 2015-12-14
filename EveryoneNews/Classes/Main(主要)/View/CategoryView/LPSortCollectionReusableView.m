//
//  LPSortCollectionReusableView.m
//  EveryoneNews
//
//  Created by dongdan on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPSortCollectionReusableView.h"

@interface LPSortCollectionReusableView () <UIGestureRecognizerDelegate>

@end

@implementation LPSortCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, self.bounds.size.height)];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = [UIColor grayColor];
        [self addSubview:self.titleLabel];
        
        self.sortButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 120, 10, 60, 20)];
        self.sortButton.titleLabel.font = [UIFont systemFontOfSize:13];
        self.sortButton.layer.masksToBounds = YES;
        self.sortButton.layer.cornerRadius = 10;
        self.sortButton.layer.borderColor = [UIColor redColor].CGColor;
        self.sortButton.layer.borderWidth = 0.7;
        [self.sortButton setTitle:@"排序删除" forState:UIControlStateNormal];
        [self.sortButton setTitle:@"完成" forState:UIControlStateSelected];
        [self.sortButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.sortButton addTarget:self action:@selector(sortButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.sortButton];
    }
    return self;
}

- (void)sortButtonDidClick:(sortButtonClickBlock)sortButtonClickBlock {
    if(sortButtonClickBlock) {
        self.sortButtonClickBlock = sortButtonClickBlock;
    }
}

- (void)sortButtonClick:(UIButton *)sender {
    self.sortButton.selected = !self.sortButton.selected;
    if (sender.selected) {
        self.sortButtonClickBlock(DeleteState);
    } else {
        self.sortButtonClickBlock(FinishState);
    }
}

@end
