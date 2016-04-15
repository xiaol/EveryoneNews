//
//  LPNewsMyCollectionView.m
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPNewsMyCollectionView.h"

@implementation LPNewsMyCollectionView

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
    [self setNavTitleView:@"收藏"];
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
    UIImageView *noticeImg = [[UIImageView alloc] init];
    [noticeImg setImage:[UIImage imageNamed:@"LP_construction"]];
    [self.view addSubview:noticeImg];
     __weak __typeof(self)weakSelf = self;
    [noticeImg mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        make.centerX.equalTo(strongSelf.view);
        make.top.equalTo(strongSelf.view).with.offset(148);
        
    }];
    
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.text = @"正在建设中，请移步";
    noticeLabel.font = [UIFont systemFontOfSize:17.f];
    noticeLabel.textColor = [UIColor colorWithDesignIndex:5];
    [self.view addSubview:noticeLabel];
    [noticeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        make.centerX.equalTo(strongSelf.view);
        make.top.equalTo(noticeImg.mas_bottom).with.offset(20);
        
    }];
}

@end
