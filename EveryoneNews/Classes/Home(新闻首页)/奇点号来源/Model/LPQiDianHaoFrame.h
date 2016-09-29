//
//  LPQiDianHaoFrame.h
//  EveryoneNews
//
//  Created by dongdan on 16/7/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPQiDianHao;
@interface LPQiDianHaoFrame : NSObject

@property (nonatomic, assign) CGRect concernImageViewF;
@property (nonatomic, assign) CGRect titleLabelF;
@property (nonatomic, assign) CGRect concernCountLabelF;
@property (nonatomic, assign) CGRect concernButtonF;
@property (nonatomic, assign) CGRect seperatorLineF;
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) LPQiDianHao *qiDianHao;

@end
