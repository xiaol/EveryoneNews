//
//  LPLoadingView.m
//  DrawingDemo
//
//  Created by dongdan on 2016/11/22.
//  Copyright © 2016年 dongdan. All rights reserved.
//

#import "LPLoadingView.h"

@interface LPLoadingView ()

@property (nonatomic, strong) UIImageView *horizontalImageView;
@property (nonatomic, strong) UIImageView *verticalImageView;

@end

@implementation LPLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSArray *horizontalImageNames = @[@"正在加载横向_01", @"正在加载横向_02", @"正在加载横向_03", @"正在加载横向_04", @"正在加载横向_05", @"正在加载横向_06", @"正在加载横向_07", @"正在加载横向_08", @"正在加载横向_09"];
        
        NSArray *verticalImageNames = @[@"正在加载纵向_01", @"正在加载纵向_02", @"正在加载纵向_03", @"正在加载纵向_04", @"正在加载纵向_05", @"正在加载纵向_06", @"正在加载纵向_07", @"正在加载纵向_08", @"正在加载纵向_09"];
        
        // 横向动画
        NSMutableArray *horizontalImages = [[NSMutableArray alloc] init];
        for (int i = 0; i < horizontalImageNames.count; i++) {
            [horizontalImages addObject:[UIImage imageNamed:[horizontalImageNames objectAtIndex:i]]];
        }
        UIImageView *horizontalImageView = [[UIImageView alloc] init];
        horizontalImageView.frame = CGRectMake(0, 0, 100, 50);
        horizontalImageView.animationImages = horizontalImages;
        horizontalImageView.animationDuration = 1.0f;
        horizontalImageView.center = self.center;
        self.horizontalImageView = horizontalImageView;
        
        // 纵向动画
        NSMutableArray *verticalImages = [[NSMutableArray alloc] init];
        for (int i = 0; i < verticalImageNames.count; i++) {
            [verticalImages addObject:[UIImage imageNamed:[verticalImageNames objectAtIndex:i]]];
        }
        UIImageView *verticalImageView = [[UIImageView alloc] init];
        verticalImageView.opaque = YES;
        verticalImageView.frame = CGRectMake(0, 0, 45, 30);
        verticalImageView.animationImages = verticalImages;
        verticalImageView.animationDuration = 1.0f;
        verticalImageView.center = self.center;
        self.verticalImageView = verticalImageView;
        
        [self addSubview:horizontalImageView];
        [self addSubview:verticalImageView];
        
        UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(horizontalImageView.frame), ScreenWidth, 40)];
        loadingLabel.textAlignment = NSTextAlignmentCenter;
        loadingLabel.text = @"正在努力加载...";
        loadingLabel.font = [UIFont systemFontOfSize:12];
        loadingLabel.textColor = [UIColor colorFromHexString:@"#999999"];
        [self addSubview:loadingLabel];
    }
    return self;
}

- (void)startAnimating {
    self.hidden = NO;
    [self.horizontalImageView startAnimating];
    [self.verticalImageView startAnimating];
}

- (void)stopAnimating {
    self.hidden = YES;
    [self.horizontalImageView stopAnimating];
    [self.verticalImageView stopAnimating];
}



@end
