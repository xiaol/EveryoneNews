//
//  AlbumCell.h
//  EveryoneNews
//
//  Created by apple on 15/10/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Album;

@interface AlbumCell : UICollectionViewCell
@property (nonatomic, strong) Album *album;

@property (nonatomic, strong) UIImageView *coverView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIView *hud;
@property (nonatomic, strong) CAShapeLayer *dash;

- (void)deleteCell:(id)sender;
- (void)editCell:(id)sender;
@end
