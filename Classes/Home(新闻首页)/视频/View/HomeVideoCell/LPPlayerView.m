//
//  LPPlayerView.m
//  AVPlayerDemo
//
//  Created by dongdan on 2016/12/7.
//  Copyright © 2016年 dongdan. All rights reserved.
//

#import "LPPlayerView.h"
#import "LPPlayerModel.h"
#import "LPPlayerControlView.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+LPCustomPlayView.h"
#import <MediaPlayer/MediaPlayer.h>

// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionHorizontalMoved, // 横向移动
    PanDirectionVerticalMoved    // 纵向移动
};
@interface LPPlayerView()<UIGestureRecognizerDelegate,UIAlertViewDelegate>

// 播放属性
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVURLAsset *asset;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) id timeObserver;

// 是否自动播放
@property (nonatomic, assign) BOOL isAutoPlay;

@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong) AVAssetImageGenerator  *imageGenerator;


// 是否为全屏
@property (nonatomic, assign) BOOL isFullScreen;
// 是否锁定屏幕方向
@property (nonatomic, assign) BOOL isLocked;;
// 进入后台
@property (nonatomic, assign) BOOL didEnterBackground;
// 是否再次设置URL播放视频
@property (nonatomic, assign) BOOL repeatToPlay;


// 播放完了
@property (nonatomic, assign) BOOL playDidEnd;
// slider预览图
@property (nonatomic, strong) UIImage *thumbImg;

//  是否在cell上播放video
@property (nonatomic, assign) BOOL isCellVideo;
//  用来保存快进的总时长
@property (nonatomic, assign) CGFloat sumTime;

// player添加到tableView
@property (nonatomic, strong) UITableView *tableView;
// player所在cell的indexPath
@property (nonatomic, strong) NSIndexPath *indexPath;
// ViewController中页面是否消失
@property (nonatomic, assign) BOOL viewDisappear;
// 是否缩小视频在底部
@property (nonatomic, assign) BOOL isBottomVideo;
// 是否正在拖拽
@property (nonatomic, assign) BOOL  isDragged;


@property (nonatomic, strong) UISlider *volumeViewSlider;
// 定义一个实例变量，保存枚举值
@property (nonatomic, assign) PanDirection  panDirection;
// 播发器的几种状态
@property (nonatomic, assign) LPPlayerState state;

@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
// 视频URL的数组
@property (nonatomic, strong) NSArray *videoURLArray;
// 亮度view
@property (nonatomic, strong) LPBrightnessView *brightnessView;
// slider上次的值
@property (nonatomic, assign) CGFloat sliderLastValue;

// 是否播放本地文件
@property (nonatomic, assign) BOOL isLocalVideo;
// 是否在调节音量
@property (nonatomic, assign) BOOL isVolume;

@end

@implementation LPPlayerView

- (instancetype)init {
    if (self = [super init]) {
        self.cellPlayerOnCenter = YES;;
    }
    return self;
}

#pragma mark - getter

- (AVAssetImageGenerator *)imageGenerator {
    if (!_imageGenerator) {
        _imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:self.asset];
    }
    return _imageGenerator;
}

- (LPBrightnessView *)brightnessView {
    if (!_brightnessView) {
        _brightnessView = [LPBrightnessView sharedBrightnessView];
    }
    return _brightnessView;
}

#pragma mark - setter
- (void)setVideoURL:(NSURL *)videoURL {
    _videoURL = videoURL;
    // 每次加载视频URL都设置重播为NO
    self.repeatToPlay = NO;
    self.playDidEnd   = NO;
    
    // 添加通知
    [self addNotifications];
    
    self.isPauseByUser = YES;
    
    // 添加手势
    [self createGesture];
    
}

// 设置播放状态
- (void)setState:(LPPlayerState)state {
    _state = state;
    // 控制菊花显示、隐藏
    [self.controlView lp_playerActivity:state == LPPlayerStateBuffering];
    if (state == LPPlayerStatePlaying || state == LPPlayerStateBuffering) {
        // 隐藏占位图
        [self.controlView lp_playerItemPlaying];
    } else if (state == LPPlayerStateFailed) {
        NSError *error = [self.playerItem error];
        [self.controlView lp_playerItemStatusFailed:error];
    }
}

// 单击和双击
- (void)createGesture {
    // 单击
    self.singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
    self.singleTap.delegate                = self;
    self.singleTap.numberOfTouchesRequired = 1; //手指数
    self.singleTap.numberOfTapsRequired    = 1;
    [self addGestureRecognizer:self.singleTap];
    
    // 双击(播放/暂停)
    self.doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
    self.doubleTap.delegate                = self;
    self.doubleTap.numberOfTouchesRequired = 1; //手指数
    self.doubleTap.numberOfTapsRequired    = 2;
    
    [self addGestureRecognizer:self.doubleTap];
    
    // 解决点击当前view时候响应其他控件事件
    [self.singleTap setDelaysTouchesBegan:YES];
    [self.doubleTap setDelaysTouchesBegan:YES];
    // 双击失败响应单击事件
    [self.singleTap requireGestureRecognizerToFail:self.doubleTap];
}

