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
        UILabel *titelLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 70, self.bounds.size.height)];
        titelLabel.font = [UIFont systemFontOfSize:17];
        titelLabel.textColor = [UIColor colorFromHexString:@"#414141"];
        [self addSubview:titelLabel];
        self.titleLabel = titelLabel;
        
        CGFloat sortButtonX = CGRectGetMaxX(titelLabel.frame);
        UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(sortButtonX + 10, 7, 82, 16)];
        subTitleLabel.textColor = [UIColor colorFromHexString:@"#414141"];
        subTitleLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:subTitleLabel];
        self.subtitleLabel = subTitleLabel;
        
        UIButton *sortButton = [[UIButton alloc] initWithFrame:CGRectMake(sortButtonX + 10, 7, 82, 16)];
        sortButton.titleLabel.font = [UIFont systemFontOfSize:10];
        sortButton.layer.masksToBounds = YES;
        sortButton.layer.cornerRadius = 5;
        sortButton.layer.borderColor = [UIColor colorFromHexString:@"#747476"].CGColor;
        sortButton.layer.borderWidth = 0.5;
        [sortButton setTitle:@"长按排序或删除" forState:UIControlStateNormal];
        [sortButton setTitle:@"完成" forState:UIControlStateSelected];
        [sortButton setTitleColor:[UIColor colorFromHexString:@"#747476"] forState:UIControlStateNormal];
        [sortButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [sortButton addTarget:self action:@selector(sortButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sortButton];
        self.sortButton = sortButton;
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
