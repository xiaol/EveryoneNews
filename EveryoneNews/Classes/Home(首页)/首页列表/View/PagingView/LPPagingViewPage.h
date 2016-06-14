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
@class CardFrame;
@class Card;

@protocol LPPagingViewPageDelegate <NSObject>
@optional
- (void)page:(LPPagingViewPage *)page didSelectCellWithCardID:(NSManagedObjectID *)cardID cardFrame:(CardFrame *)cardFrame;

- (void)page:(LPPagingViewPage *)page didClickSearchImageView:(UIImageView *)imageView;

- (void)page:(LPPagingViewPage *)page didClickDeleteButtonWithCardFrame:(CardFrame *)cardFrame deleteButton:(UIButton *)deleteButton;

- (void)didClickReloadPage:(LPPagingViewPage *)page;
//
//- (void)page:(LPPagingViewPage *)page updateCardFrames:(NSArray *)cardFrames;

@end
//
@interface LPPagingViewPage : UIView


@property (nonatomic, strong) NSMutableArray *cardFrames;

@property (nonatomic, copy) NSString *cellIdentifier;

//@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, copy) NSString *pageChannelName;

@property (nonatomic, strong) UIView *reloadPage;

// 正在加载视图
@property (nonatomic, strong) UIView *contentLoadingView;
// 首页动画UIImageView
@property (nonatomic, strong) UIImageView *animationImageView;
//// 正在加载文字提示
//@property (nonatomic, strong) UILabel *loadingLabel;

@property (nonatomic, weak) id<LPPagingViewPageDelegate> delegate;
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
