//
//  UIView+LPCustomPlayView.m
//  AVPlayerDemo
//
//  Created by dongdan on 2016/12/8.
//  Copyright © 2016年 dongdan. All rights reserved.
//

#import "UIView+LPCustomPlayView.h"
#import <objc/runtime.h>
#import "LPPlayerModel.h"

@implementation UIView (LPCustomPlayView)

- (void)setDelegate:(id<LPPlayerControlViewDelegate>)delegate {
    objc_setAssociatedObject(self, @selector(delegate), delegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<LPPlayerControlViewDelegate>)delegate {
    return objc_getAssociatedObject(self, _cmd);
}

// 设置播放模型
- (void)lp_playerModel:(LPPlayerModel *)playerModel{}

// 显示控制层
- (void)lp_playerShowControlView{}

// 重置ControllView
- (void)lp_playerResetControlView{}

// 取消自动隐藏控制层
- (void)lp_playerCancelAutoFadeOutControlView{}

// 开始播放(用来隐藏placeholderImageView）
- (void)lp_playerItemPlaying{}

// 播放完毕
- (void)lp_playerPlayEnd{}

// 播放按钮状态
- (void)lp_playerPlayBtnState:(BOOL)state{}

// 锁定屏幕方向按钮状态
- (void)lp_playerLockBtnState:(BOOL)state{}

// 返回按钮状态
- (void)lp_playerBackBtnState:(BOOL)state{}

// 分享按钮状态
- (void)lp_playerShareBtnState:(BOOL) state{}

// 加载菊花
- (void)lp_playerActivity:(BOOL)animated{}

// 拖拽预览图
- (void)lp_playerDraggedTime:(NSInteger)draggedTime sliderImage:(UIImage *)image{}

// 快进快退
- (void)lp_playerDraggedTime:(NSInteger)draggedTime totalTime:(NSInteger)totalTime isForward:(BOOL)forawrd hasPreview:(BOOL)preview{}

// 滑动结束
- (void)lp_playerDraggedEnd{}

// 正常播放
- (void)lp_playerCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)value{}

// 显示缓冲进度
- (void)lp_playerSetProgress:(CGFloat)progress{}

// 视频加载失败
- (void)lp_playerItemStatusFailed:(NSError *)error{}

// 小屏播放
- (void)lp_playerBottomShrinkPlay{}

// 在cell上播放
- (void)lp_playerCellPlay{}

 


@end
