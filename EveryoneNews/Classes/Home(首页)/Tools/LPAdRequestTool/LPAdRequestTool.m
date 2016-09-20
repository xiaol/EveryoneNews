//
//  LPAdRequestTool.m
//  EveryoneNews
//
//  Created by dongdan on 16/9/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPAdRequestTool.h"
//#import <AdSupport/ASIdentifierManager.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation LPAdRequestTool

//+ (NSString *)adBase64 {
//    NSMutableDictionary *adReuqest = [NSMutableDictionary dictionary];
//    // 当前版本号
//    CGFloat version = 1.0;
//    adReuqest[@"version"] = @(version);
//    // 提取当前服务器时间戳，精确到秒
//    NSDate *datetime = [NSDate date];
//    NSTimeInterval interval = [datetime timeIntervalSince1970];
//    adReuqest[@"ts"] = @(round(interval));
//    
//    // impression对象
//    NSMutableDictionary *impressionDictionary = [NSMutableDictionary dictionary];
//    impressionDictionary[@"aid"] = @(99);
//    
//    NSInteger width = ScreenWidth;
//    NSInteger height = (3 * width ) / 4;
//    
//    impressionDictionary[@"width"] = @(width);
//    impressionDictionary[@"height"] = @(height);
//    impressionDictionary[@"keywords"] = @"体育,足球";
//    
//    NSMutableArray *impressionArray = [NSMutableArray array];
//    [impressionArray addObject:impressionDictionary];
//    adReuqest[@"impression"] = impressionArray;
//    
//    // device 对象
//    NSMutableDictionary *deviceDictionary = [NSMutableDictionary dictionary];
//    
//    //
//    NSString *idfa = [[[ ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//    NSString *idfaMD5 = [idfa stringToMD5:idfa];
//    deviceDictionary[@"idfa"] = idfaMD5;
//    
//    NSString *brand = [[UIDevice currentDevice] model];
//    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
//    deviceDictionary[@"brand"] = brand;
//    // 操作系统 0 : 未知  1 安卓 2 iOS 3 Windows
//    deviceDictionary[@"os"] = @(2);
//    deviceDictionary[@"os_version"] = systemVersion;
//    deviceDictionary[@"device_size"] = [NSString stringWithFormat:@"%f*%f", round(ScreenWidth), round(ScreenHeight)];
//    deviceDictionary[@"network"] = @(0);
//    deviceDictionary[@"operator"] = @(0);
//    deviceDictionary[@"ip"] = [self getIPAddress];
//    
//    adReuqest[@"device"] = deviceDictionary;
//    
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:adReuqest options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *adBase64Str;
//    if (! jsonData) {
//        adBase64Str = @"{}";
//    } else {
//        adBase64Str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    }
//    
//    NSLog(@"%@",adBase64Str);
//    
//    return [adBase64Str stringByBase64Encoding];
//}

+(NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Get NSString from C String
                address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

@end
