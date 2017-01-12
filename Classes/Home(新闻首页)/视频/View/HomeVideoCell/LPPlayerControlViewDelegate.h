//
//  LPPlayerControlViewDelegate.h
//  AVPlayerDemo
//
//  Created by dongdan on 2016/12/7.
//  Copyright © 2016年 dongdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LPPlayerControlViewDelegate <NSObject>

@optional

// 返回
- (void)lp_controlView:(UIView *)controlView backAction:(UIButton *)sender;





// cell播放中小屏状态 关闭按钮事件
- (void)lp_controlView:(UIView *)controlView closeAction:(UIButton *)sender;

// 播放
- (void)lp_controlView:(UIView *)controlView playAction:(UIButton *)sender;

// 全屏
- (void)lp_controlView:(UIView *)controlView fullScreenAction:(UIButton *)sender;

// 锁定屏幕方向
- (void)lp_controlView:(UIView *)controlView lockScreenAction:(UIButton *)sender;

//  重播按钮事件
- (void)lp_controlView:(UIView *)controlView repeatPlayAction:(UIButton *)sender;

// 中间播放按钮
- (void)lp_controlView:(UIView *)controlView centerPlayAction:(UIButton *)sender;

// 加载失败
- (void)lp_controlView:(UIView *)controlView failAction:(UIButton *)sender;

// slider控制进度
- (void)lp_controlView:(UIView *)controlView progressSliderTap:(CGFloat)value;

// 开始触摸slider
- (void)lp_controlView:(UIView *)controlView progressSliderTouchBegan:(UISlider *)slider;

// slider触摸中
- (void)lp_controlView:(UIView *)controlView progressSliderValueChanged:(UISlider *)slider;

//  slider触摸结束
- (void)lp_controlView:(UIView *)controlView progressSliderTouchEnded:(UISlider *)slider;

// 分享
- (void)lp_controlView:(UIView *)controlView shareAction:(UIButton *)sender;

// 静音切换
- (void)lp_controlView:(UIView *)controlView volumnAction:(UIButton *)sender;



@end
