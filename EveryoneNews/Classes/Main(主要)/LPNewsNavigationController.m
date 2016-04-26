//
//  LPNewsNavigationController.m
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPNewsNavigationController.h"
#import "LPNewsNavigationBar.h"
#import "LCPanGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "LPNewsSettingViewController.h"

NS_ASSUME_NONNULL_BEGIN

#define kGetCallBackOffset  (kApplecationScreenWidth)

@interface UIView (Snapshot)
- (UIImage *)snapshot;
@end

@implementation UIView (Snapshot)

- (UIImage *)snapshot
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}

@end


static const NSString *contentImageKey  = @"contentImageKey";
static const NSString *barImageKey      = @"barImageKey";
static const NSString *contentFrameKey  = @"contentFrameKey";

@interface LPNewsNavigationController ()<UIGestureRecognizerDelegate>

@property (nonatomic,readonly) BOOL canPushOrPop;

@property (nonatomic,readonly) id navLock;

@property (strong, nonatomic) LCPanGestureRecognizer *pan;
@property (strong, nonatomic) NSMutableArray *shotStack;

@property (strong, nonatomic) UIImageView *previousMirrorView;
@property (strong, nonatomic) UIImageView *previousBarMirrorView;
@property (strong, nonatomic) UIView *previousOverLayView;
@property (assign, nonatomic) BOOL animatedFlag;

@property (readonly, nonatomic) UIView *controllerWrapperView;
@property (weak, nonatomic,nullable) UIView *barBackgroundView;
@property (weak, nonatomic) UIView *barBackIndicatorView;

@property (assign, nonatomic) CGFloat showViewOffsetScale;
@property (assign, nonatomic) CGFloat showViewOffset;

@end

@implementation LPNewsNavigationController

#pragma mark- init

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)init {
    self = [super initWithNavigationBarClass:[LPNewsNavigationBar class] toolbarClass:nil];
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithNavigationBarClass:[LPNewsNavigationBar class] toolbarClass:nil];
    if(self) {
        self.viewControllers = @[rootViewController];
    }
    
    return self;
}

- (instancetype)initWithOtherPopStyleAndRootViewController:(UIViewController *)rootViewController{
    
    self = [super initWithNavigationBarClass:[LPNewsNavigationBar class] toolbarClass:nil];
    if(self) {
        self.viewControllers = @[rootViewController];
    }
    [self doOtherPopStyle];
    return self;
    
}


#pragma mark-  Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    _pan = [[LCPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    _pan.delegate = self;
    _pan.maximumNumberOfTouches = 1;
    [self.view addGestureRecognizer:_pan];
    
    _shotStack = [NSMutableArray array];
    _previousMirrorView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _previousMirrorView.backgroundColor = [UIColor clearColor];
    
    _previousOverLayView = [[UIView alloc] initWithFrame:_previousMirrorView.bounds];
    _previousOverLayView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _previousOverLayView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
    [_previousMirrorView addSubview:_previousOverLayView];
    
    
    _previousBarMirrorView = [[UIImageView alloc] initWithFrame:self.navigationBar.bounds];
    _previousBarMirrorView.backgroundColor = [UIColor clearColor];
    
    self.showViewOffsetScale = 1 / 3.0;
    self.showViewOffset = self.showViewOffsetScale * self.view.frame.size.width;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    if ([self.view window] == nil && [self isViewLoaded]) {
    }
    // Dispose of any resources that can be recreated.
}


-(BOOL)shouldAutorotate
{
    return NO;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#else

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#endif


- (void)setViewControllers:(NSArray *)viewControllers
{
    [super setViewControllers:viewControllers];
}

#pragma mark UINavigationController Overrides

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!self.canPushOrPop) {
        
    }
    if (self.canPushOrPop) {
        UIViewController *previousViewController = [self.viewControllers lastObject];
        
        if (previousViewController) {
            
            NSMutableDictionary *shotInfo = [NSMutableDictionary dictionary];
            UIImage *barImage = [self barSnapshot];
            
            double delayInSeconds = animated ? 0.35 : 0.1; // 等按钮状态恢复到normal状态
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                UIImage *contentImage = [previousViewController.view snapshot];
                
                shotInfo[contentImageKey] = contentImage;
                shotInfo[barImageKey] = barImage;
                shotInfo[contentFrameKey] = [NSValue valueWithCGRect:previousViewController.view.frame];
                
                [self.shotStack addObject:shotInfo];
            });
        }
        
        // 动画标识，在动画的情况下，禁掉右滑手势
        [self startAnimated:animated];
        [super pushViewController:viewController animated:animated];
    }
}

