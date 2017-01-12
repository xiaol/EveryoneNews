//
//  LPDetailVideoCell.h
//  EveryoneNews
//
//  Created by dongdan on 2017/1/5.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LPDetailVideoFrame;
@class LPDetailVideoCell;
@class LPVideoModel;

@protocol LPDetailVideoCellDelegate <NSObject>

@optional
- (void)videoCell:(LPDetailVideoCell *)cell didClickCellWithVideoModel:(LPVideoModel *)videoModel;

@end

@interface LPDetailVideoCell : UITableViewCell

@property (nonatomic, strong) LPDetailVideoFrame *detailVideoFrame;

@property (nonatomic, weak) id<LPDetailVideoCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
