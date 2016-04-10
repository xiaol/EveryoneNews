//
//  LPDigViewController.m
//  EveryoneNews
//
//  Created by apple on 15/8/24.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPDigViewController.h"
#import "DigButton.h"
#import "LPTextView.h"
#import "HotwordCloud.h"
#import "LPHttpTool.h"
#import "AlbumCell.h"
#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "Album.h"
#import "LPAddAlbumViewController.h"
#import "Thumbnailer.h"
#import "LPCollectToAlbumViewController.h"
#import "AccountTool.h"
#import "LPPressListViewController.h"
#import "LPEditAlbumViewController.h"
#import "AlbumPhoto.h"
#import "AFNetworking.h"
#import "LPTriangleView.h"

static const CGFloat headerH = 44;
static const CGFloat padding = 10.0;

NSString * const AlbumCellReuseId = @"albumCell";
const NSInteger HotwordPageCapacity = 8;
NSString * const HotwordsURL = @"http://api.deeporiginalx.com/news/baijia/fetchElementary";

@interface LPDigViewController () <UITextViewDelegate, UIScrollViewDelegate, HotwordCloudDelegate>
@property (nonatomic, strong) UIButton *dismissBtn;
@property (nonatomic, strong) UIButton *showBtn;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, assign) BOOL showAlbum;
@property (nonatomic, strong) LPTextView *textView;
//@property (nonatomic, assign) BOOL keyboardShown;
@property (nonatomic, strong) UIView *digView;
@property (nonatomic, strong) UIView *textBgView;
@property (nonatomic, strong) UIView *albumView;
@property (nonatomic, strong) UIImageView *blurBg;
@property (nonatomic, strong) UIView *blurMask;
@property (nonatomic, strong) UIScrollView *albumContainer;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, assign) BOOL wordsChanged;
@property (nonatomic, strong) HotwordCloud *cloud;

//@property (nonatomic, strong) UIButton *pasteboardHint;

@property (nonatomic, strong) LPHttpTool *http;
@property (nonatomic, strong) UIView *blurView;

@end

@implementation LPDigViewController
{
    CGFloat albumW;
    CGFloat albumH;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupDigView];
    
//    [self setupHint];

    [self setupDismissBtn];

//    [self setupAlbumView];
    
    [self setupHeader];
    
    [self configureFetch];
    [self performFetch];

    // 接到专辑创建通知滚到顶端
    [noteCenter addObserver:self selector:@selector(albumCreatedNote) name:AlbumDidCreatedSuccessNotification object:nil];
//    [noteCenter addObserver:self selector:@selector(albumEditNote) name:AlbumDidEditSuccessNotification object:nil];

    // 首次加载的时候
    if (![userDefaults objectForKey:@"isFirstDigger"]) {
        [self setupTipView];
        if (self.pasteString.length > 0) {
            self.blurView.hidden = NO;
        }
    }
    // 如果剪贴板有内容，自动复制到文本框
    if (self.pasteString.length > 0) {
        self.textView.text = self.pasteString;
        self.addBtn.enabled = YES;
        self.blurView.hidden = NO;
    }
    
}

- (void)albumCreatedNote {
//    [self performFetch];
    [self.collectionView setContentOffset:CGPointZero animated:YES];
//    [self performCollectFRCFetch];
}

