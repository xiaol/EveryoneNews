//
//  QDNewsBaseViewController.m
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPNewsBaseViewController.h"
#import "LPNewsNavigationBar.h"

NS_ASSUME_NONNULL_BEGIN

static const NSInteger kNavBarTag = 10000;
@interface LPNewsBaseViewController ()

@property (nonatomic, strong ,nullable)UINavigationItem *navItem;

@end

@implementation LPNewsBaseViewController{
    BOOL _isCustomBar;
}

#pragma mark-  Life Cycle


- (void)loadView {
    CGRect viewFrame = [[UIScreen mainScreen] bounds];
    UIView *rootView = [[UIView alloc] initWithFrame:viewFrame];
    [rootView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [rootView setBackgroundColor:[UIColor whiteColor]];
    
    [self setView:rootView];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_isCustomBar) {
        if (self.isRootLevel) {
            [self.parentViewController.navigationController setNavigationBarHidden:YES animated:YES];
        }else{
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    if ([self.view window] == nil && [self isViewLoaded]) {
        self.navItem = nil;
    }
}

- (void)dealloc{
    self.rigthItemMethodBlock = nil;
}

#pragma mark- init


- (instancetype)init{
    self = [super init];
    if (self) {
        _isRootLevel = NO;
        _isPresent = NO;
        _isCustomBar = NO;
    }
    return self;
}

- (instancetype)initWithCustom{
    self = [super init];
    if (self) {
        _isRootLevel = NO;
        _isPresent = NO;
        _isCustomBar = YES;
    }
    return self;
}

- (instancetype)initWithRootCustom{
    self = [super init];
    if (self) {
        _isRootLevel = YES;
        _isPresent = NO;
        _isCustomBar = YES;
    }
    return self;
}


- (instancetype)initWithRoot{
    self = [super init];
    if (self) {
        _isRootLevel = YES;
        _isPresent = NO;
        _isCustomBar = NO;
    }
    return self;
}

- (instancetype)initWithPresent{
    self = [super init];
    if (self) {
        _isRootLevel = NO;
        _isPresent = YES;
        _isCustomBar = NO;
    }
    return self;
}



#pragma mark- CustomNavigationBar

- (void)constructionNaigationBar{
    
    UINavigationBar *navBar = (UINavigationBar *)[self.view viewWithTag:kNavBarTag];
    
    if (!navBar) {
        CGRect barFrame;
        if (self.isRootLevel) {
            barFrame = self.parentViewController.navigationController.navigationBar.bounds;
        }else{
            barFrame = self.navigationController.navigationBar.bounds;
        }
        CGFloat barHeight;
        if (iOS8) {
            barHeight = (kNavigationBarHEIGHT+20.f);
        }else{
            barHeight = kNavigationBarHEIGHT;
        }
        if (barFrame.size.width == 0) {
            barFrame.size.width = kApplecationScreenWidth;
        }
        navBar = [[LPNewsNavigationBar alloc]initWithCustomFame:barFrame];
        navBar.tag = kNavBarTag;
        
        CGRect lineLayerRect = CGRectMake(0.f, (barHeight-.5f), CGRectGetWidth(barFrame), .5f);
        CALayer *lineLayer = [CALayer layer];
        lineLayer.frame = lineLayerRect;
        lineLayer.backgroundColor = [[UIColor colorWithDesignIndex:5] CGColor];
        [navBar.layer addSublayer:lineLayer];
    }
    
    
    if (!_navItem) {
        UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@""];
        _navItem = navItem;
        [navBar pushNavigationItem:_navItem animated:YES];
    }
    
    if (!navBar.superview) {
        [self.view addSubview:navBar];
    }
}

#pragma mark- InitNavItem



- (void)setNavItemWithTitle:(nullable NSString *)title  titleColor:(nullable NSString *)titileColor imageColor:(nullable NSString *)imageColor  hlImage:(nullable NSString *)hlImageColor  position:(NavItemPosition) position{
    
    self.navigationItem.hidesBackButton = YES;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize textSize = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.f]}].size;
    
    CGFloat btnWidth = textSize.width;
    if (imageColor && imageColor.length  > 0) {
        btnWidth = textSize.width+18.f;
        if (btnWidth < 52.f) {
            btnWidth = 52.f;
        }
    }
    
    btn.frame = CGRectMake(0, 0, btnWidth, 26.f);
    UIImage *image = nil;
    if (imageColor && imageColor.length != 0) {
        image = [UIImage commonColorSquarenessImage:[UIColor colorWithHexString:imageColor] size:btn.frame.size];
        [btn setBackgroundImage:image forState:UIControlStateNormal];
    }
    if (hlImageColor && hlImageColor.length != 0) {
        image = [UIImage commonColorSquarenessImage:[UIColor colorWithHexString:hlImageColor] size:btn.frame.size];
        [btn setBackgroundImage:image forState:UIControlStateHighlighted];
    }
    
    if (titileColor) {
        [btn setTitleColor:[UIColor colorWithHexString:titileColor] forState:UIControlStateNormal];
    }
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
    
    
    
    if (position == NavLeftItem) {
        [btn addTarget:self action:@selector(leftItemAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navItem.leftBarButtonItem = leftItem;
    }else{
        [btn addTarget:self action:@selector(rightItemAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navItem.rightBarButtonItem = rightItem;
    }
    
}


- (void)setCustomView:(UIView *)view position:(NavItemPosition) position{
    switch (position) {
        case NavLeftItem:{
            UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:view];
            self.navItem.leftBarButtonItem = leftItem;
            break;
        }
        case NavRightItem:{
            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:view];
            self.navItem.rightBarButtonItem = rightItem;
            break;
        }
        case NavTitleView:
            self.navItem.titleView = view;
            break;
            
        default:
            break;
    }
}

- (void)setCustomViews:(NSArray *)viewArray position:(NavItemPosition) position{
    switch (position) {
        case NavLeftItem:{
            NSMutableArray *barItemArray = [NSMutableArray array];
            [viewArray enumerateObjectsUsingBlock:^(id  __nonnull obj, NSUInteger idx, BOOL * __nonnull stop) {
                UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:obj];
                [barItemArray addObject:leftItem];
            }];
            self.navItem.leftBarButtonItems = barItemArray;
            break;
        }
        case NavRightItem:{
            NSMutableArray *barItemArray = [NSMutableArray array];
            [viewArray enumerateObjectsUsingBlock:^(id  __nonnull obj, NSUInteger idx, BOOL * __nonnull stop) {
                UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:obj];
                [barItemArray addObject:leftItem];
            }];
            self.navItem.rightBarButtonItems = barItemArray;
            break;
        }
        default:
            break;
    }
}

