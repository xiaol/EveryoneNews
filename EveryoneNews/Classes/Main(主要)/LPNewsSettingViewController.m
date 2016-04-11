//
//  LPNewsSettingViewController.m
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPNewsSettingViewController.h"

NS_ASSUME_NONNULL_BEGIN

@implementation LPNewsSettingViewController

#pragma mark- Initialize

- (instancetype)initWithCustom{
    self = [super initWithCustom];
    if (self) {
       
    }
    return self;
}

- (void)dealloc{
  
}


#pragma mark-  ViewLife Cycle

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setNavTitleView:@"设置"];
  
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    if ([self.view window] == nil && [self isViewLoaded]) {
    }
}


#pragma mark- UITableViewDataSource



#pragma mark- UITableViewDelegate



#pragma mark- CustomDelegate


#pragma mark- Event reponse

#pragma mark- Public methods

#pragma mark- private methods


#pragma mark- NSNotification

#pragma mark- Getters and Setters


@end

NS_ASSUME_NONNULL_END



