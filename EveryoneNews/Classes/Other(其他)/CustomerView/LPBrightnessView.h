//
//  LPBrightnessView.h
//  AVPlayerDemo
//
//  Created by dongdan on 2016/12/8.
//  Copyright © 2016年 dongdan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPBrightnessView : UIView

// 是否锁屏
@property (nonatomic, assign) BOOL isLockScreen;
// 是否允许横屏
@property (nonatomic, assign) BOOL isAllowLandscape;

+(instancetype)sharedBrightnessView;

@end
