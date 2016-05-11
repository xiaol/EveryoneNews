//
//  LPFeaturedViewController.m
//  EveryoneNews
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPFeaturedViewController.h"
#import "LPFeaturedCell.h"
#import "LPFeature.h"
#import "LPPress.h"
#import "Account.h"
#import "AccountTool.h"
#import "LPHttpTool.h"
#import "LPZhihuPoint.h"
#import "MJExtension.h"
#import "LPComment.h"
#import "LPContent.h"
#import "LPContentFrame.h"
#import "LPFeatureFrame.h"
#import "LPContentCell.h"
#import "MBProgressHUD+MJ.h"
#import "LPZhihuView.h"
#import "LPFeatureView.h"

NSString * const FeaturedCellReuseIdentifier = @"featuredCell";

@interface LPFeaturedViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *featureFrames;
@property (nonatomic, assign) BOOL hasReturn;
@property (nonatomic, assign) NSInteger tmpIndex;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@end

@implementation LPFeaturedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.isBuiltInPop = YES;
    [self setupCollectionView];
    [self setupIndicatorView];
    [self setupDataWithCompletion:nil];
}

#pragma mark - lazy loading
- (NSMutableArray *)featureFrames {
    if (_featureFrames == nil) {
        _featureFrames = [NSMutableArray array];
    }
    return _featureFrames;
}

#pragma mark - setup subviews
- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(ScreenWidth, ScreenHeight); // ?
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [collectionView registerClass:[LPFeaturedCell class] forCellWithReuseIdentifier:FeaturedCellReuseIdentifier];
    collectionView.backgroundColor = [UIColor colorFromHexString:TableViewBackColor];
    collectionView.userInteractionEnabled = NO;
    collectionView.pagingEnabled = YES;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}

- (void)setupIndicatorView {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = self.view.center;
    indicator.color = [UIColor lightGrayColor];
    [self.view addSubview:indicator];
    self.indicator = indicator;
}

#pragma mark - setup data
- (void)setupDataWithCompletion:(returnCotentsBlock)block {
    [self.indicator startAnimating];
    
    [self.featureFrames removeAllObjects];
    
    __weak typeof(self) wself = self;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    Account *account = [AccountTool account];
    if (account) {
        params[@"userId"] = account.userId;
        params[@"platformType"] = account.platformType;
    }
    NSString *url = [NSString stringWithFormat:@"%@%@", ServerUrl, @"/news/baijia/newsFetchContentList"];
//    NSLog(@"%@", url);
    NSMutableString *urls = [NSMutableString stringWithString:@""];
    NSInteger count = self.presses.count;
    for (int i = 0; i < count; i++) {
        LPPress *press = self.presses[i];
        [urls appendString:[NSString stringWithFormat:@"%@,", press.sourceUrl]];
    }

    params[@"url"] = [urls stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
    NSLog(@"%@", params[@"url"]);
    params[@"type"] = @"0";
    params[@"deviceType"] = @"IOS";
    [LPHttpTool postWithURL:url params:params success:^(id jsonArray) {
        NSArray *jsons = (NSArray *)jsonArray;
        NSLog(@"jsons.count = %ld", jsons.count);
        for (int i = 0; i < 20; i++) {
            NSLog(@"i = %d", i);
            NSDictionary *json = (NSDictionary *)jsons[i];
            LPFeatureFrame *featureFrame = [[LPFeatureFrame alloc] init];
            LPPress *press = self.presses[i];
            LPFeature *feature = [[LPFeature alloc] init];
            feature.headerImg = json[@"imgUrl"];
            feature.title = json[@"title"];
            NSLog(@"%d title : %@", i, feature.title);
            if (json[@"zhihu"] == [NSNull null] || !json[@"zhihu"]) {
                feature.zhihuPoints = @[];
            } else {
                feature.zhihuPoints = [LPZhihuPoint objectArrayWithKeyValuesArray:json[@"zhihu"]];
            }
            feature.color = [UIColor colorFromCategory:json[@"category"]];
            
            NSString *abstract = json[@"abs"];

            if ([abstract isBlank]) {
                abstract = @"摘要";
            }
            NSString *rawBody = json[@"content"];
            NSLog(@"content --- %@", rawBody);
            NSArray *rawBodies = [rawBody componentsSeparatedByString:@"\n"];
            NSMutableArray *bodies = [NSMutableArray arrayWithArray:@[abstract]];
            for (NSString *str in rawBodies) {
                if (![str isBlank]) {
                    [bodies addObject:str];
                }
            }
            NSArray *totalComments = [LPComment objectArrayWithKeyValuesArray:json[@"point"]];

            NSMutableArray *contents = [NSMutableArray array];
            NSMutableArray *contentFrames = [NSMutableArray array];
            for (int k = 0; k < bodies.count; k++) {
                LPContent *content = [[LPContent alloc] init];
                content.paragraphIndex = k;
                content.body = bodies[k];
                content.category = press.category;
                content.color = [UIColor colorFromCategory:content.category];
                NSMutableArray *comments = [NSMutableArray array];
                if (k == 0) {
                    content.isAbstract = YES;
                } else {
                    content.isAbstract = NO;
                }
                if (!press.isCommentsFlag || content.isAbstract || totalComments.count == 0) {
                    content.hasComment = NO;
                } else {
                    for (LPComment *comment in totalComments) {
                        if (comment.paragraphIndex.intValue == k - 1 && [comment.type isEqualToString:@"text_paragraph"]) {
                            [comments addObject:comment];
                            comment.color = content.color;
                        }
                    }
                    content.hasComment = (comments.count > 0);
                    content.comments = comments;
                }
                LPContentFrame *contentFrame = [[LPContentFrame alloc] init];
                contentFrame.content = content;
                [contentFrames addObject:contentFrame];
                [contents addObject:content];
            }
            
//            NSDictionary *relateOpinion = json[@"relate_opinion"];
//            NSArray *opinions = relateOpinion[@"self_opinion"];
//            for (NSDictionary *dict in opinions) {
//                LPContent *content = [[LPContent alloc] init];
//                content.isOpinion = YES;
//                content.url = dict[@"url"];
//                content.body = dict[@"self_opinion"];
//                NSLog(@"%@", content.body);
//                LPContentFrame *frm = [[LPContentFrame alloc] init];
//                frm.content = content;
//                [contentFrames addObject:frm];
//                [contents addObject:content];
//            }

            feature.contents = contents;
            featureFrame.contentFrames = contentFrames;
            featureFrame.feature = feature;
            [self.featureFrames addObject:featureFrame];
        }
        wself.collectionView.backgroundColor = [UIColor blackColor];
        [wself.collectionView reloadData];
        wself.collectionView.userInteractionEnabled = YES;
        [self.indicator stopAnimating];
    } failure:^(NSError *error) {
        NSLog(@"error!!!");
    }];
}

#pragma mark - Collection view data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.featureFrames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LPFeaturedCell *cell = (LPFeaturedCell *)[collectionView dequeueReusableCellWithReuseIdentifier:FeaturedCellReuseIdentifier forIndexPath:indexPath];
    cell.featureFrame = self.featureFrames[indexPath.row];
    return cell;

}

