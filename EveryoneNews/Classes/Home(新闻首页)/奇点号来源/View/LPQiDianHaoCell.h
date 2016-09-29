//
//  LPQiDianHaoCell.h
//  EveryoneNews
//
//  Created by dongdan on 16/7/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LPQiDianHaoFrame;
@class LPQiDianHaoCell;
@class LPQiDianHaoFrame;

@protocol LPQiDianHaoCellDelegate <NSObject>

@optional
- (void)cell:(LPQiDianHaoCell *)cell didClickConcernButtonWithConcernState:(NSString *)concernState sourceName:(NSString *)sourceName qiDianHaoFrame:(LPQiDianHaoFrame *)qiDianHaoFrame ;

@end


@interface LPQiDianHaoCell : UITableViewCell

@property (nonatomic, strong) LPQiDianHaoFrame *qiDianHaoFrame;

@property (nonatomic, weak) id<LPQiDianHaoCellDelegate> delegate;

@end
