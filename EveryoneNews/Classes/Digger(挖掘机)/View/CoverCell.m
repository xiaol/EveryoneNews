//
//  CoverCell.m
//  EveryoneNews
//
//  Created by apple on 15/10/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CoverCell.h"
#import "Cover.h"

@interface CoverCell ()
@property (nonatomic, strong) UIImageView *coverView;
@property (nonatomic, strong) UIView *hud;
@property (nonatomic, strong) UIImageView *selectedView;
@property (nonatomic, strong) CAShapeLayer *dash;
@end

@implementation CoverCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *coverView = [[UIImageView alloc] init];
        coverView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverView = coverView;
        [self.contentView addSubview:coverView];
        
        UIView *hud = [[UIView alloc] init];
        hud.backgroundColor = [UIColor lightGrayColor];
        hud.alpha = 0.6;
        hud.hidden = YES;
        self.hud = hud;
        [self.contentView addSubview:hud];
        
        UIImageView *selectedView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dig对号"]];
        self.selectedView = selectedView;
        [hud addSubview:selectedView];
        
        CAShapeLayer *dash = [CAShapeLayer layer];
        dash.strokeColor = [UIColor lightGrayColor].CGColor;
        dash.lineWidth = 2.0;
        dash.lineDashPattern = @[@4, @2];
        dash.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:5.0].CGPath;
        dash.fillColor = nil;
        self.dash = dash;
        [self.layer addSublayer:dash];
        dash.hidden = YES;
    }
    return self;
}

//- (void)setCover:(Cover *)cover {
//    _cover = cover;
//    
//    self.coverView.frame = self.bounds;
//    self.coverView.image = cover.image;
//    
//    self.hud.frame = self.bounds;
//    self.selectedView.center = CGPointMake(self.hud.width / 2, self.hud.height / 2);
//    self.selectedView.size = self.selectedView.image.size;
//    
//    if (!cover.allowsSelection) {
//        self.dash.hidden = NO;
//    } else {
//        self.dash.hidden = YES;
//    }
//}

- (void)setCover:(Cover *)cover {
    _cover = cover;
    
    self.coverView.frame = self.bounds;
    self.coverView.image = cover.image;
    
    self.hud.frame = self.bounds;
    self.selectedView.center = CGPointMake(self.hud.width / 2, self.hud.height / 2);
    self.selectedView.size = self.selectedView.image.size;
    
    if (cover.isAddSign) {
        self.dash.hidden = NO;
    } else {
        self.dash.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (!self.cover.isAddSign) {
        self.hud.hidden = !selected;
    } else {
        self.hud.hidden = YES;
    }
}
@end
