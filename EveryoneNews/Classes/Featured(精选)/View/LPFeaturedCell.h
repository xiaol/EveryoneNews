//
//  LPFeaturedCell.h
//  EveryoneNews
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LPFeatureFrame;
@class LPFeatureView;

@interface LPFeaturedCell : UICollectionViewCell
@property (nonatomic, strong) LPFeatureFrame *featureFrame;

@property (nonatomic, strong) LPFeatureView *featureView;
@end
