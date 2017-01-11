//
//  LPMyCollectionViewController.m
//  EveryoneNews
//
//  Created by dongdan on 16/8/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPMyCollectionViewController.h"
#import "LPMyCollectionViewCell.h"
#import "LPMyCollectionCard.h"
#import "CollectionTool.h"
#import "LPMyCollectionCardFrame.h"
#import "LPDetailViewController.h"
#import "LPLoadingView.h"
#import "LPVideoDetailViewController.h"

static NSString *cellIdentifier = @"cellIdentifier";

@interface LPMyCollectionViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *cardFrames;
@property (nonatomic, strong) LPLoadingView *loadingView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *noCollectionTipView;
@property (nonatomic, strong) UIButton *manageButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, assign) BOOL deleteFlag;
@property (nonatomic, strong) NSMutableArray *selectedIndexPaths;

@end

@implementation LPMyCollectionViewController


- (NSMutableArray *)cardFrames {
    if (_cardFrames == nil) {
        _cardFrames = [NSMutableArray array];
    }
    return _cardFrames;
}

- (NSMutableArray *)selectedIndexPaths {
    if (_selectedIndexPaths == nil) {
        _selectedIndexPaths =[NSMutableArray array];
    }
    return _selectedIndexPaths;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorFromHexString:LPColor9];
    // 导航栏
    double topViewHeight = TabBarHeight + StatusBarHeight + 0.5;
    double padding = 15;
    
    double returnButtonWidth = 13;
    double returnButtonHeight = 22;
    
    if (iPhone6Plus) {
        returnButtonWidth = 12;
        returnButtonHeight = 21;
    }
    if (iPhone6) {
        topViewHeight = 72;
    }
    double returnButtonPaddingTop = (topViewHeight - returnButtonHeight + StatusBarHeight) / 2;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, topViewHeight)];
    topView.backgroundColor = [UIColor colorFromHexString:@"#ffffff" alpha:0.0f];
    [self.view addSubview:topView];
    
    // 返回button
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(padding, returnButtonPaddingTop, returnButtonWidth, returnButtonHeight)];
    [backButton setBackgroundImage:[UIImage oddityImage:@"消息中心返回"] forState:UIControlStateNormal];
    backButton.enlargedEdge = 15;
    [backButton addTarget:self action:@selector(topViewBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    titleLabel.text = @"收藏";
    titleLabel.textColor = [UIColor colorFromHexString:LPColor7];
    titleLabel.font = [UIFont  boldSystemFontOfSize:LPFont8];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.centerX = topView.centerX;
    titleLabel.centerY = backButton.centerY;
    [topView addSubview:titleLabel];
    
    
    NSString *manageStr = @"管理";
    CGFloat manageFontSize = 16;
    CGFloat manageButtonW = [manageStr sizeWithFont:[UIFont systemFontOfSize:manageFontSize] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
    CGFloat manageButtonH = [manageStr sizeWithFont:[UIFont systemFontOfSize:manageFontSize] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
    CGFloat manageButtonX = ScreenWidth - manageButtonW - 15;
    
    UIButton *manageButton = [[UIButton alloc] initWithFrame:CGRectMake(manageButtonX, 0, manageButtonW, manageButtonH)];
    [manageButton setTitle:manageStr forState:UIControlStateNormal];
    [manageButton setTitleColor:[UIColor colorFromHexString:LPColor7] forState:UIControlStateNormal];
    [manageButton.titleLabel setFont:[UIFont systemFontOfSize:manageFontSize]];
    [manageButton addTarget:self action:@selector(manageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    manageButton.enlargedEdge = 10;
    self.manageButton = manageButton;
    manageButton.centerY = backButton.centerY;
    [topView addSubview:manageButton];

    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), ScreenWidth , 0.5)];
    seperatorView.backgroundColor = [UIColor colorFromHexString:LPColor10];
    [self.view addSubview:seperatorView];
    
    CGFloat tableViewY = CGRectGetMaxY(seperatorView.frame);
    CGFloat tableViewH = ScreenHeight - tableViewY;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableViewY, ScreenWidth, tableViewH)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[LPMyCollectionViewCell class] forCellReuseIdentifier:cellIdentifier];
    tableView.backgroundColor = [UIColor colorFromHexString:@"#ffffff" alpha:0.0f];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.allowsMultipleSelectionDuringEditing = true;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    // 没有收藏提示信息
    UIView *noCollectionTipView = [[UIView alloc] initWithFrame:CGRectMake(0, topViewHeight + 42, ScreenWidth, 140)];
    CGFloat noCollectionImageViewW = 90;
    CGFloat noCollectionImageViewH = 83;
    CGFloat noCollectionImageViewX = (ScreenWidth - noCollectionImageViewW) / 2;
    CGFloat noCollectionImageViewY = 42;
    UIImageView *noCollectionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(noCollectionImageViewX, noCollectionImageViewY, noCollectionImageViewW, noCollectionImageViewH)];
    noCollectionImageView.image = [UIImage oddityImage:@"wushoucang"];
    
    CGFloat noCollectionLabelX = 0;
    CGFloat noCollectionLabelY = CGRectGetMaxY(noCollectionImageView.frame);
    CGFloat noCollectionLabelW = ScreenWidth;
    CGFloat noCollectionLabelH = 20;
    UILabel *noCollectionLabelFirst = [[UILabel alloc] initWithFrame:CGRectMake(noCollectionLabelX, noCollectionLabelY, noCollectionLabelW, noCollectionLabelH)];
    noCollectionLabelFirst.text = @"暂无收藏内容";
    noCollectionLabelFirst.textColor = [UIColor colorFromHexString:@"#d4d4d4"];
    noCollectionLabelFirst.font = [UIFont systemFontOfSize:17];
    noCollectionLabelFirst.textAlignment = NSTextAlignmentCenter;
    [noCollectionTipView addSubview:noCollectionLabelFirst];
    [noCollectionTipView addSubview:noCollectionImageView];
    noCollectionTipView.hidden = YES;
    [self.tableView insertSubview:noCollectionTipView belowSubview:self.tableView];
    
    self.noCollectionTipView = noCollectionTipView;
 

    LPLoadingView *loadingView = [[LPLoadingView alloc] initWithFrame:CGRectMake(0, StatusBarHeight + TabBarHeight, ScreenWidth, (ScreenHeight - StatusBarHeight - TabBarHeight) / 2.0f)];
    [self.view addSubview:loadingView];
    self.loadingView = loadingView;
    [loadingView startAnimating];
    
    [self setupData];
    
    // 底部删除按钮
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 40)];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    deleteButton.backgroundColor = [UIColor colorFromHexString:LPColor2];
    [deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
     deleteButton.enabled = NO;
     [self.view addSubview:deleteButton];
     self.deleteButton = deleteButton;
}

