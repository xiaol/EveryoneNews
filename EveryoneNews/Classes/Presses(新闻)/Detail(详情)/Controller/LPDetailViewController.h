//
//  LPDetailViewController.h
//  EveryoneNews
//
//  Created by apple on 15/5/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LPPress;

typedef void (^returnCommentsToUpBlock)(NSArray *contents);

@interface LPDetailViewController : UIViewController
@property (nonatomic, strong) LPPress *press;
- (void)returnContentsBlock:(returnCommentsToUpBlock)returnBlock;
@end
