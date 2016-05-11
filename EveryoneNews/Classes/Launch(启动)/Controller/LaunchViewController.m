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
@property (nonatomic, strong) UIImageView *hud;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) BOOL isCompleted;
@property (nonatomic, assign) BOOL isInDisk;
@property (nonatomic, strong) MainNavigationController *nav;
@property (nonatomic, strong) UIImageView *startView;
@property (nonatomic, copy) NSString *place;
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *logoView;

@end

@implementation LaunchViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *bg = nil;
    NSString *place = nil;
    NSString *logo = nil;
    CGFloat logoY = 0;
    if (iPhone4) {
        bg = @"bg4";
        place = @"iPhone4占位图";
        logo = @"iPhone4logo";
        logoY = 125;
    } else if (iPhone5) {
        bg = @"bg5";
        place = @"iPhone5占位图";
        logo = @"iPhone5logo";
        logoY = 125;
    } else if (iPhone6) {
        bg = @"bg6";
        place = @"iPhone6占位图";
        logo = @"iPhone6logo";
        logoY = 147;
    } else if (iPhone6Plus) {
        bg = @"bgPlus";
        place = @"iPhone6P占位图";
        logo = @"iPhone6pluslogo";
        logoY = 162;
    }
    self.place = [place copy];
    
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.frame = self.view.bounds;
    bgView.image = [UIImage imageNamed:bg];
    [self.view addSubview:bgView];
    self.bgView = bgView;
    
    UIImage *logoImg = [UIImage imageNamed:logo];
    UIImageView *logoView = [[UIImageView alloc] initWithImage:logoImg];
    logoView.width = logoImg.size.width;
    logoView.height = logoImg.size.height;
    logoView.x = (ScreenWidth - logoView.width) / 2;
    logoView.y = logoY;
    [self.view addSubview:logoView];
    self.logoView = logoView;
    
    UIImageView *startView = [[UIImageView alloc] init];
    startView.userInteractionEnabled = YES;
    CGFloat offset = 40;
    startView.x = -offset;
    startView.y = -offset;
    startView.height = ScreenHeight + offset * 2;
    startView.width = ScreenWidth + offset * 2;
    startView.contentMode = UIViewContentModeScaleAspectFill;
    self.startView = startView;
    [startView addCenterMotionEffectsXYWithOffset:offset];
    
    [startView.layer setMagnificationFilter:kCAFilterNearest];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.x = 0;
    titleLabel.width = ScreenWidth;
    UIFont *font = [UIFont systemFontOfSize:20];
    titleLabel.height = [@"123" sizeWithFont:font maxSize:CGSizeMake(ScreenWidth, MAXFLOAT)].height;
    titleLabel.y = ScreenHeight - 30 - titleLabel.height;
    titleLabel.font = font;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.alpha = 0.0;
    self.titleLabel = titleLabel;

    
    UIImageView *hud = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"渐变"]];
    hud.x = 0.0;
    hud.width = ScreenWidth;
    hud.height = ScreenHeight * 0.25;
    hud.y = ScreenHeight - hud.height;
    hud.alpha = 0.0;
    self.hud = hud;
    
    [LPHttpTool postWithURL:@"http://api.deeporiginalx.com/news/baijia/startPage" params:nil success:^(id json) {
        NSString *title = json[@"title"];
        titleLabel.text = title;
        NSString *imgURL = json[@"imgUrl"];
        [[SDImageCache sharedImageCache] queryDiskCacheForKey:imgURL done:^(UIImage *image, SDImageCacheType cacheType) {
            if (image) {
//                NSLog(@"由磁盘取出");
                self.isCompleted = YES;
                self.isInDisk = YES;
            }
        }];
        
        [startView sd_setImageWithURL:[NSURL URLWithString:imgURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            NSLog(@"成功加载图像");
            self.isCompleted = YES;
        }];
    } failure:^(NSError *error) {
        
    }];
    
    if (self.isInDisk) {
        [self start];
        NSLog(@"is in disk");
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self start];
        });

    }
}

- (void)start {
    if (!self.isCompleted) {
//        [self.startView sd_cancelCurrentImageLoad];
//        self.startView.image = nil;
        CGRect newFrm = self.startView.frame;
        self.startView = nil;
        self.startView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.place]];
        self.startView.frame = newFrm;
        self.startView.userInteractionEnabled = YES;
//        NSLog(@"!isComplete");
    } else {
        [self.view addSubview:self.hud];
        [self.view addSubview:self.titleLabel];
    }
    self.startView.alpha = 0.0;
    [self.view addSubview:self.startView];
    [self.view bringSubviewToFront:self.logoView];
    [self.view bringSubviewToFront:self.titleLabel];
    
    MainViewController *mainVc = [[MainViewController alloc] init];
    MainNavigationController *mainNavVc = [[MainNavigationController alloc] initWithRootViewController:mainVc];
    self.nav = mainNavVc;
    
    [UIView animateWithDuration:3.5 animations:^{
        self.bgView.alpha = 0.2;
        self.startView.alpha = 0.8;
        if (self.isCompleted) {
            self.hud.alpha = 0.8;
            self.titleLabel.alpha = 0.9;
        }
    } completion:^(BOOL finished) {
        //            UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //            window.rootViewController = self.nav;
        [self.startView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeRootVc)]];
    }];
}

- (void)changeRootVc {

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = self.nav;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
