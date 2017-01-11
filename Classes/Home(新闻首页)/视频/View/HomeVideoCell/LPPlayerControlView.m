//
//  LPPlayerControlView.m
//  AVPlayerDemo
//
//  Created by dongdan on 2016/12/7.
//  Copyright © 2016年 dongdan. All rights reserved.
//

#import "LPPlayerControlView.h"
#import "ASValueTrackingSlider.h"
#import "MMMaterialDesignSpinner.h"
#import "LPPlayerModel.h"
#import "UIView+LPCustomPlayView.h"

static const CGFloat LPPlayerAnimationTimeInterval = 5.0f;
static const CGFloat LPPlayerControlBarAutoFadeOutTimeInterval = 0.35f;

@interface LPPlayerControlView()<UIGestureRecognizerDelegate>

// 标题
@property (nonatomic, strong) UILabel *titleLabel;
// 开始播放按钮
@property (nonatomic, strong) UIButton *playButton;
// 当前播放时长
@property (nonatomic, strong) UILabel *currentTimeLabel;
// 播放总时长
@property (nonatomic, strong) UILabel *totalTimeLabel;
// 缓冲进度条
@property (nonatomic, strong) UIProgressView *progressView;

// 滑块
@property (nonatomic, strong) ASValueTrackingSlider *videoSlider;
// 全屏
@property (nonatomic, strong) UIButton *fullScreenButton;
// 锁定屏幕方向
@property (nonatomic, strong) UIButton *lockScreenButton;
// 系统菊花
@property (nonatomic, strong) MMMaterialDesignSpinner *activity;
// 返回
@property (nonatomic, strong) UIButton *backButton;

// 关闭
@property (nonatomic, strong) UIButton *closeButton;
// 重播按钮
@property (nonatomic, strong) UIButton *repeatButton;
// 加载失败按钮
@property (nonatomic, strong) UIButton *failButton;
// 快进快退
@property (nonatomic, strong) UIView *fastView;
// 快进快退进度
@property (nonatomic, strong) UIProgressView *fastProgressView;

// 快进快退时间
@property (nonatomic, strong) UILabel *fastTimeLabel;
// 播放模型
@property (nonatomic, strong) LPPlayerModel *playerModel;
// 占位图
@property (nonatomic, strong) UIImageView *placeholderImageView;
// 重播按钮
@property (nonatomic, strong) UIButton *repeatBtn;
// 顶部背景图
@property (nonatomic, strong) UIImageView   *topImageView;

// 底部背景图
@property (nonatomic, strong) UIImageView *bottomImageView;
// 快进快退图
@property (nonatomic, strong) UIImageView *fastImageView;
// 底部背景图
@property (nonatomic, strong) UIProgressView  *bottomProgressView;
// 音量按钮
@property (nonatomic, strong) UIButton *volumnButton;

// 分享按钮
@property (nonatomic, strong) UIButton *shareButton;
// 加载失败按钮
@property (nonatomic, strong) UIButton *failBtn;
// 显示控制层
@property (nonatomic, assign, getter=isShowing) BOOL showing;


// 是否结束播放
@property (nonatomic, assign, getter=isPlayEnd) BOOL playEnd;
// 是否全屏播放
@property (nonatomic, assign, getter=isFullScreen) BOOL fullScreen;
// 是否拖拽控制播放进度
@property (nonatomic, assign, getter=isDragged) BOOL dragged;
// 小屏播放
@property (nonatomic, assign, getter=isShrink) BOOL shrink;

@end

@implementation LPPlayerControlView