#pragma mark - 添加通知
- (void)addNotifications {
    // app退到后台
    [noteCenter addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    // app进入前台
    [noteCenter addObserver:self selector:@selector(appDidEnterPlayground) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // 监测设备方向
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [noteCenter addObserver:self
                   selector:@selector(onDeviceOrientationChange)
                       name:UIDeviceOrientationDidChangeNotification
                     object:nil];
    
    [noteCenter addObserver:self
                   selector:@selector(onStatusBarOrientationChange)
                       name:UIApplicationDidChangeStatusBarOrientationNotification
                     object:nil];
}


#pragma mark - layoutSubViews
- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutIfNeeded];
    self.playerLayer.frame = self.bounds;
}

#pragma mark - 单例模式
+ (instancetype)sharedPlayerView {
    static LPPlayerView *playerView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerView = [[LPPlayerView alloc] init];
    });
    return playerView;
}


#pragma mark - addPlayerToParentView(将播放器添加到指定View)
- (void)addPlayerToParentView: (UIView *)view {
    [self removeFromSuperview];
    [view addSubview:self];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsZero);
    }];
}

#pragma mark - 设置播放器相关信息

// 播放相关数据
- (void)setPlayerModel:(LPPlayerModel *)playerModel {
    _playerModel = playerModel;
    if (playerModel.seekTime) {
        self.seekTime = playerModel.seekTime;
    }
    [self.controlView lp_playerModel:playerModel];
    if (playerModel.tableView && playerModel.indexPath && playerModel.videoURL) {
        [self cellVideoWithTableView:playerModel.tableView AtIndexPath:playerModel.indexPath];
    }
    [self addPlayerToParentView:playerModel.parentView];
    self.videoURL = playerModel.videoURL;

}

- (void)setControlView:(LPPlayerControlView *)controlView {
    if (_controlView) {
        return;
    }
    _controlView = controlView;
    controlView.delegate = self;
    [self addSubview:controlView];
    [controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(self);
    }];
}

