//
//  LPFeaturedViewController.h
//  EveryoneNews
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPBaseViewController.h"

typedef void (^returnCotentsBlock)(NSArray *contents);

@interface LPFeaturedViewController : LPBaseViewController
@property (nonatomic, assign) NSInteger item;
@property (nonatomic, strong) NSArray *presses;
@end
