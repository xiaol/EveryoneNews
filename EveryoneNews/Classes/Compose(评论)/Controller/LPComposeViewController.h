//
//  LPComposeViewController.h
//  EveryoneNews
//
//  Created by apple on 15/6/29.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnTextBlock)(NSString *text);

@interface LPComposeViewController : LPBaseViewController
//@property (nonatomic, strong) LPContent *content;
@property (nonatomic, copy) NSString *draftText;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, copy) returnTextBlock returnTextBlock;

- (void)returnText:(returnTextBlock)returnTextBlock;
@end