#pragma mark - 单击管理按钮
- (void)manageButtonClick {
    if (self.deleteFlag == YES) {
        self.deleteFlag = NO;
        [self.manageButton setTitle:@"管理" forState:UIControlStateNormal];
        [self.tableView setEditing:NO animated:YES];
        [UIView animateWithDuration:0.3f animations:^{
            self.deleteButton.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 40);
        }];
    } else {
        self.deleteFlag = YES;
        [self.manageButton setTitle:@"取消" forState:UIControlStateNormal];
        
        [self.tableView setEditing:YES animated:YES];
        
        [UIView animateWithDuration:0.3f animations:^{
            self.deleteButton.frame = CGRectMake(0, ScreenHeight - 40, ScreenWidth, 40);
        }];
    }
}

#pragma mark - 单击删除按钮
- (void)deleteButtonClick {
    if (self.selectedIndexPaths.count > 0) {
        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
        for (NSIndexPath *indexPath in self.selectedIndexPaths ) {
            [indexSet addIndex:indexPath.row];
            LPMyCollectionCardFrame *cardFrame = self.cardFrames[indexPath.row];
            NSString *nid = [NSString stringWithFormat:@"%@",cardFrame.card.nid];
            [CollectionTool deleteCollection:nid deleteFlag:^(NSString *deleteFlag) {
                
            }];
            
        }
        [self.cardFrames removeObjectsAtIndexes:indexSet];
        [self.tableView deleteRowsAtIndexPaths:self.selectedIndexPaths withRowAnimation:UITableViewRowAnimationNone];
    }
    
    if (self.cardFrames.count == 0) {
        self.deleteFlag = NO;
        [self.manageButton setTitle:@"管理" forState:UIControlStateNormal];
        [self.tableView setEditing:NO animated:YES];
        [UIView animateWithDuration:0.3f animations:^{
            self.deleteButton.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 40);
        }];
        [self reloadData];
    }
}

#pragma mark - setup Data 
- (void)setupData {

    [CollectionTool collectionQuerySuccess:^(NSArray *cards) {
        if (cards.count > 0) {
            for (LPMyCollectionCard *card in cards) {
                LPMyCollectionCardFrame *cardFrame = [[LPMyCollectionCardFrame alloc] init];
                cardFrame.card = card;
                [self.cardFrames addObject:cardFrame];
            }
        }
        [self.loadingView stopAnimating];
        [self reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - reloadData
- (void)reloadData {
    if (self.cardFrames.count > 0) {
        self.noCollectionTipView.hidden = YES;
    } else {
        
        self.noCollectionTipView.hidden = NO;
    }
    self.manageButton.enabled = self.cardFrames.count > 0 ? YES : NO;
    [self.tableView reloadData];
}

#pragma mark - 返回
- (void)topViewBackBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cardFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPMyCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LPMyCollectionViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.cardFrame = self.cardFrames[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPMyCollectionCardFrame *cardFrame = self.cardFrames[indexPath.row];
    return cardFrame.cellHeight;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(!tableView.isEditing) {
        LPMyCollectionCardFrame *cardFrame = self.cardFrames[indexPath.row];
        LPMyCollectionCard *card = cardFrame.card;
        // 跳转到视频播放详情页
        if (card.rtype == videoNewsType) {
            
            LPVideoDetailViewController *videoDetailViewController = [[LPVideoDetailViewController alloc] init];
            videoDetailViewController.qidianChannel = YES;
            videoDetailViewController.sourceViewController =  collectionSource;
            videoDetailViewController.myCollectionCardFrame = cardFrame;
            [self.navigationController pushViewController:videoDetailViewController animated:YES];
            
        } else {
            LPDetailViewController *detailViewController = [[LPDetailViewController alloc] init];
            detailViewController.sourceViewController =  collectionSource;
            detailViewController.myCollectionCardFrame = cardFrame;
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
        
        
        
        
    } else {
        if (![self.selectedIndexPaths containsObject:indexPath]) {
            [self.selectedIndexPaths addObject:indexPath];
            self.deleteButton.enabled = YES;
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.selectedIndexPaths containsObject:indexPath]) {
        [self.selectedIndexPaths removeObject:indexPath];
        self.deleteButton.enabled = self.selectedIndexPaths.count > 0 ? YES : NO;
    }
}



@end
