//
//  LPPagingViewPage.h
//  EveryoneNews
//
//  Created by apple on 15/12/1.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  自定义 page
 */
@class LPHomeViewFrame;
@interface LPPagingViewPage : UIView

@property (nonatomic, strong) NSMutableArray *cardFrames;
- (void)setChannelID:(NSString *)channelID;

/**
 *  复用前的准备工作(复写该方法)
 */
//- (void)prepareForReuse;

// table view, collection view, label, image view, ... and so on (your custom subviews)

@end