#pragma mark - 第一次加载提示信息
- (void)setupTipView {
    // 第一次操作时添加提示框
    UIView *blurView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    blurView.backgroundColor = [UIColor blackColor];
    blurView.alpha = 0.85f;
    
    // 添加高亮按钮
    UIButton *blurAddButton = [UIButton buttonWithType:UIButtonTypeCustom];
    blurAddButton.frame = CGRectMake(ScreenWidth - padding - 24, 7, 30, 30);
    blurAddButton.backgroundColor = [UIColor clearColor];
    blurAddButton.enlargedEdge = 8;
    [blurAddButton addTarget:self action:@selector(blurAddButtonClick) forControlEvents:UIControlEventTouchUpInside];
    blurAddButton.layer.shadowColor = [[UIColor whiteColor] CGColor];
    blurAddButton.layer.shadowOpacity = 1;
    blurAddButton.layer.shadowRadius = 15;
    blurAddButton.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:blurAddButton.bounds cornerRadius:15].CGPath;
    blurAddButton.layer.shouldRasterize = YES;
    blurAddButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [blurView addSubview:blurAddButton];
    
    // 添加提示框
    LPTriangleView *triangleView = [[LPTriangleView alloc] initWithFrame:CGRectMake(ScreenWidth - 49, 35, 30, 30)];
    triangleView.backgroundColor = [UIColor clearColor];
    [blurView addSubview:triangleView];
    
    UIView *rectangleView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth - 169, 50, 150, 50)];
    rectangleView.backgroundColor = [UIColor whiteColor];
    rectangleView.layer.cornerRadius = 2;
    
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 150, 20)];
    firstLabel.textAlignment = NSTextAlignmentCenter;
    firstLabel.font = [UIFont systemFontOfSize:13];
    firstLabel.textColor= [UIColor colorFromHexString:@"#2b2b2b"];
    
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:@"点击“+”加入专辑"];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"#0086d1"] range:NSMakeRange(3,1)];
    firstLabel.attributedText = string;
    [rectangleView addSubview:firstLabel];
    
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 150, 20)];
    secondLabel.textAlignment = NSTextAlignmentCenter;
    secondLabel.font = [UIFont systemFontOfSize:13];
    secondLabel.textColor= [UIColor colorFromHexString:@"#2b2b2b"];
    secondLabel.text = @"开始挖掘";
    [rectangleView addSubview:secondLabel];
    
    [blurView addSubview:rectangleView];
    
    [self.view addSubview: blurView];
    self.blurView = blurView;
    
    self.blurView.hidden = YES;
}


//- (void)albumEditNote {
//    [self performCollectFRCFetch];
//}
//#pragma mark - setup past board hint label
//- (void)setupHint {
//    UIButton *hint = [[UIButton alloc] init];
//    hint.frame = CGRectMake(DigButtonPadding, ScreenHeight - DigButtonPadding - DigButtonWidth, 0, DigButtonHeight);
//    self.pasteboardHint = hint;
//    hint.backgroundColor = [UIColor colorFromHexString:@"000000"];
//    [hint setTitle:@"挖掘粘贴板里的链接内容?" forState:UIControlStateNormal];
//    hint.layer.cornerRadius = DigButtonHeight / 2;
//    hint.clipsToBounds = YES;
//    [hint setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    hint.titleLabel.font = [UIFont systemFontOfSize:15];
//    [hint addTarget:self action:@selector(clickHint) forControlEvents:UIControlEventTouchUpInside];
//    hint.alpha = 0.1;
//}

#pragma mark - configure frc
- (void)configureFetch {
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Album"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"albumID" ascending:NO]];
    request.fetchBatchSize = 15;
    
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:cdh.context sectionNameKeyPath:nil cacheName:nil];
    self.frc.delegate = self;
    
//    self.collectFRC = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:cdh.context sectionNameKeyPath:nil cacheName:nil];
}

//- (void)performCollectFRCFetch {
//    [self.collectFRC.managedObjectContext performBlock:^{
//        NSError *error = nil;
//        if (![self.collectFRC performFetch:&error]) {
//            NSLog(@"Failed to perform collect fetch: %@", error);
//        }
//    }];
//}

