//
//  LPCategoryViewController.m
//  EveryoneNews
//
//  Created by apple on 15/5/26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPCategoryViewController.h"
#import "LPTabBarButton.h"
#import "LPTabBarController.h"
#import "LPTabBar.h"
#import "LPCategoryButton.h"
#import "LPCategory.h"


@interface LPCategoryViewController ()
@property (nonatomic, strong) NSMutableArray *categoryBtns;
@property (nonatomic, weak) LPCategoryButton *selectedBtn;
@end

@implementation LPCategoryViewController

- (NSMutableArray *)categoryBtns
{
    if (_categoryBtns == nil) {
        _categoryBtns = [NSMutableArray array];
    }
    return _categoryBtns;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCategoryView];
    
    [noteCenter addObserver:self selector:@selector(receivePushNotification:) name:LPPushNotificationFromBack object:nil];
}


- (void)setupCategoryView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    NSArray *categoryTitles = @[@"今日", @"时事", @"娱乐", @"科技", @"国际", @"体育", @"财经", @"港台", @"社会"];
    CGFloat categoryW = (ScreenWidth - CategoryBorderLeft - CategoryBorderRight - CategoryBorderColumn) / 2;
    CGFloat categoryH = categoryW / CategoryViewAspectRatio;
 
    for (int i = 0; i < categoryTitles.count; i++) {
        int row = i / 2;
        int col = i % 2;
        CGFloat categoryX = CategoryBorderLeft + col * (categoryW + CategoryBorderColumn);
        CGFloat categoryY = CategoryBorderTop + row * (categoryH + CategoryBorderRow);
        LPCategory *category = [[LPCategory alloc] init];
        LPCategoryButton *categoryBtn = [[LPCategoryButton alloc] init];
        category.ID = i;
        categoryBtn.frame = CGRectMake(categoryX, categoryY, categoryW, categoryH);
        categoryBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        categoryBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        NSString *name = categoryTitles[i];
        if (name && name.length) {
            [categoryBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", name]] forState:UIControlStateNormal];
            [categoryBtn setTitle:name forState:UIControlStateNormal];
            category.title = name;
        }
        if (i == 0) {
            category.url = HomeUrl;
        } else {
            category.url = [NSString stringWithFormat:@"%@/news/baijia/fetchHome?channelId=%d&page=1&limit=50", ServerUrl,i - 1];
        }
        categoryBtn.category = category;
        [categoryBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.categoryBtns addObject:categoryBtn];
        
        [scrollView addSubview:categoryBtn];
        if (i == 0) {
            self.selectedBtn = categoryBtn;
            categoryBtn.selected = YES;
        }
        if (i == categoryTitles.count - 1) {
            CGFloat contentH = categoryY + categoryH + CategoryBorderBottom;
            scrollView.contentSize = CGSizeMake(0, contentH);
        }
    }
}

//- (void)btnClick:(LPCategoryButton *)btn
//{
//    LPCategory *from = self.selectedBtn.category;
//    LPCategory *to = btn.category;
//    if ([self.delegate respondsToSelector:@selector(categoryViewController:didSelectCategoryFrom:to:)]) {
//        [self.delegate categoryViewController:self didSelectCategoryFrom:from to:to];
//    }
//    
//    self.selectedBtn.selected = NO;
//    btn.selected = YES;
//    self.selectedBtn = btn;
//}

- (void)btnClick:(LPCategoryButton *)btn
{
    LPCategory *from = self.selectedBtn.category;
    LPCategory *to = btn.category;
    
    self.selectedBtn.selected = NO;
    btn.selected = YES;
    self.selectedBtn = btn;

    // 发布通知
    NSDictionary *info = @{LPCategoryFrom:from, LPCategoryTo:to};
    [noteCenter postNotificationName:LPCategoryDidChangeNotification object:self userInfo:info];
}

# pragma mark - notification selector
- (void)receivePushNotification:(NSNotification *)note
{
    for (LPCategoryButton *btn in self.categoryBtns) {
        if ([btn.category.title isEqualToString:@"今日"]) {
            NSLog(@"LPCategoryVC receivePushNotification");
            self.selectedBtn.selected = NO;
            btn.selected = YES;
            self.selectedBtn = btn;
            break;
        }
    }
}

- (void)dealloc
{
    [noteCenter removeObserver:self name:LPPushNotificationFromBack object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
