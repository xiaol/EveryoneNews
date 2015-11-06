//
//  LPEditAlbumViewController.m
//  EveryoneNews
//
//  Created by apple on 15/10/28.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPEditAlbumViewController.h"
#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "MBProgressHUD+MJ.h"
#import "Album+Create.h"
#import "Cover.h"
#import "CoverCell.h"
#import "SineLayout.h"
#import "AlbumPhoto.h"
#import "Thumbnailer.h"

static NSString * const CoverCellReuseId = @"editCoverCell";
static const NSInteger totalCoverNums = 8;

NSString * const AlbumDidEditSuccessNotification = @"com.everyonenews.editalbumsuccessfully";

@interface LPEditAlbumViewController () <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) NSMutableArray *covers;
@property (nonatomic, strong) UITextField *titleField;
@property (nonatomic, strong) UITextField *subtitleField;
@property (nonatomic, strong) UICollectionView *coverView;
@property (nonatomic, strong) UIButton *createBtn;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, assign) CGFloat firstOffsetAdjustment;
@property (nonatomic, assign) CGFloat lastOffsetAdjustment;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) BOOL returnFromPicker;
@property (nonatomic, strong) UIButton *changeCoverBtn;
@end

@implementation LPEditAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubviews];
    [noteCenter addObserver:self selector:@selector(textFieldsChangeText) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.returnFromPicker) {
        [self.titleField becomeFirstResponder];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    [cdh saveBackgroundContext];
}

- (void)setupSubviews {
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    Album *album = (Album *)[cdh.context existingObjectWithID:self.albumObjID error:nil];
    
    // 1. setup header
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    [self.view addSubview:headerView];
    headerView.backgroundColor = [UIColor colorFromHexString:@"f6f6f7"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:headerView.bounds];
    titleLabel.text = @"编辑专辑";
    titleLabel.textColor = [UIColor colorFromHexString:@"353535"];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:titleLabel];
    
    UIButton *backBtn = [[UIButton alloc] init];
    [headerView addSubview:backBtn];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"dig返回"] forState:UIControlStateNormal];
    backBtn.x = 10;
    backBtn.y = 13;
    backBtn.width = 10;
    backBtn.height = 18;
    [backBtn setEnlargedEdgeWithTop:8 left:8 bottom:8 right:10];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *createBtn = [[UIButton alloc] init];
    self.createBtn = createBtn;
    [headerView addSubview:createBtn];
    NSString *createText = @"完成";
    [createBtn setTitle:createText forState:UIControlStateNormal];
    UIFont *createFont = [UIFont boldSystemFontOfSize:14];
    createBtn.titleLabel.font = createFont;
    [createBtn setTitleColor:[UIColor colorFromHexString:@"353535"] forState:UIControlStateNormal];
    [createBtn setTitleColor:[UIColor colorFromHexString:@"939393"] forState:UIControlStateDisabled];
    createBtn.enabled = NO;
    createBtn.height = 44;
    createBtn.width = [createText sizeWithFont:createFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    createBtn.x = ScreenWidth - createBtn.width - 10;
    createBtn.y = 0;
    [createBtn setEnlargedEdgeWithTop:8 left:8 bottom:8 right:10];
    [createBtn addTarget:self action:@selector(createBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, 0.5)];
    divider.backgroundColor = [UIColor lightGrayColor];
    divider.alpha = 0.9;
    [self.view addSubview:divider];
    
    // 2. text fields & dividers
    UITextField *titleField = [[UITextField alloc] init];
    titleField.returnKeyType = UIReturnKeyDone;
    titleField.delegate = self;
    UIFont *titleFont = [UIFont systemFontOfSize:14];
    titleField.font = titleFont;
    titleField.placeholder = @"名称 (最多显示7个文字)";
    titleField.text = album.title;
    titleField.x = 20;
    titleField.y = CGRectGetMaxY(divider.frame) + 25;
    titleField.width = ScreenWidth - 40;
    //    titleField.height = [createText heightForLineWithFont:titleFont];
    titleField.height = 25;
    [self.view addSubview:titleField];
    self.titleField = titleField;
    
    UIView *titleDivider = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(titleField.frame) + 5, ScreenWidth - 40, 0.5)];
    titleDivider.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:titleDivider];
    
    UITextField *subtitleField = [[UITextField alloc] init];
    subtitleField.returnKeyType = UIReturnKeyDone;
    subtitleField.delegate = self;
    subtitleField.font = titleFont;
    subtitleField.placeholder = @"描述 (最多显示10个文字)";
    if (album.subtitle.length > 0) {
        subtitleField.text = album.subtitle;
    }
    subtitleField.x = 20;
    subtitleField.y = CGRectGetMaxY(titleDivider.frame) + 20;
    subtitleField.width = ScreenWidth - 40;
    //    subtitleField.height = [createText heightForLineWithFont:subtitleFont];
    subtitleField.height = 25;
    [self.view addSubview:subtitleField];
    self.subtitleField = subtitleField;
    
    UIView *subtitleDivider = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(subtitleField.frame) + 4.5, ScreenWidth - 40, 0.5)];
    subtitleDivider.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:subtitleDivider];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    UIFont *tipFont = [UIFont systemFontOfSize:14];
    NSString *tip = @"选择封面";
    tipLabel.text = tip;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = [UIColor colorFromHexString:@"646464"];
    tipLabel.x = 0;
    tipLabel.y = CGRectGetMaxY(subtitleDivider.frame) + 20;
    tipLabel.width = ScreenWidth;
    tipLabel.height = [tip heightForLineWithFont:tipFont];
    [self.view addSubview:tipLabel];
    
    // 3. album cover collection view
    SineLayout *layout = [[SineLayout alloc] init];
    CGFloat maxWidth = ScreenWidth * 0.45;
    CGFloat maxHeight = maxWidth * 1.3;
    CGFloat spacing = 10;
    self.firstOffsetAdjustment = (maxWidth + spacing) / 2;
    self.lastOffsetAdjustment = (maxWidth + spacing) * (totalCoverNums - 1) - (maxWidth + spacing) / 2;
    layout.itemSize = CGSizeMake(maxWidth, maxHeight);
    self.itemSize = layout.itemSize;
    layout.minimumLineSpacing = spacing;
    layout.sectionInset = UIEdgeInsetsMake(15, (ScreenWidth - maxWidth) / 2, 15, (ScreenWidth - maxWidth) / 2);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tipLabel.frame), ScreenWidth, maxHeight + 30) collectionViewLayout:layout];
    [collectionView registerClass:[CoverCell class] forCellWithReuseIdentifier:CoverCellReuseId];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.allowsMultipleSelection = NO;
    [self.view addSubview:collectionView];
    self.coverView = collectionView;
    
    UIButton *changeCoverBtn = [[UIButton alloc] init];
    [changeCoverBtn setBackgroundImage:[UIImage imageNamed:@"dig换照片"] forState:UIControlStateNormal];
    changeCoverBtn.width = 22;
    changeCoverBtn.height = 21;
    changeCoverBtn.x = (maxWidth + spacing) * totalCoverNums + (ScreenWidth - maxWidth) / 2;
    changeCoverBtn.y = maxHeight + 15 - 22;
    [collectionView addSubview:changeCoverBtn];
    changeCoverBtn.hidden = YES;
    self.changeCoverBtn = changeCoverBtn;
    [changeCoverBtn addTarget:self action:@selector(changeCoverImage) forControlEvents:UIControlEventTouchUpInside];
}

