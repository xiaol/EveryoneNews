//
//  Zhihu.h
//  EveryoneNews
//
//  Created by apple on 15/11/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Press;

@interface Zhihu : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * user;
@property (nonatomic, retain) NSNumber * zhihuID;
@property (nonatomic, retain) Press *press;

@end
