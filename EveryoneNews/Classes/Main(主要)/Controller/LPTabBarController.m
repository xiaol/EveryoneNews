//
//  LPTabBarController.m
//  EveryoneNews
//
//  Created by apple on 15/5/26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPTabBarController.h"
#import "LPTabBar.h"
#import "LPHomeViewController.h"
#import "LPCategoryViewController.h"
#import "LPNavigationController.h"
#import "TransitioningObject.h"
#import "LPCategoryViewController.h"
#import "LPCategory.h"


@interface LPTabBarController () <LPTabBarDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>


// @property (nonatomic, assign) NSInteger selectedContentIndex;
@property (nonatomic, strong) NSMutableArray *contents;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIGestureRecognizer *gestureRecognizer;
@property (nonatomic, strong) UIView *clock;
@end

@implementation LPTabBarController

- (NSMutableArray *)contents
{
    if (_contents == nil) {
        _contents = [NSMutableArray array];
    }
    return _contents;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupPageViewController];

    [self setupTabBar];
    
    [self setupAllChildViewControllers];
    
    [self setupContent];
    
    [noteCenter addObserver:self selector:@selector(receivePushNotification:) name:LPPushNotificationFromBack object:nil];
    
//    UIView *clock = [[UIView alloc] initWithFrame:CGRectMake(20, ScreenHeight - 40, 20, 20)];
//    clock.backgroundColor = [UIColor purpleColor];
//    clock.layer.cornerRadius = clock.height / 2;
//    [self.view addSubview:clock];
//    self.clock = clock;
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


- (void)setupPageViewController
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    
    [self addChildViewController:self.pageViewController];
    
    UIScrollView *scrollView = (UIScrollView *)[self.pageViewController.view.subviews objectAtIndex:0];
    
    scrollView.delegate = self;
    
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
}

- (void)setupTabBar
{
    LPTabBar *customTabBar = [[LPTabBar alloc] init];
    customTabBar.frame = CGRectMake(0, 0, ScreenWidth, TabBarHeight);
# pragma mark - to be modified...
    customTabBar.backgroundColor = [UIColor colorFromHexString:TabBarColor alpha:1.0];
    customTabBar.delegate = self;
    [self.view addSubview:customTabBar];
    self.customTabBar = customTabBar;
}

- (void)setupAllChildViewControllers
{
    LPCategoryViewController *category = [[LPCategoryViewController alloc] init];

    category.view.backgroundColor = [UIColor whiteColor];
    [self setupChildViewController:category withTitle:@"关注" tabImageName:nil tabSelectedImage:nil tag:0];
    [noteCenter addObserver:self selector:@selector(categoryChange:) name:LPCategoryDidChangeNotification object:category];
//    category.delegate = self;
    
    LPHomeViewController *home = [[LPHomeViewController alloc] init];
    [self setupChildViewController:home withTitle:@"今日" tabImageName:nil tabSelectedImage:nil tag:1];
}

- (void)setupChildViewController:(UIViewController *)childVc withTitle:(NSString *)title tabImageName:(NSString *)imageName tabSelectedImage:(NSString *)selectedImageName tag:(int)i
{
    // 1 设置子控制器属性(此时的tabBarItem被当作模型使用，原tabBar自带的子控件按钮会被删除)
    childVc.tabBarItem.title = title;
//    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
//    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 2 包装导航控制器
    LPNavigationController *nav = [[LPNavigationController alloc] initWithRootViewController:childVc];
    
    nav.tabVc = self;
    
    [self.contents addObject:nav];
    
    // 3 添加tabbar内部的按钮,参数为tabBarItem模型
    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem tag:i];
}