// 添加和移除监控
- (void)setPlayerItem:(AVPlayerItem *)playerItem {
    if (_playerItem == playerItem) {
        return;
    }
    if (_playerItem) {
        [noteCenter removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
        [_playerItem removeObserver:self forKeyPath:@"status"];
        [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [_playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [_playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    }
    
    _playerItem = playerItem;
    if (playerItem) {
        [noteCenter addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
        [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        // 缓冲区空了，需要等待数据
        [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
        // 缓冲区有足够数据可以播放了
        [playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)setTableView:(UITableView *)tableView {
    if (_tableView == tableView) { return; }
    if (_tableView) {
        [_tableView removeObserver:self forKeyPath:kLPPlayerViewContentOffset];
    }
    _tableView = tableView;
    if (tableView) { [tableView addObserver:self forKeyPath:kLPPlayerViewContentOffset options:NSKeyValueObservingOptionNew context:nil]; }
}

- (void)setPlayerLayerGravity:(LPPlayerLayerGravity)playerLayerGravity {
    _playerLayerGravity = playerLayerGravity;
    switch (playerLayerGravity) {
        case LPPlayerLayerGravityResize:
            self.playerLayer.videoGravity = AVLayerVideoGravityResize;
            break;
        case LPPlayerLayerGravityResizeAspect:
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            break;
        case LPPlayerLayerGravityResizeAspectFill:
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            break;
        default:
            break;
    }
}


- (void)playerControlView:(LPPlayerControlView *)controlView playerModel:(LPPlayerModel *)playerModel {
    if (!controlView) {
        LPPlayerControlView *defaultControlView = [[LPPlayerControlView alloc] init];
        self.controlView = defaultControlView;
    } else {
        self.controlView = controlView;
    }
    self.playerModel = playerModel;
    
}



#pragma mark - 私有方法
- (void)cellVideoWithTableView:(UITableView *)tableView AtIndexPath:(NSIndexPath *)indexPath {
    // 如果页面没有消失，并且playerItem有值，需要重置player(其实就是点击播放其他视频时候)
    if (!self.viewDisappear && self.playerItem) {
        [self resetPlayer];
    }
    // 在cell上播放视频
    self.isCellVideo = YES;
    // viewDisappear改为NO
    self.viewDisappear = NO;
    // 设置tableview
    self.tableView = tableView;
    // 设置indexPath
    self.indexPath = indexPath;
    // 在cell播放
    [self.controlView lp_playerCellPlay];
}

#pragma mark - 公共方法
// 播放
- (void)play {
    [self.controlView lp_playerPlayBtnState:YES];
    if (self.state == LPPlayerStatePause) {
        self.state = LPPlayerStatePlaying;
    }
    self.isPauseByUser = NO;
    [self.player play];
}

// 暂停
- (void)pause {
    [self.controlView lp_playerPlayBtnState:NO];
    if (self.state == LPPlayerStatePlaying) {
        self.state = LPPlayerStatePause;
    }
    self.isPauseByUser = YES;
    [self.player pause];
}

// 初始化配置
- (void)configurePlayer {
    self.asset = [AVURLAsset assetWithURL:self.videoURL];
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.asset];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.backgroundColor = [UIColor blackColor];
    // 默认视频填充模式
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.isAutoPlay = YES;
    // 添加播放进度计时器
    [self createTimer];
    // 获取系统音量
    [self configureVolume];
    // 本地文件不设置ZFPlayerStateBuffering状态
    if ([self.videoURL.scheme isEqualToString:@"file"]) {
        self.state = LPPlayerStatePlaying;
        self.isLocalVideo = YES;
        
    } else {
        self.state = LPPlayerStateBuffering;
        self.isLocalVideo = NO;
  
    }
    [self play];
}

- (void)createTimer {
    __weak typeof(self) weakSelf = self;
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, 1) queue:queue usingBlock:^(CMTime time){
        AVPlayerItem *currentItem = weakSelf.playerItem;
        NSArray *loadedRanges = currentItem.seekableTimeRanges;
        if (loadedRanges.count > 0 && currentItem.duration.timescale != 0) {
            NSInteger currentTime = (NSInteger)CMTimeGetSeconds([currentItem currentTime]);
            CGFloat totalTime     = (CGFloat)currentItem.duration.value / currentItem.duration.timescale;
            CGFloat value         = CMTimeGetSeconds([currentItem currentTime]) / totalTime;
            [weakSelf.controlView lp_playerCurrentTime:currentTime totalTime:totalTime sliderValue:value];
        }
    }];
}

//  获取系统音量
- (void)configureVolume {
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    _volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    
    // 使用这个category的应用不会随着手机静音键打开而静音，可在手机静音下播放声音
    NSError *setCategoryError = nil;
    BOOL success = [[AVAudioSession sharedInstance]
                    setCategory: AVAudioSessionCategoryPlayback
                    error: &setCategoryError];
    
    if (!success) { /* handle the error in setCategoryError */ }
    
    // 监听耳机插入和拔掉通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:nil];
}

// 耳机插入、拔出事件
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (routeChangeReason) {
            
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            // 耳机插入
            break;
            
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {
            // 耳机拔掉
            // 拔掉耳机继续播放
            [self play];
        }
            break;
            
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}

// 自动播放
- (void)autoPlayVideo {
    [self configurePlayer];
}

- (void)resetPlayer {
    
    self.hidden = NO;
    // 改为为播放完
    self.playDidEnd = NO;
    self.playerItem  = nil;
    self.didEnterBackground = NO;
    // 视频跳转秒数置0
    self.seekTime = 0;
    self.isAutoPlay = NO;
    if (self.timeObserver) {
        [self.player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
    }
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 暂停
    [self pause];
    // 移除原来的layer
    [self.playerLayer removeFromSuperlayer];
    // 替换PlayerItem为nil
    [self.player replaceCurrentItemWithPlayerItem:nil];
    // 把player置为nil
    self.imageGenerator = nil;
    self.player  = nil;
    [self.controlView lp_playerResetControlView];
    self.controlView   = nil;
    // 非重播时，移除当前playerView
    if (!self.repeatToPlay) { [self removeFromSuperview]; }
    // 底部播放video改为NO
    self.isBottomVideo = NO;
    // cell上播放视频 && 不是重播时
    if (self.isCellVideo && !self.repeatToPlay) {
        // vicontroller中页面消失
        self.viewDisappear = YES;
        self.isCellVideo   = NO;
        self.tableView     = nil;
        self.indexPath     = nil;
    }
}

//  在当前页面，设置新的视频时候调用此方法
- (void)resetToPlayNewVideo:(LPPlayerModel *)playerModel {
    self.repeatToPlay = YES;
    [self resetPlayer];
    self.playerModel = playerModel;
    [self configurePlayer];
}



#pragma mark - UIPanGestureRecognizer手势方法

- (void)panDirection:(UIPanGestureRecognizer *)pan {
    //根据在view上Pan的位置，确定是调音量还是亮度
    CGPoint locationPoint = [pan locationInView:self];
    
    // 我们要响应水平移动和垂直移动
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [pan velocityInView:self];
    
    // 判断是垂直移动还是水平移动
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{ // 开始移动
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) { // 水平移动
                // 取消隐藏
                self.panDirection = PanDirectionHorizontalMoved;
                // 给sumTime初值
                CMTime time       = self.player.currentTime;
                self.sumTime      = time.value/time.timescale;
            }
            else if (x < y){ // 垂直移动
                self.panDirection = PanDirectionVerticalMoved;
                // 开始滑动的时候,状态改为正在控制音量
                if (locationPoint.x > self.bounds.size.width / 2) {
                    self.isVolume = YES;
                }else { // 状态改为显示亮度调节
                    self.isVolume = NO;
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{ // 正在移动
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    [self horizontalMoved:veloctyPoint.x]; // 水平移动的方法只要x方向的值
                    break;
                }
                case PanDirectionVerticalMoved:{
                    [self verticalMoved:veloctyPoint.y]; // 垂直移动方法只要y方向的值
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{ // 移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    self.isPauseByUser = NO;
                    [self seekToTime:self.sumTime completionHandler:nil];
                    // 把sumTime滞空，不然会越加越多
                    self.sumTime = 0;
                    break;
                }
                case PanDirectionVerticalMoved:{
                    // 垂直移动结束后，把状态改为不再控制音量
                    self.isVolume = NO;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

// pan垂直移动的方法
- (void)verticalMoved:(CGFloat)value {
    self.isVolume ? (self.volumeViewSlider.value -= value / 10000) : ([UIScreen mainScreen].brightness -= value / 10000);
}

//  pan水平移动的方法
 
- (void)horizontalMoved:(CGFloat)value {
    // 每次滑动需要叠加时间
    self.sumTime += value / 200;
    // 需要限定sumTime的范围
    CMTime totalTime = self.playerItem.duration;
    CGFloat totalMovieDuration = (CGFloat)totalTime.value/totalTime.timescale;
    if (self.sumTime > totalMovieDuration) { self.sumTime = totalMovieDuration;}
    if (self.sumTime < 0) { self.sumTime = 0; }
    
    BOOL style = false;
    if (value > 0) { style = YES; }
    if (value < 0) { style = NO; }
    if (value == 0) { return; }
    
    self.isDragged = YES;
    [self.controlView lp_playerDraggedTime:self.sumTime totalTime:totalMovieDuration isForward:style hasPreview:NO];
}

- (NSString *)durationStringWithTime:(int)time {
    // 获取分钟
    NSString *min = [NSString stringWithFormat:@"%02d",time / 60];
    // 获取秒数
    NSString *sec = [NSString stringWithFormat:@"%02d",time % 60];
    return [NSString stringWithFormat:@"%@:%@", min, sec];
}

#pragma mark - 播放监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.player.currentItem) {
        dispatch_async(dispatch_get_main_queue(), ^{
        if ([keyPath isEqualToString:@"status"]) {
            if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
                [self setNeedsLayout];
                [self layoutIfNeeded];
                // 添加playerLayer到self.layer
                [self.layer insertSublayer:self.playerLayer atIndex:0];
                self.state = LPPlayerStatePlaying;
                // 加载完成后，再添加平移手势
                // 添加平移手势，用来控制音量、亮度、快进快退
       
                UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDirection:)];
                panRecognizer.delegate = self;
                [panRecognizer setMaximumNumberOfTouches:1];
                [panRecognizer setDelaysTouchesBegan:YES];
                [panRecognizer setDelaysTouchesEnded:YES];
                [panRecognizer setCancelsTouchesInView:YES];
                [self addGestureRecognizer:panRecognizer];
                
                // 跳到xx秒播放视频
                if (self.seekTime) {
                    [self seekToTime:self.seekTime completionHandler:nil];
                }
                self.player.muted = self.mute;
            } else if (self.player.currentItem.status == AVPlayerItemStatusFailed) {
                self.state = LPPlayerStateFailed;
            }
        } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            // 计算缓冲进度
            NSTimeInterval timeInterval = [self availableDuration];
            CMTime duration             = self.playerItem.duration;
            CGFloat totalDuration       = CMTimeGetSeconds(duration);
            if (!self.isPauseByUser) {
                [self play];
            } // 如果没有被用户暂停，就继续播放，只要缓冲就播放。
            [self.controlView lp_playerSetProgress:timeInterval / totalDuration];
            
        } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
            
            // 当缓冲是空的时候
            if (self.playerItem.playbackBufferEmpty) {
                self.state = LPPlayerStateBuffering;
                [self bufferingSomeSecond];
            }
            
        } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
            
            // 当缓冲好的时候
            if (self.playerItem.playbackLikelyToKeepUp && self.state == LPPlayerStateBuffering){
                self.state = LPPlayerStatePlaying;
            }
            
        }
          });
    } else if (object == self.tableView) {
        if ([keyPath isEqualToString:kLPPlayerViewContentOffset]) {
            if (self.isFullScreen) { return; }
            // 当tableview滚动时处理playerView的位置
            [self handleScrollOffsetWithDict:change];
        }
    }
                          
}

#pragma mark - 缓冲较差时候

// 缓冲较差时候回调这里
 
- (void)bufferingSomeSecond
{
    self.state = LPPlayerStateBuffering;
    // playbackBufferEmpty会反复进入，因此在bufferingOneSecond延时播放执行完之前再调用bufferingSomeSecond都忽略
    __block BOOL isBuffering = NO;
    if (isBuffering) return;
    isBuffering = YES;
    
    // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    [self.player pause];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 如果此时用户已经暂停了，则不再需要开启播放了
        if (self.isPauseByUser) {
            isBuffering = NO;
            return;
        }
        
        [self play];
        // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        isBuffering = NO;
        if (!self.playerItem.isPlaybackLikelyToKeepUp) { [self bufferingSomeSecond]; }
        
    });
}
// 计算缓冲进度
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds        = CMTimeGetSeconds(timeRange.start);
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

#pragma mark - Action
// 单击
- (void)singleTapAction:(UIGestureRecognizer *)gesture {
    if ([gesture isKindOfClass:[NSNumber class]] && ![(id)gesture boolValue]) {
        [self fullScreenAction];
        return;
    }
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        if (self.isBottomVideo && !self.isFullScreen) {
                [self fullScreenAction];
            } else {
            if (self.playDidEnd) {
                return;
            } else {
                [self.controlView lp_playerShowControlView];
            }
        }
    }
}

//  双击播放/暂停
 
- (void)doubleTapAction:(UIGestureRecognizer *)gesture {
    if (self.playDidEnd) { return;  }
    // 显示控制层
    [self.controlView lp_playerCancelAutoFadeOutControlView];
    [self.controlView lp_playerShowControlView];
    if (self.isPauseByUser) {
        [self play];
    } else {
        [self pause];
    }
    if (!self.isAutoPlay) {
        self.isAutoPlay = YES;
        [self configurePlayer];
    }
}

// 全屏
- (void)fullScreenAction {
    // 退出全屏解锁
    if(LPPlayerShared.isLockScreen) {
        [self unLockScreen];
        return;
    }
    if (self.isFullScreen) {
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
        self.isFullScreen = NO;
       
        return;
    } else {
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (orientation == UIDeviceOrientationLandscapeRight) {
            [self interfaceOrientation:UIInterfaceOrientationLandscapeLeft];
        } else {
            [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
        }
        self.isFullScreen = YES;
    }
   
}

#pragma mark - 解锁屏幕
- (void)unLockScreen {
    LPPlayerShared.isLockScreen = NO;
    [self.controlView lp_playerLockBtnState:NO];
    self.isLocked = NO;
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
   
}

#pragma mark - 屏幕转屏相关
// 状态条变化通知（在前台播放才去处理）
- (void)onStatusBarOrientationChange {
    if (!self.didEnterBackground) {
        // 获取到当前状态条的方向
        UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
        if (currentOrientation == UIInterfaceOrientationPortrait) {
            [self setOrientationPortraitConstraint];
            if (self.cellPlayerOnCenter) {
                [self.tableView scrollToRowAtIndexPath:self.indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            }
            [self.brightnessView removeFromSuperview];
            [[UIApplication sharedApplication].keyWindow addSubview:self.brightnessView];
            [self.brightnessView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(155);
                make.leading.mas_equalTo((ScreenWidth - 155)/2);
                make.top.mas_equalTo((ScreenHeight - 155)/2);
            }];
        } else {
            if (currentOrientation == UIInterfaceOrientationLandscapeRight) {
                [self toOrientation:UIInterfaceOrientationLandscapeRight];
            } else if (currentOrientation == UIDeviceOrientationLandscapeLeft){
                [self toOrientation:UIInterfaceOrientationLandscapeLeft];
            }
            [self.brightnessView removeFromSuperview];
            [self addSubview:self.brightnessView];
            [self.brightnessView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self);
                make.width.height.mas_equalTo(155);
            }];
            
        }
    }
}

