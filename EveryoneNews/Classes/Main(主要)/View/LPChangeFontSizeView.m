//
//  LPChangeFontSizeView.m
//  EveryoneNews
//
//  Created by dongdan on 16/4/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPChangeFontSizeView.h"
#import "NSString+LP.h"

@implementation LPChangeFontSizeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat fontSize = 14;
        
        NSString *strFinish = @"完成";
        CGFloat finishButtonWidth = [strFinish sizeWithFont:[UIFont systemFontOfSize:fontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
        UIButton *finishButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - finishButtonWidth - 15, 0, finishButtonWidth, 40)];
        [finishButton setTitle:@"完成" forState:UIControlStateNormal];
        [finishButton setTitleColor:[UIColor colorFromHexString:@"#999999"] forState:UIControlStateNormal];
        finishButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [finishButton addTarget:self action:@selector(finishButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:finishButton];
        
        UILabel *fontSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        fontSizeLabel.font = [UIFont systemFontOfSize:fontSize];
        fontSizeLabel.textColor = [UIColor colorFromHexString:@"#1a1a1a"];
        fontSizeLabel.centerX = self.centerX;
        fontSizeLabel.text = @"字体大小";
        [self addSubview:fontSizeLabel];
        
        UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(15, 40, ScreenWidth - 30, 0.5)];
        seperatorView.backgroundColor = [UIColor colorFromHexString:@"#e4e4e4"];
        [self addSubview:seperatorView];
        
        UILabel *standardLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 45, finishButtonWidth, 40)];
        standardLabel.font = [UIFont systemFontOfSize:fontSize];
        standardLabel.textAlignment = NSTextAlignmentLeft;
        standardLabel.text = @"标准";
        [self addSubview:standardLabel];
        
        UILabel *bigLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, finishButtonWidth, 40)];
        bigLabel.font = [UIFont systemFontOfSize:fontSize];
        bigLabel.textAlignment = NSTextAlignmentCenter;
        bigLabel.centerX = self.centerX;
        bigLabel.text = @"大";
        [self addSubview:bigLabel];
        
        UILabel *superLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - finishButtonWidth - 30, 45, finishButtonWidth, 40)];
        superLabel.font = [UIFont systemFontOfSize:fontSize];
        superLabel.textAlignment = NSTextAlignmentRight;
        superLabel.text = @"超大";
        [self addSubview:superLabel];
        
        
        CGFloat sliderBackgroundViewX = CGRectGetMaxX(standardLabel.frame) - finishButtonWidth / 2;
        CGFloat sliderBackgroundViewY = CGRectGetMaxY(standardLabel.frame) + 10;
        
        // 绘制刻度值
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path moveToPoint:CGPointMake(sliderBackgroundViewX,sliderBackgroundViewY)];
        [path addLineToPoint:CGPointMake(sliderBackgroundViewX, sliderBackgroundViewY + 10)];
        
        [path moveToPoint:CGPointMake(sliderBackgroundViewX,sliderBackgroundViewY + 5)];
        [path addLineToPoint:CGPointMake(ScreenWidth - sliderBackgroundViewX, sliderBackgroundViewY + 5)];
        
        [path moveToPoint:CGPointMake(self.centerX,sliderBackgroundViewY)];
        [path addLineToPoint:CGPointMake(self.centerX, sliderBackgroundViewY + 10)];
        
        [path moveToPoint:CGPointMake(ScreenWidth - sliderBackgroundViewX ,sliderBackgroundViewY)];
        [path addLineToPoint:CGPointMake(ScreenWidth - sliderBackgroundViewX , sliderBackgroundViewY + 10)];
        
        
        //create shape layer
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.strokeColor =  [UIColor colorFromHexString:@"#e4e4e4"].CGColor;
        shapeLayer.lineWidth = 1;
        shapeLayer.path = path.CGPath;
        [self.layer addSublayer:shapeLayer];
     
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(30, sliderBackgroundViewY - 10, ScreenWidth - 60, 30)];
        // 通常状态下
        [slider setThumbImage:[UIImage imageNamed:@"滑块背景"] forState:UIControlStateNormal];
        slider.minimumTrackTintColor = [UIColor clearColor];
        slider.maximumTrackTintColor = [UIColor clearColor];
        slider.minimumValue = 1.0;
        slider.maximumValue = 3.0;
        // 设置滑动默认值和字体大小
        if ([[userDefaults objectForKey:@"homeViewFontSizeType"]  isEqual: @"standard"]) {
            slider.value = 1;
            
        } else if ([[userDefaults objectForKey:@"homeViewFontSizeType"] isEqual:@"larger"]) {
            slider.value = 2;
            
        } else if ([[userDefaults objectForKey:@"homeViewFontSizeType"] isEqual:@"superlarger"]) {
            slider.value = 3;
        } else {
              slider.value = 1;
        }
     
        [slider addTarget:self action:@selector(sliderTouchUpInside:)  forControlEvents:UIControlEventTouchUpInside];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [slider addGestureRecognizer:tap];
        
        [self addSubview:slider];
    }
    return  self;
}

