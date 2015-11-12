//
//  LPPressListViewController.m
//  EveryoneNews
//
//  Created by apple on 15/10/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPPressListViewController.h"
#import "CoreDataHelper.h"
#import "Thumbnailer.h"
#import "AppDelegate.h"
#import "Album.h"
#import "LPHttpTool.h"
#import "Press+Timer.h"
#import "Press+HTTP.h"
#import "PressCell.h"
#import "LPCollectToAlbumViewController.h"
#import "AccountTool.h"
#import "SDWebImageManager.h"
#import "PressPhoto.h"
#import "MBProgressHUD+MJ.h"
#import "Content.h"
#import "Zhihu.h"
#import "LPDigDetailViewController.h"
#import "TimerTool.h"

static const CGFloat headerH = 64.0f;

@interface LPPressListViewController () <PressCellDelegate>
@property (nonatomic, strong) UIView *hud;
@end

@implementation LPPressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupHeader];
    [self setupTableView];
    
    [self configureFetch];
    [self performFetch];
    [self configureSearch];
}

#pragma mark - 设置table view和header
- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerH, ScreenWidth, ScreenHeight - headerH)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 12)];
    tableView.tableFooterView = footer;
}

- (void)setupHeader {
    UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, headerH)];
    [self.view addSubview:header];
    header.backgroundColor = [UIColor colorFromHexString:@"2b2b2b"];
    header.clipsToBounds = YES;
    header.userInteractionEnabled = YES;
    [header addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToTop:)]];
    
    UIVisualEffectView *blur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    blur.frame = CGRectMake(0, 0, ScreenWidth, header.height + 44);
    [header addSubview:blur];
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    Album *album = (Album *)[cdh.context existingObjectWithID:self.albumObjID error:nil];
    if (album.thumbnail) {
        UIImage *thumbnail = [UIImage imageWithData:album.thumbnail];
        header.image = thumbnail;
        UIView *blackHUD = [[UIView alloc] initWithFrame:header.bounds];
        blackHUD.backgroundColor = [UIColor blackColor];
        blackHUD.alpha = 0.3;
        [header addSubview:blackHUD];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:header.bounds];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = album.title;
    [header addSubview:label];
    
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"dig新闻返回"] forState:UIControlStateNormal];
    backBtn.x = 10;
    backBtn.width = 10;
    backBtn.height = 18;
    backBtn.y = (headerH - backBtn.height) / 2;
    backBtn.enlargedEdge = 8;
    [header addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *hud = [[UIView alloc] initWithFrame:header.bounds];
    hud.backgroundColor = [UIColor grayColor];
    hud.alpha = 0.5;
    self.hud = hud;
    self.hud.hidden = YES;
    [header addSubview:hud];
}

- (void)tapToTop:(UITapGestureRecognizer *)gr {
    CGPoint loc = [gr locationInView:gr.view];
    if (loc.y < 50) {
        [self.tableView setContentOffset:CGPointMake(0, 44) animated:YES];
    }
}

- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 配置frc
- (void)configureFetch {
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    Album *album = (Album *)[cdh.context existingObjectWithID:self.albumObjID error:nil];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Press"];
    request.fetchBatchSize = 15;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    request.predicate = [NSPredicate predicateWithFormat:@"album.title = %@", album.title];
    
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:cdh.context sectionNameKeyPath:nil cacheName:nil];
    self.frc.delegate  = self;
}

#pragma mark - table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PressCell *cell = [PressCell cellWithTableView:tableView];
    cell.press = [[self frcFromTableView:tableView] objectAtIndexPath:indexPath];
    cell.delegate = self;
    cell.layer.cornerRadius = 2.0;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete && [self frcFromTableView:tableView]) {
        NSFetchedResultsController *frc = [self frcFromTableView:tableView];
        Press *press = [frc objectAtIndexPath:indexPath];
        if (!press.isDownloading.boolValue || press.isDownload.boolValue) {
//            press.contents = nil;
//            press.photo = nil;
//            press.thumbnail = nil;
            [frc.managedObjectContext deleteObject:press];
            CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
            [cdh saveBackgroundContext];
        } else {
            return;
        }
    }
    return;
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return pressCellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Press *press = [[self frcFromTableView:tableView] objectAtIndexPath:indexPath];
    if (press.isDownload.boolValue) {
        Press *press = [[self frcFromTableView:tableView] objectAtIndexPath:indexPath];
        LPDigDetailViewController *detailVc = [[LPDigDetailViewController alloc] init];
        detailVc.pressObjID = press.objectID;
        [self.navigationController pushViewController:detailVc animated:YES];
    } else {
        [MBProgressHUD showError:@"未完成"];
    }
}

