//
//  LPFullPhotoCell.m
//  EveryoneNews
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPFullPhotoCell.h"
#import "UIImageView+WebCache.h"
#import "LPPhoto.h"
#import "MBProgressHUD+MJ.h"

#define ContentPadding 10
#define IndexH
@interface LPFullPhotoCell ()<UIActionSheetDelegate>
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@end

@implementation LPFullPhotoCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *photoView = [[UIImageView alloc] init];
        photoView.contentMode = UIViewContentModeScaleAspectFit;
        // 必须设置
        photoView.userInteractionEnabled = YES;
        UILongPressGestureRecognizer * longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesturePressed:)];
        [photoView addGestureRecognizer:longGesture];
        
        [self.contentView addSubview:photoView];
        self.photoView = photoView;
  
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.indicator = indicator;
        [photoView addSubview:indicator];
        
  
    }
    return self;
}

- (void)setPhoto:(LPPhoto *)photo {
    _photo = photo;

//    [self.photoView sd_setImageWithURL:[NSURL URLWithString:photo.img] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        
//    }];
    self.photoView.frame = self.bounds;
    self.indicator.center = CGPointMake(self.photoView.width / 2, self.photoView.height / 2);
    [self.indicator startAnimating];
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:photo.img] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.indicator.hidden = receivedSize == expectedSize;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.indicator stopAnimating];
      
    }];
    
}


- (void)longGesturePressed:(UILongPressGestureRecognizer *)recognier {
    if(recognier.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存到手机" otherButtonTitles:nil, nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet showInView:self];
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
