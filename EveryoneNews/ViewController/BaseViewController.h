//
//  BaseViewController.h
//  newPocketPlayer
//
//  Created by 于咏畅 on 14-9-2.
//  Copyright (c) 2014年 yyc. All rights reserved.
//
//  **** 去video ******

#import <UIKit/UIKit.h>
#import "KDNavigationController.h"
//#import "VideoPlayView.h"

//@class VideoPlayView;
@class KDNavigationController;

@interface BaseViewController : UIViewController

//区别Feed和search页
//@property (nonatomic, copy)NSString *queryKey;
//@property (nonatomic, copy) NSString *channelName;
@property (nonatomic, strong)KDNavigationController *navicationController;
//@property (nonatomic, strong) VideoPlayView *videoView;

- (void)changeOrientation:(UIInterfaceOrientation)toOrientation;


@end
