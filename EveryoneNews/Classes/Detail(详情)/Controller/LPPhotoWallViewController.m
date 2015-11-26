//
//  LPPhotoWallViewController.m
//  EveryoneNews
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPPhotoWallViewController.h"
#import "LPFullPhotoCell.h"
#import "LPPhoto.h"

NSString * const FullPhotoCellReuseId = @"fullPhotoCell";

@interface LPPhotoWallViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UITextView *noteView;

@end

@implementation LPPhotoWallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
    [self setupSubviews];
}


- (void)setupSubviews {
    // 0. label & text view
    UILabel *indexLabel = [[UILabel alloc] init];
    indexLabel.numberOfLines = 0;
    indexLabel.textAlignment = NSTextAlignmentRight;
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:indexLabel];
    self.indexLabel = indexLabel;
    
    UITextView *noteView = [[UITextView alloc] init];
    noteView.editable = NO;
    noteView.textColor = [UIColor whiteColor];
    noteView.font = [UIFont systemFontOfSize:15];
    noteView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:noteView];
    self.noteView = noteView;

    self.indexLabel.text = [NSString stringWithFormat:@"%d/%d", self.originIndexPath.item + 1, self.photos.count];
    self.indexLabel.width = ScreenWidth - DetailCellPadding;
    self.indexLabel.x = 0;
    self.indexLabel.height = 34;
    self.indexLabel.y = DetailCellPadding * 2;
    
    LPPhoto *photo = self.photos[self.originIndexPath.item];
    self.noteView.text = photo.note;
    self.noteView.x = DetailCellPadding;
    self.noteView.height = ScreenHeight / 7;
    self.noteView.width = ScreenWidth - 2 * DetailCellPadding;
    self.noteView.y = ScreenHeight - DetailCellPadding - self.noteView.height;
    noteView.showsVerticalScrollIndicator = YES;
    
    // 1. collection view

    CGFloat y = 34 + 3 * DetailCellPadding;
    CGFloat h = self.noteView.y - y - 20;

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(ScreenWidth, h);
    layout.minimumLineSpacing = PhotoGutter;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, PhotoGutter);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, y, ScreenWidth + PhotoGutter, h) collectionViewLayout:layout];
    [collectionView registerClass:[LPFullPhotoCell class] forCellWithReuseIdentifier:FullPhotoCellReuseId];
    collectionView.backgroundColor = [UIColor blackColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
    [collectionView scrollToItemAtIndexPath:self.originIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    // 2. pop btn
    UIButton *popBtn = [[UIButton alloc] initWithFrame:CGRectMake(DetailCellPadding, DetailCellPadding * 2, 34, 34)];
    popBtn.enlargedEdge = 5;
    [popBtn setImage:[UIImage resizedImageWithName:@"back"] forState:UIControlStateNormal];
    popBtn.backgroundColor = [UIColor clearColor];
    popBtn.alpha = 0.8;
    [popBtn addTarget:self action:@selector(popBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popBtn];
}

- (void)popBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - collection view datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LPFullPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FullPhotoCellReuseId forIndexPath:indexPath];
    cell.photo = self.photos[indexPath.item];
    return cell;
}

#pragma mark - scroll view delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self setTextWithScrollView:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self setTextWithScrollView:scrollView];
}

- (void)setTextWithScrollView:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:[UICollectionView class]]) {
        return;
    }
    if (scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > (self.photos.count - 1) * (ScreenWidth + PhotoGutter)) {
        return;
    }
    NSInteger currentPage = scrollView.contentOffset.x / (ScreenWidth + PhotoGutter) + 0.5;
    LPPhoto *photo = self.photos[currentPage];
    self.indexLabel.text = [NSString stringWithFormat:@"%ld/%ld", currentPage + 1, self.photos.count];
    self.noteView.text = photo.note;
}

@end