-(nullable NSArray*)popToRootViewControllerAnimated:(BOOL)animated {
    if (self.canPushOrPop) {
        [self.shotStack removeAllObjects];
        [[NSNotificationCenter defaultCenter] postNotificationName:kLPNewsSliderBackVCNotification object:nil];
        return [super popToRootViewControllerAnimated:animated];
    }
    else {
        return @[];
    }
}

- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated;
{
    [self.shotStack removeLastObject];
    [self startAnimated:animated];
    
    return [super popViewControllerAnimated:animated];
}

-(nullable NSArray*)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.canPushOrPop) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLPNewsSliderBackVCNotification object:nil];
        return [super popToViewController:viewController animated:animated];
    }
    else {
        return @[];
    }
}

#pragma mark -
#pragma mark Pan

- (void)pan:(UIPanGestureRecognizer *)pan
{
    UIGestureRecognizerState state = pan.state;
    switch (state) {
        case UIGestureRecognizerStateBegan:{
            NSDictionary *shotInfo = [self.shotStack lastObject];
            UIImage *contentImage = shotInfo[contentImageKey];
            UIImage *barImage = shotInfo[barImageKey];
            CGRect rect = [shotInfo[contentFrameKey] CGRectValue];
            
            self.previousMirrorView.image = contentImage;
            self.previousMirrorView.frame = rect;
            self.previousMirrorView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -self.showViewOffset, 0);
            [self.controllerWrapperView insertSubview:self.previousMirrorView belowSubview:self.visibleViewController.view];
            
            self.previousOverLayView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
            
            self.previousBarMirrorView.image = barImage;
            self.previousBarMirrorView.frame = self.navigationBar.bounds;
            self.previousBarMirrorView.alpha = 0;
            [self.navigationBar addSubview:self.previousBarMirrorView ];
            [self startPanBack];
            
            break;
        }
            
        case UIGestureRecognizerStateChanged:{
            CGPoint translationPoint = [self.pan translationInView:self.view];
            
            if (translationPoint.x < 0) translationPoint.x = 0;
            if (translationPoint.x > kApplecationScreenWidth) translationPoint.x = kApplecationScreenWidth;
            
            CGFloat k = translationPoint.x / kApplecationScreenWidth;
            
            [self barTransitionWithAlpha:1 - k];
            self.previousBarMirrorView.alpha = k;
            
            self.previousMirrorView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -self.showViewOffset + translationPoint.x * self.showViewOffsetScale, 0);
            
            self.previousOverLayView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2 * (1 - k)];
            self.visibleViewController.view.transform = CGAffineTransformTranslate(CGAffineTransformIdentity,translationPoint.x, 0);
            
            break;
        }
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            
            CGPoint velocity = [self.pan velocityInView:self.view];
            BOOL reset = velocity.x < 0;
            [[NSNotificationCenter defaultCenter] postNotificationName:kLPNewsSliderBackVCNotification object:nil];
            
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            [UIView animateWithDuration:0.3 animations:^{
                
                CGFloat alpha = reset ? 1.f : 0.f;
                [self barTransitionWithAlpha:alpha];
                self.previousBarMirrorView.alpha = 1 - alpha;
                self.previousMirrorView.transform = reset ? CGAffineTransformTranslate(CGAffineTransformIdentity, -self.showViewOffset, 0) : CGAffineTransformIdentity;
                self.visibleViewController.view.transform = reset ? CGAffineTransformIdentity : CGAffineTransformTranslate(CGAffineTransformIdentity, kApplecationScreenWidth, 0);
                self.previousOverLayView.backgroundColor = reset ? [[UIColor grayColor] colorWithAlphaComponent:0.2] : [UIColor clearColor];
                
            } completion:^(BOOL finished) {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
                [self barTransitionWithAlpha:1];
                
                self.visibleViewController.view.transform = CGAffineTransformIdentity;
                self.previousMirrorView.transform = CGAffineTransformIdentity;
                self.previousMirrorView.image = nil;
                
                self.previousBarMirrorView.image = nil;
                self.previousBarMirrorView.alpha = 0;
                
                [self.previousMirrorView removeFromSuperview];
                [self.previousBarMirrorView removeFromSuperview];
                
                self.barBackgroundView = nil;
                
                [self finshPanBackWithReset:reset];
                
                if (!reset) {
                    [self popViewControllerAnimated:NO];
                }
            }];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark GestureRecognizer Delegate

#define MIN_TAN_VALUE tan(M_PI/6)

//- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
//{
//    if (self.viewControllers.count < 2) return NO;
//    if (self.animatedFlag) return NO;
//    if (![self enablePanBack]) return NO; // 询问当前viewconroller 是否允许右滑返回
//    
//    CGPoint touchPoint = [gestureRecognizer locationInView:self.controllerWrapperView];
//    if (touchPoint.x < 0 || touchPoint.y < 10 || touchPoint.x > kGetCallBackOffset) return NO;
//    
//    CGPoint translation = [gestureRecognizer translationInView:self.view];
//    if (translation.x <= 0) return NO;
//    
//    // 是否是右滑
//    BOOL succeed = fabs(translation.y / translation.x) < MIN_TAN_VALUE;
//    
//    return succeed;
//}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([self.visibleViewController isKindOfClass:[LPNewsSettingViewController class]]) {
//        LPNewsSettingViewController *tabVC = (LPNewsSettingViewController *)self.visibleViewController;
            if (otherGestureRecognizer.state != UIGestureRecognizerStateBegan) {
                
                return YES;
            }
            // 如果是scrollview 判断scrollview contentOffset 是否为0，是 cancel scrollview 的手势，否cancel自己
            if ([[otherGestureRecognizer view] isKindOfClass:[UIScrollView class]]) {
                UIScrollView *scrollView = (UIScrollView *)[otherGestureRecognizer view];
                
                if (scrollView.contentOffset.x <= 0) {
                    CGPoint translatedPoint = [(UIPanGestureRecognizer *)otherGestureRecognizer translationInView:scrollView];//在滑动方法当中根据 translationInView 这个方法返回的点的正负来判断向左还是向右 大于0说明向左，小于0说明向右
                    if (translatedPoint.x > 0) {
                        [self cancelOtherGestureRecognizer:otherGestureRecognizer];
                        return YES;
                    }
                    
                }
            return NO;
        }
    }else{
        if (gestureRecognizer != self.pan) return NO;
        if (self.pan.state != UIGestureRecognizerStateBegan) return NO;
    }
    
    
    if (otherGestureRecognizer.state != UIGestureRecognizerStateBegan) {
        
        return YES;
    }
    
    CGPoint touchPoint = [self.pan beganLocationInView:self.controllerWrapperView];
    
    // 点击区域判断 如果在左边 30 以内, 强制手势后退
    if (touchPoint.x < 30) {
        
        [self cancelOtherGestureRecognizer:otherGestureRecognizer];
        return YES;
    }
    
    // 如果是scrollview 判断scrollview contentOffset 是否为0，是 cancel scrollview 的手势，否cancel自己
    if ([[otherGestureRecognizer view] isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)[otherGestureRecognizer view];
        if (scrollView.contentOffset.x <= 0) {
            
            [self cancelOtherGestureRecognizer:otherGestureRecognizer];
            return YES;
        }
    }
    
    return NO;
}

- (void)cancelOtherGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    NSSet *touchs = [self.pan.event touchesForGestureRecognizer:otherGestureRecognizer];
    [otherGestureRecognizer touchesCancelled:touchs withEvent:self.pan.event];
}


#pragma mark -
#pragma mark Custom

- (void)startAnimated:(BOOL)animated
{
    self.animatedFlag = YES;
    
    NSTimeInterval delay = animated ? 0.8 : 0.1;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishedAnimated) object:nil];
    [self performSelector:@selector(finishedAnimated) withObject:nil afterDelay:delay];
}

- (void)finishedAnimated
{
    self.animatedFlag = NO;
}

- (void)barTransitionWithAlpha:(CGFloat)alpha
{
    UINavigationItem *topItem = self.navigationBar.topItem;
    
    UIView *topItemTitleView = topItem.titleView;
    
    if (!topItemTitleView) { // 找titleview
        UIView *defaultTitleView = nil;
        @try {
            defaultTitleView = [topItem valueForKey:@"_defaultTitleView"];
        }
        @catch (NSException *exception) {
            defaultTitleView = nil;
        }
        
        topItemTitleView = defaultTitleView;
    }
    
    topItemTitleView.alpha = alpha;
    
    if (!topItem.leftBarButtonItems.count) { // 找后退按钮Item
        UINavigationItem *backItem = self.navigationBar.backItem;
        UIView *backItemBackButtonView = nil;
        
        @try {
            backItemBackButtonView = [backItem valueForKey:@"_backButtonView"];
        }
        @catch (NSException *exception) {
            backItemBackButtonView = nil;
        }
        backItemBackButtonView.alpha = alpha;
        self.barBackIndicatorView.alpha = alpha;
    }
    
    
    [topItem.leftBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem *barButtonItem, NSUInteger idx, BOOL *stop) {
        barButtonItem.customView.alpha = alpha;
    }];
    
    [topItem.rightBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem *barButtonItem, NSUInteger idx, BOOL *stop) {
        barButtonItem.customView.alpha = alpha;
    }];
}

