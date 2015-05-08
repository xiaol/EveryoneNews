//
//  pointView.m
//  EveryoneNews
//
//  Created by 于咏畅 on 15/5/8.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "pointView.h"
#import "UIColor+HexToRGB.h"
#define kBlue @"#4FB5EA"

@implementation pointView

- (instancetype)init
{
    if (self = [super init]) {
        _circleView = [[UIView alloc] init];
        _circleView.backgroundColor = [UIColor colorFromHexString:kBlue];
//        _circleView.frame = _singleImgFrm.circleFrm;
        _circleView.layer.masksToBounds = YES;
        _circleView.layer.cornerRadius = _circleView.frame.size.width / 2;
        _circleView.center = CGPointMake(_circleView.center.x, self.center.y);
        [self addSubview:_circleView];
        
        _topBar = [[UIView alloc] init];
        _topBar.backgroundColor = [UIColor colorFromHexString:kBlue];
//        _topBar.frame = _singleImgFrm.topBlueBarFrm;
        _topBar.center = CGPointMake(_circleView.center.x, _topBar.center.y);
        [self addSubview:_topBar];
        
        _bottonBar = [[UIView alloc] init];
        _bottonBar.backgroundColor = [UIColor colorFromHexString:kBlue];
//        bottonBar.frame = _singleImgFrm.bottonBlueBarFrm;
        _bottonBar.center = CGPointMake(_circleView.center.x, _bottonBar.center.y);
        [self addSubview:_bottonBar];
        
        _sourceLab = [[UILabel alloc] init];
        _sourceLab.backgroundColor = [UIColor blueColor];
//        _sourceLab.bounds = CGRectMake(0, 0, sourceSize.width, sourceSize.height);
        [self addSubview:_sourceLab];
    }
    return self;
}

@end