- (instancetype)init {
    if (self = [super init]) {
        // 占位图
        UIImageView *placeholderImageView = [[UIImageView alloc] init];
        placeholderImageView.userInteractionEnabled = YES;
        [self addSubview:placeholderImageView];
        self.placeholderImageView = placeholderImageView;
        
        // 视频顶部
        UIImageView *topImageView = [[UIImageView alloc] init];
        topImageView.userInteractionEnabled = YES;
        topImageView.image = [UIImage oddityImage:@"video_top_shadow"];
        [self addSubview:topImageView];
        self.topImageView = topImageView;
        
        // 返回
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.userInteractionEnabled = YES;
        [backButton setImage:[UIImage oddityImage:@"video_back"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [topImageView addSubview:backButton];
        self.backButton = backButton;
        
        // 标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [topImageView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        // 分享
        UIButton *shareButton = [[UIButton alloc] init];
        [shareButton setImage:[UIImage oddityImage:@"video_share_white"] forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        shareButton.enlargedEdge = 10;
        [topImageView addSubview:shareButton];
        self.shareButton = shareButton;
        
        // 锁屏按钮
        UIButton *lockScreenButton = [[UIButton alloc] init];
        [lockScreenButton setImage:[UIImage oddityImage:@"video_unlock"] forState:UIControlStateNormal];
        [lockScreenButton setImage:[UIImage oddityImage:@"video_lock"] forState:UIControlStateSelected];
        [lockScreenButton addTarget:self action:@selector(lockScreenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        lockScreenButton.enlargedEdge = 5;
        [topImageView addSubview:lockScreenButton];
        self.lockScreenButton = lockScreenButton;
        
        // 播放按钮
        UIButton *playButton = [[UIButton alloc] init];
        [playButton setImage:[UIImage oddityImage:@"video_play"] forState:UIControlStateNormal];
        [playButton setImage:[UIImage oddityImage:@"video_pause"] forState:UIControlStateSelected];
        [playButton addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:playButton];
        self.playButton = playButton;
        
        // 视频底部
        UIImageView *bottomImageView = [[UIImageView alloc] init];
        bottomImageView.userInteractionEnabled = YES;
        bottomImageView.image = [UIImage oddityImage:@"video_bottom_shadow"];
        [self addSubview:bottomImageView];
        self.bottomImageView = bottomImageView;
        
        // 音量
        UIButton *volumnButton = [[UIButton alloc] init];
        [volumnButton setImage:[UIImage oddityImage:@"video_volume"] forState:UIControlStateNormal];
        [volumnButton setImage:[UIImage oddityImage:@"video_mute"] forState:UIControlStateSelected];
        [volumnButton addTarget:self action:@selector(volumnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        volumnButton.enlargedEdge = 5;
        [bottomImageView addSubview:volumnButton];
        self.volumnButton = volumnButton;
        
        // 当前时间
        UILabel *currentTimeLabel = [[UILabel alloc] init];
        currentTimeLabel.textColor = [UIColor whiteColor];
        currentTimeLabel.font = [UIFont systemFontOfSize:12.0f];
        currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        [bottomImageView addSubview:currentTimeLabel];
        self.currentTimeLabel = currentTimeLabel;
        
        // 滑块
        ASValueTrackingSlider *videoSlider = [[ASValueTrackingSlider alloc] init];
        videoSlider.popUpViewCornerRadius = 2.0f;
        videoSlider.popUpViewColor = LPColorRGBA(19, 19, 9, 1);
        videoSlider.popUpViewArrowLength = 8;
        
        [videoSlider setThumbImage:[UIImage oddityImage:@"video_huakuai"] forState:UIControlStateNormal];
        videoSlider.maximumValue = 1;
        videoSlider.minimumTrackTintColor = [UIColor colorFromHexString:LPColor15];
        videoSlider.maximumTrackTintColor = [UIColor whiteColor];
        // slider开始滑动事件
        [videoSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        // slider滑动中事件
        [videoSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // slider结束滑动事件
        [videoSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
        
        UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSliderAction:)];
        [videoSlider addGestureRecognizer:sliderTap];
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panRecognizer:)];
        panRecognizer.delegate = self;
        [panRecognizer setMaximumNumberOfTouches:1];
        [panRecognizer setDelaysTouchesBegan:YES];
        [panRecognizer setDelaysTouchesEnded:YES];
        [panRecognizer setCancelsTouchesInView:YES];
        [videoSlider addGestureRecognizer:panRecognizer];
        [bottomImageView addSubview:videoSlider];
        self.videoSlider = videoSlider;
        
        // 播放总时间
        UILabel *totalTimeLabel = [[UILabel alloc] init];
        totalTimeLabel.textColor = [UIColor whiteColor];
        totalTimeLabel.font = [UIFont systemFontOfSize:12.0f];
        totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        [bottomImageView addSubview:totalTimeLabel];
        self.totalTimeLabel = totalTimeLabel;
        
        // 全屏
        UIButton *fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [fullScreenButton setImage:[UIImage oddityImage:@"video_max"] forState:UIControlStateNormal];
        [fullScreenButton setImage:[UIImage oddityImage:@"video_mini"] forState:UIControlStateSelected];
        [fullScreenButton addTarget:self action:@selector(fullScreenBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomImageView addSubview:fullScreenButton];
        self.fullScreenButton = fullScreenButton;
        
        // 正中间快进快退
        UIView *fastView = [[UIView alloc] init];
        fastView.backgroundColor = LPColorRGBA(0, 0, 0, 0.8);
        fastView.layer.cornerRadius = 4;
        fastView.layer.masksToBounds = YES;
        [self addSubview:fastView];
        self.fastView = fastView;
        
        UIImageView *fastImageView = [[UIImageView alloc] init];
        [fastView addSubview:fastImageView];
        self.fastImageView = fastImageView;
        
        UILabel *fastTimeLabel = [[UILabel alloc] init];
        fastTimeLabel.textColor = [UIColor whiteColor];
        fastTimeLabel.textAlignment = NSTextAlignmentCenter;
        fastTimeLabel.font = [UIFont systemFontOfSize:14.0];
        [fastView addSubview:fastTimeLabel];
        self.fastTimeLabel = fastTimeLabel;
        
        UIProgressView *fastProgressView = [[UIProgressView alloc] init];
        fastProgressView.progressTintColor = [UIColor whiteColor];
        fastProgressView.trackTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
        [fastView addSubview:fastProgressView];
        self.fastProgressView = fastProgressView;
        
        // 最底部进度条
        UIProgressView *bottomProgressView = [[UIProgressView alloc] init];
        bottomProgressView.progressTintColor = [UIColor colorFromHexString:LPColor15];
        bottomProgressView.trackTintColor = [UIColor clearColor];
        [self addSubview:bottomProgressView];
        self.bottomProgressView = bottomProgressView;
        
        // 缓冲图标
        MMMaterialDesignSpinner *activity = [[MMMaterialDesignSpinner alloc] init];
        activity.lineWidth = 1;
        activity.duration = 1;
        activity.tintColor = [[UIColor colorFromHexString:LPColor15] colorWithAlphaComponent:0.9];
        [self addSubview:activity];
        self.activity = activity;
        
        // 重播按钮
        UIButton *repeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [repeatBtn setImage:LPPlayerImage(@"video_repeat_video") forState:UIControlStateNormal];
        [repeatBtn addTarget:self action:@selector(repeatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.repeatBtn = repeatBtn;
        [self addSubview:repeatBtn];
        
        // 关闭按钮
        UIButton *closeButton = [[UIButton alloc] init];
        [closeButton setImage:LPPlayerImage(@"video_close") forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        self.closeButton = closeButton;
        
        // 加载失败按钮
        UIButton *failBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [failBtn setTitle:@"加载失败,点击重试" forState:UIControlStateNormal];
        [failBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        failBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        failBtn.backgroundColor = LPColorRGBA(0, 0, 0, 0.7);
        [failBtn addTarget:self action:@selector(failBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 添加子控件的约束
        [self makeSubViewsConstraints];
        
        // 初始化时重置ControlView
        [self lp_playerResetControlView];
        
        // app退到后台
        [noteCenter addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
        // app进入前台
        [noteCenter addObserver:self selector:@selector(appDidEnterPlayground) name:UIApplicationDidBecomeActiveNotification object:nil];
        [self listeningRotating];
    }
    return self;
}

// 添加子控件约束
- (void)makeSubViewsConstraints {
    [self.placeholderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.mas_top).offset(0);
        make.height.mas_equalTo(60);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.topImageView.mas_leading).offset(10);
        make.top.mas_offset(20);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.backButton.mas_trailing).offset(5);
        make.trailing.equalTo(self.lockScreenButton.mas_leading).offset(-10);
        make.centerY.equalTo(self.backButton.mas_centerY);
    }];

    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.height.mas_equalTo(50);
    }];

    [self.volumnButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomImageView.mas_leading).offset(5);
        make.bottom.equalTo(self.bottomImageView.mas_bottom).offset(-5);
        make.width.height.mas_equalTo(30);
    }];

    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.volumnButton.mas_trailing).offset(-3);
        make.centerY.equalTo(self.volumnButton.mas_centerY);
        make.width.mas_equalTo(43);
    }];

    [self.fullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.trailing.equalTo(self.bottomImageView.mas_trailing).offset(-5);
        make.centerY.equalTo(self.volumnButton.mas_centerY);
    }];

    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.fullScreenButton.mas_leading).offset(3);
        make.centerY.equalTo(self.volumnButton.mas_centerY);
        make.width.mas_equalTo(43);
    }];
    
    [self.videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(4);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-4);
        make.centerY.equalTo(self.currentTimeLabel.mas_centerY).offset(-1);
        make.height.mas_equalTo(30);
    }];

    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.trailing.equalTo(self.topImageView.mas_trailing).offset(-10);
        make.centerY.equalTo(self.backButton.mas_centerY);
    }];
 
    [self.lockScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.shareButton.mas_leading).offset(-18);
        make.centerY.equalTo(self.backButton.mas_centerY);
        make.width.height.mas_equalTo(40);
    }];

    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
     
        make.width.height.mas_equalTo(46);
        make.center.equalTo(self);
    }];
 
    [self.fastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(125);
        make.height.mas_equalTo(80);
        make.center.equalTo(self);
    }];
    
    [self.fastImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(32);
        make.height.mas_offset(32);
        make.top.mas_equalTo(5);
        make.centerX.mas_equalTo(self.fastView.mas_centerX);
    }];
    
    [self.fastTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.with.trailing.mas_equalTo(0);
        make.top.mas_equalTo(self.fastImageView.mas_bottom).offset(2);
    }];
    
    [self.fastProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(12);
        make.trailing.mas_equalTo(-12);
        make.top.mas_equalTo(self.fastTimeLabel.mas_bottom).offset(10);
    }];
    [self.bottomProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.mas_equalTo(45);
    }];
    [self.repeatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(0);
        make.top.mas_offset(0);
        make.width.height.mas_equalTo(26);
        
    }];
    [self.failBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(33);
    }];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutIfNeeded];
    
    [self loadVideoAtFirstTime];
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (currentOrientation == UIDeviceOrientationPortrait) {
        [self setOrientationPortraitConstraint];
    } else {
        [self setOrientationLandscapeConstraint];
    }
}

