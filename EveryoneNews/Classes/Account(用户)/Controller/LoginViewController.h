//
//  LoginViewController.h
//  EveryoneNews
//
//  Created by apple on 15/6/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^success)();
typedef void (^failure)();
typedef void (^cancel)();
@interface LoginViewController : UIViewController

//tabbar的背景图
@property (nonatomic,strong) UIImage *headerBackgroundImage;
//非tabbar的背景图
@property (nonatomic,strong) UIImage *footerBackgroundImage;
//设置用户登录回调blocks
- (void) setCallBackBlocks:(success)success :(failure) failure :(cancel)cancel;

@end