- (NSMutableArray *)covers {
    if (_covers == nil) {
        _covers = [NSMutableArray arrayWithCapacity:totalCoverNums];
        for (NSInteger i = 0; i < totalCoverNums - 1; i++) {
            Cover *cover = [[Cover alloc] init];
            NSString *imageName = [NSString stringWithFormat:@"%ld", i + 2];
            cover.image = [UIImage imageNamed:imageName];
            cover.addSign = NO;
            [_covers addObject:cover];
        }
        Cover *lastCover = [[Cover alloc] init];
        lastCover.image = [UIImage imageNamed:@"dig添加专辑"];
        lastCover.addSign = YES;
        [_covers addObject:lastCover];
    }
    return _covers;
}

#pragma mark - change cover image from picker
- (void)changeCoverImage {
    if (self.selectedIndexPath.row == self.covers.count - 1 && self.titleField.text.length > 0) {
        self.createBtn.enabled = NO;
    }
    [self pickImage];
}

#pragma mark - collection view data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return totalCoverNums;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CoverCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CoverCellReuseId forIndexPath:indexPath];
    cell.cover = self.covers[indexPath.item];
    cell.layer.cornerRadius = 5.0;
    cell.layer.masksToBounds = YES;
    return cell;
}

#pragma mark - collection view delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self limitingTextLength];
    
    self.selectedIndexPath = indexPath;
    
    CGFloat offsetX = (self.itemSize.width + 10) * indexPath.item;
    [collectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
    self.createBtn.enabled = (self.titleField.text.length > 0);
    
    if (indexPath.item == totalCoverNums - 1) {
        Cover *cover = self.covers[indexPath.item];
        if (cover.isAddSign) {
            self.selectedIndexPath = nil;
            self.returnFromPicker = YES;
            self.createBtn.enabled = NO;
            [self pickImage];
        }
    }
}

