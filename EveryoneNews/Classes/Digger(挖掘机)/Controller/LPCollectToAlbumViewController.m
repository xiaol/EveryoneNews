//
//  LPCollectToAlbumViewController.m
//  EveryoneNews
//
//  Created by apple on 15/10/13.
//  Copyright (c) 2015年 apple. All rights reserved.
//  1. 监听滚动 5. 添加专辑

#import "LPCollectToAlbumViewController.h"
#import "MainNavigationController.h"
#import "AppDelegate.h"
#import "CollectCell.h"
#import "SectionColorLayout.h"
#import "Album.h"
#import "LPAddAlbumViewController.h"
#import "Thumbnailer.h"
#import "LPPressListViewController.h"
#import "Press+Create.h"
#import "MBProgressHUD+MJ.h"
#import "AccountTool.h"

static const CGFloat padding = 10.0;
static NSString * CollectAlbumCellReuseId = @"collectAlbumCell";

@interface LPCollectToAlbumViewController () <UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIView *hud;
//@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, assign) BOOL didAppear;
@property (nonatomic, strong) UIView *header;
@end

@implementation LPCollectToAlbumViewController
{
//    CGFloat albumW;
//    CGFloat albumH;
    CGFloat exposureH;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorFromHexString:@"222222"];
    [self setupBgView];

    [noteCenter addObserver:self selector:@selector(albumDidCreatedNote) name:AlbumDidCreatedSuccessNotification object:nil];
//  把configureFRC以及performFetch的工作预先放在digVC中
//    self.frc.delegate = self;
//    [self.collectionView reloadData];
    [self configureFetch];
    [self performFetch];
}

- (void)configureFetch {
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Album"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"albumID" ascending:NO]];
    request.fetchBatchSize = 15;
        
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:cdh.context sectionNameKeyPath:nil cacheName:nil];
    self.frc.delegate = self;
}

- (void)albumDidCreatedNote {
    [self performFetch];
    if (self.collectionView.contentOffset.y > ScreenHeight - exposureH - 44) {
        [self.collectionView setContentOffset:CGPointMake(0, ScreenHeight - exposureH - 44)];
    }
}

#pragma mark - setup background view
- (void)setupBgView {
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgView.image = self.snapshot;
    [self.view addSubview:bgView];
//    [self.view insertSubview:bgView belowSubview:self.collectionView];
    [self.view addSubview:bgView];
    self.bgView = bgView;
        
    UIView *hud = [[UIView alloc] initWithFrame:self.bgView.bounds];
    hud.backgroundColor = [UIColor blackColor];
    hud.alpha = 0.0;
    [bgView addSubview:hud];
    self.hud = hud;
}

#pragma mark - setup collection view
- (void)setupCollectionView {
    
    SectionColorLayout *layout = [[SectionColorLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:layout];
    [collectionView registerClass:[CollectCell class] forCellWithReuseIdentifier:CollectAlbumCellReuseId];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    self.collectionView = collectionView;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:collectionView];
    [collectionView setContentOffset:CGPointMake(0, - layout.exposureH - 44)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCollectionView:)];
    tap.delegate = self;
    [collectionView addGestureRecognizer:tap];
    
    exposureH = layout.exposureH;
}

- (void)tapCollectionView:(UITapGestureRecognizer *)recognizer {
    [self cancelBtnClick];
}

- (void)setupHeader {
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UIColor colorFromHexString:@"f6f6f7"];
    header.x = 0;
    header.y = ScreenHeight - exposureH - 44;
    header.height = 44;
    header.width = ScreenWidth;
    [self.collectionView addSubview:header];
    self.header = header;
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.frame = header.bounds;
    titleLabel.text = @"添加至";
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor whiteColor];
    [header addSubview:titleLabel];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    cancelBtn.x = padding;
    cancelBtn.y = 15;
    cancelBtn.width = 14;
    cancelBtn.height = 14;
    cancelBtn.enlargedEdge = 6;
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"dig叉号"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:cancelBtn];
    
//    UIButton *confirmBtn = [[UIButton alloc] init];
//    confirmBtn.x = ScreenWidth - padding - 23;
//    confirmBtn.y = 15;
//    confirmBtn.width = 23;
//    confirmBtn.height = 14;
//    confirmBtn.enlargedEdge = 6;
//    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"dig加入专辑对号"] forState:UIControlStateNormal];
//    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"dig加入专辑对号灰色"] forState:UIControlStateDisabled];
//    confirmBtn.enabled = NO;
//    self.confirmBtn = confirmBtn;
//    [header addSubview:confirmBtn];
    
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, ScreenWidth, 0.5)];
    divider.backgroundColor = [UIColor lightGrayColor];
    [header addSubview:divider];
}


#pragma mark - collection view data source
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectAlbumCellReuseId forIndexPath:indexPath];
    Album *album = [self.frc objectAtIndexPath:indexPath];
    cell.album = album;
    cell.layer.cornerRadius = 5.0;
    cell.layer.masksToBounds = YES;
    return cell;
}