#pragma mark - search display delegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    if (!searchString.length) return NO;
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    Album *album = (Album *)[cdh.context existingObjectWithID:self.albumObjID error:nil];
    // fuzzy match
    NSMutableString *fuzzyString = [NSMutableString stringWithFormat:@"*%@*", searchString];
    if (fuzzyString.length > 3) {
        for (int i = 2; i < searchString.length * 2; i += 2) {
            [fuzzyString insertString:@"*" atIndex:i];
        }
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"album.title = %@ && title like[cd] %@", album.title, fuzzyString];
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    [self reloadSearchFRCWithPredicate:predicate entityName:@"Press" sortDescriptors:sortDescriptors inContext:cdh.context];
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.frame = CGRectMake(0, headerH, ScreenWidth, ScreenHeight);
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    self.hud.hidden = NO;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    self.hud.hidden = YES;
}

#pragma mark - life cycle
- (void)viewDidAppear:(BOOL)animated {
    // 如果从collect2AlbumVC进来, 则删除这个vc
    NSMutableArray *vcs = [self.navigationController.viewControllers mutableCopy];
    UIViewController *vc = vcs[self.navigationController.viewControllers.count - 2];
    if ([vc isKindOfClass:[LPCollectToAlbumViewController class]]) {
        [vcs removeObject:vc];
        self.navigationController.viewControllers = vcs;
    }
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    [Thumbnailer createMissingThumnbnailsForEntityName:@"Press" thumbnailAttributeName:@"thumbnail" photoRelationshipName:@"photo" photoAttributeName:@"data" sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]] thumbnailSize:CGSizeMake(pressThumbnailW, pressThumbnailH) inManagedObjectContext:cdh.importContext];
    // 遍历列表, 请求未下载的新闻
    [self downloadMissingPresses];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
        
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    Album *album = (Album *)[cdh.context existingObjectWithID:self.albumObjID error:nil];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Press"];
    request.fetchBatchSize = 15;
    request.predicate = [NSPredicate predicateWithFormat:@"album.title = %@ && isDownloading = %@", album.title, @(YES)];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    NSArray *results = [cdh.context executeFetchRequest:request error:nil];
    if (results.count == 0) return;
    for (Press *press in results) {
        [press cancelRequest];
        press.isDownloading = @(NO);
        [press stopTimer];
    }
    [cdh saveBackgroundContext];
}

#pragma mark - downloading missing presses
- (void)downloadMissingPresses {
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    Album *album = (Album *)[cdh.context existingObjectWithID:self.albumObjID error:nil];
    [cdh.context performBlock:^{
        NSLog(@"thread: %@", [NSThread currentThread]);
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Press"];
        request.fetchBatchSize = 15;
        request.predicate = [NSPredicate predicateWithFormat:@"album.title = %@ && isDownload = %@", album.title, @(NO)];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
        NSArray *results = [cdh.context executeFetchRequest:request error:nil];
        if (results.count == 0)
            return;
        for (Press *press in results) {
                // 关联一个定时器(先杀死当前定时器)
                [press stopTimer];
                press.timer = [TimerTool timerWithCountdown:5];
                [press startTimer];
                NSLog(@"timer setting");
                press.isDownloading = @(YES);
                [self downloadPress:press inAlbum:album withCDH:cdh];
        }
    }];
}

