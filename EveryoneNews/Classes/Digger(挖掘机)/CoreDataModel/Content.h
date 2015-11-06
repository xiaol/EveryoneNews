//
//  Content.h
//  EveryoneNews
//
//  Created by apple on 15/11/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ContentPhoto, Press;

@interface Content : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSNumber * isPhotoType;
@property (nonatomic, retain) NSNumber * paraID;
@property (nonatomic, retain) NSString * photoURL;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSString * thumbnailDesc;
@property (nonatomic, retain) ContentPhoto *photo;
@property (nonatomic, retain) Press *press;

@end
