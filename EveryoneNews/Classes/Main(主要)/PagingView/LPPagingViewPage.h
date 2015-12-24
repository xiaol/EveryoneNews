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

@interface LPPagingViewPage : UIView

@property (nonatomic, strong) NSMutableArray *cardFrames;

@property (nonatomic, copy) NSString *cellIdentifier;

@property (nonatomic, copy) NSString *selectedChannelID;
/**
 *  复用前的准备工作(复写该方法)
 */
//- (void)prepareForReuse;

// table view, collection view, label, image view, ... and so on (your custom subviews)

@end