#pragma mark - tableViewContentOffset

//  KVO TableViewContentOffset
- (void)handleScrollOffsetWithDict:(NSDictionary*)dict {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
    NSArray *visableCells = self.tableView.visibleCells;
    if ([visableCells containsObject:cell]) {
        // 在显示中
        [self updatePlayerViewToCell];
    } else {
        if (self.stopPlayWhileCellNotVisable) {
            [self resetPlayer];
        } else {
            // 在底部
            [self updatePlayerViewToBottom];
        }
    }
}

//  回到cell显示
- (void)updatePlayerViewToCell {
    if (!self.isBottomVideo) { return; }
    self.isBottomVideo = NO;
    [self setOrientationPortraitConstraint];
    [self.controlView lp_playerCellPlay];
    
    [self play];    
    self.hidden = NO;
    
    
}

//  缩小到底部，显示小视频
- (void)updatePlayerViewToBottom {
    if (self.isBottomVideo) { return; }
    
    [self pause];
    self.hidden = YES;
    
    self.isBottomVideo = YES;
    if (self.playDidEnd) { // 如果播放完了，滑动到小屏bottom位置时，直接resetPlayer
        self.repeatToPlay = NO;
        self.playDidEnd   = NO;
        [self resetPlayer];
        return;
    }
    [self layoutIfNeeded];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        CGFloat width = ScreenWidth * 0.5 - 20;
        CGFloat height = (self.bounds.size.height / self.bounds.size.width);
        make.width.mas_equalTo(width);
        make.height.equalTo(self.mas_width).multipliedBy(height);
        make.trailing.mas_equalTo(-10);
        make.bottom.mas_equalTo(-self.tableView.contentInset.bottom + 34);
        
        
    }];
    // 小屏播放
    [self.controlView lp_playerBottomShrinkPlay];
}