#pragma mark - collection view delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Album *album = [self.frc objectAtIndexPath:indexPath];
    if (album.albumID.integerValue == 0) { // 新建专辑
        LPAddAlbumViewController *addVC = [[LPAddAlbumViewController alloc] init];
//        addVC.addID = [NSNumber numberWithInteger:[self.collectionView numberOfItemsInSection:0]];
        Album *lastAlbum = [self.frc objectAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        addVC.addID = [NSNumber numberWithInteger:[lastAlbum.albumID integerValue] + 1];
        [self.navigationController pushViewController:addVC animated:YES];
    } else { // 进入新闻列表, 并添加要挖掘的新闻
        LPPressListViewController *pressVc = [[LPPressListViewController alloc] init];
        // 0. 排重
        NSString *digKey = [self.digText stringByTrimmingWhitespaceAndNewline];
        CoreDataHelper *cdh =
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Press"];
        request.fetchBatchSize = 15;
        request.predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"title", digKey];
        NSArray *results = [cdh.context executeFetchRequest:request error:nil];
        if (results.count) { // 有重复
            [MBProgressHUD showError:@"重复挖掘的内容"];
        } else { // 加入专辑
            // 0. 查看账号
            Account *account = [AccountTool account];
            if (!account) {
                __weak typeof(self) wSelf = self;
                [AccountTool accountLoginWithViewController:wSelf success:^(Account *account){
                    [MBProgressHUD showSuccess:@"登录成功"];
                    [wSelf pushPressListVC:pressVc withAlbum:album digKey:digKey managedObjectContext:cdh.context];
                } failure:^{
                    [MBProgressHUD showError:@"登录失败!"];
                } cancel:nil];
            } else {
                [self pushPressListVC:pressVc withAlbum:album digKey:digKey managedObjectContext:cdh.context];
            }
        }
    }
}

- (void)pushPressListVC:(LPPressListViewController *)pressVc withAlbum:(Album *)album digKey:(NSString *)digKey managedObjectContext:(NSManagedObjectContext *)context {
    self.collectionView.userInteractionEnabled = NO;
    // 1. 传入专辑
    pressVc.albumObjID = album.objectID;
    // 2. 新建press
    [Press pressWithTitle:digKey date:[NSString absoluteStringFromNowDate] albumObjID:album.objectID inManagedObjectContext:context];
    // 3. push新闻列表页
    [self.navigationController pushViewController:pressVc animated:YES];
}

#pragma mark - flow layout delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    SectionColorLayout *layout = (SectionColorLayout *)collectionView.collectionViewLayout;
    return CGSizeMake(ScreenWidth, ScreenHeight - layout.exposureH);
}

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.didAppear) return;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        CGFloat newExposureH = exposureH + 44 + offsetY;
        CGFloat bgH = ScreenHeight - newExposureH - 40;
        CGFloat bgW = bgH * ScreenWidth / ScreenHeight;
        CGFloat bgX = (ScreenWidth - bgW) / 2;
        self.bgView.frame = CGRectMake(bgX, 20, bgW, bgH);
        self.hud.frame = self.bgView.bounds;
    } else if (offsetY > 0) {
        CGFloat newAlpha = MIN(offsetY / (ScreenHeight - exposureH - 44), 0.8);
        self.hud.alpha = newAlpha;
        if (offsetY > ScreenHeight - exposureH - 44) {
            self.header.y = offsetY;
        } else {
            self.header.y = ScreenHeight - exposureH - 44;
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y < - 44) {
        self.didAppear = NO;
        [self cancelBtnClick];
    }
}

#pragma mark - cancel button clicked
- (void)cancelBtnClick {
    [self.header removeFromSuperview];
    self.collectionView.hidden = YES;
    [UIView animateWithDuration:0.1 animations:^{
        self.bgView.frame = self.view.bounds;
        self.hud.frame = self.bgView.bounds;
        self.hud.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.navigationController popViewControllerAnimated:NO];
    }];
}

#pragma mark - gesture recognizer delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    UICollectionView *collectionView = (UICollectionView *)gestureRecognizer.view;
    CGPoint loc = [gestureRecognizer locationInView:collectionView];
    if (collectionView != self.collectionView) return NO;
    return loc.y < (ScreenHeight - exposureH - 44); // 只有点击collectionview的header时手势有效
}

#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    MainNavigationController *nav = (MainNavigationController *)self.navigationController;
    nav.popRecognizer.enabled = NO;
    if (self.fromPush) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setupCollectionView];
            [self setupHeader];
            [UIView animateWithDuration:0.12 animations:^{
                CGFloat y = 20;
                CGFloat h = ScreenHeight - 40 - exposureH - 44;
                CGFloat w = ScreenWidth * h / ScreenHeight;
                CGFloat x = (ScreenWidth - w) / 2;
                [self.bgView setFrame:CGRectMake(x, y, w, h)];
                self.hud.frame = self.bgView.bounds;
                [self.collectionView setContentOffset:CGPointZero];
            } completion:^(BOOL finished) {
                self.didAppear = YES;
                
            }];
        });
        self.fromPush = NO;
    } else {
        // Create missing Thumbnails
        CGFloat albumW = (ScreenWidth - 36) / 3;
        CGFloat albumH = albumW * 1.3;
        CoreDataHelper *cdh =
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
        NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"albumID" ascending:NO]];
        [Thumbnailer createMissingThumnbnailsForEntityName:@"Album"
                                    thumbnailAttributeName:@"thumbnail"
                                     photoRelationshipName:@"photo"
                                        photoAttributeName:@"data"
                                           sortDescriptors:sortDescriptors
                                             thumbnailSize:CGSizeMake(albumW, albumH)
                                    inManagedObjectContext:cdh.importContext];

    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    MainNavigationController *nav = (MainNavigationController *)self.navigationController;
    nav.popRecognizer.enabled = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    [cdh saveBackgroundContext];
}

- (void)dealloc {
    [noteCenter removeObserver:self];
}
@end
