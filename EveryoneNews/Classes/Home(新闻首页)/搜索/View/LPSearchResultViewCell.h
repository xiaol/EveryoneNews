//
//  LPSearchResultViewCell.h
//  EveryoneNews
//
//  Created by dongdan on 16/6/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPSearchCardFrame;
//@class LPSearchResultViewCell;
//
//@protocol  LPSearchResultViewCellDelegate<NSObject>
//
//- (void)cell:(LPSearchResultViewCell *)cell didSelectedCardFrame:(LPSearchCardFrame *)cardFrame;
//
//@end

@interface LPSearchResultViewCell : UITableViewCell

@property (nonatomic, strong) LPSearchCardFrame *cardFrame;
//
//@property (nonatomic, weak) id<LPSearchResultViewCellDelegate> delegate;

@end
