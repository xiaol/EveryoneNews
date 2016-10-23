//
//  LPDeviceObject.h
//  EveryoneNews
//
//  Created by dongdan on 16/9/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPDeviceObject : NSObject

@property (nonatomic, copy) NSString *mac;
@property (nonatomic, copy) NSString *brand;
@property (nonatomic, copy) NSString *platform;
@property (nonatomic, assign) NSInteger os;
@property (nonatomic, copy) NSString *device_size;
@property (nonatomic, assign) NSInteger network;
// 运营商 （0 未知 1 中国移动  2 中国联通 3 中国电信）
@property (nonatomic, assign) NSInteger chinaOperator;
@property (nonatomic, copy) NSString *ip;

@end