- (void)loadVideoAtFirstTime {
    self.playButton.alpha = 0;
    self.bottomImageView.alpha = 0;
    self.bottomProgressView.alpha = 1;
    self.topImageView.alpha = 0;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGRect rect = [self thumbRect];
    CGPoint point = [touch locationInView:self.videoSlider];
    if ([touch.view isKindOfClass:[UISlider class]]) {
        // 如果在滑块上点击就不响应pan手势
        if (point.x <= rect.origin.x + rect.size.width && point.x >= rect.origin.x) {
            return NO;
        }
    }
    return YES;
}

- (CGRect)thumbRect {
    return [self.videoSlider thumbRectForBounds:self.videoSlider.bounds
                                      trackRect:[self.videoSlider trackRectForBounds:self.videoSlider.bounds]
                                          value:self.videoSlider.value];
}

#pragma mark - Action
- (void)tapSliderAction:(UITapGestureRecognizer *)tap {
    if ([tap.view isKindOfClass:[UISlider class]]) {
        UISlider *slider = (UISlider *)tap.view;
        CGPoint point = [tap locationInView:slider];
        CGFloat length = slider.frame.size.width;
        // 视频跳转的value
        CGFloat tapValue = point.x / length;
        if ([self.delegate respondsToSelector:@selector(lp_controlView:progressSliderTap:)]) {
            [self.delegate lp_controlView:self progressSliderTap:tapValue];
        }
    }
}