#pragma mark - setup dig view
- (void)setupDigView {
    UIView *digView = [[UIView alloc] initWithFrame:self.view.bounds];
    digView.backgroundColor = [UIColor colorFromHexString:@"eeeef0"];
    [self.view addSubview:digView];
    self.digView = digView;
    
    // 输入框
    LPTextView *textView = [[LPTextView alloc] init];
    self.textView = textView;
    textView.backgroundColor = [UIColor whiteColor];
    textView.alwaysBounceVertical = YES;
    textView.x = padding;
    textView.y = headerH + 10;
    if (iPhone6Plus) {
        textView.height = 100;
    } else {
        textView.height = 80;
    }
    textView.width = ScreenWidth - 20;
    [digView addSubview:textView];
    textView.layer.cornerRadius = 5;
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:15];
    textView.placehoder = @"输入或粘贴文本/链接";
    
 
//    CAShapeLayer *layer = [CAShapeLayer layer];
//    layer.strokeColor = [UIColor lightGrayColor].CGColor;
//    layer.borderWidth = 0.5;
//    layer.fillColor = nil;
//    layer.path = [UIBezierPath bezierPathWithRoundedRect:textView.bounds cornerRadius:5.0].CGPath;
//    [textView.layer addSublayer:layer];
    
    [noteCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [noteCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 提示label
    UILabel *tipLabel = [[UILabel alloc] init];
    NSString *tipStr = @"提示: 请选择下方的热词或在上方文本框中输入内容以获取您想深度挖掘的新闻内容";
    tipLabel.font = [UIFont systemFontOfSize:13];
    tipLabel.numberOfLines = 0;
    tipLabel.x = padding;
    tipLabel.y = CGRectGetMaxY(textView.frame) + padding;
    tipLabel.width = ScreenWidth - 2 * padding;
    tipLabel.height = [tipStr sizeWithFont:tipLabel.font maxSize:CGSizeMake(tipLabel.width, MAXFLOAT)].height;
    tipLabel.textColor = [UIColor lightGrayColor];
    tipLabel.text = tipStr;
    [digView insertSubview:tipLabel belowSubview:textView];
    self.tipLabel = tipLabel;
    
    UIView *textBg = [[UIView alloc] initWithFrame:self.view.bounds];
    textBg.height = ScreenHeight - DigButtonHeight - DigButtonPadding;
    textBg.backgroundColor = [UIColor clearColor];
    textBg.hidden = YES;
    self.textBgView = textBg;
    [digView insertSubview:textBg belowSubview:textView];
    [textBg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTap:)]];
}

- (void)setupHotwordCloud {
    // 热词view
    HotwordCloud *cloud = [[HotwordCloud alloc] init];
    cloud.x = 0;
    cloud.y = (int)CGRectGetMaxY(self.tipLabel.frame) + 35;
    if (iPhone6Plus) {
        cloud.y = (int)CGRectGetMaxY(self.tipLabel.frame) + 44;
    } else if (iPhone4) {
        cloud.y = (int)CGRectGetMaxY(self.tipLabel.frame) + 20;
    }
    cloud.width = ScreenWidth;
    cloud.height = [HotwordCloud totalHeight];
//    if (self.hotwords.count > 0) {
//        cloud.hotwords = self.hotwords;
//    } else {
//        self.hotwords = nil;
    cloud.delegate = self;
    self.cloud = cloud;
    self.http = [LPHttpTool http];
    __weak typeof(self) wSelf = self;
    [self.http postWithURL:HotwordsURL params:nil success:^(id json) {
            NSArray *jsonArray = (NSArray *)json;
            NSLog(@"success download hotwords!");
            NSInteger majority = [jsonArray count] / HotwordPageCapacity * HotwordPageCapacity;
            NSInteger residual = [jsonArray count] - majority;
            NSInteger count = majority + (residual == 7 ? residual : 0);
            NSMutableArray *tags = [NSMutableArray arrayWithCapacity:count];
            for (int i = 0; i < count; i++) {
                NSDictionary *dict = jsonArray[i];
                NSString *title = dict[@"title"];
                [tags addObject:title];
            }
            wSelf.cloud.hotwords = tags;
            wSelf.wordsChanged = YES;
        } failure:^(NSError *error) {
            NSLog(@"fail to download hotwords!");
    }];
//    }
    [self.digView insertSubview:cloud belowSubview:self.textView];
}

