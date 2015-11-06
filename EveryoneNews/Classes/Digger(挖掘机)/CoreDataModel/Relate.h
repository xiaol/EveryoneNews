//
//  Relate.h
//  EveryoneNews
//
//  Created by apple on 15/11/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Press, RelatePhoto;

@interface Relate : NSManagedObject

@property (nonatomic, retain) NSString * photoURL;
@property (nonatomic, retain) NSNumber * relateID;
@property (nonatomic, retain) NSString * sourceSite;
@property (nonatomic, retain) NSNumber * thumbnailH;
@property (nonatomic, retain) NSNumber * thumbnailW;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * updateTime;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) RelatePhoto *photo;
@property (nonatomic, retain) Press *press;

@end
