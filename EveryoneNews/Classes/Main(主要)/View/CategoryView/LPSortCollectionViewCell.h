//
//  LPSortCollectionViewCell.h
//  EveryoneNews
//
//  Created by dongdan on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPSortCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) NSIndexPath *indexPath;
- (void)setCellWithArray:(NSMutableArray *)dataMutableArray indexPath:(NSIndexPath*)indexPath selectedTitle:(NSString *)selectedTitle;

@end