// 不做处理，只是为了滑动slider其他地方不响应其他手势
- (void)panRecognizer:(UIPanGestureRecognizer *)sender {}

// 锁屏
- (void)lockScreenBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(lp_controlView:lockScreenAction:)]) {
        [self.delegate lp_controlView:self lockScreenAction:sender];
    }
}

// 播放
- (void)playBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(lp_controlView:playAction:)]) {
        [self.delegate lp_controlView:self playAction:sender];
    }
}

// 静音
- (void)volumnButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(lp_controlView:volumnAction:)]) {
        [self.delegate lp_controlView:self volumnAction:sender];
    }
    
}

// 关闭
- (void)closeBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(lp_controlView:closeAction:)]) {
        [self.delegate lp_controlView:self closeAction:sender];
    }
}

// 分享
- (void)shareButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(lp_controlView:shareAction:)]) {
        [self.delegate lp_controlView:self shareAction:sender];
    }
}

// 锁屏
-(void)lockScreenButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(lp_controlView:lockScreenAction:)]) {
        [self.delegate lp_controlView:self lockScreenAction:sender];
    }
}

// 返回
- (void)backButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(lp_controlView:backAction:)]) {
        [self.delegate lp_controlView:self backAction:sender];
    }
}
// 全屏
- (void)fullScreenBtnDidClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(lp_controlView:fullScreenAction:)]) {
        [self.delegate lp_controlView:self fullScreenAction:sender];        
    }
}