#pragma mark - Collection view delegate
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    LPFeaturedCell *featuredCell = (LPFeaturedCell *)cell;
    [featuredCell.featureView setContentOffset:CGPointMake(0, 0) animated:NO];
}



#pragma mark - Scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[LPFeatureView class]]) {
//        LPFeaturedCell *cell = [[self.collectionView visibleCells] firstObject];
        LPFeatureView *featureView = (LPFeatureView *)scrollView;
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY < 0) { // 内切时，放大头部imageView及其颜色蒙版
            CGFloat scale = - offsetY / TableHeaderViewH + 1;
            CGFloat w = ScreenWidth * scale;
            CGFloat offsetX = (w - ScreenWidth) / 2;
            
            featureView.headerImageView.frame = CGRectMake(- offsetX, offsetY, w, TableHeaderImageViewH -  offsetY);
            featureView.filterView.frame = featureView.headerImageView.bounds;
            featureView.headerImageView.layer.mask = nil;
        } else { // 向上拖动时，控制视差并添加遮盖
            if (offsetY < TableHeaderViewH) {
                CGFloat diff = 0.5 * offsetY;
                UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, ScreenWidth, TableHeaderImageViewH - diff)];
                featureView.maskLayer.path = path.CGPath;
                featureView.headerImageView.layer.mask = featureView.maskLayer;
                featureView.headerImageView.frame = CGRectMake(0, diff, ScreenWidth, TableHeaderImageViewH);
                featureView.filterView.frame = featureView.headerImageView.bounds;
            }
        }

    }
}

//#pragma mark - Table view data source
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSMutableArray *contentFrames = self.tmpFeatureFrame.contentFrames;
//    return contentFrames.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSMutableArray *contentFrames = self.tmpFeatureFrame.contentFrames;
//    LPContentCell *cell = [LPContentCell cellWithTableView:tableView identifier:self.tmpIndex];
//    cell.contentFrame = contentFrames[indexPath.row];
//    cell.layer.shadowOpacity = 0.24f;
//    cell.layer.shadowRadius = 3.0;
//    cell.layer.shadowOffset = CGSizeMake(0, 0);
//    cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//    cell.layer.zPosition = 999.0;
//    return cell;
//    
//}
//
//#pragma mark - Table view delegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSMutableArray *contentFrames = self.tmpFeatureFrame.contentFrames;
//    LPContentFrame *contentFrame = contentFrames[indexPath.row];
//    return contentFrame.cellHeight;
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
