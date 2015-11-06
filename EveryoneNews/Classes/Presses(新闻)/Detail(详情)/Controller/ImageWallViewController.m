//
//  ImageWallViewController.m
//  EveryoneNews
//
//  Created by Feng on 15/7/13.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ImageWallViewController.h"
#import "ImageWall.h"
#import "UIImageView+WebCache.h"


@interface ImageWallViewController () <UIScrollViewDelegate>

@end

@implementation ImageWallViewController
- (BOOL)prefersStatusBarHidden{
    return YES;
}
- (void)viewDidLoad{
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.imageWallScrollView];
    [self.view addSubview:self.progressLabel];
    [self.view addSubview:self.descTextField];
    [self.view addSubview:self.newsTitleLabel];
    [self.view addSubview:self.closeBtn];
}
-(UILabel *)newsTitleLabel{
    if (_newsTitleLabel == nil) {
        _newsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, CGRectGetMaxY(self.imageWallScrollView.frame) + 3, ScreenWidth - 40, 18)];
    }
    return _newsTitleLabel;
}
- (UIScrollView *)imageWallScrollView{
    if (_imageWallScrollView == nil) {
        _imageWallScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight - 160)];
        _imageWallScrollView.bounces = NO;
        _imageWallScrollView.pagingEnabled = YES;
        _imageWallScrollView.clipsToBounds = YES;
        _imageWallScrollView.delegate = self;
        _imageWallScrollView.showsHorizontalScrollIndicator = NO;
        _imageWallScrollView.showsVerticalScrollIndicator = NO;
    }
    return _imageWallScrollView;
}
- (UIButton *)closeBtn{
    if (_closeBtn == nil) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(22, 44, 35, 35)];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        _closeBtn.layer.cornerRadius = _closeBtn.frame.size.height / 2;
        _closeBtn.layer.borderWidth = 1;
        _closeBtn.layer.masksToBounds = YES;
        _closeBtn.layer.borderColor = [UIColor colorWithWhite:0.6 alpha:0.8].CGColor;
        [_closeBtn addTarget:self action:@selector(closeBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}
- (UITextView *)descTextField{
    if (_descTextView == nil) {
        _descTextView = [[UITextView alloc] initWithFrame:CGRectMake(4, CGRectGetMaxY(self.newsTitleLabel.frame) + 4, ScreenWidth - 4 * 2, ScreenHeight - CGRectGetMaxY(self.newsTitleLabel.frame) - 15)];
        _descTextView.backgroundColor = [UIColor clearColor];
    }
    return _descTextView;
}
-(UILabel *)progressLabel{
    if (_progressLabel == nil) {
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 40, CGRectGetMaxY(self.imageWallScrollView.frame) + 4, 40, 18)];
        _progressLabel.font = [UIFont systemFontOfSize:13];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _progressLabel;
}
-(void)setNewsTitle:(NSString *)newsTitle{
    self.newsTitleLabel.font = [UIFont systemFontOfSize:18];
    self.newsTitleLabel.textColor = [UIColor whiteColor];
    self.newsTitleLabel.text = newsTitle;
}
- (void)setImages:(NSArray *)images{
    _images = images;
    for (int i = 0; i < images.count; i ++) {
       UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i *ScreenWidth, 0, ScreenWidth, ScreenHeight - 160)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        ImageWall *imageWall = images[i];
        [imageView sd_setImageWithURL:[[NSURL alloc] initWithString:imageWall.img]placeholderImage:nil];
        [self.imageWallScrollView addSubview:imageView];
    }
    self.imageWallScrollView.contentSize = CGSizeMake(ScreenWidth * images.count, ScreenHeight - 200);
    
    NSMutableAttributedString *progressAttrString = [[NSString stringWithFormat:@"%ld",self.currentIndex + 1] attributedStringWithFont:[UIFont systemFontOfSize:18]];
    [progressAttrString appendAttributedString:[[NSString stringWithFormat:@"/%ld",images.count] attributedStringWithFont:[UIFont systemFontOfSize:14]]];
    self.progressLabel.attributedText = progressAttrString;
    self.progressLabel.textColor = [UIColor colorFromHexString:@"ffffff" alpha:0.7];
    ImageWall *imageWall = images[self.currentIndex];
    
    self.descTextField.text = imageWall.note;
    self.descTextField.font = [UIFont systemFontOfSize:14];
    self.descTextView.editable = NO;
    self.descTextView.selectable = NO;
    self.descTextField.textColor = [UIColor whiteColor];
}
- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    NSMutableAttributedString *progressAttrString = [[NSString stringWithFormat:@"%ld",self.currentIndex + 1] attributedStringWithFont:[UIFont systemFontOfSize:18]];
    [progressAttrString appendAttributedString:[[NSString stringWithFormat:@"/%ld",self.images.count] attributedStringWithFont:[UIFont systemFontOfSize:14]]];
    self.progressLabel.attributedText = progressAttrString;
    ImageWall *imageWall = self.images[currentIndex];
    self.descTextField.text = imageWall.note;
    self.imageWallScrollView.contentOffset = CGPointMake(currentIndex * ScreenWidth, 0);
}
- (void)closeBtnDidClick:(UIButton*)closeBtn{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - imageWallScrollView delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / ScreenWidth ;
    [self setCurrentIndex:index];
}

@end