// 重播
- (void)repeatBtnClick:(UIButton *)sender {
    // 重置控制层View
    [self lp_playerResetControlView];
    [self lp_playerShowControlView];
    if ([self.delegate respondsToSelector:@selector(lp_controlView:repeatPlayAction:)]) {
        [self.delegate lp_controlView:self repeatPlayAction:sender];
    }
}

// 加载失败
- (void)failBtnClick:(UIButton *)sender {
    self.failBtn.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(lp_controlView:failAction:)]) {
        [self.delegate lp_controlView:self failAction:sender];
    }
}

- (void)progressSliderTouchBegan:(ASValueTrackingSlider *)sender {
    [self lp_playerCancelAutoFadeOutControlView];
    self.videoSlider.popUpView.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(lp_controlView:progressSliderTouchBegan:)]) {
        [self.delegate lp_controlView:self progressSliderTouchBegan:sender];
    }
}

- (void)progressSliderValueChanged:(ASValueTrackingSlider *)sender {
    if ([self.delegate respondsToSelector:@selector(lp_controlView:progressSliderValueChanged:)]) {
        [self.delegate lp_controlView:self progressSliderValueChanged:sender];
    }
}

- (void)progressSliderTouchEnded:(ASValueTrackingSlider *)sender {
    self.showing = YES;
    if ([self.delegate respondsToSelector:@selector(lp_controlView:progressSliderTouchEnded:)]) {
        [self.delegate lp_controlView:self progressSliderTouchEnded:sender];
    }
}


// 进入后台
- (void)appDidEnterBackground {
    [self lp_playerCancelAutoFadeOutControlView];
}

// 进入前台
- (void)appDidEnterPlayground {
    if (!self.isShrink) { [self lp_playerShowControlView]; }
}

- (void)playerPlayDidEnd {
    self.backgroundColor  = LPColorRGBA(0, 0, 0, .6);
    self.repeatBtn.hidden = NO;
    // 初始化显示controlView为YES
    self.showing = NO;
    // 延迟隐藏controlView
    [self lp_playerShowControlView];
}

// 设备方向改变
- (void)onDeviceOrientationChange {
    if (LPPlayerShared.isLockScreen) { return; }
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown || orientation == UIDeviceOrientationPortraitUpsideDown) { return; }
    if (LPPlayerOrientationIsLandscape) {
        [self setOrientationLandscapeConstraint];
    } else {
        [self setOrientationPortraitConstraint];
    }
   
    [self layoutIfNeeded];
}

// 横屏约束
- (void)setOrientationLandscapeConstraint {
    
    self.shrink = NO;
    self.fullScreen = YES;
    self.fullScreenButton.selected = self.isFullScreen;
}

// 竖屏约束
- (void)setOrientationPortraitConstraint {
    self.fullScreen = NO;
    self.fullScreenButton.selected = self.isFullScreen;
}

#pragma mark - Setter
- (void)setShrink:(BOOL)shrink {
    _shrink = shrink;
    self.closeButton.hidden = !self.isShrink;
}

