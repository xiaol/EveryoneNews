//
//  LPDetailVideoFrame.h
//  EveryoneNews
//
//  Created by dongdan on 2017/1/5.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPVideoModel;
@interface LPDetailVideoFrame : NSObject

@property (nonatomic, strong) LPVideoModel *videoModel;
@property (nonatomic, assign) CGRect titleF;
@property (nonatomic, assign) CGRect thumbnailImageViewF;
@property (nonatomic, assign) CGRect sourceSiteF;
@property (nonatomic, assign) CGRect seperatorViewF;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGRect durationF;
@property (nonatomic, assign) CGRect playImageViewF;


@end
