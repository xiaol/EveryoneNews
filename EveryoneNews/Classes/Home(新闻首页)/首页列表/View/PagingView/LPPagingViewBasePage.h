//
//  LPPagingViewBasePage.h
//  EveryoneNews
//
//  Created by dongdan on 16/8/31.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPPagingViewBasePage;
@protocol LPPagingViewBasePageDelegate<NSObject>



@end

@interface LPPagingViewBasePage : UIView

@property (nonatomic, strong) NSMutableArray *cardFrames;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) NSString *pageChannelName;
@property (nonatomic, assign) CGPoint offset;
// 频道编号
@property (nonatomic, copy) NSString *pageChannelID;


@property (nonatomic, weak) id<LPPagingViewBasePageDelegate> delegate;

@end
