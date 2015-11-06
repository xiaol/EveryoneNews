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

#define ContentPadding 10
#define IndexH
@interface LPFullPhotoCell ()
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@end

@implementation LPFullPhotoCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *photoView = [[UIImageView alloc] init];
        photoView.contentMode = UIViewContentModeScaleAspectFit;
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
@end
