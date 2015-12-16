//
//  CardParam.h
//  EveryoneNews
//
//  Created by apple on 15/12/14.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  请求类型
 */
typedef NS_ENUM(NSUInteger, HomeCardsFetchType) {
    /**
     *  下拉刷新
     */
    HomeCardsFetchTypeNew,
    /**
     *  上拉加载更多
     */
    HomeCardsFetchTypeMore,
};

@interface CardParam : NSObject
/**
 *  请求类型 (必填)
 */
@property (nonatomic, assign) HomeCardsFetchType type;
/**
 *  频道ID  (必填)
 */
@property (nonatomic, copy) NSString *channelID;
/**
 *  请求数量 (默认20)
 */
@property (nonatomic, strong) NSNumber *count;
/**
 *  起始时间 (如非第一次上拉, 必填, 第一次上拉默认为当前时间; 下拉必填)
 */
@property (nonatomic, copy) NSString *startTime;

@end
