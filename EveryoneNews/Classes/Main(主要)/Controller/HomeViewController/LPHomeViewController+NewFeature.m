//
//  LPHomeViewController+NewFeature.m
//  EveryoneNews
//
//  Created by dongdan on 16/1/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPHomeViewController+NewFeature.h"

@implementation LPHomeViewController (NewFeature)
 
#pragma mark - 新特性
- (void)setupNewFeatureView {
    // 添加遮罩背景层
    UIView *featureBlurView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    featureBlurView.backgroundColor = [UIColor blackColor];
    featureBlurView.alpha = 0.6;
    
    [self.view addSubview:featureBlurView];
    self.featureBlurView = featureBlurView;
    
    // 添加新特性
    UIView *featureView = [[UIView alloc] init];
    featureView.backgroundColor = [UIColor whiteColor];
    featureView.layer.cornerRadius = 10;
    featureView.frame = CGRectMake(30, 100, ScreenWidth - 60, ScreenHeight - 200);
    if (iPhone6Plus) {
        featureView.frame = CGRectMake(30, 150, ScreenWidth - 60, ScreenHeight - 300);
    }
    
    CGFloat headerImageHeight = 50;
    CGFloat headerImageWidth = 200;
    CGFloat paddingTop = 30;
    
    NSString *headerImageName;
    
    headerImageName = @"5_欢迎来到头条百家";
    if (iPhone4) {
        headerImageName = @"4_欢迎来到头条百家";
    } else if(iPhone5) {
        headerImageName = @"5_欢迎来到头条百家";
        
    } else if(iPhone6) {
        headerImageName = @"6_欢迎来到头条百家";
    } else if(iPhone6Plus) {
        headerImageName = @"6Plus_欢迎来到头条百家";
    } else {
        headerImageName = @"6Plus_欢迎来到头条百家";
    }
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake((featureView.frame.size.width - headerImageWidth) / 2, paddingTop, headerImageWidth, headerImageHeight)];
    headerImageView.image = [UIImage imageNamed:headerImageName];
    [featureView addSubview:headerImageView];
    
    
    CGFloat featureScrollViewX = 0;
    CGFloat featureScrollViewY = CGRectGetMaxY(headerImageView.frame);
    CGFloat featureScrollViewW = featureView.size.width;
    CGFloat featureScrollViewH = featureView.size.height - featureScrollViewY - 50;
    
    CGFloat featureImageX = 50;
    CGFloat featureImageY = 30;
    CGFloat featureImageW = featureScrollViewW - 2 * featureImageX;
    CGFloat featureImageH = featureScrollViewH - 30;
    
    UIScrollView *featureScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(featureScrollViewX, featureScrollViewY, featureScrollViewW, featureScrollViewH)];
    for (int i = 0; i < 2; i ++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        NSString *imageName;
        imageView.frame = CGRectMake(i * featureScrollViewW + featureImageX, featureImageY, featureImageW, featureImageH);
        imageView.contentMode = UIViewContentModeCenter;
        if (iPhone4) {
            imageName = [NSString stringWithFormat:@"4_新功能%d", i + 1];
        } else if(iPhone5) {
            imageName = [NSString stringWithFormat:@"5_新功能%d", i + 1];
            
        } else if(iPhone6) {
            imageName = [NSString stringWithFormat:@"6_新功能%d", i + 1];
        } else if(iPhone6Plus) {
            imageName = [NSString stringWithFormat:@"6Plus_新功能%d", i + 1];
        } else {
            imageName = [NSString stringWithFormat:@"6Plus_新功能%d", i + 1];
        }
        imageView.image = [UIImage imageNamed:imageName];
        [featureScrollView addSubview:imageView];
    }
    
    featureScrollView.contentSize = CGSizeMake(2 * featureScrollViewW, 0);
    featureScrollView.showsHorizontalScrollIndicator = NO;
    featureScrollView.pagingEnabled = YES;
    featureScrollView.delegate = self;

    // 分页栏
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(0, CGRectGetMaxY(featureScrollView.frame), featureScrollViewW, 50);
    pageControl.bounds = CGRectMake(0, 0, 150, 50);
    pageControl.numberOfPages = 2; // 一共显示多少个圆点（多少页）
    // 设置非选中页的圆点颜色
    pageControl.pageIndicatorTintColor = [UIColor colorFromHexString:@"#b8b8b8"];
    // 设置选中页的圆点颜色
    pageControl.currentPageIndicatorTintColor = [UIColor colorFromHexString:@"#717171"];
    // 禁止默认的点击功能
    pageControl.enabled = NO;
    [featureView addSubview:featureScrollView];
    [featureView addSubview:pageControl];
    self.pageControl = pageControl;
    
    UITapGestureRecognizer *closeTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newFeatureDidClose:)];
    closeTapGesture.delegate = self;
    
    [self.view addSubview:featureView];
    self.featureView = featureView;
    
    // 关闭按钮
    CGFloat closeImageViewW = 23;
    CGFloat closeImageViewH = 23;
    UIImageView *closeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(featureView.frame) - closeImageViewW / 2, featureView.frame.origin.y-closeImageViewH / 2, closeImageViewW, closeImageViewH)];
    
    NSString *closeImageName = @"5_新功能删除按钮";
    
    if (iPhone4) {
        
        closeImageName = @"4_新功能删除按钮";
        
    } else if(iPhone5) {
        
        closeImageName = @"5_新功能删除按钮";
        
    } else if(iPhone6) {
        
        closeImageName = @"6_新功能删除按钮";
        
    } else if(iPhone6Plus) {
        
        closeImageName = @"6Plus_新功能删除按钮";
        
    } else {
        
        closeImageName = @"6Plus_新功能删除按钮";
    }
    
    UIImage *closeImage = [UIImage imageNamed:closeImageName];
    closeImageView.image = closeImage;
    closeImageView.userInteractionEnabled = YES;
    [closeImageView addGestureRecognizer:closeTapGesture];
    
    [self.view addSubview:closeImageView];
    self.closeImageView = closeImageView;
    
}

#pragma mark - 新特性分页
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = page;
}

#pragma mark - 关闭新特性窗口
- (void)newFeatureDidClose:(UITapGestureRecognizer *)sender {
    self.featureBlurView.hidden = YES;
    self.featureView.hidden = YES;
    self.closeImageView.hidden = YES;
}

@end