- (void)downloadPress:(Press *)press inAlbum:(Album *)album withCDH:(CoreDataHelper *)cdh {
    if (press.timer == nil) {
        // 关联一个定时器
        press.timer = [TimerTool timerWithCountdown:5];
        [press startTimer];
        NSLog(@"timer resetting");
        press.isDownloading = @(YES);
    }
    if (press.timeover) { // 超时, 设置状态并清空timer
        press.isDownloading = @(NO);
        [press stopTimer];
        NSLog(@"预判超时");
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [AccountTool account].userId;
    params[@"album"] = @"ios";
    params[@"key"] = press.title;
//    press.http = [[LPHttpTool alloc] init];
    __weak typeof(press) wPress = press;
    press.http = [LPHttpTool http];
    [press.http postWithURL:@"http://api.deeporiginalx.com/news/baijia/dredgeUpStatusforiOS" params:params success:^(id json) {
        NSString *status = json[@"status"];
        if (status && status.integerValue == 0) { // 成功
            
            NSIndexPath *ip = [self.frc indexPathForObject:wPress];
            //  0. 清空timer
            [wPress stopTimer];
            //  1. 储存json数据
            NSArray *contents = json[@"content"];
            NSArray *zhihus = json[@"zhihu"];
            //  1.1 content
            NSUInteger index = 0;
            for (NSDictionary *dict in contents) {
                Content *content = [NSEntityDescription insertNewObjectForEntityForName:@"Content" inManagedObjectContext:cdh.context];
                [cdh.context obtainPermanentIDsForObjects:@[content] error:nil];
                content.press = wPress;
                content.paraID = @(index);
                NSString *body = dict[@"text"];
                NSString *photoURL = dict[@"src"];
                if (body.length) {
                    content.isPhotoType = @(NO);
                    content.body = body;
                } else if (photoURL.length) {
                    content.isPhotoType = @(YES);
                    content.photoURL = photoURL;
                }
                index ++;
            }
            //  1.2 zhihu
            index = 0;
            for (NSDictionary *dict in zhihus) {
                Zhihu *zhihu = [NSEntityDescription insertNewObjectForEntityForName:@"Zhihu" inManagedObjectContext:cdh.context];
                [cdh.context obtainPermanentIDsForObjects:@[zhihu] error:nil];
                zhihu.press = wPress;
                zhihu.zhihuID = @(index);
                zhihu.user = dict[@"user"];
                zhihu.title = dict[@"url"];
                zhihu.url = dict[@"title"];
                index ++;
            }
            
            //  2. 处理头图
            NSString *imgUrl = json[@"postImg"];
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imgUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (image && !error && finished) {
                    if (!wPress.photo) {
                        PressPhoto *newPhoto = [NSEntityDescription insertNewObjectForEntityForName:@"PressPhoto" inManagedObjectContext:cdh.context];
                        [cdh.context obtainPermanentIDsForObjects:@[newPhoto] error:nil];
                        wPress.photo = newPhoto;
                        
                    }
                    wPress.photo.data = UIImagePNGRepresentation(image);
                    [Thumbnailer createThumbnailForManagedObject:wPress
                                      withThumbnailAttributeName:@"thumbnail"
                                           photoRelationshipName:@"photo"
                                              photoAttributeName:@"data"
                                                   thumbnailSize:CGSizeMake(pressThumbnailW, pressThumbnailH)
                                          inManagedObjectContext:cdh.context
                    ];
                }
            }];
            //  3. 下载成功更新属性
            wPress.isDownloading = @(NO);
            wPress.isDownload = @(YES);
            //  4. 及时刷新cell
            [self.tableView reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationFade];
//            // 5. 保存上下文
//            [cdh saveBackgroundContext];

            
            NSLog(@"完成!");
        } else {
            if (wPress.timeover) { // 超时, 设置状态并清空timer
                wPress.isDownloading = @(NO);
                [wPress stopTimer];
                NSLog(@"超时!");
            } else { // 未超时
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (wPress) {
                        wPress.isDownloading = @(NO);
                        [wPress stopTimer];
                    }
//                    NSLog(@"重发请求!");
//                    [self downloadPress:press inAlbum:album withCDH:cdh];
                 });
            }
        }
    } failure:^(NSError *error) {
        wPress.isDownloading = @(NO);
        [wPress stopTimer];
    }];
}

#pragma mark - press cell delegate
- (void)pressCell:(PressCell *)pressCell didRefreshPress:(Press *)press {
    if (!press.isDownload.boolValue) {
        CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
        Album *album = (Album *)[cdh.context existingObjectWithID:self.albumObjID error:nil];
        [self downloadPress:press inAlbum:album withCDH:cdh];
    }
}

- (void)dealloc {
    NSLog(@"%@ dealloc!!!", self.class);
}
@end