#pragma mark -
#pragma mark GET

- (UIPanGestureRecognizer *)panGestureRecognizer
{
    return self.pan;
}

- (UIView *)controllerWrapperView
{
    return self.visibleViewController.view.superview;
}

- (nullable UIView *)barBackgroundView
{
    if (_barBackgroundView) return _barBackgroundView;
    
    for (UIView *subview in self.navigationBar.subviews) {
        if (!subview.hidden && subview.frame.size.height >= self.navigationBar.frame.size.height
            && subview.frame.size.width >= self.navigationBar.frame.size.width) {
            _barBackgroundView = subview;
            break;
        }
    }
    return _barBackgroundView;
}

- (nullable UIView *)barBackIndicatorView
{
    if (!_barBackIndicatorView) {
        for (UIView *subview in self.navigationBar.subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"_UINavigationBarBackIndicatorView")]) {
                _barBackIndicatorView = subview;
                break;
            }
        }
        
    }
    return _barBackIndicatorView;
}

- (UIImage *)barSnapshot
{
    self.barBackgroundView.hidden = YES;
    UIImage *viewImage = [self.navigationBar snapshot];
    self.barBackgroundView.hidden = NO;
    return viewImage;
}

#pragma mark -
#pragma mark LCPanBackProtocol

- (BOOL)enablePanBack
{
    BOOL enable = YES;
    if ([self.visibleViewController respondsToSelector:@selector(enablePanBack:)]) {
        UIViewController<JoyPanBackProtocol> * viewController = (UIViewController<JoyPanBackProtocol> *)self.visibleViewController;
        enable = [viewController enablePanBack:self];
    }
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        return enable;
    }else{
        return NO;
    }
}

- (void)startPanBack
{
    if ([self.visibleViewController respondsToSelector:@selector(startPanBack:)]) {
        UIViewController<JoyPanBackProtocol> * viewController = (UIViewController<JoyPanBackProtocol> *)self.visibleViewController;
        [viewController startPanBack:self];
    }
}

- (void)finshPanBackWithReset:(BOOL)reset
{
    if (reset) {
        [self resetPanBack];
    } else {
        [self finshPanBack];
    }
}

- (void)finshPanBack
{
    if ([self.visibleViewController respondsToSelector:@selector(finshPanBack:)]) {
        UIViewController<JoyPanBackProtocol> * viewController = (UIViewController<JoyPanBackProtocol> *)self.visibleViewController;
        [viewController finshPanBack:self];
    }
}

- (void)resetPanBack
{
    if ([self.visibleViewController respondsToSelector:@selector(resetPanBack:)]) {
        UIViewController<JoyPanBackProtocol> * viewController = (UIViewController<JoyPanBackProtocol> *)self.visibleViewController;
        [viewController resetPanBack:self];
    }
}


#pragma mark PUBLIC PROPERTIES

-(BOOL)canPushOrPop {
    id navLock = self.navLock;
    id topVC = self.topViewController;
    return ( (! navLock) || (navLock == topVC) );
}

-(id)navLock {
    return self.topViewController;
}

#pragma mark- StatusBarConfig

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000 // iOS 7.0 supported
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
#endif


#pragma mark- init OtherPopStyle

- (void)doOtherPopStyle{
    self.navigationBar.hidden = YES;
    
    // built-in pop recognizer
    UIGestureRecognizer *recognizer = self.interactivePopGestureRecognizer;
    recognizer.enabled = NO;
    UIView *gestureView = recognizer.view;
    
    // pop recognizer
    UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc] init];
    popRecognizer.delegate = self;
    popRecognizer.maximumNumberOfTouches = 1;
    [gestureView addGestureRecognizer:popRecognizer];
    self.popRecognizer = popRecognizer;
    
    // taget-action reflect
    NSMutableArray *actionTargets = [recognizer valueForKey:@"_targets"];
    id actionTarget = [actionTargets firstObject];
    id target = [actionTarget valueForKey:@"_target"];
    SEL action = NSSelectorFromString(@"handleNavigationTransition:");
    [popRecognizer addTarget:target action:action];
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    return self.viewControllers.count > 1 && ![[self valueForKey:@"_isTransitioning"] boolValue] && [gestureRecognizer translationInView:gestureRecognizer.view].x > 0;
}



@end

NS_ASSUME_NONNULL_END