//
//  Account.m
//  EveryoneNews
//
//  Created by Feng on 15/6/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "Account.h"

@implementation Account

-(NSString *)description{
    return [NSString stringWithFormat:@"<%p> (%@,%ld,%@,%@,%ld,%@)",self,_userId,_userGender,_userName,_userIcon,_platformType,_deviceType];
}
// 从文件中解析对象的时候使用
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.userGender = [aDecoder decodeIntegerForKey:@"userGender"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.userIcon = [aDecoder decodeObjectForKey:@"userIcon"];
        self.platformType = [aDecoder decodeIntegerForKey:@"platformType"];
        self.deviceType=[aDecoder decodeObjectForKey:@"deviceType"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.userGender forKey:@"userGender"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.userIcon forKey:@"userIcon"];
    [aCoder encodeInteger:self.platformType forKey:@"platformType"];
    [aCoder encodeObject:self.deviceType forKey:@"deviceType"];
}
@end
