//
//  LPHomeViewController.m
//  EveryoneNews
//
//  Created by apple on 15/5/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//
#import "LPNavigationController.h"
#import "LPHomeViewController.h"
#import "LPTabBarController.h"
#import "LPPressFrame.h"
// #import "LPHttpTool.h"
#import "LPPress.h"
#import "MJExtension.h"
#import "LPPressCell.h"
#import "LPPointview.h"
#import "LPDetailViewController.h"
#import "LPDetailViewController.h"
#import "LPCategory.h"
#import "LPPressTool.h"

@interface LPHomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *pressFrames;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSUInteger timeRow;
@property (nonatomic, assign) NSUInteger originDisplayCount;
@property (nonatomic, assign) NSUInteger anyDisplayingCellRow;
@property (nonatomic, assign) BOOL isScrolled;

@end

@implementation LPHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self setupDataWithCategory:[LPCategory categoryWithURL:HomeUrl]];
}

- (void)setupSubviews
{
    self.view.backgroundColor = [UIColor colorFromHexString:@"#EBEDED"];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = self.view.bounds;
    tableView.contentInset = UIEdgeInsetsMake(TabBarHeight, 0, 0, 0);
    tableView.backgroundColor = [UIColor colorFromHexString:@"#EBEDED"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    sharedIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    sharedIndicator.center = self.view.center;
    sharedIndicator.bounds = CGRectMake(0, 0, ScreenWidth / 4, ScreenWidth / 4);
    [self.view addSubview:sharedIndicator];
    
    self.originDisplayCount = 0;
    [noteCenter addObserver:self selector:@selector(changeCategory:) name:LPCategoryDidChangeNotification object:nil];
}

- (NSMutableArray *)pressFrames
{
    if (_pressFrames == nil) {
        _pressFrames = [NSMutableArray array];
    }
    return _pressFrames;
}

- (void)setupDataWithCategory:(LPCategory *)category
{
    self.tableView.hidden = YES;
    // 清空数据
    [self.pressFrames removeAllObjects];
    __weak typeof(self) weakSelf = self;
    [LPPressTool homePressesWithCategory:category success:^(id json) {
        NSLog(@"%@", category.url);
        NSMutableArray *pressFrameArray = [NSMutableArray array];
        // 字典转模型
        for (NSDictionary *dict in (NSArray *)json) {
            LPPress *press = [LPPress objectWithKeyValues:dict];
            if (press.special.intValue != 9) {
                LPPressFrame *pressFrame = [[LPPressFrame alloc] init];
                pressFrame.press = press;
                [pressFrameArray addObject:pressFrame];
            }
        }
        if (pressFrameArray.count == 0) {
            return;
        }
        // 插入时间栏
        int i = 0;
        for (; i < pressFrameArray.count; i++) {
            LPPressFrame *pressFrame = pressFrameArray[i];
            LPPress *press = pressFrame.press;
            if (press.special.integerValue == 400) {
                break;
            }
        }
        if (i == pressFrameArray.count) {
            i = 0;
        }
        weakSelf.timeRow = MAX(i - 1, 0);
        weakSelf.anyDisplayingCellRow = i;
        //        LPPressFrame *pressFrame = [LPPressFrame pressFrameWithTimeCell];
        //        [pressFrameArray insertObject:nil atIndex:self.timeRow];
        // 模型数组属性的赋值
        weakSelf.pressFrames = pressFrameArray;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.timeRow inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        weakSelf.isScrolled = NO;
        [weakSelf performSelector:@selector(homeDisplay) withObject:weakSelf afterDelay:0.5];
    } failure:^(NSError *error) {
        NSLog(@"Failure: %@", error);
    }];
        
}

- (void)homeDisplay
{
    self.tableView.hidden = NO;
}

- (void)changeCategory:(NSNotification *)note
{
    NSDictionary *info = note.userInfo;
    LPCategory *from = info[LPCategoryFrom];
    LPCategory *to = info[LPCategoryTo];
    if (from.ID != to.ID) {
        [self setupDataWithCategory:to];
    }
}

- (void)dealloc
{
    [noteCenter removeObserver:self name:LPCategoryDidChangeNotification object:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.pressFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LPPressCell *cell = [LPPressCell cellWithTableView:tableView];
    cell.pressFrame = self.pressFrames[indexPath.row];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isScrolled == NO) {
        return;
    }
    
    CATransform3D translation;
        
    if (indexPath.row > self.anyDisplayingCellRow) {
        translation = CATransform3DMakeTranslation(0, ScreenHeight, 0);
    } else if (indexPath.row < self.anyDisplayingCellRow) {
        translation = CATransform3DMakeTranslation(0, - ScreenHeight, 0);
    } else {
        return;
    }
    self.anyDisplayingCellRow = indexPath.row;

    cell.layer.transform = translation;
    
    [UIView beginAnimations:@"translation" context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    cell.layer.transform = CATransform3DIdentity;
    
    [UIView commitAnimations];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LPPressFrame *pressFrame = self.pressFrames[indexPath.row];
    return pressFrame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LPPressFrame *pressFrame = self.pressFrames[indexPath.row];
    LPPress *press = pressFrame.press;
    LPDetailViewController *detailVc = [[LPDetailViewController alloc] init];
    detailVc.press = press;
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isScrolled = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.isScrolled = NO;
}


@end
