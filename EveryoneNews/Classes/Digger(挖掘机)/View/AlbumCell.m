//
//  AlbumCell.m
//  EveryoneNews
//
//  Created by apple on 15/10/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "AlbumCell.h"
#import "Album.h"
#import "AlbumPhoto.h"

@interface AlbumCell ()
@property (nonatomic, strong) UIMenuController *menu;
@end

@implementation AlbumCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *coverView = [[UIImageView alloc] init];
        coverView.clipsToBounds = YES;
        coverView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:coverView];
        self.coverView = coverView;
        
        UIView *hud = [[UIView alloc] init];
        hud.backgroundColor = [UIColor colorFromHexString:@"000000" alpha:0.25];
        [self.contentView addSubview:hud];
        self.hud = hud;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 1;
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UILabel *subtitleLabel = [[UILabel alloc] init];
        subtitleLabel.numberOfLines = 1;
        subtitleLabel.font = [UIFont systemFontOfSize:12];
        subtitleLabel.textColor = [UIColor whiteColor];
        subtitleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:subtitleLabel];
        self.subtitleLabel = subtitleLabel;
        
        CAShapeLayer *dash = [CAShapeLayer layer];
        dash.strokeColor = [UIColor lightGrayColor].CGColor;
        dash.lineWidth = 1.0;
        dash.lineDashPattern = @[@4, @2];
        dash.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:5.0].CGPath;
        dash.fillColor = nil;
        self.dash = dash;
        [self.layer addSublayer:dash];
        dash.hidden = YES;
    }
    return self;
}

- (void)setAlbum:(Album *)album {
    _album = album;
    
    self.coverView.frame = self.bounds;
    if (album.thumbnail) {
        self.coverView.image = [UIImage imageWithData:album.thumbnail];
    }
    self.hud.frame = self.bounds;
    
    if (album.title.length) {
        self.titleLabel.hidden = NO;
        CGFloat titleH = [album.title heightForLineWithFont:[UIFont systemFontOfSize:16]];
        self.titleLabel.x = 0;
        self.titleLabel.y = self.height / 2 - titleH - 5;
        self.titleLabel.height = titleH;
        self.titleLabel.width = self.width;
        self.titleLabel.text = album.title;
    } else {
        self.titleLabel.hidden = YES;
    }
    
    if (album.subtitle.length) {
        self.subtitleLabel.hidden = NO;
        CGFloat subtitleH = [album.title heightForLineWithFont:[UIFont systemFontOfSize:16]];
        self.subtitleLabel.x = 0;
        self.subtitleLabel.y = self.height / 2 + 5;
        self.subtitleLabel.height = subtitleH;
        self.subtitleLabel.width = self.width;
        self.subtitleLabel.text = album.subtitle;
    } else {
        self.subtitleLabel.hidden = YES;
    }
    
    if (album.albumID.integerValue == 0) {
        self.hud.hidden = YES;
        self.dash.hidden = NO;
    } else {
        self.hud.hidden = NO;
        self.dash.hidden = YES;
    }
}

- (void)deleteCell:(id)sender {
    UIView *view = self;
    do {
        view = view.superview;
    } while (![view isKindOfClass:[UICollectionView class]]);
    UICollectionView *collectionView = (UICollectionView *)view;
    NSIndexPath *indexPath = [collectionView indexPathForCell:self];
    if ([collectionView.delegate respondsToSelector:@selector(collectionView:performAction:forItemAtIndexPath:withSender:)]) {
        [collectionView.delegate collectionView:collectionView performAction:_cmd forItemAtIndexPath:indexPath withSender:sender];
    }
}

- (void)editCell:(id)sender {
    UIView *view = self;
    do {
        view = view.superview;
    } while (![view isKindOfClass:[UICollectionView class]]);
    UICollectionView *collectionView = (UICollectionView *)view;
    NSIndexPath *indexPath = [collectionView indexPathForCell:self];
    if ([collectionView.delegate respondsToSelector:@selector(collectionView:canPerformAction:forItemAtIndexPath:withSender:)]) {
        [collectionView.delegate collectionView:collectionView performAction:_cmd forItemAtIndexPath:indexPath withSender:sender];
    }
}
@end
