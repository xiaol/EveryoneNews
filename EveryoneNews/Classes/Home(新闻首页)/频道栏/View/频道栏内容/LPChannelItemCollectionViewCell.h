//
//  LPChannelItemCollectionViewCell.h
//  EveryoneNews
//
//  Created by dongdan on 16/5/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPChannelItem;

@interface LPChannelItemCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) LPChannelItem *channelItem;
@property (nonatomic, strong) UILabel *channelItemLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)setCellWithArray:(NSMutableArray *)dataMutableArray indexPath:(NSIndexPath*)indexPath selectedTitle:(NSString *)selectedTitle;

@end
