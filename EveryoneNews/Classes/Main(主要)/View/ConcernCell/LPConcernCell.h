//
//  LPConcernCell.h
//  EveryoneNews
//
//  Created by apple on 15/7/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LPConcern;

@interface LPConcernCell : UICollectionViewCell
@property (nonatomic, strong) LPConcern *concern;
@property (nonatomic, assign) BOOL shimmering;
@end
