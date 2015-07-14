//
//  CategoryView.m
//  EveryoneNews
//
//  Created by Feng on 15/7/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CategoryView.h"
#import "LPCategoryButton.h"
#import "LPCategory.h"

@interface CategoryView ()
@property (nonatomic, strong) NSMutableArray *categoryBtns;
@property (nonatomic, weak) LPCategoryButton *selectedBtn;
@property (nonatomic,copy) categoryBtnClick categoryBtnClick;
@end


@implementation CategoryView
- (void)didCategoryBtnClick:(categoryBtnClick)block{
    __weak typeof(self) weakSelf = self;
    weakSelf.categoryBtnClick = block;
}

- (NSMutableArray *)categoryBtns
{
    if (_categoryBtns == nil) {
        _categoryBtns = [NSMutableArray array];
    }
    return _categoryBtns;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self setupCategoryView];
    }
    return self;
}
- (void)setupCategoryView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:scrollView];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
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

- (void)btnClick:(LPCategoryButton *)btn
{
    LPCategory *from = self.selectedBtn.category;
    LPCategory *to = btn.category;
    
    self.selectedBtn.selected = NO;
    btn.selected = YES;
    self.selectedBtn = btn;
    
    __weak typeof(self) weakSelf = self;
    if (weakSelf.categoryBtnClick != nil) {
        weakSelf.categoryBtnClick(from,to);
    }
}
@end
