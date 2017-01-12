//
//  LPPlayerControlView.h
//  AVPlayerDemo
//
//  Created by dongdan on 2016/12/7.
//  Copyright © 2016年 dongdan. All rights reserved.
//

 

#import <UIKit/UIKit.h>

typedef void (^SliderTapBlock)(CGFloat value);

@interface LPPlayerControlView:UIView

- (void)hideControlView;

// 在Cell上播放
@property (nonatomic, assign, getter=isCellVideo) BOOL cellVideo;

@end
