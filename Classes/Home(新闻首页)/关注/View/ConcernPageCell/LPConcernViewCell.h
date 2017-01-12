//
//  LPConcernViewCell.h
//  EveryoneNews
//
//  Created by dongdan on 16/7/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^didTapSourceListViewBlock)(NSString *sourceSiteName);

@class LPCardConcernFrame;
@interface LPConcernViewCell : UITableViewCell

@property (nonatomic, strong) LPCardConcernFrame *cardFrame;
@property (nonatomic, copy) didTapSourceListViewBlock didTapSourceListBlock;
- (void)didTapSourceListViewBlock:(didTapSourceListViewBlock)didTapSourceListViewBlock;
@end
