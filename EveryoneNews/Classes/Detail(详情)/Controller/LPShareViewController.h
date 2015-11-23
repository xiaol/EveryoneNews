//
//  LPShareViewController.h
//  EveryoneNews
//
//  Created by dongdan on 15/11/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPBaseViewController.h"

@interface LPShareViewController : LPBaseViewController

// 详情页标题和链接
@property(nonatomic, copy) NSString *detailTitleWithUrl;
// 详情页链接
@property(nonatomic, copy) NSString *detailUrl;
// 详情页标题
@property(nonatomic, copy) NSString *detailTitle;
// 详情页图像链接
@property(nonatomic, copy) NSString *detailImageUrl;
// 分享页blur
@property(nonatomic, strong) UIImageView *blurImageView;
@end
