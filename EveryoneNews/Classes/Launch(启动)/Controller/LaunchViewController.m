//
//  LaunchViewController.m
//  EveryoneNews
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LaunchViewController.h"
#import "UIImageView+WebCache.h"
#import "MainNavigationController.h"
#import "MainViewController.h"
#import "LPHttpTool.h"
@interface LaunchViewController ()
@end

@implementation LaunchViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __block BOOL isCompleted = NO;
    NSString *bg = nil;
    NSString *place = nil;
    if (iPhone4) {
        bg = @"iPhone4";
        place = @"startPage4";
    } else if (iPhone5) {
        bg = @"iPhone5";
        place = @"startPage5";
    } else if (iPhone6) {
        bg = @"iPhone6";
        place = @"startPage6";
    } else if (iPhone6Plus) {
        bg = @"plus";
        place = @"startPagePlus";
    }
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.frame = self.view.bounds;
    bgView.image = [UIImage imageNamed:bg];
    [self.view addSubview:bgView];
    
    UIImageView *startView = [[UIImageView alloc] init];
    startView.userInteractionEnabled = YES;
    startView.frame = self.view.bounds;
    startView.contentMode = UIViewContentModeScaleAspectFill;
    UILabel *titleLabel = [[UILabel alloc] init];
    [LPHttpTool postWithURL:@"http://api.deeporiginalx.com/news/baijia/startPage" params:nil success:^(id json) {
        [startView sd_setImageWithURL:[NSURL URLWithString:json[@"imgUrl"]] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            isCompleted = (receivedSize == expectedSize);
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        NSString *title = json[@"title"];
        UIFont *font = [UIFont systemFontOfSize:20];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.x = 0;
        titleLabel.width = ScreenWidth;
        titleLabel.height = [title sizeWithFont:font maxSize:CGSizeMake(ScreenWidth, MAXFLOAT)].height;
        titleLabel.y = ScreenHeight - 30 - titleLabel.height;
        titleLabel.font = font;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = title;
    } failure:^(NSError *error) {
        
    }];
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (isCompleted) {
            [startView sd_cancelCurrentImageLoad];
            startView.image = nil;
            startView.image = [UIImage imageNamed:place];
        } else {
            UIImageView *hud = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"渐变"]];
            hud.x = 0;
            hud.width = ScreenWidth;
            hud.height = ScreenHeight * 0.25;
            hud.y = ScreenHeight - hud.height;
            [startView addSubview:hud];
            [startView addSubview:titleLabel];
        }
//        UIButton *cancelBtn = [[UIButton alloc] init];
//        [self.view addSubview:cancelBtn];
//        cancelBtn.width = 25;
//        cancelBtn.height = 25;
//        if (iPhone6Plus) {
//            cancelBtn.width = 40;
//            cancelBtn.height = 40;
//        }
//        cancelBtn.x = ScreenWidth - 20 - cancelBtn.width;
//        cancelBtn.y =  20;
//        [cancelBtn setImage:[UIImage imageNamed:@"跳过"] forState:UIControlStateNormal];
//        [cancelBtn addTarget:self action:@selector(changeRootVc) forControlEvents:UIControlEventTouchUpInside];
        startView.alpha = 0.0;
        [self.view addSubview:startView];
        [UIView animateWithDuration:3.5 animations:^{
            bgView.alpha = 0.2;
            startView.alpha = 0.8;
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf changeRootVc];
            });
        }];
    });
}

- (void)changeRootVc {
    MainViewController *mainVc = [[MainViewController alloc] init];
    MainNavigationController *mainNavVc = [[MainNavigationController alloc] initWithRootViewController:mainVc];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = mainNavVc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
