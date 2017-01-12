//
//  LPPagingViewConcernPage.h
//  EveryoneNews
//
//  Created by dongdan on 16/7/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "LPPagingViewBasePage.h"

@class LPPagingViewConcernPage;
@class LPCardConcernFrame;

@protocol LPPagingViewConcernPageDelegate <LPPagingViewBasePageDelegate>

@optional
- (void)concernPage:(LPPagingViewConcernPage *)concernPage didSelectCellWithCardID:(NSManagedObjectID *)cardID;
- (void)concernPage:(LPPagingViewConcernPage *)concernPage didClickSearchImageView:(UIImageView *)imageView;
- (void)concernPage:(LPPagingViewConcernPage *)concernPage didTapListViewWithSourceName:(NSString *)sourceName;
@end

@interface LPPagingViewConcernPage : LPPagingViewBasePage

- (void)autotomaticLoadNewData;
- (void)tapStatusBarScrollToTop;
@end