#pragma mark - 私有方法
- (void)showControlView {
    
    self.playButton.alpha = 1;
    self.topImageView.alpha = 1;
    self.bottomImageView.alpha = 1;
    self.shrink = NO;
    self.bottomProgressView.alpha = 0;
 
    if (self.isFullScreen) {
        
        self.titleLabel.hidden = NO;
        self.backButton.hidden = NO;
        self.lockScreenButton.hidden = NO;
        self.shareButton.hidden = NO;
     
    } else {
        self.titleLabel.hidden = YES;
        self.backButton.hidden = YES;
        self.lockScreenButton.hidden = YES;
        self.shareButton.hidden = YES;
    }
}

- (void)hideControlView {
    self.playButton.alpha = 0;
    self.bottomImageView.alpha = 0;
    self.bottomProgressView.alpha = 1;
    self.topImageView.alpha = 0;
    if (self.isFullScreen && !self.playEnd) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
}

- (void)listeningRotating {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [noteCenter addObserver:self
                   selector:@selector(onDeviceOrientationChange)
                       name:UIDeviceOrientationDidChangeNotification
                     object:nil
     ];
}

- (void)autoFadeOutControlView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(lp_playerHideControlView) object:nil];
    [self performSelector:@selector(lp_playerHideControlView) withObject:nil afterDelay:LPPlayerAnimationTimeInterval];
}

#pragma mark - 公共方法
- (void)lp_playerResetControlView {
    [self.activity stopAnimating];
    self.videoSlider.value = 0;
    self.progressView.progress = 0;
    
    self.currentTimeLabel.text = @"00:00";
    self.totalTimeLabel.text = @"00:00";
    
    self.fastView.hidden = YES;
    self.repeatBtn.hidden = YES;
    self.failBtn.hidden = YES;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.shrink = NO;
    self.showing = NO;
    self.playEnd = NO;
    
    [self loadVideoAtFirstTime];
}

// 取消延时隐藏controlView的方法
- (void)lp_playerCancelAutoFadeOutControlView {
    self.showing = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

// 设置播放模型
- (void)lp_playerModel:(LPPlayerModel *)playerModel {
    _playerModel = playerModel;
    if (playerModel.title) {
        self.titleLabel.text = playerModel.title;
    }
    // 设置网络占位图片
    if (playerModel.placeHolderImageURLString) {
        NSURL *url = [NSURL URLWithString:playerModel.placeHolderImageURLString];
        
        [self.placeholderImageView sd_setImageWithURL:url placeholderImage:[UIImage sharePlaceholderImage:[UIColor lightGrayColor] sizes:CGSizeMake(80, 80)]];
    } else {
        self.placeholderImageView.image = playerModel.placeholderImage;
    }
}

// 正在播放（隐藏placeholderImageView）
- (void)lp_playerItemPlaying {
    [UIView animateWithDuration:0.8 animations:^{
        self.placeholderImageView.alpha = 0;
    }];
}


// 显示控制层
- (void)lp_playerShowControlView {
    if (self.isShowing) {
        [self lp_playerHideControlView];
        return;
    }
    [self lp_playerCancelAutoFadeOutControlView];
    [UIView animateWithDuration:LPPlayerControlBarAutoFadeOutTimeInterval animations:^{
        [self showControlView];
    } completion:^(BOOL finished) {
        self.showing = YES;
        [self autoFadeOutControlView];
    }];
    
}

//  隐藏控制层
- (void)lp_playerHideControlView {
    if (!self.isShowing) { return; }
    [self lp_playerCancelAutoFadeOutControlView];
    [UIView animateWithDuration:LPPlayerControlBarAutoFadeOutTimeInterval animations:^{
        [self hideControlView];
    }completion:^(BOOL finished) {
        self.showing = NO;
    }];
}

// 小屏播放
- (void)lp_playerBottomShrinkPlay {
    [self updateConstraints];
    [self layoutIfNeeded];
    [self hideControlView];
    self.shrink = YES;
}

// 在cell播放
- (void)lp_playerCellPlay {
    self.cellVideo = YES;
    self.shrink = NO;
    [self layoutIfNeeded];
    
}



- (void)lp_playerCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)value {
    // 当前时长进度progress
    NSInteger proMin = currentTime / 60;//当前秒
    NSInteger proSec = currentTime % 60;//当前分钟
    // duration 总时长
    NSInteger durMin = totalTime / 60;//总秒
    NSInteger durSec = totalTime % 60;//总分钟
    if (!self.isDragged) {
        // 更新slider
        self.videoSlider.value           = value;
        self.bottomProgressView.progress = value;
        // 更新当前播放时间
        self.currentTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    }
    // 更新总时间
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
}