- (void)bgTap:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification *)note {
    self.textBgView.hidden = NO;
}

- (void)keyboardWillHide:(NSNotification *)note {
    self.textBgView.hidden = YES;
}

#pragma mark - setup album view
- (void)setupAlbumView {
    UIView *albumView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.albumView = albumView;
    [self.view insertSubview:albumView belowSubview:self.headerView];
    albumView.hidden = YES;
    
    UIImageView *blurBg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.blurBg = blurBg;
    [albumView addSubview:blurBg];
    
    UIView *blurMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, headerH)];
    self.blurMask = blurMask;
    blurMask.backgroundColor = [UIColor whiteColor];
    blurBg.layer.mask = blurMask.layer;
    
    UIScrollView *albumContainer = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [albumView addSubview:albumContainer];
    albumContainer.contentSize = CGSizeMake(ScreenWidth, ScreenHeight * 2 - headerH);
    self.albumContainer = albumContainer;
    albumContainer.backgroundColor = [UIColor clearColor];
    [albumContainer setContentOffset:CGPointMake(0, ScreenHeight - headerH)];
    albumContainer.delegate = self;
    albumContainer.scrollEnabled = NO;
    
    // collection view
    albumW = (ScreenWidth - 36) / 3;
    albumH = albumW * 1.3;
    CGSize albumSize = CGSizeMake(albumW, albumH);
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = albumSize;
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 8;
    layout.sectionInset = UIEdgeInsetsMake(padding + headerH, padding, padding, padding);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:layout];
    [collectionView registerClass:[AlbumCell class] forCellWithReuseIdentifier:AlbumCellReuseId];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    self.collectionView = collectionView;
    collectionView.backgroundColor = [UIColor clearColor];
    [albumContainer addSubview:collectionView];
}

#pragma mark - setup header view
- (void)setupHeader {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, headerH)];
    headerView.backgroundColor = [UIColor colorFromHexString:@"f6f6f7"];
    self.headerView = headerView;
    [self.view addSubview:headerView];
    headerView.alpha = 0.98;
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:headerView.bounds];
    [headerView addSubview:headerLabel];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.text = @"挖掘机";
    headerLabel.font = [UIFont boldSystemFontOfSize:15];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.textColor = [UIColor colorFromHexString:@"121212"];
    self.headerLabel = headerLabel;
//    self.headerLabel.hidden = YES;
    
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:divider];
    divider.x = 0;
    divider.y = headerH - 0.5;
    divider.width = ScreenWidth;
    divider.height = 0.5;
    
    UIButton *showBtn = [[UIButton alloc] initWithFrame:CGRectMake(padding, 13, 18, 18)];
    showBtn.enlargedEdge = 8;
    showBtn.enabled = NO;
    self.showBtn = showBtn;
    [showBtn addTarget:self action:@selector(showBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [showBtn setBackgroundImage:[UIImage imageNamed:@"dig专辑列表"] forState:UIControlStateNormal];
    [showBtn setBackgroundImage:[UIImage imageNamed:@"dig专辑列表"] forState:UIControlStateDisabled];
    [headerView addSubview:showBtn];
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - padding - 18, 13, 18, 18)];
//    addBtn.backgroundColor = [UIColor redColor];
    addBtn.enlargedEdge = 8;
    self.addBtn = addBtn;
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:addBtn];
    addBtn.enabled = NO;
    [addBtn setBackgroundImage:[UIImage imageNamed:@"dig添加至专辑可点击"] forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"dig添加至专辑灰"] forState:UIControlStateDisabled];
    
}

- (void)blurAddButtonClick {
    self.blurView.hidden = YES;
    [self addBtnClick];
}

