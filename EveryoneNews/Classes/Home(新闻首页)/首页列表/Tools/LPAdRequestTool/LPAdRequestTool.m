//
//  LPAdRequestTool.m
//  EveryoneNews
//
//  Created by dongdan on 16/9/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPAdRequestTool.h"
#import <AdSupport/ASIdentifierManager.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation LPAdRequestTool

+ (NSString *)adBase64WithType:(NSString *)type {
    NSMutableDictionary *adReuqest = [NSMutableDictionary dictionary];
    // 当前版本号
    NSString *version = @"1.0";
    adReuqest[@"version"] = version;
    // 提取当前服务器时间戳，精确到秒
    adReuqest[@"ts"] = [NSString stringWithFormat:@"%lld", (long long)([[NSDate date] timeIntervalSince1970])];
    
    // impression对象
    NSMutableDictionary *impressionDictionary = [NSMutableDictionary dictionary];
    impressionDictionary[@"aid"]  = type;
    
    NSInteger width = ScreenWidth;
    NSInteger height = (2 * width ) / 3;
    
    // 详情页广告图片
    if ([type isEqualToString:@"243"]) {
        height = (10 * width) / 19;
    } else if ([type isEqualToString:@"244"]) {
         height = (2 * width) / 3;
    }
    
    impressionDictionary[@"width"] = [NSString stringWithFormat:@"%d", width];
    impressionDictionary[@"height"] = [NSString stringWithFormat:@"%d", height];
    //    impressionDictionary[@"keywords"] = @"体育,足球";
    
    NSMutableArray *impressionArray = [NSMutableArray array];
    [impressionArray addObject:impressionDictionary];
    adReuqest[@"impression"] = impressionArray;
    
    // device 对象
    NSMutableDictionary *deviceDictionary = [NSMutableDictionary dictionary];
    
    NSString *idfa = [[[ ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    //    NSLog(@"idfa:%@", idfa);
    
    NSString *idfaMD5 = [idfa stringToMD5:idfa];
    deviceDictionary[@"idfa"] = idfaMD5;
    deviceDictionary[@"idfaori"] = idfa;
    
    NSString *brand = [[UIDevice currentDevice] model];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    deviceDictionary[@"brand"] = brand;
    // 操作系统 0 : 未知  1 安卓 2 iOS 3 Windows
    deviceDictionary[@"os"] = @"2";
    deviceDictionary[@"os_version"] = systemVersion;
    
    NSInteger screenHeight = ScreenHeight;
    deviceDictionary[@"device_size"] = [NSString stringWithFormat:@"%d*%d", width, screenHeight];
    deviceDictionary[@"network"] = @"0";
    deviceDictionary[@"operator"] = @"0";
    deviceDictionary[@"ip"] = [self getIPAddress];
    deviceDictionary[@"screen_orientation"] = @"1";
    deviceDictionary[@"longtitude"] = [[userDefaults objectForKey:LPCurrentLongitude] stringValue];
    deviceDictionary[@"latitude"] =  [[userDefaults objectForKey:LPCurrentLatitude] stringValue];
    
    adReuqest[@"device"] = deviceDictionary;
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:adReuqest options:NSJSONWritingPrettyPrinted error:&error];
    NSString *adBase64Str;
    
    if (! jsonData) {
        adBase64Str = @"{}";
    } else {
        adBase64Str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return [adBase64Str stringByBase64Encoding];
}

+ (NSString *)getIPAddress {
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
