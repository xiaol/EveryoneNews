//
//  LPPhotoCell.m
//  EveryoneNews
//
//  Created by apple on 15/8/13.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPPhotoCell.h"
#import "LPPhoto.h"
#import "UIImageView+WebCache.h"

@interface LPPhotoCell ()
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UIImageView *hud;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation LPPhotoCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *photoView = [[UIImageView alloc] init];
        photoView.contentMode = UIViewContentModeScaleAspectFill;
        photoView.clipsToBounds = YES;
        [self.contentView addSubview:photoView];
        self.photoView = photoView;
        
        UIImageView *hud = [[UIImageView alloc] init];
        [self.contentView addSubview:hud];
        NSString *imgName = @"";
        if (iPhone4) {
            imgName = @"imgwallHUD4";
        } else if (iPhone5) {
            imgName = @"imgwallHUD5";
        } else {
            imgName = @"imgwallHUD";
        }
        hud.image = [UIImage imageNamed:imgName];
        self.hud = hud;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
    }
    return self;
}

- (void)setPhoto:(LPPhoto *)photo {
    _photo = photo;
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:photo.img] placeholderImage:[UIImage imageNamed:@"imgWallPlaceholder"]];
    self.photoView.frame = self.bounds;
//    self.photoView.layer.shadowOffset = CGSizeMake(0, 0);
//    self.photoView.layer.shadowRadius = 2;
//    self.photoView.layer.shadowOpacity = 0.7;
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(0.0, self.photoView.height)];
//    [path moveToPoint:CGPointMake(self.photoView.width, self.photoView.height)];
//    [path closePath];
//    self.photoView.layer.shadowPath = path.CGPath;
    
    self.hud.frame = self.bounds;
    
    self.titleLabel.text = photo.note;
    UIFont *font = [UIFont systemFontOfSize:15];
    CGFloat lineH = [photo.note heightForLineWithFont:font];
    self.titleLabel.height = lineH * 2;
    self.titleLabel.x = BodyPadding;
    self.titleLabel.y = self.height - self.titleLabel.height - BodyPadding;
    self.titleLabel.width = self.width - 2 * BodyPadding;
}
@end