#pragma mark - collect into album (push collectVc)
- (void)addBtnClick {
    [self.cloud stopAnimation];
    // 判断是否是第一次加载挖掘机页面
    if (![userDefaults objectForKey:@"isFirstDigger"]) {
        [userDefaults setObject:@"NO" forKey:@"isFirstDigger"];
        [userDefaults synchronize];
    }
    LPCollectToAlbumViewController *collectVc = [[LPCollectToAlbumViewController alloc] init];
    collectVc.digText = self.textView.text;
    collectVc.snapshot = [UIImage captureWithView:self.view];
    collectVc.fromPush = YES;
    
    [self.navigationController pushViewController:collectVc animated:NO];
}

#pragma mark - show albums or not
- (void)showBtnClick {
    [self.cloud stopAnimation];
    self.showAlbum = !self.showAlbum;
    self.showAlbum ? [self albumDown] : [self albumUp];
}

- (void)albumDown {
    if (self.wordsChanged) {
        self.blurBg.image = [self blurWithImageEffects:[UIImage captureWithView:self.digView]];
        self.wordsChanged = NO;
    }
    [self.view endEditing:YES];
    self.albumView.hidden = NO;
    self.addBtn.hidden = YES;
    self.headerLabel.text = @"我的专辑";
    self.showBtn.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.4 animations:^{
        self.showBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
        [self.albumContainer setContentOffset:CGPointMake(0, 0)];
    } completion:^(BOOL finished) {
        self.showBtn.userInteractionEnabled = YES;
    }];
}

- (void)albumUp {
    self.showBtn.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.4 animations:^{
        self.showBtn.transform = CGAffineTransformIdentity;
        [self.albumContainer setContentOffset:CGPointMake(0, ScreenHeight - headerH)];
    } completion:^(BOOL finished) {
        self.showBtn.userInteractionEnabled = YES;
        self.albumView.hidden = YES;
        self.addBtn.hidden = NO;
        self.headerLabel.text = @"挖掘机";
    }];
}

#pragma mark - dissmiss vc
- (void)setupDismissBtn {
    DigButton *dismissBtn = [[DigButton alloc] init];
//    [self.digView addSubview:dismissBtn];
    [self.view addSubview:dismissBtn];
    dismissBtn.x = DigButtonPadding;
    dismissBtn.y = ScreenHeight - DigButtonPadding - DigButtonHeight;
    
    self.view.backgroundColor = [UIColor redColor];
    
    if (iPhone6Plus) {
        dismissBtn.y = ScreenHeight - 2 * DigButtonPadding - DigButtonHeight;
    }

    dismissBtn.width = DigButtonWidth;
    dismissBtn.height = DigButtonHeight;
    dismissBtn.layer.cornerRadius = dismissBtn.width / 2;
    [dismissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    dismissBtn.hidden = YES;
    self.dismissBtn = dismissBtn;
}

- (void)dismiss {
//    [self.cloud stopAnimation];
    if (self.http) {
        [self.http cancelRequest];
        self.http = nil;
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
//        NSLog(@"%ld", CFGetRetainCount((__bridge CFTypeRef) self.navigationController));
//        NSLog(@"%@", [self.navigationController.presentingViewController class]);
//        UIViewController *vc = self.navigationController.presentingViewController;
//        vc.transitioningDelegate = nil;
//        NSLog(@"%ld", CFGetRetainCount((__bridge CFTypeRef) self.frc));
//        NSLog(@"%ld", CFGetRetainCount((__bridge CFTypeRef) self.collectFRC));
//        NSLog(@"%ld", CFGetRetainCount((__bridge CFTypeRef) self.collectionView));
        [self.cloud removeFromSuperview];
        self.cloud = nil;
    }];
}

#pragma mark - text view delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
}

- (void)textViewDidChange:(UITextView *)textView {
    NSString *absoluteStr = [textView.text stringByTrimmingWhitespaceAndNewline];
    self.addBtn.enabled = (absoluteStr.length > 0);
    if (absoluteStr.length > 1 && ![userDefaults objectForKey:@"isFirstDigger"]) {
        self.blurView.hidden = NO;
    }
}

