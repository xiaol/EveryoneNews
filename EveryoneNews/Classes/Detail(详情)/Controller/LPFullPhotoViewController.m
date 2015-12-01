//
//  LPFullPhotoViewController.m
//  EveryoneNews
//
//  Created by dongdan on 15/11/26.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPFullPhotoViewController.h"

@interface LPFullPhotoViewController ()

@end

@implementation LPFullPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor blackColor];
    [self setupSubViews];
}

- (void)setupSubViews {
    // 2. pop btn
    UIButton *popBtn = [[UIButton alloc] initWithFrame:CGRectMake(DetailCellPadding, DetailCellPadding * 2, 34, 34)];
    popBtn.enlargedEdge = 5;
    [popBtn setImage:[UIImage resizedImageWithName:@"back"] forState:UIControlStateNormal];
    popBtn.backgroundColor = [UIColor clearColor];
    popBtn.alpha = 0.8;
    [popBtn addTarget:self action:@selector(popBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popBtn];
}

- (void)popBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
