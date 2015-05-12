//
//  ContentViewController.h
//  upNews
//
//  Created by 于咏畅 on 15/1/20.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ContentViewController : BaseViewController

@property (nonatomic, copy) NSString *sourceId;

@property (nonatomic, copy) NSString *sourceUrl;
@property (nonatomic, copy) NSString *imgStr;
@property (nonatomic, copy) NSString *sourceSite;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *rootClass;

@property (nonatomic, copy) NSArray *responseUrls;
@property (nonatomic, assign)BOOL hasImg;
@property (nonatomic, assign)int favorNum;
//@property (nonatomic, strong)UIImageView *imgView;

@end
