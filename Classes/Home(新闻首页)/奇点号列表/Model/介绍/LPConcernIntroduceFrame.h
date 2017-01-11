//
//  LPConcernIntroduceFrame.h
//  EveryoneNews
//
//  Created by dongdan on 16/7/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPConcernIntroduce;
@interface LPConcernIntroduceFrame : NSObject

@property (nonatomic, assign) CGRect introduceLabelFrame;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGRect introduceSeperatorLineFrame;

@property (nonatomic, strong) LPConcernIntroduce *concernIntroduce;

@end
