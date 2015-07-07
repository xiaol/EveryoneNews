//
//  UICustomLoadding.h
//  自定义加载view
//
//  Created by Feng on 15/7/7.
//  Copyright (c) 2015年 Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomLoaddingView : UIView
+ (instancetype)showMessage:(NSString *)message toView:(UIView *)rootView;
- (void)dismissMessage;
@end
