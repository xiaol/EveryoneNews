//
//  LPPagingViewConcernPage.h
//  EveryoneNews
//
//  Created by dongdan on 16/7/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class LPPagingViewConcernPage;
@class LPCardConcernFrame;

@protocol LPPagingViewConcernPageDelegate <NSObject>

@optional
- (void)concernPage:(LPPagingViewConcernPage *)concernPage didSelectCellWithCardID:(NSManagedObjectID *)cardID;

@end

@interface LPPagingViewConcernPage : UIView

@property (nonatomic, strong) NSMutableArray *cardFrames;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) NSString *pageChannelName;
@property (nonatomic, weak) id<LPPagingViewConcernPageDelegate> delegate;


@end
