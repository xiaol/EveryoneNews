//
//  LPFullPhotoViewController.m
//  EveryoneNews
//
//  Created by dongdan on 15/11/26.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPFullPhotoViewController.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+MJ.h"

@interface LPFullPhotoViewController ()<UIActionSheetDelegate>

@property (nonatomic, strong) UIImageView *photoView;

@end

@implementation LPFullPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor blackColor];
    [self setupSubViews];
}

- (void)setupSubViews {
    // 2. pop btn
    UIButton *popBtn = [[UIButton alloc] initWithFrame:CGRectMake(DetailCellPadding, DetailCellPadding * 2, 34, 34)];
    popBtn.enlargedEdge = 5;
    [popBtn setImage:[UIImage resizedImageWithName:@"back"] forState:UIControlStateNormal];
    popBtn.backgroundColor = [UIColor clearColor];
    popBtn.alpha = 0.8;
    [popBtn addTarget:self action:@selector(popBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popBtn];
    
    UIImageView *photoView = [[UIImageView alloc] init];
    photoView.clipsToBounds = YES;
    photoView.layer.cornerRadius = 4.0;
    photoView.contentMode = UIViewContentModeScaleAspectFill;
    CGFloat photoX = DetailCellPadding;
    CGFloat photoY = 0;
    CGFloat photoW = DetailCellWidth;
    CGFloat photoH = photoW * 9 / 11;
    photoView.frame = CGRectMake(photoX, photoY, photoW, photoH);
    photoView.centerY = self.view.centerY;
    [photoView sd_setImageWithURL:self.imageURL placeholderImage:[UIImage imageNamed:@"详情占位图"]];
    photoView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer * longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesturePressed:)];
    [photoView addGestureRecognizer:longGesture];
    
    self.photoView = photoView;
    
    [self.view addSubview:photoView];
}

- (void)popBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)longGesturePressed:(UILongPressGestureRecognizer *)recognier {
    if(recognier.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存到手机" otherButtonTitles:nil, nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet showInView:self.view];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        UIImageWriteToSavedPhotosAlbum(self.photoView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }
    
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        [MBProgressHUD showSuccess:@"保存成功"];
    } else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"无法访问相册" message:@"请在iPhone的“设置－隐私－照片”中允许“头条百家”访问你的照片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
    }
    
}
@end
