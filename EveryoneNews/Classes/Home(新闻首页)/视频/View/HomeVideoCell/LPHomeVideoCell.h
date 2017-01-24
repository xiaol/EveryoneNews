//
//  LPHomeVideoCell.h
//  AVPlayerDemo
//
//  Created by dongdan on 2016/12/6.
//  Copyright © 2016年 dongdan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PlayButtonCallBackBlock)(UIButton *);
typedef void (^CoverImageViewCallBackBlock)(UIImageView *);
typedef void(^didClickTipButtonBlock)();


@class Card;
@class LPHomeVideoCell;
@protocol LPHomeVideoCellDelegate <NSObject>

@optional
-(void)cell:(LPHomeVideoCell *)cell didClickTitleWithNid:(NSString *)nid;
-(void)cell:(LPHomeVideoCell *)cell didTapImageViewWithCard:(Card *)card;

@end

@class LPHomeVideoFrame;
@interface LPHomeVideoCell : UITableViewCell

@property (nonatomic, assign) NSInteger currentRow;
@property (nonatomic, strong) LPHomeVideoFrame *videoFrame;
@property (nonatomic, copy) PlayButtonCallBackBlock playButtonBlock;
@property (nonatomic, copy) CoverImageViewCallBackBlock coverImageBlock;

@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, weak) id<LPHomeVideoCellDelegate> delegate;

@property (nonatomic, copy) didClickTipButtonBlock didClickTipBlock;

- (void)didClickTipButtonBlock:(didClickTipButtonBlock)didClickTipButtonBlock;

@end
