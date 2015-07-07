//
//  Account.m
//  EveryoneNews
//
//  Created by Feng on 15/6/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "Account.h"

@implementation Account


- (NSString *)description{
    return [NSString stringWithFormat:@"<%p> (%@,%@,%@,%@,%@,%@,%@)",self,_userId,_userGender,_userName,_userIcon,_platformType,_deviceType,_expiresTime];
}
// 从文件中解析对象的时候使用
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.userGender = [aDecoder decodeObjectForKey:@"userGender"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.userIcon = [aDecoder decodeObjectForKey:@"userIcon"];
        self.platformType = [aDecoder decodeObjectForKey:@"platformType"];
        self.deviceType=[aDecoder decodeObjectForKey:@"deviceType"];
        self.token=[aDecoder decodeObjectForKey:@"token"];
        self.expiresTime=[aDecoder decodeObjectForKey:@"expiresTime"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userGender forKey:@"userGender"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.userIcon forKey:@"userIcon"];
    [aCoder encodeObject:self.platformType forKey:@"platformType"];
    [aCoder encodeObject:self.deviceType forKey:@"deviceType"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.expiresTime forKey:@"expiresTime"];
}
@end