- (void)setupContent
{
    self.contentView = self.pageViewController.view;
    self.contentView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.view insertSubview:self.contentView belowSubview:self.customTabBar];
    self.selectedIndex = 1;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    UIViewController *vc = [self.contents objectAtIndex:selectedIndex];
    if (selectedIndex == self.selectedIndex) {
        [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
            
        }];
    } else {
        NSInteger direction = selectedIndex < self.selectedIndex ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward;
        [UIView animateWithDuration:0.2 animations:^{
            self.customTabBar.sliderView.x = selectedIndex < self.selectedIndex ? 0 : TabBarButtonWidth;
        }];
        [self.pageViewController setViewControllers:@[vc] direction:direction animated:YES completion:^(BOOL finished) {
            
        }];
    }
    self.customTabBar.selectedButton = [self.customTabBar.tabBarButtons objectAtIndex:selectedIndex];
    _selectedIndex = selectedIndex;
}


#pragma mark - LPTabBarDelegate
// 注意子控制器逆序存放
- (void)tabBar:(LPTabBar *)tabBar didSelectButtonFrom:(int)from to:(int)to
{
    if (from == to) return;
    self.selectedIndex = to;
}


#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.contents indexOfObject:viewController];
    if (index == 0) {
        return nil;
    } else {
        index--;
        return [self.contents objectAtIndex:index];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.contents indexOfObject:viewController];
    index++;
    if (index == self.contents.count) {
        return nil;
    } else {
        return [self.contents objectAtIndex:index];
    }
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
    UIViewController *destVc = self.pageViewController.viewControllers[0];

    NSUInteger index = [self.contents indexOfObject:destVc];

    self.selectedIndex = index;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{ // 既得pageViewController的子scrollView，在此通过其代理方法实现sliderView的跟随滚动
    if (self.selectedIndex == 1 && scrollView.contentOffset.x < ScreenWidth) {
        self.customTabBar.sliderView.x = TabBarButtonWidth * scrollView.contentOffset.x / ScreenWidth;
    } else if (self.selectedIndex == 0 && scrollView.contentOffset.x > ScreenWidth) {
        self.customTabBar.sliderView.x = TabBarButtonWidth * (scrollView.contentOffset.x / ScreenWidth - 1);
    }
}

#pragma mark - notification selector
- (void)categoryChange:(NSNotification *)note
{
    NSDictionary *info = note.userInfo;
    LPCategory *from = info[LPCategoryFrom];
    LPCategory *to = info[LPCategoryTo];
    if (from.ID != to.ID) {
        LPTabBarButton *btn = self.customTabBar.tabBarButtons[1];
        [UIView transitionWithView:btn duration:0.8 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                [btn setTitle:to.title forState:UIControlStateNormal];
                self.selectedIndex = 1;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        self.selectedIndex = 1;
    }
}

- (void)receivePushNotification:(NSNotification *)note
{
    NSLog(@"LPTabBarVC receivePushNotification");
    LPTabBarButton *btn = self.customTabBar.tabBarButtons[1];
    [btn setTitle:@"今日" forState:UIControlStateNormal];
    self.selectedIndex = 1;
}

- (void)dealloc
{
    [noteCenter removeObserver:self name:LPCategoryDidChangeNotification object:nil];
    [noteCenter removeObserver:self name:LPPushNotificationFromBack object:nil];
}

//#pragma mark - LPCategoryViewControllerDelegate
//- (void)categoryViewController:(LPCategoryViewController *)categoryViewController didSelectCategoryFrom:(LPCategory *)from to:(LPCategory *)to
//{
//    if (from.ID != to.ID) {
//        // 1.转场、改标题
//        LPTabBarButton *btn = self.customTabBar.tabBarButtons[1];
//        [UIView transitionWithView:btn duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
//                [btn setTitle:to.title forState:UIControlStateNormal];
//                self.selectedIndex = 1;
//        } completion:^(BOOL finished) {
//                
//        }];
//
//        // 2.刷新数据 with to.url
//        
//    } else {
//        self.selectedIndex = 1;
//    }
//}

//#pragma mark - 转场动画
//- (id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
//{
//    TransitioningObject *transitioningObject = [[TransitioningObject alloc] init];
//    transitioningObject.tabBarController = self;
//    return transitioningObject;
//}


@end
