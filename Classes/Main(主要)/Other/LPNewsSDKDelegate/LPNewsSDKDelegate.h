//
//  LPNewsSDKDelegate.h
//  Pods
//
//  Created by dongdan on 2017/1/13.
//
//

#import <Foundation/Foundation.h>

@protocol LPNewsSDKDelegate <NSObject>

@optional

// 列表页下滑操作
- (void)homeListDidScroll;

// 进入详情页面
- (void)pushDetailViewController;

// 切换频道栏
- (void)switchChannel;

@end