#pragma mark- navItem

- (nullable UINavigationItem *)navItem{
    if (_isCustomBar) {
        [self constructionNaigationBar];
        return _navItem;
    }
    if (self.isRootLevel) {
        return self.parentViewController.navigationItem;
    }else{
        return self.navigationItem;
    }
    
}

#pragma mark - TitleView

- (void)setNavTitleView:(NSString *)title{
    CGSize textSize = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.f]}].size;
    UIFont *textFont = [UIFont systemFontOfSize:18.f];
    if (textSize.width > 150.f) {
        textFont = [UIFont systemFontOfSize:15.f];
        textSize = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:textFont}].size;
    }
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, 44.f)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = textFont;
    titleLabel.text = title;
    titleLabel.textColor = kNavTextColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navItem.titleView = titleLabel;
}



#pragma mark - BackItem

- (void)backImageItem{
    self.navItem.hidesBackButton = YES;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [LPNewsAssistant imageWithContentsOfFile:@"BackArrow_black"];
    
    CGFloat btnWidth = image.size.width+18.f;
    CGFloat btnHeight = image.size.height;
    if (btnWidth < 52.f) {
        btnWidth = 60.f;
    }
    if (btnHeight < 30.f) {
        btnHeight = kNavigationBarHEIGHT;
    }
    btn.frame = CGRectMake(0, 0, btnWidth, btnHeight);
    if (iOS8) {
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -68.f, 0, 0)];
    }else{
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -20.f, 0, 0)];
    }
    [btn setImage:image forState:UIControlStateNormal];
    btn.adjustsImageWhenHighlighted = NO;
    [btn addTarget:self action:@selector(doBackAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navItem.leftBarButtonItem = leftItem;
}

- (void)backItem:(NSString *)title
{
    if (!title) {
        title = @"";
    }
    self.navigationItem.hidesBackButton = YES;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [LPNewsAssistant imageWithContentsOfFile:@"joyBack"];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithDesignIndex:1] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
    
    CGSize textSize = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.f]}].size;
    CGFloat btnWidth = (textSize.width +image.size.width+8.f);
    if (btnWidth > kApplecationScreenWidth/2) {
        btnWidth = kApplecationScreenWidth/2;
    }
    if (iOS8) {
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -10.f, 0, 0)];
    }else{
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8.f, 0, 0)];
    }
    
    
    btn.frame = CGRectMake(0, 0, btnWidth, 44.f);
    [btn addTarget:self action:@selector(doBackAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navItem.leftBarButtonItem = backItem;
}

#pragma mark - LeftItem

- (void)setCancelItem{
    [self setLeftItemWithTitle:@"取消"];
}

- (void)setLeftItemWithTitle:(NSString *)title{
    self.navigationItem.hidesBackButton = YES;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize textSize = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.f]}].size;
    CGFloat btnWidth = textSize.width+18.f;
    if (btnWidth < 52.f) {
        btnWidth = 52.f;
    }
    btn.frame = CGRectMake(0, 0, btnWidth, 30.f);
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithDesignIndex:10]] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithDesignIndex:0] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
    
    
    [btn addTarget:self action:@selector(leftItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    //设置一个空位置使得左上角的btn与右边距没有过大的间距
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    self.navItem.leftBarButtonItems = @[negativeSpacer,leftItem];
}


- (void)setLeftItemWithImage:(NSString *)imageName{
    self.navigationItem.hidesBackButton = YES;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *image = [LPNewsAssistant imageWithContentsOfFile:imageName];
    
    CGFloat btnWidth = image.size.width+18.f;
    CGFloat btnHeight = image.size.height;
    if (btnWidth < 52.f) {
        btnWidth = 52.f;
    }
    if (btnHeight < 30.f) {
        btnHeight = 30.f;
    }
    btn.frame = CGRectMake(0, 0, btnWidth, btnHeight);
    if (iOS8) {
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -30.f, 0, 0)];
    }else{
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -20.f, 0, 0)];
    }
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navItem.leftBarButtonItem = leftItem;
}