- (void)lp_playerDraggedTime:(NSInteger)draggedTime totalTime:(NSInteger)totalTime isForward:(BOOL)forawrd hasPreview:(BOOL)preview {
    // 快进快退时候停止菊花
    [self.activity stopAnimating];
    // 拖拽的时长
    NSInteger proMin = draggedTime / 60;//当前秒
    NSInteger proSec = draggedTime % 60;//当前分钟
    
    //duration 总时长
    NSInteger durMin = totalTime / 60;//总秒
    NSInteger durSec = totalTime % 60;//总分钟
    
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    NSString *totalTimeStr = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
    CGFloat  draggedValue = (CGFloat)draggedTime/(CGFloat)totalTime;
    NSString *timeStr = [NSString stringWithFormat:@"%@ / %@", currentTimeStr, totalTimeStr];
    
    // 显示、隐藏预览窗
    self.videoSlider.popUpView.hidden = !preview;
    // 更新slider的值
    self.videoSlider.value = draggedValue;
    // 更新bottomProgressView的值
    self.bottomProgressView.progress = draggedValue;
    // 更新当前时间
    self.currentTimeLabel.text = currentTimeStr;
    // 正在拖动控制播放进度
    self.dragged = YES;
  
    if (forawrd) {
        self.fastImageView.image = LPPlayerImage(@"video_fast_forward");
    } else {
        self.fastImageView.image = LPPlayerImage(@"video_fast_backward");
    }
    self.fastView.hidden = preview;
    self.fastTimeLabel.text = timeStr;
    self.fastProgressView.progress = draggedValue;
    
}

- (void)lp_playerDraggedEnd
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.fastView.hidden = YES;
    });
    self.dragged = NO;
    // 结束滑动时候把开始播放按钮改为播放状态
    self.playButton.selected = YES;
    // 滑动结束延时隐藏controlView
    [self autoFadeOutControlView];
}

- (void)lp_playerDraggedTime:(NSInteger)draggedTime sliderImage:(UIImage *)image {
    // 拖拽的时长
    NSInteger proMin = draggedTime / 60;//当前秒
    NSInteger proSec = draggedTime % 60;//当前分钟
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    [self.videoSlider setImage:image];
    [self.videoSlider setText:currentTimeStr];
    self.fastView.hidden = YES;
}

//  progress显示缓冲进度
- (void)lp_playerSetProgress:(CGFloat)progress
{
    [self.progressView setProgress:progress animated:NO];
}

// 视频加载失败
- (void)lp_playerItemStatusFailed:(NSError *)error
{
    self.failBtn.hidden = NO;
}

// 加载的菊花
- (void)lp_playerActivity:(BOOL)animated {
    if (animated) {
        [self.activity startAnimating];
        self.fastView.hidden = YES;
        self.activity.hidden = NO;
        self.playButton.hidden = YES;
    } else {
        [self.activity stopAnimating];
        self.activity.hidden = YES;
        self.playButton.hidden = NO;
    }
}

// 播放完
- (void)lp_playerPlayEnd {
    self.backgroundColor  = LPColorRGBA(0, 0, 0, .6);
    self.repeatBtn.hidden = NO;
    self.playEnd = YES;
    self.showing = NO;
    // 隐藏controlView
    [self hideControlView];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    self.bottomProgressView.alpha = 0;
}

// 播放按钮状态
- (void)lp_playerPlayBtnState:(BOOL)state {
    self.playButton.selected = state;
}

- (void)lp_playerBackBtnState:(BOOL)state {
    self.backButton.hidden = state;
}

- (void)lp_playerShareBtnState:(BOOL)state {
    self.shareButton.hidden = state;
}

// 锁定屏幕方向按钮状态
- (void)lp_playerLockBtnState:(BOOL)state {
    self.lockScreenButton.selected = state;
}


#pragma mark - dealloc

- (void)dealloc {
    [noteCenter removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

@end
