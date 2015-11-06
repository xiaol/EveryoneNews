//
//  CollectCell.m
//  EveryoneNews
//
//  Created by apple on 15/10/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CollectCell.h"

@interface CollectCell ()
@property (nonatomic, strong) UIImageView *selectedImg;
@end

@implementation CollectCell

//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        UIView *selectedHUD = [[UIView alloc] init];
//        selectedHUD.backgroundColor = [UIColor lightGrayColor];
//        [self.contentView addSubview:selectedHUD];
//        self.selectedHUD = selectedHUD;
//        selectedHUD.alpha = 0.6;
//        
//        UIImageView *selectedImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dig对号"]];
//
//        [selectedHUD addSubview:selectedImg];
//        self.selectedImg = selectedImg;
//    }
//    return self;
//}

- (void)setAlbum:(Album *)album {
    [super setAlbum:album];
//    self.selectedHUD.frame = self.bounds;
//    self.selectedHUD.hidden = YES;
//    
//    self.selectedImg.width = self.width / 6;
//    self.selectedImg.height = self.height / 6;
//    self.selectedImg.center = CGPointMake(self.selectedHUD.width / 2, self.selectedHUD.height / 2);
}

@end
