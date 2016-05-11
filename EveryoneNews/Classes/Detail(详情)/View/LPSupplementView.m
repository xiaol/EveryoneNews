//
//  LPSupplementView.m
//  EveryoneNews
//
//  Created by apple on 15/8/5.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPSupplementView.h"
#import "LPContentFrame.h"
#import "LPContent.h"

@interface LPSupplementView ()
@property (nonatomic, strong) UIView *dividerView;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *sourceView;
@property (nonatomic, strong) UIImageView *pointerView;
@end

@implementation LPSupplementView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *dividerView = [[UIView alloc] init];
        dividerView.backgroundColor = [UIColor colorFromHexString:@"dadada"];
        [self addSubview:dividerView];
        self.dividerView = dividerView;
        
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"三角"]];
        arrowView.clipsToBounds = YES;
        [self addSubview:arrowView];
        self.arrowView = arrowView;
        
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.image = [UIImage imageNamed:@"来源"];
        [self addSubview:iconView];
        self.iconView = iconView;
        
        UILabel *sourceView = [[UILabel alloc] init];
        sourceView.lineBreakMode = NSLineBreakByCharWrapping;
        sourceView.numberOfLines = 0;
        [self addSubview:sourceView];
        self.sourceView = sourceView;
        
        UIImageView *pointerView = [[UIImageView alloc] init];
        pointerView.image = [UIImage imageNamed:@"链接箭头"];
        [self addSubview:pointerView];
        self.pointerView = pointerView;
    }
    return self;
}

- (void)setContentFrame:(LPContentFrame *)contentFrame {
    _contentFrame = contentFrame;
    LPContent *content = contentFrame.content;
    
    self.dividerView.frame = contentFrame.dividerViewF;
    
    self.arrowView.frame = contentFrame.arrowViewF;
    
    self.iconView.frame = contentFrame.iconViewF;
    
    self.sourceView.frame = contentFrame.sourceViewF;
    self.sourceView.attributedText = content.opinionString;
    
    self.pointerView.frame = contentFrame.pointerViewF;
}


@end
