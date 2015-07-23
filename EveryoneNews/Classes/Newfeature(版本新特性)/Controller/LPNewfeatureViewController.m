//
//  LPNewfeatureViewController.m
//  EveryoneNews
//
//  Created by apple on 15/6/24.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <ImageIO/ImageIO.h>

#import "LPNewfeatureViewController.h"
#import "LaunchViewController.h"

#define GIFHeight 337
#define GIFWidth 222
#define PageCount 3

@interface LPNewfeatureViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation LPNewfeatureViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGif];
    [self setupScrollView];
    [self setupPageControl];
    [self setupCancelBtn];
}

- (void)setupGif
{
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"引导页" withExtension:@"gif"];
    CGImageSourceRef cImageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)url, NULL);
    size_t imageCount = CGImageSourceGetCount(cImageSource);
    NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:imageCount];
    for (size_t i = 0; i < imageCount; i++) {
        CGImageRef cgImage= CGImageSourceCreateImageAtIndex(cImageSource, i, NULL);
        UIImage *image = [UIImage imageWithCGImage:cgImage];
        [images addObject:image];
        CGImageRelease(cgImage);
    }
    imageView.image = images[0];
    CGFloat w = ScreenWidth * 0.3;
    if (iPhone6Plus) {
        w = ScreenWidth * 0.4;
    }
    CGFloat h = w * GIFHeight / GIFWidth;
    CGFloat x = (ScreenWidth - w) / 2;
    CGFloat y = ScreenHeight * 0.2;
    if (iPhone6Plus) {
        y = ScreenHeight * 0.2 - 30;
    }
    imageView.frame = CGRectMake(x, y, w, h);
    imageView.animationImages = images;
    imageView.animationRepeatCount = 0;
    imageView.animationDuration = 1.6;
    [imageView startAnimating];
}

- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.contentSize = CGSizeMake(ScreenWidth * PageCount, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    self.scrollView = scrollView;
    [self.view insertSubview:scrollView belowSubview:self.imageView];
    
    
    for (int i = 0; i < PageCount; i++) {
        UIImageView *titleImgView = [[UIImageView alloc] init];
        [scrollView addSubview:titleImgView];
        titleImgView.contentMode = UIViewContentModeScaleAspectFit;
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"newfeature%d", i + 1]];
        titleImgView.image = image;
        CGFloat imageH = image.size.height * 0.3;
        CGFloat imageW = image.size.width * 0.3;
        if (iPhone6Plus) {
            imageH = image.size.height * 0.4;
            imageW = image.size.width * 0.4;
        } else if (iPhone6) {
            imageH = image.size.height * 0.32;
            imageW = image.size.width * 0.32;
        }
        titleImgView.x = ScreenWidth * i + (ScreenWidth - imageW) / 2;
        titleImgView.y = CGRectGetMaxY(self.imageView.frame) + 100 - imageH / 2;
        if (iPhone6Plus || iPhone6) {
            titleImgView.y = CGRectGetMaxY(self.imageView.frame) + 130 - imageH / 2;
        }
        titleImgView.width = imageW;
        titleImgView.height = imageH;
    }
    
    UIButton *startBtn = [[UIButton alloc] init];
    [scrollView addSubview:startBtn];
    startBtn.width = 210 * 0.6;
    startBtn.height = 74 * 0.6;
    if (iPhone4) {
        startBtn.width = 210 * 0.5;
        startBtn.height = 74 * 0.5;
    }
    startBtn.centerX = ScreenWidth * 2.5;
    if (iPhone4) {
        startBtn.centerY = ScreenHeight - 77;
    } else if (iPhone6Plus) {
        startBtn.centerY = ScreenHeight - 120;
    } else if (iPhone6){
        startBtn.centerY = ScreenHeight - 120;
    } else {
        startBtn.centerY = ScreenHeight - 100;
    }
    [startBtn setImage:[UIImage imageNamed:@"体验"] forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupPageControl
{
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = PageCount;
    pageControl.centerX = ScreenWidth * 0.5;
    pageControl.centerY = ScreenHeight - 32;
    [self.view addSubview:pageControl];
    
    pageControl.currentPageIndicatorTintColor = LPColor(30, 144, 255);
    pageControl.pageIndicatorTintColor = LPColor(189, 189, 189);
    self.pageControl = pageControl;
}

- (void)setupCancelBtn
{
    CGFloat padding = 20;
    UIButton *cancelBtn = [[UIButton alloc] init];
    [self.view insertSubview:cancelBtn aboveSubview:self.scrollView];
    cancelBtn.width = 25;
    cancelBtn.height = 25;
    if (iPhone6Plus) {
        cancelBtn.width = 40;
        cancelBtn.height = 40;
    }
    cancelBtn.x = ScreenWidth - padding - cancelBtn.width;
    cancelBtn.y =  padding;
    [cancelBtn setImage:[UIImage imageNamed:@"跳过"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(startBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)startBtnClick
{
//    MainViewController *mainVc = [[MainViewController alloc] init];
//    MainNavigationController *mainNavVc = [[MainNavigationController alloc] initWithRootViewController:mainVc];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    LaunchViewController *launchVc = [[LaunchViewController alloc] init];
    window.rootViewController = launchVc;
}

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.width + 0.5;
    self.pageControl.currentPage = page;
}
@end
