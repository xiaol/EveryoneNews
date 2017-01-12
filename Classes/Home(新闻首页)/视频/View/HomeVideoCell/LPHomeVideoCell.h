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

@class LPHomeVideoCell;
@protocol LPHomeVideoCellDelegate <NSObject>

@optional
-(void)cell:(LPHomeVideoCell *)cell didClickTitleWithNid:(NSString *)nid;

@end

@class LPHomeVideoFrame;
@interface LPHomeVideoCell : UITableViewCell

@property (nonatomic, strong) LPHomeVideoFrame *videoFrame;
@property (nonatomic, copy) PlayButtonCallBackBlock playButtonBlock;
@property (nonatomic, copy) CoverImageViewCallBackBlock coverImageBlock;

@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, weak) id<LPHomeVideoCellDelegate> delegate;

@end
