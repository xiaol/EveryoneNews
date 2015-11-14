//
//  LPDigDetailViewController.m
//  EveryoneNews
//
//  Created by apple on 15/10/26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPDigDetailViewController.h"
#import "CoreDataHelper.h"
#import "LPWebViewController.h"
#import "AppDelegate.h"
#import "Content.h"
#import "Press.h"
#import "Zhihu.h"
#import "Relate.h"
#import "ContentFrame.h"
#import "ContentCell.h"
#import "Album.h"
#import "SDWebImageManager.h"
#import "ZhihuView.h"
#import "LPPressTool.h"

@interface LPDigDetailViewController () <UITableViewDataSource, UITableViewDelegate, ZhihuViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *contentFrames;
@end

@implementation LPDigDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupTableView];
    [self setupTableHeaderView];
//    [self setupTableFooterView];
    [self setupData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
//    Press *press = (Press *)[cdh.context existingObjectWithID:self.pressObjID error:nil];
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Content"];
//    request.fetchBatchSize = 15;
//    request.predicate = [NSPredicate predicateWithFormat:@"press.title = %@ && isPhotoType = %@", press.title, @(YES)];
//    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"paraID" ascending:YES]];
//    NSArray *contents = [cdh.context executeFetchRequest:request error:nil];
//    if (contents.count == 0) return;
//    for (Content *content in contents) {
//        [[SDWebImageManager sharedManager].imageCache removeImageForKey:content.photoURL fromDisk:NO];
//    }
}

- (NSMutableArray *)contentFrames {
    if (_contentFrames == nil) {
        _contentFrames = [NSMutableArray array];
    }
    return _contentFrames;
}

#pragma mark - 配置table view
- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor clearColor];
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setupTableHeaderView {
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    Press *press = (Press *)[cdh.context existingObjectWithID:self.pressObjID error:nil];
    UIView *header = [[UIView alloc] init];
    
    NSMutableAttributedString *title = [press.title attributedStringWithFont:[UIFont boldSystemFontOfSize:19] color:[UIColor colorFromHexString:@"2b2b2b"] lineSpacing:0];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:titleLabel];
    titleLabel.x = 13;
    titleLabel.y = 30;
    titleLabel.width = ScreenWidth - 26;
    titleLabel.height = [title heightWithConstraintWidth:titleLabel.width] + 1.0;
    titleLabel.numberOfLines = 0;
    titleLabel.attributedText = title;
    
    UILabel *albumLabel = [[UILabel alloc] init];
    Album *album = press.album;
    albumLabel.text = album.title;
    albumLabel.font = [UIFont systemFontOfSize:13];
    albumLabel.textColor = [UIColor grayColor];
    albumLabel.x = 13;
    albumLabel.y = CGRectGetMaxY(titleLabel.frame) + 13;
    albumLabel.size = [albumLabel.text sizeWithFont:albumLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    [header addSubview:albumLabel];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    NSString *date = press.date;
    NSString *time = [NSString stringWithFormat:@"%@-%@ %@:%@", [date substringWithRange:NSMakeRange(4, 2)], [date substringWithRange:NSMakeRange(6, 2)], [date substringWithRange:NSMakeRange(8, 2)], [date substringWithRange:NSMakeRange(10, 2)]];
    timeLabel.text = time;
    timeLabel.font = albumLabel.font;
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.x = CGRectGetMaxX(albumLabel.frame) + 15;
    timeLabel.y = albumLabel.y;
    timeLabel.size = [time sizeWithFont:timeLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    


    [header addSubview:timeLabel];
    
    header.x = 0;
    header.y = 0;
    header.width = ScreenWidth;
    header.height = CGRectGetMaxY(albumLabel.frame) + 20;
    self.tableView.tableHeaderView = header;
}

//- (void)setupTableFooterView {
//    UIView *footer = [[UIView alloc] init];
//    footer.frame = CGRectMake(0, 0, ScreenWidth, 20);
//    self.tableView.tableFooterView = footer;
//}

#pragma mark - 配置frc
- (void)setupData {
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    
    Press *press = (Press *)[cdh.context existingObjectWithID:self.pressObjID error:nil];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Content"];
    request.fetchBatchSize = 15;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"paraID" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"press.title = %@", press.title];
    NSArray *contentArray = [cdh.context executeFetchRequest:request error:nil];
    NSMutableArray *frms = [NSMutableArray array];
    for (Content *content in contentArray) {
        ContentFrame *contentFrame = [[ContentFrame alloc] init];
        contentFrame.content = content;
        [frms addObject:contentFrame];
    }
    self.contentFrames = frms;
    CGFloat footerViewHeight = 20.0;
    UIView *footerView = [[UIView alloc] init];
    // 知乎页面
    ZhihuView *zhihuView = [[ZhihuView alloc] init];
    if(press.zhihus != nil)
    {
        zhihuView.zhihuArray = [press.zhihus allObjects];
        zhihuView.frame = CGRectMake(0, 0, ScreenWidth, [zhihuView heightWithPointsArray:[press.zhihus allObjects]]);
        zhihuView.delegate = self;
        footerViewHeight = footerViewHeight + [zhihuView heightWithPointsArray:[press.zhihus allObjects]];
        [footerView addSubview:zhihuView];
  
    }
    [footerView setFrame:CGRectMake(0, 0,ScreenWidth,footerViewHeight)];
    self.tableView.tableFooterView = footerView;
}

#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContentCell *cell = [ContentCell cellWithTableView:tableView];
    cell.contentFrame = self.contentFrames[indexPath.row];
    return cell;
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContentFrame *contentFrame = self.contentFrames[indexPath.row];
    return contentFrame.cellHeight;
}

- (void)zhihuView:(ZhihuView *)zhihuView didClickURL:(NSString *)url
{
    [LPPressTool loadWebViewWithURL:url viewController:self];
}

@end
