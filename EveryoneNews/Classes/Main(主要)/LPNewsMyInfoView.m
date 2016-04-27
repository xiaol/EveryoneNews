//
//  LPNewsMyInfoView.m
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPNewsMyInfoView.h"
#import "LPNewsMineViewController.h"

@implementation LPNewsMyInfoView

#pragma mark- Initialize

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc{
    
}

#pragma mark-  ViewLife Cycle

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithDesignIndex:9];
    [self setNavTitleView:@"消息"];
    [self backImageItem];
    
    CGRect lineLayerRect = CGRectMake(0.f, (self.navigationController.navigationBar.size.height-1.f), kApplecationScreenWidth, 0.5f);
    CALayer *lineLayer = [CALayer layer];
    lineLayer.frame = lineLayerRect;
    lineLayer.backgroundColor = [[UIColor colorWithDesignIndex:5] CGColor];
    [self.navigationController.navigationBar.layer addSublayer:lineLayer];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithDesignIndex:9];
    self.navigationController.navigationBar.translucent = NO;
    
    [self addContentView];
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

#pragma mark- private methods
-(void)addContentView{
    
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.text = @"暂时无消息内容";
    noticeLabel.font = [UIFont systemFontOfSize:32.f/fontSizePxToSystemMultiple];
    noticeLabel.textColor = [UIColor colorWithDesignIndex:5];
    [self.view addSubview:noticeLabel];
    __weak __typeof(self)weakSelf = self;
    [noticeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        make.centerX.equalTo(strongSelf.view);
        make.top.equalTo(strongSelf.view).with.offset(220);
        
    }];
    
}



@end
