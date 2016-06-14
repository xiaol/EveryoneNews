//
//  LPLoginTool.m
//  EveryoneNews
//
//  Created by dongdan on 16/6/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPLoginTool.h"
#import "AccountTool.h"
#import "Account.h"
#import "NSDate+Extension.h"
#import "LPHttpTool.h"

@implementation LPLoginTool

#pragma mark - 重新验证当前用户身份 防止Authorization过期
+ (void)loginVerify {
    // 如果是游客用户则重新登录
    if ([[[userDefaults objectForKey:@"utype"] stringValue] isEqualToString:@"2"]) {
        NSString *url = @"http://bdp.deeporiginalx.com/v2/au/lin/g";
        NSMutableDictionary *paramUser = [NSMutableDictionary dictionary];
        paramUser[@"uid"] = [userDefaults objectForKey:@"uid"];
        paramUser[@"password"] = [userDefaults objectForKey:@"password"];
        
        [LPHttpTool postJSONResponseAuthorizationWithURL:url params:paramUser success:^(id json, NSString *authorization) {
            if ([json[@"code"] integerValue] == 2000) {
                NSDictionary *dict = (NSDictionary *)json[@"data"];
                [userDefaults setObject:dict[@"uid"] forKey:@"uid"];
                [userDefaults setObject:dict[@"utype"] forKey:@"utype"];
                [userDefaults setObject:dict[@"password"] forKey:@"password"];
                [userDefaults setObject:authorization forKey:@"uauthorization"];
                [userDefaults synchronize];
            }
        }  failure:^(NSError *error) {
        }];
        
    }
    // 如果是第三方用户则调用第三方注册接口
    else if ([[[userDefaults objectForKey:@"utype"] stringValue] isEqualToString:@"3"] || [[[userDefaults objectForKey:@"utype"] stringValue] isEqualToString:@"4"] ) {
        
        Account *accountEntity = [AccountTool account];
        
        //将用户授权信息上传到服务器
        NSMutableDictionary *paramsUser = [NSMutableDictionary dictionary];
        paramsUser[@"muid"] = ![userDefaults objectForKey:@"uid"] ? @(0):[userDefaults objectForKey:@"uid"];
        paramsUser[@"msuid"] = accountEntity.userId;
        paramsUser[@"utype"] = [userDefaults objectForKey:@"utype"];
        paramsUser[@"platform"] = @(1);
        paramsUser[@"suid"] =[NSString stringWithFormat:@"%@", accountEntity.userId ] ;
        paramsUser[@"stoken"] = accountEntity.token;
        
        //用于格式化NSDate对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设置格式：zzz表示时区
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        // NSDate转NSString
        NSString *currentDateString = [dateFormatter stringFromDate:[NSDate getDateTimeFromMilliSeconds:accountEntity.expiresTime.unsignedIntegerValue]];
        paramsUser[@"sexpires"] = currentDateString;
        paramsUser[@"uname"] = accountEntity.userName;
        paramsUser[@"gender"] = @(0);
        paramsUser[@"avatar"] =  accountEntity.userIcon;
        paramsUser[@"province"] = @"";
        paramsUser[@"city"] = @"";
        paramsUser[@"district"] = @"";
        
        // 第三方注册
        NSString *url = [NSString stringWithFormat:@"%@/v2/au/sin/s", ServerUrlVersion2];
        
        [LPHttpTool postJSONResponseAuthorizationWithURL:url params:paramsUser success:^(id json, NSString *authorization) {
            if ([json[@"code"] integerValue] == 2000) {
                NSDictionary *dictData = (NSDictionary *)json[@"data"];
                [userDefaults setObject:dictData[@"uid"] forKey:@"uid"];
                [userDefaults setObject:dictData[@"utype"] forKey:@"utype"];
                [userDefaults setObject:authorization forKey:@"uauthorization"];
                [userDefaults synchronize];
            }
        } failure:^(NSError *error) {
            
        }];
        
    }
}

@end
