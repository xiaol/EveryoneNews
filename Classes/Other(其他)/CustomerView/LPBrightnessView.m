//
//  LPBrightnessView.m
//  AVPlayerDemo
//
//  Created by dongdan on 2016/12/8.
//  Copyright © 2016年 dongdan. All rights reserved.
//

#import "LPBrightnessView.h"

@interface LPBrightnessView()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIView *longView;
@property (nonatomic, strong) NSMutableArray *tipArray;
@property (nonatomic, assign) BOOL orientationDidChanged;


@end


@implementation LPBrightnessView

+(instancetype)sharedBrightnessView {
    static LPBrightnessView *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LPBrightnessView alloc] init];
        [[UIApplication sharedApplication].keyWindow addSubview:instance];
    });
    return instance;
}


- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(ScreenWidth * 0.5, ScreenHeight * 0.5, 155, 155);
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
        // 实现毛玻璃效果
        UIToolbar *toolBar = [[UIToolbar alloc] init];
        toolBar.alpha = 0.90;
        [self addSubview:toolBar];
        
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 76, 76)];
        bgImageView.image = [UIImage oddityImage:@"video_light"];
        [self addSubview:bgImageView];
        self.bgImageView = bgImageView;
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.bounds.size.width, 30)];
        title.font = [UIFont boldSystemFontOfSize:16];
        title.textColor  = [UIColor colorWithRed:0.25f green:0.22f blue:0.21f alpha:1.00f];
        title.textAlignment = NSTextAlignmentCenter;
        title.text = @"亮度";
        [self addSubview:title];
        self.title = title;
        
        UIView *longView = [[UIView alloc]initWithFrame:CGRectMake(13, 132, self.bounds.size.width - 26, 7)];
        longView.backgroundColor = [UIColor colorWithRed:0.25f green:0.22f blue:0.21f alpha:1.00f];
        [self addSubview:longView];
        self.longView = longView;
        
        [self createTips];
        [self addNotification];
        [self addObserver];
        self.alpha = 0.0;
    
    }
    return self;
}


- (void)addNotification {
    
    [noteCenter addObserver:self
                   selector:@selector(updateLayer:)
                       name:UIDeviceOrientationDidChangeNotification
                     object:nil];
}

- (void)addObserver {
    [[UIScreen mainScreen] addObserver:self
                            forKeyPath:@"brightness"
                               options:NSKeyValueObservingOptionNew
                               context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    CGFloat sound = [change[@"new"] floatValue];
    [self appearSoundView];
    [self updateLongView:sound];
}

- (void)updateLayer:(NSNotification *)notify {
    self.orientationDidChanged = YES;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)appearSoundView {
    if (self.alpha == 0.0) {
        self.orientationDidChanged = NO;
        self.alpha = 1.0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self disappearSoundView];
        });
    }
}


- (void)disappearSoundView {
    
    if (self.alpha == 1.0) {
        [UIView animateWithDuration:0.8 animations:^{
            self.alpha = 0.0;
        }];
    }
}

- (void)createTips {
    
    self.tipArray = [NSMutableArray arrayWithCapacity:16];
    
    CGFloat tipW = (self.longView.bounds.size.width - 17) / 16;
    CGFloat tipH = 5;
    CGFloat tipY = 1;
    
    for (int i = 0; i < 16; i++) {
        CGFloat tipX = i * (tipW + 1) + 1;
        UIImageView *image = [[UIImageView alloc] init];
        image.backgroundColor = [UIColor whiteColor];
        image.frame = CGRectMake(tipX, tipY, tipW, tipH);
        [self.longView addSubview:image];
        [self.tipArray addObject:image];
    }
    [self updateLongView:[UIScreen mainScreen].brightness];
}

- (void)updateLongView:(CGFloat)sound {
    CGFloat stage = 1 / 15.0;
    NSInteger level = sound / stage;
    for (int i = 0; i < self.tipArray.count; i++) {
        UIImageView *img = self.tipArray[i];
        if (i <= level) {
            img.hidden = NO;
        } else {
            img.hidden = YES;
        }
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.bgImageView.center = CGPointMake(155 * 0.5, 155 * 0.5);
    self.center = CGPointMake(ScreenWidth * 0.5, ScreenHeight * 0.5);
}

- (void)dealloc {
    [[UIScreen mainScreen] removeObserver:self forKeyPath:@"brightness"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
