//
//  LPPlayerView.h
//  AVPlayerDemo
//
//  Created by dongdan on 2016/12/7.
//  Copyright © 2016年 dongdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPPlayerControlViewDelegate.h"

@class LPPlayerModel;
@class LPPlayerControlView;

@protocol LPPlayerDelegate <NSObject>
@optional
// 返回按钮事件
//- (void)lp_playerBackAction;

- (void)lp_playerDetailBackAction;

@end

// playerLayer的填充模式（默认：等比例填充，直到一个维度到达区域边界）
typedef NS_ENUM(NSInteger, LPPlayerLayerGravity) {
    LPPlayerLayerGravityResize,           // 非均匀模式。两个维度完全填充至整个视图区域
    LPPlayerLayerGravityResizeAspect,     // 等比例填充，直到一个维度到达区域边界
    LPPlayerLayerGravityResizeAspectFill  // 等比例填充，直到填充满整个视图区域，其中一个维度的部分区域会被裁剪
};


// 播放器的几种状态
typedef NS_ENUM(NSInteger, LPPlayerState) {
    LPPlayerStateFailed,     // 播放失败
    LPPlayerStateBuffering,  // 缓冲中
    LPPlayerStatePlaying,    // 播放中
    LPPlayerStateStopped,    // 停止播放
    LPPlayerStatePause       // 暂停播放
};


@interface LPPlayerView : UIView<LPPlayerControlViewDelegate>

@property (nonatomic, weak) id<LPPlayerDelegate> delegate;
// 设置playerLayer的填充模式
@property (nonatomic, assign) LPPlayerLayerGravity playerLayerGravity;
// 是否暂停
@property (nonatomic, assign) BOOL isPauseByUser;
// 播放状态
@property (nonatomic, assign, readonly) LPPlayerState state;
// 是否开启预览图
@property (nonatomic, assign) BOOL hasPreviewView;

// 静音（默认为NO）
@property (nonatomic, assign) BOOL mute;
//  当cell划出屏幕的时候停止播放（默认为NO）
@property (nonatomic, assign) BOOL stopPlayWhileCellNotVisable;
// 当cell播放视频由全屏变为小屏时候，是否回到中间位置(默认YES)
@property (nonatomic, assign) BOOL cellPlayerOnCenter;
@property (nonatomic, strong) LPPlayerModel *playerModel;
@property (nonatomic, assign) NSInteger seekTime;
@property (nonatomic, strong) LPPlayerControlView *controlView;

// 单例
+(instancetype)sharedPlayerView;

// 指定播放控制层和模型
- (void)playerControlView:(LPPlayerControlView *)controlView playerModel:(LPPlayerModel *)playerModel;

// 设置新视频
- (void)resetToPlayNewVideo:(LPPlayerModel *)playerModel;

// 播放
- (void)play;

// 暂停
- (void)pause;

// 自动播放
- (void)autoPlayVideo;


- (void)addPlayerToParentView: (UIView *)view;

- (void)removePlayerObserver;

@end