#pragma mark - pick image
- (void)pickImage {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - image picker controller delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:^{
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        Cover *cover = [self.covers lastObject];
        if (image) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:totalCoverNums - 1 inSection:0];
            cover.image = image;
            //            cover.allowsSelection = YES;
            cover.addSign = NO;
            [self.coverView reloadItemsAtIndexPaths:@[indexPath]];
            self.changeCoverBtn.hidden = NO;
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:totalCoverNums - 1 inSection:0];
        [self.coverView reloadItemsAtIndexPaths:@[indexPath]];
    }];
}


#pragma mark - scroll view delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.coverView) {
        if (!decelerate && scrollView.contentOffset.x < self.firstOffsetAdjustment) {
            [self.coverView setContentOffset:CGPointZero animated:YES];
        } else if (!decelerate && scrollView.contentOffset.x > self.lastOffsetAdjustment) {
            [self.coverView setContentOffset:CGPointMake((self.itemSize.width + 10) * (totalCoverNums - 1) , 0) animated:YES];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.coverView) {
        if (scrollView.contentOffset.x < self.firstOffsetAdjustment) {
            [self.coverView setContentOffset:CGPointZero animated:YES];
        } else if (scrollView.contentOffset.x > self.lastOffsetAdjustment) {
            [self.coverView setContentOffset:CGPointMake((self.itemSize.width + 10) * (totalCoverNums - 1), 0) animated:YES];
        }
    }
}

#pragma mark - pop btn click
- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - text field delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)text {
    //    NSLog(@"textField.text = %@, range = (%ld, %ld), string = %@", textField.text, range.location, range.length, string);
    // 判断键盘情况
    if ([text isEqualToString:@"\n"]) { // 键盘"完成"
        if (self.titleField.text.length && self.subtitleField.text.length) {
            [self.view endEditing:YES];
        } else if (self.titleField.text.length && !self.subtitleField.text.length) {
            [self.subtitleField becomeFirstResponder];
        } else if (!self.titleField.text.length && self.subtitleField.text.length) {
            [self.titleField becomeFirstResponder];
        }
    }
    if (range.length + range.location > textField.text.length) {
        return NO;
    }
    NSUInteger newLength = textField.text.length + text.length - range.length;
    if (textField == self.titleField) {
        return newLength <= 50;
    } else {
        return newLength <= 50;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self limitingTextLength];
}

- (void)limitingTextLength {
    if (self.titleField.text.length > 7) {
        self.titleField.text = [self.titleField.text substringToIndex:7];
    }
    if (self.subtitleField.text.length > 10) {
        self.subtitleField.text = [self.subtitleField.text substringToIndex:10];
    }
}

#pragma mark - create btn click
- (void)createBtnClick {
    [self limitingTextLength];
    
    NSString *title = [[self.titleField.text stringByTrimmingNewline] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; // 不允许有换行, 不允许两端有空格
    NSString *subtitle = [[self.subtitleField.text stringByTrimmingNewline] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    Album *album = (Album *)[cdh.context existingObjectWithID:self.albumObjID error:nil];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Album"];
    request.fetchBatchSize = 15;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title = %@ && title != %@", title, album.title];
    request.predicate = predicate;
    NSArray *results = [cdh.context executeFetchRequest:request error:nil];
    if (!title.length) {
        [MBProgressHUD showError:@"专辑名不能为空!"];
    } else if (results.count > 0) {
        [MBProgressHUD showError:@"专辑同名!"];
    } else {
        album.title = title;
        album.subtitle = subtitle;
        Cover *cover = self.covers[self.selectedIndexPath.item];
        if (self.selectedIndexPath) {
            if (self.selectedIndexPath.item < totalCoverNums - 1) {
                album.thumbnail = UIImagePNGRepresentation(cover.image);
            } else { // 还是最后一张图
                CGFloat albumW = (ScreenWidth - 36) / 3;
                CGFloat albumH = albumW * 1.3;
                [Thumbnailer changeThumbnailForManagedObject:album withThumbnailAttributeName:@"thumbnail" photo:cover.image thumbnailSize:CGSizeMake(albumW, albumH) inManagedObjectContext:cdh.importContext];
            }
        }
        // 发通知?
//        [MBProgressHUD showSuccess:@"修改成功"];
        [noteCenter postNotificationName:AlbumDidEditSuccessNotification object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - text field text did change notification
- (void)textFieldsChangeText {
    self.createBtn.enabled = (self.titleField.text.length > 0);
}

#pragma mark - dealloc
- (void)dealloc {
    [noteCenter removeObserver:self];
}
@end
