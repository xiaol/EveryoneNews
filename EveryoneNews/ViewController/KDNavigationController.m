//
//  KDNavigationController.m
//  TogetherTV
//
//  Created by leeqj on 14-3-13.
//  Copyright (c) 2014年 Spark Inc. All rights reserved.
//

#import "KDNavigationController.h"

@interface KDNavigationController ()

@end

@implementation KDNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.automaticallyAdjustsScrollViewInsets = NO;
        
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    self.supportAuto = YES;
//    self.supportedOrientations = UIInterfaceOrientationMaskAll;   //支持屏幕全方向旋转
    self.supportedOrientations = UIInterfaceOrientationMaskPortrait;    //不支持屏幕旋转
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//test for sourcetree



-(NSUInteger)supportedInterfaceOrientations{
    return self.supportedOrientations;
}

- (BOOL)shouldAutorotate{
    return self.supportAuto;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return self.supportAuto;
}

-(UIInterfaceOrientation) preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeLeft;
}

@end
