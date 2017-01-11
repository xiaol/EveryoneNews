//
//  LPPagingViewPage.h
//  EveryoneNews
//
//  Created by apple on 15/12/1.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "LPPagingViewBasePage.h"

/**
 *  自定义 page
 */
@class LPPagingViewPage;
@class CardFrame;
@class Card;
@class LPLoadingView;
 

@protocol LPPagingViewPageDelegate <LPPagingViewBasePageDelegate>

@optional
- (void)page:(LPPagingViewPage *)page didSelectCellWithCardID:(NSManagedObjectID *)cardID cardFrame:(CardFrame *)cardFrame;
- (void)page:(LPPagingViewPage *)page didClickDeleteButtonWithCardFrame:(CardFrame *)cardFrame deleteButton:(UIButton *)deleteButton;
- (void)page:(LPPagingViewPage *)page didClickSearchImageView:(UIImageView *)imageView;
- (void)page:(LPPagingViewPage *)page didTapListViewWithSourceName:(NSString *)sourceName sourceImage:(NSString *)sourceImage;
- (void)didClickReloadPage:(LPPagingViewPage *)page;

@end

@interface LPPagingViewPage : LPPagingViewBasePage

@property (nonatomic, strong) UIView *reloadPage;
// 正在加载视图
@property (nonatomic, strong) LPLoadingView *loadingView;

- (void)autotomaticLoadNewData;
- (void)tableViewReloadData;
- (void)scrollToCurrentRow:(NSInteger)rowIndex;
- (void)tapStatusBarScrollToTop;
- (void)deleteRowAtIndexPath:(CardFrame *)cardFrame;
- (void)updateCardFramesWithCardFrame:(CardFrame *)cardFrame;

/**
 *  复用前的准备工作(复写该方法)
 */
- (void)prepareForReuse;

// table view, collection view, label, image view, ... and so on (your custom subviews)

@end