- (void)tapGesture:(UITapGestureRecognizer *)sender
{
    UISlider *slider = (UISlider *)sender.view;
    CGPoint p = [sender locationInView:slider];
    
    if (p.x <= (30 + (ScreenWidth - 60) / 4)) {
        [slider setValue:1];
        
        self.homeViewFontSize = iPhone5HomeTitleSizeStandard;
        self.currentDetailContentFontSize = iPhone5DetailContentSizeStandard;
        self.currentDetaiTitleFontSize  = iPhone5DetailTitleSizeStandard;
        self.currentDetailCommentFontSize = iPhone5DetailCommentSizeStandard;
        self.currentDetailRelatePointFontSize = iPhone5DetailRelateSizeStandard;
        self.currentDetailSourceFontSize = iPhone5DetailSourceSizeStandard;
        
        
        if (iPhone6Plus) {
            self.homeViewFontSize = iPhone6PlusHomeTitleSizeStandard;
            self.currentDetailContentFontSize = iPhone6PlusDetailContentSizeStandard;
            self.currentDetaiTitleFontSize  = iPhone6PlusDetailTitleSizeStandard;
            self.currentDetailCommentFontSize = iPhone6PlusDetailCommentSizeStandard;
            self.currentDetailRelatePointFontSize = iPhone6PlusDetailRelateSizeStandard;
            self.currentDetailSourceFontSize = iPhone6PlusDetailSourceSizeStandard;
        }
        
    } else if (p.x <= (30 + (ScreenWidth - 60) * 3 / 4)) {
        [slider setValue:2];
        
        self.homeViewFontSize = iPhone5HomeTitleSizeLarger;
        self.currentDetailContentFontSize = iPhone5DetailContentSizeLarger;
        self.currentDetaiTitleFontSize  = iPhone5DetailTitleSizeLarger;
        self.currentDetailCommentFontSize = iPhone5DetailCommentSizeLarger;
        self.currentDetailRelatePointFontSize = iPhone5DetailRelateSizeLarger;
        self.currentDetailSourceFontSize = iPhone5DetailSourceSizeLarger;
        
        if (iPhone6Plus) {
            self.homeViewFontSize = iPhone6PlusHomeTitleSizeLarger;
            self.currentDetailContentFontSize = iPhone6PlusDetailContentSizeLarger;
            self.currentDetaiTitleFontSize  = iPhone6PlusDetailTitleSizeLarger;
            self.currentDetailCommentFontSize = iPhone6PlusDetailCommentSizeLarger;
            self.currentDetailRelatePointFontSize = iPhone6PlusDetailRelateSizeLarger;
            self.currentDetailSourceFontSize = iPhone6PlusDetailSourceSizeLarger;
        }
    } else {
        
        [slider setValue:3];
        
        self.homeViewFontSize = iPhone5HomeTitleSizeSuperLarger;
        self.currentDetailContentFontSize = iPhone5DetailContentSizeSuperLarger;
        self.currentDetaiTitleFontSize  = iPhone5DetailTitleSizeSuperLarger;
        self.currentDetailCommentFontSize = iPhone5DetailCommentSizeSuperLarger;
        self.currentDetailRelatePointFontSize = iPhone5DetailRelateSizeSuperLarger;
        self.currentDetailSourceFontSize = iPhone5DetailSourceSizeSuperLarger;
        
        if (iPhone6Plus) {
            self.homeViewFontSize = iPhone6PlusHomeTitleSizeSuperLarger;
            self.currentDetailContentFontSize = iPhone6PlusDetailContentSizeSuperLarger;
            self.currentDetaiTitleFontSize  = iPhone6PlusDetailTitleSizeSuperLarger;
            self.currentDetailCommentFontSize = iPhone6PlusDetailCommentSizeSuperLarger;
            self.currentDetailRelatePointFontSize = iPhone6PlusDetailRelateSizeSuperLarger;
            self.currentDetailSourceFontSize = iPhone6PlusDetailSourceSizeSuperLarger;
        }
    }
    NSString *homeViewFontSizeType = [self getCurrentHomeViewFontSizeTypeWithSliderValue:(NSInteger)slider.value];
    
    if ([self.delegate respondsToSelector:@selector(changeFontSizeView:reloadTableViewWithFontSize:fontSizeType:currentDetailContentFontSize:currentDetaiTitleFontSize:currentDetailCommentFontSize:currentDetailRelatePointFontSize:currentDetailSourceFontSize:)]) {
        [self.delegate changeFontSizeView:self reloadTableViewWithFontSize:self.homeViewFontSize fontSizeType:homeViewFontSizeType currentDetailContentFontSize:self.currentDetailContentFontSize currentDetaiTitleFontSize:self.currentDetaiTitleFontSize currentDetailCommentFontSize:self.currentDetailCommentFontSize currentDetailRelatePointFontSize:self.currentDetailRelatePointFontSize currentDetailSourceFontSize:self.currentDetailSourceFontSize];
    }
 
}

