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
    /**
     *  今日最新
     */
    HomeCardsFetchTypeToday,
};

@interface CardParam : NSObject
/**
 *  请求类型
 */
@property (nonatomic, assign) HomeCardsFetchType type;
/**
 *  频道ID
 */
@property (nonatomic, copy) NSString *channelID;
/**
 *  请求数量
 */
@property (nonatomic, strong) NSNumber *count;
/**
 *  起始时间
 */
@property (nonatomic, copy) NSString *startTime;

@end