- (void)setLeftItemAdjoiningWithImage:(NSString *)imageName{
    self.navItem.hidesBackButton = YES;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *image = [LPNewsAssistant imageWithContentsOfFile:imageName];
    
    CGFloat btnWidth = image.size.width+18.f;
    CGFloat btnHeight = image.size.height;
    if (btnWidth < 52.f) {
        btnWidth = 52.f;
    }
    if (btnHeight < 30.f) {
        btnHeight = 30.f;
    }
    btn.frame = CGRectMake(0, 0, btnWidth, btnHeight);
    if (iOS8) {
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -40.f, 0, 0)];
    }else{
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -20.f, 0, 0)];
    }
    
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navItem.leftBarButtonItem = leftItem;
}


#pragma mark- SetRightItem

- (void)setRightItemWithTitle:(nullable NSString *)title{
    if (title) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGSize textSize = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.f]}].size;
        
        CGFloat btnWidth = textSize.width+18.f;
        
        if (btnWidth < 52.f) {
            btnWidth = 52.f;
        }
        btn.frame = CGRectMake(0, 0, btnWidth, 30.f);
        //        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithDesignIndex:10]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithDesignIndex:2] forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
        if (iOS8) {
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20.f, 0, 0)];
        }else{
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10.f, 0, 0)];
        }
        //设置一个空位置使得右上角的btn与右边距没有过大的间距
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        if (iOS8) {
            
            negativeSpacer.width = -10;
            
        }else{
            
            negativeSpacer.width = 0;
        }
        
        [btn addTarget:self action:@selector(rightItemAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        self.navItem.rightBarButtonItems = @[negativeSpacer,rightItem];
        
    }else{
        
        self.navItem.rightBarButtonItems = nil;
    }
    
}

- (void)setRightItemWithImage:(NSString *)imageName{
    self.navigationItem.hidesBackButton = YES;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *image = [LPNewsAssistant imageWithContentsOfFile:imageName];
    
    CGFloat btnWidth = image.size.width+18.f;
    CGFloat btnHeight = image.size.height;
    if (btnWidth < 52.f) {
        btnWidth = 52.f;
    }
    if (btnHeight < 30.f) {
        btnHeight = 30.f;
    }
    btn.frame = CGRectMake(0, 0, btnWidth, btnHeight);
    
    if (iOS8) {
        
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -30.f)];
        
    }else{
        
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20.f)];
        
    }
    
    [btn setImage:image forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(rightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navItem.rightBarButtonItem = rightItem;
}

#pragma mark- BackItemMethod

- (void)doBackAction:(nullable id)sender
{
    if (self.isRootLevel) {
        
        [self.parentViewController.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}



#pragma mark- ItemMethod


- (void)leftItemAction:(nullable id)sender{
    
}

- (void)rightItemAction:(nullable id)sender{
    if (self.rigthItemMethodBlock) {
        self.rigthItemMethodBlock();
    }
}

#pragma mark- KeyBoardNotification

- (void)enableKeyboardNSNotification:(BOOL)isEnable{
    
    if (isEnable) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        
    }
    
}

- (void)keyboardWillShow:(nullable NSNotification *)notification{
    
}

- (void)keyboardWillHide:(nullable NSNotification *)notification{
    
}


#pragma mark- StatusBarConfig

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000 // iOS 7.0 supported
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
#endif


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

- (BOOL)shouldAutorotate{
    return NO;
}


- (BOOL)prefersStatusBarHidden{
    return NO;
}

@end
NS_ASSUME_NONNULL_END