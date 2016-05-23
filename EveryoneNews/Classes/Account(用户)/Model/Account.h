//
//  Account.h
//  EveryoneNews
//
//  Created by Feng on 15/6/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject <NSCoding>

@property (nonatomic,copy) NSString *userId;
@property (nonatomic,strong) NSNumber *userGender;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *userIcon;
@property (nonatomic,strong) NSString *platformType;
@property (nonatomic,copy) NSString *deviceType;
@property (nonatomic,copy) NSString *token;
@property (nonatomic,strong) NSNumber *expiresTime;
@property (nonatomic, copy) NSString *uniqueDeviceID;
@end
