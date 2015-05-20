//
//  BaseViewController.m
//  newPocketPlayer
//
//  Created by 于咏畅 on 14-9-2.
//  Copyright (c) 2014年 yyc. All rights reserved.
//

#import "BaseViewController.h"
#import "UIColor+HexToRGB.h"
#import "BaseCell.h"
#import "WebViewController.h"

@interface BaseViewController ()<WebDelegate>
{
    
//    KDNavigationController *_navicationController;
    UINavigationBar *_naBar;
}

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //图文版不需要旋转，禁止掉
//    if (self.interfaceOrientation != UIInterfaceOrientationPortrait) {
//        [self changeOrientation:UIInterfaceOrientationPortrait];
//    }
    _navicationController = (KDNavigationController*)self.navigationController;
//    _navicationController.supportedOrientations = UIInterfaceOrientationMaskPortrait;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorFromHexString:@"ffffff"],NSFontAttributeName:[UIFont fontWithName:kFont size:22]}];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.videoView backBtnClick];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /******* 适配IOS6、7，使navigationBar不遮挡其他View ***********/
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"7.0" options: NSNumericSearch];
    if (order == NSOrderedSame || order == NSOrderedDescending)
    {
        // OS version >= 7.0
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    /************************************************************/

    _naBar = self.navigationController.navigationBar;
//    _naBar.barStyle = UIBarStyleBlackTranslucent;
//    _naBar.barStyle = UIBarStyleDefault;
    _naBar.barStyle = UIBarStyleBlackOpaque;
    _naBar.tintColor = [UIColor whiteColor];
    
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setFloat:_naBar.frame.size.height forKey:@"navBarH"];
    [accountDefaults setFloat:[[[UIDevice currentDevice] systemVersion] floatValue] forKey:@"systemVersion"];
    
//    NSLog(@"系统版本：%f", [[[UIDevice currentDevice] systemVersion] floatValue]);
    
//    self.navicationController.view.backgroundColor = [UIColor colorFromHexString:@"#F6F6F8"];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorFromHexString:@"#4fb5ea"]];
    
//    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor colorFromHexString:@"#FFFFFF"],
//                                                                    UITextAttributeFont : [UIFont systemFontOfSize:19]};

}


#pragma mark 屏幕旋转

-(void)changeOrientation:(UIInterfaceOrientation)toOrientation
{
//    _navicationController.supportedOrientations = UIInterfaceOrientationMaskAll;
//    NSLog(@"---_navicationController.supportedOrientations:%d", _navicationController.supportedOrientations);
//    NSLog(@"---- changeOrientation ----");
//    if ([[UIDevice currentDevice] respondsToSelector:NSSelectorFromString(@"setOrientation:")]) {
//        
//        SEL selector = NSSelectorFromString(@"setOrientation:");
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//        [invocation setSelector:selector];
//        [invocation setTarget:[UIDevice currentDevice]];
//        int val = toOrientation;
//        [invocation setArgument:&val atIndex:2];
//        [invocation invoke];
//    }
//    [UIViewController attemptRotationToDeviceOrientation];
}


#pragma mark 屏幕旋转
//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
//    [UIView animateWithDuration:duration animations:^{
//        
//        NSLog(@"---- ROTATE !!!! ------");
//        CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
//        CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
//        float systemVersion = [[NSUserDefaults standardUserDefaults] floatForKey:@"systemVersion"];
//        
//        if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
//            if (systemVersion >= 8.0) {
//                self.videoView.frame = CGRectMake(0, 0, screenH, screenH / 16 * 9);
//                self.view.frame = CGRectMake(0, 0, screenH, screenW);
//            } else {
//                self.videoView.frame = CGRectMake(0, 0, screenW, screenW / 16 * 9);
//                self.view.frame = CGRectMake(0, 0, screenW, screenH);
//            }
////            NSLog(@"\nW:%f,\nH:%f", self.frame.size.width, self.frame.size.height);
//            self.navigationController.navigationBar.hidden = NO;
//        } else {
//            if (screenW > screenH) {
//                self.videoView.frame = CGRectMake(0, 0, screenW, screenH);
//            } else {
//                self.videoView.frame = CGRectMake(0, 0, screenH, screenW);
//            }
//            
//            self.view.frame = self.videoView.frame;
//            self.navigationController.navigationBar.hidden = YES;
//        }
//        [self.videoView setViewFrame];
//    }];
//}


#pragma mark WebDelegate
- (void)loadWebViewWithURL:(NSString *)URL
{
    WebViewController *webVC = [[WebViewController alloc] init];
    
    webVC.webUrl = URL;
    
    [self.navigationController pushViewController:webVC animated:YES];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}



@end