// 屏幕方向
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft) {
        // 设置横屏
        [self setOrientationLandscapeConstraint:orientation];
    } else if (orientation == UIInterfaceOrientationPortrait) {
        // 设置竖屏
        [self setOrientationPortraitConstraint];
    }
}

// 设置横屏的约束
- (void)setOrientationLandscapeConstraint:(UIInterfaceOrientation)orientation {
    [self toOrientation:orientation];
    self.isFullScreen = YES;
}

// 设置竖屏的约束
- (void)setOrientationPortraitConstraint
{
    if (self.isCellVideo) {
        UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
        NSArray *visableCells = self.tableView.visibleCells;
        self.isBottomVideo = NO;
        if (![visableCells containsObject:cell]) {
            [self updatePlayerViewToBottom];
        } else {
            [self addPlayerToParentView:self.playerModel.parentView];
        }
    } else {
        [self addPlayerToParentView:self.playerModel.parentView];
    }
    
    [self toOrientation:UIInterfaceOrientationPortrait];
    self.isFullScreen = NO;
}

- (void)toOrientation:(UIInterfaceOrientation)orientation {
    // 获取到当前状态条的方向
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    // 判断如果当前方向和要旋转的方向一致,那么不做任何操作
    if (currentOrientation == orientation) {
        return;
    }
    
    // 根据要旋转的方向,使用Masonry重新修改限制
    if (orientation != UIInterfaceOrientationPortrait) {//
        // 这个地方加判断是为了从全屏的一侧,直接到全屏的另一侧不用修改限制,否则会出错;
        if (currentOrientation == UIInterfaceOrientationPortrait) {
            [self removeFromSuperview];
            LPBrightnessView *brightnessView = [LPBrightnessView sharedBrightnessView];
            [[UIApplication sharedApplication].keyWindow insertSubview:self belowSubview:brightnessView];
            [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(ScreenHeight));
                make.height.equalTo(@(ScreenWidth));
                make.center.equalTo([UIApplication sharedApplication].keyWindow);
            }];
        }
    }
    // iOS6.0之后,设置状态条的方法能使用的前提是shouldAutorotate为NO,也就是说这个视图控制器内,旋转要关掉;
    // 也就是说在实现这个方法的时候-(BOOL)shouldAutorotate返回值要为NO
    [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];
    // 获取旋转状态条需要的时间:
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    // 更改了状态条的方向,但是设备方向UIInterfaceOrientation还是正方向的,这就要设置给你播放视频的视图的方向设置旋转
    // 给你的播放视频的view视图设置旋转
    self.transform = CGAffineTransformIdentity;
    self.transform = [self getTransformRotationAngle];
    // 开始旋转
    [UIView commitAnimations];
    [self.controlView layoutIfNeeded];
    [self.controlView setNeedsLayout];
}

