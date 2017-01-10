//
//  LPSortCollectionReusableView.h
//  EveryoneNews
//
//  Created by dongdan on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, SortButtonState) {
    DeleteState = 0,
    FinishState
};
typedef void (^sortButtonClickBlock)(SortButtonState state);

@class LPSortCollectionReusableView;
@protocol LPSortCollectionReusableViewDelegate <NSObject>

@optional
- (void)upImageViewDidTap:(LPSortCollectionReusableView *)resuableView;

@end

@interface LPSortCollectionReusableView : UICollectionReusableView

// 主标题
@property (nonatomic, strong) UILabel *titleLabel;
// 副标题
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIButton *sortButton;
//@property (nonatomic, strong) UIImageView *upImageView;
@property (nonatomic, assign) BOOL sortButtonHidden;
@property (nonatomic, copy) sortButtonClickBlock sortButtonClickBlock;
@property (nonatomic, weak) id<LPSortCollectionReusableViewDelegate>  delegate;
- (void)sortButtonDidClick:(sortButtonClickBlock)sortButtonClickBlock;

@end
