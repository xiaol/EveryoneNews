//
//  LPPagingViewPage.h
//  EveryoneNews
//
//  Created by apple on 15/12/1.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
/**
 *  自定义 page
 */
@class LPPagingViewPage;
@protocol LPPagingViewPageDelegate <NSObject>
@optional
- (void)page:(LPPagingViewPage *)page didSelectCellWithCardID:(NSManagedObjectID *)cardID;

- (void)page:(LPPagingViewPage *)page didClickSearchImageView:(UIImageView *)imageView;

//- (void)page:(LPPagingViewPage *)page didSaveOffsetY:(CGFloat)offsetY;

//- (void)page:(LPPagingViewPage *)page tableView:(UITableView *)tableView deleteAtIndexPath:(NSIndexPath *)indexPath;




@end
//
@interface LPPagingViewPage : UIView
//
@property (nonatomic, strong) NSMutableArray *cardFrames;

@property (nonatomic, copy) NSString *cellIdentifier;

@property (nonatomic, copy) NSString *pageChannelName;

@property (nonatomic, weak) id<LPPagingViewPageDelegate> delegate;
- (void)autotomaticLoadNewData;

- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath;

//- (void)scrollToOffsetY:(CGFloat)offsetY;

/**
 *  复用前的准备工作(复写该方法)
 */
- (void)prepareForReuse;

// table view, collection view, label, image view, ... and so on (your custom subviews)

@end
