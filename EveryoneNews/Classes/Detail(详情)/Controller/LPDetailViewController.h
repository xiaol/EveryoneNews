//
//  LPDetailViewController.h
//  EveryoneNews
//
//  Created by apple on 15/5/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPPress;
@class LPConcernPress;
@class LPConcern;

typedef void (^returnCommentsToUpBlock)(NSArray *contents);

@interface LPDetailViewController : LPBaseViewController
@property (nonatomic, strong) LPPress *press;
@property (nonatomic, strong) LPConcernPress *concernPress;
@property (nonatomic, assign) BOOL isConcernDetail;
@property (nonatomic, strong) LPConcern *concern;
- (void)returnContentsBlock:(returnCommentsToUpBlock)returnBlock;
@end