// 获取变换的旋转角度
- (CGAffineTransform)getTransformRotationAngle {
    // 状态条的方向已经设置过,所以这个就是你想要旋转的方向
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    // 根据要进行旋转的方向来计算旋转的角度
    if (orientation == UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft){
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if(orientation == UIInterfaceOrientationLandscapeRight){
        return CGAffineTransformMakeRotation(M_PI_2);
    }
    return CGAffineTransformIdentity;
}

//  屏幕方向发生变化会调用这里
- (void)onDeviceOrientationChange
{
    if (!self.player) { return; }
    if (LPPlayerShared.isLockScreen) { return; }
    if (self.didEnterBackground) { return; };
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown ) { return; }
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
        }
            break;
        case UIInterfaceOrientationPortrait:{
            if (self.isFullScreen) {
                [self toOrientation:UIInterfaceOrientationPortrait];
                
            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            if (self.isFullScreen == NO) {
                [self toOrientation:UIInterfaceOrientationLandscapeLeft];
                self.isFullScreen = YES;
            } else {
                [self toOrientation:UIInterfaceOrientationLandscapeLeft];
            }
            
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            if (self.isFullScreen == NO) {
                [self toOrientation:UIInterfaceOrientationLandscapeRight];
                self.isFullScreen = YES;
            } else {
                [self toOrientation:UIInterfaceOrientationLandscapeRight];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - 通知
- (void)moviePlayDidEnd:(NSNotification *)notification {
    self.state = LPPlayerStateStopped;
    if (self.isBottomVideo && !self.isFullScreen) { // 播放完了，如果是在小屏模式 && 在bottom位置，直接关闭播放器
        self.repeatToPlay = NO;
        self.playDidEnd   = NO;
        [self resetPlayer];
    } else {
        if (!self.isDragged) { // 如果不是拖拽中，直接结束播放
            self.playDidEnd = YES;
            [self.controlView lp_playerPlayEnd];
        }
    }
}

//  应用退到后台
- (void)appDidEnterBackground {
    self.didEnterBackground     = YES;
    // 退到后台锁定屏幕方向
    LPPlayerShared.isLockScreen = YES;
    [_player pause];
    self.state  = LPPlayerStatePause;
}

// 应用进入前台
- (void)appDidEnterPlayground {
    self.didEnterBackground     = NO;
    // 根据是否锁定屏幕方向 来恢复单例里锁定屏幕的方向
    LPPlayerShared.isLockScreen = self.isLocked;
    if (!self.isPauseByUser) {
        self.state = LPPlayerStatePlaying;
        self.isPauseByUser = NO;
        [self play];
    }
}


#pragma mark - LPPlayerControlViewDelegate
- (void)lp_controlView:(UIView *)controlView playAction:(UIButton *)sender {
    
    self.isPauseByUser = !self.isPauseByUser;
    if (self.isPauseByUser) {
        [self pause];
        if (self.state == LPPlayerStatePlaying) { self.state = LPPlayerStatePause;}
    } else {
        [self play];
        if (self.state == LPPlayerStatePause) { self.state = LPPlayerStatePlaying; }
    }
    if (!self.isAutoPlay) {
        self.isAutoPlay = YES;
        [self configurePlayer];
    }
}

- (void)lp_controlView:(UIView *)controlView backAction:(UIButton *)sender {
    
     [self interfaceOrientation:UIInterfaceOrientationPortrait];
}

- (void)lp_controlView:(UIView *)controlView detailBackAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(lp_playerDetailBackAction)]) {
        [self.delegate lp_playerDetailBackAction];
    }
}