#pragma mark - scroll view delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[LPTextView class]]) {
        [self.view endEditing:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.albumContainer) {
        self.blurMask.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - scrollView.contentOffset.y);
    }
}

#pragma mark - collection view data source
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AlbumCellReuseId forIndexPath:indexPath];
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
        LPAddAlbumViewController *addVc = [[LPAddAlbumViewController alloc] init];
        Album *lastAlbum = [self.frc objectAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        addVc.addID = [NSNumber numberWithInteger:[lastAlbum.albumID integerValue] + 1];
        [self.navigationController pushViewController:addVc animated:YES];
    } else { // 显示专辑内新闻列表
        LPPressListViewController *pressVc = [[LPPressListViewController alloc] init];
        pressVc.albumObjID = album.objectID;
        [self.navigationController pushViewController:pressVc animated:YES];
    }
}

// 以下三个方法配置菜单并响应方法
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIMenuController * menu = [UIMenuController sharedMenuController];
    UIMenuItem *editItem = [[UIMenuItem alloc] initWithTitle:@"编辑" action:@selector(editCell:)];
    UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteCell:)];
    menu.menuItems = @[editItem, deleteItem];
//    AlbumCell *cell = (AlbumCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    [menu setTargetRect:CGRectMake(cell.centerX, cell.centerY, 0, 0) inView:collectionView];
    Album *album = [self.frc objectAtIndexPath:indexPath];
    return (album.albumID.integerValue > 0);
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    return (action == NSSelectorFromString(@"deleteCell:") || action == NSSelectorFromString(@"editCell:"));
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if (action == NSSelectorFromString(@"deleteCell:")) {
        // 根据FRC找出托管对象
        Album *album = [self.frc objectAtIndexPath:indexPath];
        // 删除托管对象
        [self.frc.managedObjectContext deleteObject:album];
        // 保存上下文
        CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
        [cdh saveBackgroundContext];
    } else if (action == NSSelectorFromString(@"editCell:")) {
        // 根据FRC找出托管对象
        Album *album = [self.frc objectAtIndexPath:indexPath];
        LPEditAlbumViewController *editVc = [[LPEditAlbumViewController alloc] init];
        editVc.albumObjID = album.objectID;
        [self.navigationController pushViewController:editVc animated:YES];
    }
}
#pragma mark - hotword cloud delegate
- (void)hotwordCloud:(HotwordCloud *)hotwordCloud didClickTitle:(NSString *)title {
    self.textView.text = title;
    [self textViewDidChange:self.textView];
}

- (void)hotwordCloudDidChangeWords:(HotwordCloud *)hotwordCloud {
    self.wordsChanged = YES;
}
#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.dismissBtn.hidden = NO;

    // Create missing Thumbnails
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
    if (self.isPresented) { // modal完成后, 间隔一段时间再添加专辑子视图, 否则控制器load内容过多, 会延迟modal效果
        
        self.presented = NO; // 标志是否为modal出来, 因为pop也会调用vc的生命周期
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setupHotwordCloud];
            [self setupAlbumView];
            self.blurBg.image = [self blurWithImageEffects:[UIImage captureWithView:self.digView]];
            self.showBtn.enabled = YES;
            
//            [self performCollectFRCFetch];
        });
        
        
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.dismissBtn.hidden = YES;
    [self.view endEditing:YES];
    
//    if (![userDefaults objectForKey:@"isFirstDigger"]) {
//        self.blurView.hidden = YES;
//    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    [cdh saveBackgroundContext];
}

#pragma  mark - image blurring
- (UIImage *)blurWithImageEffects:(UIImage *)image
{
    UIImage *blurImg = [image applyBlurWithRadius:13 tintColor:[UIColor colorWithWhite:1 alpha:0.6] saturationDeltaFactor:1.5 maskImage:nil];
    image = nil;
    return blurImg;
}

- (void)dealloc {
    [noteCenter removeObserver:self];
}

#pragma mark - hint gr
- (void)clickHint {
    NSLog(@"hint!");
}

@end
