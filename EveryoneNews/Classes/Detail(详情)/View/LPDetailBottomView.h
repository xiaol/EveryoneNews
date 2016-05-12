//
//  LPDetailBottomView.h
//  EveryoneNews
//
//  Created by dongdan on 16/3/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPDetailBottomView;
@protocol LPDetailBottomViewDelegate <NSObject>

@optional

- (void)pushCommentViewControllerWithDetailBottomView:(LPDetailBottomView *)detailBottomView;

- (void)didComposeCommentWithDetailBottomView:(LPDetailBottomView *)detailBottomView;

- (void)didShareWithDetailBottomView:(LPDetailBottomView *)detailBottomView;

- (void)didFavoriteWithDetailBottomView:(LPDetailBottomView *)detailBottomView;

- (void)didClickCommentsWithDetailBottomView:(LPDetailBottomView *)detailBottomView;

- (void)didClickContentsWithDetailBottomView:(LPDetailBottomView *)detailBottomView;

@end

@interface LPDetailBottomView : UIView

@property (nonatomic, assign) NSInteger badgeNumber;
@property (nonatomic, weak) id<LPDetailBottomViewDelegate> delegate;
@property (nonatomic, strong) UIButton *contentBtn;
@property (nonatomic, strong) UIButton *commentsBtn;
@property (nonatomic, strong) UIButton *noCommentsBtn;
@property (nonatomic, strong) UILabel *commentCountLabel;
@property (nonatomic, strong) UIView *commentsCountView;

@end