- (void)sliderTouchUpInside:(UISlider *)slider {
    [slider setValue:round(slider.value)];
    
    if (slider.value == 1) {
        
        self.homeViewFontSize = iPhone5HomeTitleSizeStandard;
        self.currentDetailContentFontSize = iPhone5DetailContentSizeStandard;
        self.currentDetaiTitleFontSize  = iPhone5DetailTitleSizeStandard;
        self.currentDetailCommentFontSize = iPhone5DetailCommentSizeStandard;
        self.currentDetailRelatePointFontSize = iPhone5DetailRelateSizeStandard;
        self.currentDetailSourceFontSize = iPhone5DetailSourceSizeStandard;
        
        if (iPhone6Plus) {
            
            self.homeViewFontSize = iPhone6PlusHomeTitleSizeStandard;
            self.currentDetailContentFontSize = iPhone6PlusDetailContentSizeStandard;
            self.currentDetaiTitleFontSize  = iPhone6PlusDetailTitleSizeStandard;
            self.currentDetailCommentFontSize = iPhone6PlusDetailCommentSizeStandard;
            self.currentDetailRelatePointFontSize = iPhone6PlusDetailRelateSizeStandard;
            self.currentDetailSourceFontSize = iPhone6PlusDetailSourceSizeStandard;
        }
        
    } else if (slider.value == 2) {
        
        self.homeViewFontSize = iPhone5HomeTitleSizeLarger;
        self.currentDetailContentFontSize = iPhone5DetailContentSizeLarger;
        self.currentDetaiTitleFontSize  = iPhone5DetailTitleSizeLarger;
        self.currentDetailCommentFontSize = iPhone5DetailCommentSizeLarger;
        self.currentDetailRelatePointFontSize = iPhone5DetailRelateSizeLarger;
        self.currentDetailSourceFontSize = iPhone5DetailSourceSizeLarger;
        
        if (iPhone6Plus) {
            
            self.homeViewFontSize = iPhone6PlusHomeTitleSizeLarger;
            self.currentDetailContentFontSize = iPhone6PlusDetailContentSizeLarger;
            self.currentDetaiTitleFontSize  = iPhone6PlusDetailTitleSizeLarger;
            self.currentDetailCommentFontSize = iPhone6PlusDetailCommentSizeLarger;
            self.currentDetailRelatePointFontSize = iPhone6PlusDetailRelateSizeLarger;
            self.currentDetailSourceFontSize = iPhone6PlusDetailSourceSizeLarger;
        }
        
    } else if (slider.value == 3) {
        
        self.homeViewFontSize = iPhone5HomeTitleSizeSuperLarger;
        self.currentDetailContentFontSize = iPhone5DetailContentSizeSuperLarger;
        self.currentDetaiTitleFontSize  = iPhone5DetailTitleSizeSuperLarger;
        self.currentDetailCommentFontSize = iPhone5DetailCommentSizeSuperLarger;
        self.currentDetailRelatePointFontSize = iPhone5DetailRelateSizeSuperLarger;
        self.currentDetailSourceFontSize = iPhone5DetailSourceSizeSuperLarger;
        
        if (iPhone6Plus) {
            self.homeViewFontSize = iPhone6PlusHomeTitleSizeSuperLarger;
            self.currentDetailContentFontSize = iPhone6PlusDetailContentSizeSuperLarger;
            self.currentDetaiTitleFontSize  = iPhone6PlusDetailTitleSizeSuperLarger;
            self.currentDetailCommentFontSize = iPhone6PlusDetailCommentSizeSuperLarger;
            self.currentDetailRelatePointFontSize = iPhone6PlusDetailRelateSizeSuperLarger;
            self.currentDetailSourceFontSize = iPhone6PlusDetailSourceSizeSuperLarger;
        }
    }
    NSString *homeViewFontSizeType = [self getCurrentHomeViewFontSizeTypeWithSliderValue:(NSInteger)slider.value];
    
    if ([self.delegate respondsToSelector:@selector(changeFontSizeView:reloadTableViewWithFontSize:fontSizeType:currentDetailContentFontSize:currentDetaiTitleFontSize:currentDetailCommentFontSize:currentDetailRelatePointFontSize:currentDetailSourceFontSize:)]) {
        [self.delegate changeFontSizeView:self reloadTableViewWithFontSize:self.homeViewFontSize fontSizeType:homeViewFontSizeType currentDetailContentFontSize:self.currentDetailContentFontSize currentDetaiTitleFontSize:self.currentDetaiTitleFontSize currentDetailCommentFontSize:self.currentDetailCommentFontSize currentDetailRelatePointFontSize:self.currentDetailRelatePointFontSize currentDetailSourceFontSize:self.currentDetailSourceFontSize];
    }
    
}

- (NSString *)getCurrentHomeViewFontSizeTypeWithSliderValue:(NSInteger)value {
    if (value == 1) {
        return @"standard";
    } else if (value == 2) {
        return @"larger";
        
    } else if (value == 3) {
        return @"superlarger";
    }
    return @"standard";
}

#pragma mark - 点击完成按钮
- (void)finishButtonClick {
    if ([self.delegate respondsToSelector:@selector(finishButtonDidClick:)]) {
        [self.delegate finishButtonDidClick:self];
    }
}
@end
