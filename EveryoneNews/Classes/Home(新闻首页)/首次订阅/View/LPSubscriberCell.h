//
//  LPSubscriberCell.h
//  Test
//
//  Created by dongdan on 16/9/1.
//  Copyright © 2016年 dongdan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPSubscriberFrame;
@class LPSubscriberCell;

@protocol LPSubscriberCellDelegate <NSObject>

- (void)cell:(LPSubscriberCell *)cell title:(NSString *)title buttonSelected:(BOOL)buttonSelected;

@end

@interface LPSubscriberCell : UICollectionViewCell

@property (nonatomic, strong) LPSubscriberFrame *subscriberFrame;
@property (nonatomic, assign, getter=isButtonSelected) BOOL buttonSelected;
@property (nonatomic, weak) id<LPSubscriberCellDelegate> delegate;

@end
