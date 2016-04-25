//
//  LPNewsAboutViewController.m
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPNewsAboutViewController.h"
#import "LPNewsMineViewController.h"

@interface LPNewsAboutViewController(){
    UIImageView *iconImage;
    UILabel *appNameLabel;
    UILabel *versionLabel;
    UIImageView *LPNetImage;
    UILabel *copyRightLabel;
}

@end

@implementation LPNewsAboutViewController

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
    [self setNavTitleView:@"关于"];
    
    [self backImageItem];
    self.view.backgroundColor = [UIColor colorWithDesignIndex:9];
    [self addAboutWebView];
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

-(void)addAboutWebView{
    
    iconImage = [[UIImageView alloc] init];
    [iconImage setImage:[UIImage imageNamed:@"LP_icon"]];
    [self.view addSubview:iconImage];
    __weak __typeof(self)weakSelf = self;
    [iconImage mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        make.centerX.equalTo(strongSelf.view);
        make.top.equalTo(strongSelf.view).with.offset(74);
    }];
    
    appNameLabel = [[UILabel alloc] init];
    appNameLabel.text = @"奇点资讯";
    appNameLabel.textAlignment = NSTextAlignmentCenter;
    appNameLabel.textColor = [UIColor colorWithDesignIndex:1];
    appNameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:38.f/fontSizePxToSystemMultiple];
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:appNameLabel.text attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:38.f/fontSizePxToSystemMultiple]}];
    [self.view addSubview:appNameLabel];
    [appNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        make.size.mas_equalTo(CGSizeMake(ceilf(attStr.size.width), ceilf(attStr.size.height)));
        make.centerX.equalTo(strongSelf.view);
        make.top.equalTo(iconImage.mas_bottom).with.offset(12);
    }];

    versionLabel = [[UILabel alloc] init];
    NSString *versionText = [NSString stringWithFormat:@"V%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    versionLabel.text = versionText;
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = [UIColor colorWithDesignIndex:2];
    versionLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:38.f/fontSizePxToSystemMultiple];
    NSAttributedString *attStr1 = [[NSAttributedString alloc] initWithString:versionLabel.text attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:40.f/fontSizePxToSystemMultiple]}];
    [self.view addSubview:versionLabel];
    [versionLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        make.size.mas_equalTo(CGSizeMake(ceilf(attStr1.size.width), ceilf(attStr.size.height)));
        make.centerX.equalTo(strongSelf.view);
        make.top.equalTo(appNameLabel.mas_bottom).with.offset(27);
    }];
    
    copyRightLabel = [[UILabel alloc] init];
    copyRightLabel.text = @"Copyright ©2016 lieying.All Rights Reserved";
    copyRightLabel.textAlignment = NSTextAlignmentCenter;
    copyRightLabel.textColor = [UIColor colorWithDesignIndex:4];
    copyRightLabel.font = [UIFont boldSystemFontOfSize:24.f/fontSizePxToSystemMultiple];
    NSAttributedString *attStr2 = [[NSAttributedString alloc] initWithString:copyRightLabel.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:26.f/fontSizePxToSystemMultiple]}];
    [self.view addSubview:copyRightLabel];
    [copyRightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        make.size.mas_equalTo(CGSizeMake(ceilf(attStr2.size.width), ceilf(attStr.size.height)));
        make.centerX.equalTo(strongSelf.view);
        make.bottom.equalTo(strongSelf.view.mas_bottom).with.offset(-14);
    }];
    
    LPNetImage = [[UIImageView alloc] init];
    [LPNetImage setImage:[UIImage imageNamed:@"LP_net"]];
    [self.view addSubview:LPNetImage];
    [LPNetImage mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        make.centerX.equalTo(strongSelf.view);
        make.bottom.equalTo(copyRightLabel.mas_top).with.offset(-16);
    }];
                              
}



@end