- (void)lp_controlView:(UIView *)controlView closeAction:(UIButton *)sender {
    [self resetPlayer];
    [self removeFromSuperview];
}

// 静音
- (void)lp_controlView:(UIView *)controlView volumnAction:(UIButton *)sender {
    self.player.muted = sender.selected;
}

// 全屏
- (void)lp_controlView:(UIView *)controlView fullScreenAction:(UIButton *)sender {
    [self fullScreenAction];
}

// 锁屏
- (void)lp_controlView:(UIView *)controlView lockScreenAction:(UIButton *)sender {
    self.isLocked = sender.selected;
    // 调用AppDelegate单例记录播放状态是否锁屏
    LPPlayerShared.isLockScreen = sender.selected;
}
// 分享
- (void)lp_controlView:(UIView *)controlView shareAction:(UIButton *)sender {
    NSLog(@"视频分享");
}

// 重播
- (void)lp_controlView:(UIView *)controlView repeatPlayAction:(UIButton *)sender {
    // 没有播放完
    self.playDidEnd   = NO;
    // 重播改为NO
    self.repeatToPlay = NO;
    [self seekToTime:0 completionHandler:nil];
    
    if ([self.videoURL.scheme isEqualToString:@"file"]) {
        self.state = LPPlayerStatePlaying;
    } else {
        self.state = LPPlayerStateBuffering;
    }
}

// 加载失败
- (void)lp_controlView:(UIView *)controlView failAction:(UIButton *)sender {
    [self configurePlayer];
}

- (void)lp_controlView:(UIView *)controlView progressSliderTap:(CGFloat)value {
    // 视频总时间长度
    CGFloat total = (CGFloat)self.playerItem.duration.value / self.playerItem.duration.timescale;
    //计算出拖动的当前秒数
    NSInteger dragedSeconds = floorf(total * value);
    
    [self.controlView lp_playerPlayBtnState:YES];
    [self seekToTime:dragedSeconds completionHandler:^(BOOL finished) {}];
    
}

- (void)lp_controlView:(UIView *)controlView progressSliderValueChanged:(UISlider *)slider {
    // 拖动改变视频播放进度
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        self.isDragged = YES;
        BOOL style = false;
        CGFloat value   = slider.value - self.sliderLastValue;
        if (value > 0) { style = YES; }
        if (value < 0) { style = NO; }
        if (value == 0) { return; }
        
        self.sliderLastValue  = slider.value;
        
        CGFloat totalTime     = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
        
        //计算出拖动的当前秒数
        CGFloat dragedSeconds = floorf(totalTime * slider.value);
        
        //转换成CMTime才能给player来控制播放进度
        CMTime dragedCMTime   = CMTimeMake(dragedSeconds, 1);
        
        [controlView lp_playerDraggedTime:dragedSeconds totalTime:totalTime isForward:style hasPreview:self.isFullScreen ? self.hasPreviewView : NO];
        
        if (totalTime > 0) { // 当总时长 > 0时候才能拖动slider
            if (self.isFullScreen && self.hasPreviewView) {
                
                [self.imageGenerator cancelAllCGImageGeneration];
                self.imageGenerator.appliesPreferredTrackTransform = YES;
                self.imageGenerator.maximumSize = CGSizeMake(100, 56);
                AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error) {
                    if (result != AVAssetImageGeneratorSucceeded) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                             [controlView lp_playerDraggedTime:dragedSeconds sliderImage:self.thumbImg ? : [UIImage sharePlaceholderImage:[UIColor colorFromHexString:@"#f8f8f8"] sizes:CGSizeMake(80, 80)]];
                        });
                    } else {
                        self.thumbImg = [UIImage imageWithCGImage:im];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [controlView lp_playerDraggedTime:dragedSeconds sliderImage:self.thumbImg ? : [UIImage sharePlaceholderImage:[UIColor colorFromHexString:@"#f8f8f8"] sizes:CGSizeMake(80, 80)]];
                        });
                    }
                };
                [self.imageGenerator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:dragedCMTime]] completionHandler:handler];
            }
        } else {
            // 此时设置slider值为0
            slider.value = 0;
        }
        
    } else { // player状态加载失败
        // 此时设置slider值为0
        slider.value = 0;
    }
    
}

- (void)lp_controlView:(UIView *)controlView progressSliderTouchEnded:(UISlider *)slider {
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        self.isPauseByUser = NO;
        self.isDragged = NO;
        // 视频总时间长度
        CGFloat total = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
        //计算出拖动的当前秒数
        NSInteger dragedSeconds = floorf(total * slider.value);
        [self seekToTime:dragedSeconds completionHandler:nil];
    }
}

// 跳转到某时间点
- (void)seekToTime:(NSInteger)dragedSeconds completionHandler:(void (^)(BOOL finished))completionHandler {
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        // seekTime:completionHandler:不能精确定位
        // 如果需要精确定位，可以使用seekToTime:toleranceBefore:toleranceAfter:completionHandler:
        // 转换成CMTime才能给player来控制播放进度
        [self.controlView lp_playerActivity:YES];
        [self.player pause];
        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1); //kCMTimeZero
        __weak typeof(self) weakSelf = self;
        [self.player seekToTime:dragedCMTime toleranceBefore:CMTimeMake(1,1) toleranceAfter:CMTimeMake(1,1) completionHandler:^(BOOL finished) {
            [weakSelf.controlView lp_playerActivity:NO];
            // 视频跳转回调
            if (completionHandler) {
                completionHandler(finished);
            }
            [weakSelf.player play];
            weakSelf.seekTime = 0;
            weakSelf.isDragged = NO;
            // 结束滑动
            [weakSelf.controlView lp_playerDraggedEnd];
            // 播放器是否能无阻塞的播放 并且是非本地文件
            if (!weakSelf.playerItem.isPlaybackLikelyToKeepUp && !weakSelf.isLocalVideo) {
                weakSelf.state = LPPlayerStateBuffering;
            }
            
        }];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        if ((self.isCellVideo && !self.isFullScreen) || self.playDidEnd){
            return NO;
        }
    }
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if (self.isBottomVideo && !self.isFullScreen) {
            return NO;
        }
    }
    if ([touch.view isKindOfClass:[UISlider class]]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - dealloc
- (void)dealloc {
    [self removePlayerObserver];
}

- (void)removePlayerObserver {
    [self resetPlayer];
    LPPlayerShared.isLockScreen = NO;
    [self.controlView lp_playerCancelAutoFadeOutControlView];
    // 移除通知
    [noteCenter removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}



@end
